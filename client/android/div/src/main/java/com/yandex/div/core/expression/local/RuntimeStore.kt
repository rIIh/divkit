package com.yandex.div.core.expression.local

import com.yandex.div.core.Div2Logger
import com.yandex.div.core.DivViewFacade
import com.yandex.div.core.ObserverList
import com.yandex.div.core.expression.ExpressionResolverImpl
import com.yandex.div.core.expression.ExpressionsRuntime
import com.yandex.div.core.expression.triggers.TriggersController
import com.yandex.div.core.expression.variables.VariableControllerImpl
import com.yandex.div.core.util.toLocalFunctions
import com.yandex.div.core.util.toVariables
import com.yandex.div.core.view2.Div2View
import com.yandex.div.core.view2.divs.DivActionBinder
import com.yandex.div.core.view2.errors.ErrorCollector
import com.yandex.div.data.Variable
import com.yandex.div.evaluable.EvaluationContext
import com.yandex.div.evaluable.Evaluator
import com.yandex.div.internal.Assert
import com.yandex.div.json.expressions.ExpressionResolver
import com.yandex.div2.Div
import com.yandex.div2.DivBase
import com.yandex.div2.DivFunction
import com.yandex.div2.DivTrigger

private const val ERROR_UNKNOWN_RESOLVER =
    "ExpressionResolverImpl didn't call RuntimeStore#putRuntime on create."
internal const val ERROR_ROOT_RUNTIME_NOT_SPECIFIED = "Root runtime is not specified."
private const val WARNING_LOCAL_USING_LOCAL_VARIABLES =
    "You are using local variables. Please ensure that all elements that use local variables " +
    "and all of their parents recursively have an 'id' attribute."


internal class RuntimeStore(
    private val evaluator: Evaluator,
    private val errorCollector: ErrorCollector,
    private val div2Logger: Div2Logger,
    private val divActionBinder: DivActionBinder,
) {
    private var warningShown = false
    private val resolverToRuntime = mutableMapOf<ExpressionResolver, ExpressionsRuntime?>()
    private val allRuntimes = ObserverList<ExpressionsRuntime>()
    internal val tree = RuntimeTree()

    internal var rootRuntime: ExpressionsRuntime? = null
        set(value) {
            field = value
            field?.let { putRuntime(it, "", null) }
        }

    private val onCreateCallback by lazy {
        ExpressionResolverImpl.OnCreateCallback { resolver, variableController, functionProvider ->
            ExpressionsRuntime(resolver, variableController, null, functionProvider, this).also {
                /**
                 * we cannot provide path here, otherwise descendants of ExpressionResolver will
                 * receive the same callback and override runtime for provided path.
                 */
                putRuntime(runtime = it)
            }
        }
    }

    internal fun showWarningIfNeeded(child: DivBase) {
        if (!warningShown && child.variables != null) {
            warningShown = true
            errorCollector.logWarning(Throwable(WARNING_LOCAL_USING_LOCAL_VARIABLES))
        }
    }

    /**
     * Returns runtime if it have been store before, otherwise creates new runtime using
     * @param parentRuntime or @param parentResolver.
     *
     * NOTE: Always provide parentResolver or parentRuntime.
     * Otherwise, if runtime wasn't created it will be created using rootRuntime
     */
    internal fun getOrCreateRuntime(
        path: String,
        div: Div,
        parentResolver: ExpressionResolver? = null,
        parentRuntime: ExpressionsRuntime? = null,
    ) = tree.getNode(path)?.runtime ?: getRuntimeOrCreateChild(path, div, null, parentResolver, parentRuntime)

    internal fun getRuntimeWithOrNull(resolver: ExpressionResolver) = resolverToRuntime[resolver]

    internal fun putRuntime(runtime: ExpressionsRuntime) {
        resolverToRuntime[runtime.expressionResolver] = runtime
        allRuntimes.addObserver(runtime)
    }

    internal fun putRuntime(
        runtime: ExpressionsRuntime,
        path: String,
        parentRuntime: ExpressionsRuntime?,
    ) {
        putRuntime(runtime)

        tree.storeRuntime(runtime, parentRuntime, path)
        runtime.updateSubscriptions()
    }

    internal fun resolveRuntimeWith(
        divView: DivViewFacade?,
        path: String,
        div: Div?,
        resolver: ExpressionResolver,
        parentResolver: ExpressionResolver?,
    ): ExpressionsRuntime? {
        val runtimeForPath = tree.getNode(path)?.runtime
        if (resolver == runtimeForPath?.expressionResolver) return runtimeForPath

        val existingRuntime = getRuntimeWithOrNull(resolver) ?: run {
            reportError(ERROR_UNKNOWN_RESOLVER)
            return null
        }

        runtimeForPath?.let { tree.removeRuntimeAndCleanup(divView, it, path) }
        return getRuntimeOrCreateChild(path, div, existingRuntime, parentResolver)
    }

    internal fun cleanup(divView: DivViewFacade) {
        warningShown = false
        allRuntimes.forEach { it.cleanup(divView) }
    }

    internal fun updateSubscriptions() = allRuntimes.forEach { it.updateSubscriptions() }

    internal fun clearBindings(divView: DivViewFacade) = allRuntimes.forEach { it.clearBinding(divView) }

    internal fun getUniquePathsAndRuntimes() = tree.getPathToRuntimes()

    private fun reportError(message: String) {
        Assert.fail(message)
        errorCollector.logError(AssertionError(message))
    }

    private fun createChildRuntime(
        baseRuntime: ExpressionsRuntime,
        parentRuntime: ExpressionsRuntime?,
        path: String,
        variables: List<Variable>?,
        variablesTriggers: List<DivTrigger>?,
        functions: List<DivFunction>?,
    ): ExpressionsRuntime {
        val localVariableController = VariableControllerImpl(baseRuntime.variableController)
        if (!variables.isNullOrEmpty()) {
            variables.forEach { localVariableController.declare(it) }
        }

        var functionProvider = baseRuntime.functionProvider
        if (!functions.isNullOrEmpty()) {
            functionProvider += functions.toLocalFunctions()
        }

        val evaluationContext = EvaluationContext(
            variableProvider = localVariableController,
            storedValueProvider = evaluator.evaluationContext.storedValueProvider,
            functionProvider = functionProvider,
            warningSender = evaluator.evaluationContext.warningSender
        )

        val evaluator = Evaluator(evaluationContext)
        val resolver = ExpressionResolverImpl(
            path = path + "/" + (baseRuntime.expressionResolver as? ExpressionResolverImpl)?.path,
            runtimeStore = this,
            variableController = localVariableController,
            evaluator = evaluator,
            errorCollector = errorCollector,
            onCreateCallback = onCreateCallback,
        )

        val triggerController = if (variablesTriggers.isNullOrEmpty()) {
            null
        } else {
            TriggersController(
                localVariableController,
                resolver,
                evaluator,
                errorCollector,
                div2Logger,
                divActionBinder
            ).apply {
                ensureTriggersSynced(variablesTriggers)
            }
        }

        return ExpressionsRuntime(resolver, localVariableController, triggerController, functionProvider, this).also {
            putRuntime(it, path, parentRuntime)
        }
    }

    private fun getRuntimeOrCreateChild(
        path: String,
        div: Div?,
        existingRuntime: ExpressionsRuntime? = null,
        parentResolver: ExpressionResolver? = null,
        parentRuntime: ExpressionsRuntime? = null,
    ): ExpressionsRuntime? {
        val runtime = existingRuntime
            ?: parentRuntime
            ?: parentResolver?.let { getRuntimeWithOrNull(it) }
            ?: rootRuntime
            ?: run {
                reportError(ERROR_ROOT_RUNTIME_NOT_SPECIFIED)
                return null
            }

        val parentRuntime = parentRuntime ?: parentResolver?.let { getRuntimeWithOrNull(it) }

        val variables = div?.value()?.variables?.toVariables()
        val variableTriggers = div?.value()?.variableTriggers
        val functions = div?.value()?.functions

        if (needLocalRuntime(variables, variableTriggers, functions)) {
            return createChildRuntime(runtime, parentRuntime, path, variables, variableTriggers, functions)
        }

        tree.storeRuntime(runtime, parentRuntime, path)
        runtime.updateSubscriptions()
        return runtime
    }
}

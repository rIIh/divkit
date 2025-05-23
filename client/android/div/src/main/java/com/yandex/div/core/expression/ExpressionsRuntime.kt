package com.yandex.div.core.expression

import com.yandex.div.core.DivViewFacade
import com.yandex.div.core.expression.local.RuntimeStore
import com.yandex.div.core.expression.triggers.TriggersController
import com.yandex.div.core.expression.variables.VariableController

internal class ExpressionsRuntime(
    val expressionResolver: ExpressionResolverImpl,
    val variableController: VariableController,
    val triggersController: TriggersController? = null,
    val functionProvider: FunctionProviderDecorator,
    val runtimeStore: RuntimeStore,
) {
    private var unsubscribed = true

    fun clearBinding(view: DivViewFacade) {
        triggersController?.clearBinding(view)
    }

    fun onAttachedToWindow(view: DivViewFacade) {
        triggersController?.onAttachedToWindow(view)
    }

    fun updateSubscriptions() {
        if (unsubscribed) {
            unsubscribed = false
            expressionResolver.subscribeOnVariables()
            variableController.restoreSubscriptions()
        }
    }

    internal fun cleanup(divView: DivViewFacade?) {
        if (!unsubscribed) {
            unsubscribed = true
            triggersController?.clearBinding(divView)
            variableController.cleanupSubscriptions()
        }
    }
}

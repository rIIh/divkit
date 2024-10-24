import 'package:divkit/divkit.dart';
import 'package:divkit/src/core/expression/analyzer.dart';
import 'package:divkit/src/core/runtime/entities.dart';
import 'package:divkit/src/utils/trace.dart';
import 'package:equatable/equatable.dart';
import 'package:petitparser/petitparser.dart';

abstract class Expression<T> with EquatableMixin {
  T? get value;

  T get requireValue => value!;

  const Expression();

  Future<T> resolveValue({
    required DivVariableContext context,
  });

  Future<void> preload(
    Map<String, dynamic> context,
  ) async {
    if (this is ResolvableExpression) {
      try {
        await resolveValue(
          context: DivVariableContext(current: context),
        );
      } catch (e, st) {
        logger.warning(
          '${(this as ResolvableExpression).source} not preloaded via error',
          error: e,
          stackTrace: st,
        );
      }
    }
  }

  Expression<T> copy();
}

class ValueExpression<T> extends Expression<T> {
  @override
  final T? value;

  const ValueExpression(this.value);

  @override
  Future<T> resolveValue({
    required DivVariableContext context,
  }) async =>
      value!;

  @override
  List<Object?> get props => [value];

  @override
  Expression<T> copy() => ValueExpression(value);
}

abstract class Preloadable extends Object {
  const Preloadable();

  Future<void> preload(Map<String, dynamic> context);
}

class ResolvableExpression<T> extends Expression<T> {
  final String? source;

  Result<dynamic>? _executionTree;

  ExpressionToken get executionTree {
    if (_executionTree! is Success) {
      return _executionTree!.value;
    }
    throw _executionTree!.message;
  }

  Set<String>? variables;

  final T? Function(Object?)? parse;

  final T? fallback;

  @override
  T? value;

  ResolvableExpression(
    this.source, {
    this.parse,
    this.fallback,
  });

  @override
  Future<T> resolveValue({
    required DivVariableContext context,
  }) async {
    _executionTree ??= parser.parse(source!);
    variables ??= await traceAsyncFunc(
      'extractVariables',
      () => exprAnalyzer.extractVariables(source!),
    );

    final hasValue = value != null;
    final hasUpdate = variables!.intersection(context.update).isNotEmpty;
    if (hasUpdate || !hasValue) {
      value = await traceAsyncFunc(
        'resolveExpression',
        () => exprResolver.resolve(this, context: context),
      );
    }
    return value!;
  }

  @override
  List<Object?> get props => [value, source, fallback];

  @override
  Expression<T> copy() => ResolvableExpression(
        source,
        parse: parse,
        fallback: fallback,
      );
}

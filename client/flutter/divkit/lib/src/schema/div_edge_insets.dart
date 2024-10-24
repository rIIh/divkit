// Generated code. Do not modify.

import 'package:divkit/src/schema/div_size_unit.dart';
import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// It sets margins.
class DivEdgeInsets extends Preloadable with EquatableMixin {
  const DivEdgeInsets({
    this.bottom = const ValueExpression(0),
    this.end,
    this.left = const ValueExpression(0),
    this.right = const ValueExpression(0),
    this.start,
    this.top = const ValueExpression(0),
    this.unit = const ValueExpression(DivSizeUnit.dp),
  });

  /// Bottom margin.
  // constraint: number >= 0; default value: 0
  final Expression<int> bottom;

  /// End margin. Margin position depends on the interface orientation. Has higher priority than the left and right margins.
  // constraint: number >= 0
  final Expression<int>? end;

  /// Left margin.
  // constraint: number >= 0; default value: 0
  final Expression<int> left;

  /// Right margin.
  // constraint: number >= 0; default value: 0
  final Expression<int> right;

  /// Start margin. Margin position depends on the interface orientation. Has higher priority than the left and right margins.
  // constraint: number >= 0
  final Expression<int>? start;

  /// Top margin.
  // constraint: number >= 0; default value: 0
  final Expression<int> top;
  // default value: DivSizeUnit.dp
  final Expression<DivSizeUnit> unit;

  @override
  List<Object?> get props => [
        bottom,
        end,
        left,
        right,
        start,
        top,
        unit,
      ];

  DivEdgeInsets copyWith({
    Expression<int>? bottom,
    Expression<int>? Function()? end,
    Expression<int>? left,
    Expression<int>? right,
    Expression<int>? Function()? start,
    Expression<int>? top,
    Expression<DivSizeUnit>? unit,
  }) =>
      DivEdgeInsets(
        bottom: bottom ?? this.bottom.copy(),
        end: end != null ? end.call() : this.end?.copy(),
        left: left ?? this.left.copy(),
        right: right ?? this.right.copy(),
        start: start != null ? start.call() : this.start?.copy(),
        top: top ?? this.top.copy(),
        unit: unit ?? this.unit.copy(),
      );

  static DivEdgeInsets? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivEdgeInsets(
        bottom: safeParseIntExpr(
          json['bottom'],
          fallback: 0,
        )!,
        end: safeParseIntExpr(
          json['end'],
        ),
        left: safeParseIntExpr(
          json['left'],
          fallback: 0,
        )!,
        right: safeParseIntExpr(
          json['right'],
          fallback: 0,
        )!,
        start: safeParseIntExpr(
          json['start'],
        ),
        top: safeParseIntExpr(
          json['top'],
          fallback: 0,
        )!,
        unit: safeParseStrEnumExpr(
          json['unit'],
          parse: DivSizeUnit.fromJson,
          fallback: DivSizeUnit.dp,
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivEdgeInsets?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivEdgeInsets(
        bottom: (await safeParseIntExprAsync(
          json['bottom'],
          fallback: 0,
        ))!,
        end: await safeParseIntExprAsync(
          json['end'],
        ),
        left: (await safeParseIntExprAsync(
          json['left'],
          fallback: 0,
        ))!,
        right: (await safeParseIntExprAsync(
          json['right'],
          fallback: 0,
        ))!,
        start: await safeParseIntExprAsync(
          json['start'],
        ),
        top: (await safeParseIntExprAsync(
          json['top'],
          fallback: 0,
        ))!,
        unit: (await safeParseStrEnumExprAsync(
          json['unit'],
          parse: DivSizeUnit.fromJson,
          fallback: DivSizeUnit.dp,
        ))!,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> preload(
    Map<String, dynamic> context,
  ) async {
    try {
      await bottom.preload(context);
      await end?.preload(context);
      await left.preload(context);
      await right.preload(context);
      await start?.preload(context);
      await top.preload(context);
      await unit.preload(context);
    } catch (e) {
      return;
    }
  }
}

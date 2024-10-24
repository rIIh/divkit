// Generated code. Do not modify.

import 'package:divkit/src/schema/div_size_unit.dart';
import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// Fixed size of an element.
class DivFixedSize extends Preloadable with EquatableMixin {
  const DivFixedSize({
    this.unit = const ValueExpression(DivSizeUnit.dp),
    required this.value,
  });

  static const type = "fixed";

  /// Unit of measurement. To learn more about units of size measurement, see [Layout inside the card](https://divkit.tech/docs/en/concepts/layout).
  // default value: DivSizeUnit.dp
  final Expression<DivSizeUnit> unit;

  /// Element size.
  // constraint: number >= 0
  final Expression<int> value;

  @override
  List<Object?> get props => [
        unit,
        value,
      ];

  DivFixedSize copyWith({
    Expression<DivSizeUnit>? unit,
    Expression<int>? value,
  }) =>
      DivFixedSize(
        unit: unit ?? this.unit.copy(),
        value: value ?? this.value.copy(),
      );

  static DivFixedSize? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivFixedSize(
        unit: safeParseStrEnumExpr(
          json['unit'],
          parse: DivSizeUnit.fromJson,
          fallback: DivSizeUnit.dp,
        )!,
        value: safeParseIntExpr(
          json['value'],
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivFixedSize?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivFixedSize(
        unit: (await safeParseStrEnumExprAsync(
          json['unit'],
          parse: DivSizeUnit.fromJson,
          fallback: DivSizeUnit.dp,
        ))!,
        value: (await safeParseIntExprAsync(
          json['value'],
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
      await unit.preload(context);
      await value.preload(context);
    } catch (e) {
      return;
    }
  }
}

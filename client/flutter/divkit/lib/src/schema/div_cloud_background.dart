// Generated code. Do not modify.

import 'package:divkit/src/schema/div_edge_insets.dart';
import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// Cloud text background. Lines draws a rectangular background with the specified color and rounded corners.
class DivCloudBackground extends Preloadable with EquatableMixin {
  const DivCloudBackground({
    required this.color,
    required this.cornerRadius,
    this.paddings = const DivEdgeInsets(),
  });

  static const type = "cloud";

  /// Fill color.
  final Expression<Color> color;

  /// Corner rounding radius.
  // constraint: number >= 0
  final Expression<int> cornerRadius;

  /// Margins between line bounds and background.
  final DivEdgeInsets paddings;

  @override
  List<Object?> get props => [
        color,
        cornerRadius,
        paddings,
      ];

  DivCloudBackground copyWith({
    Expression<Color>? color,
    Expression<int>? cornerRadius,
    DivEdgeInsets? paddings,
  }) =>
      DivCloudBackground(
        color: color ?? this.color.copy(),
        cornerRadius: cornerRadius ?? this.cornerRadius.copy(),
        paddings: paddings ?? this.paddings,
      );

  static DivCloudBackground? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivCloudBackground(
        color: safeParseColorExpr(
          json['color'],
        )!,
        cornerRadius: safeParseIntExpr(
          json['corner_radius'],
        )!,
        paddings: safeParseObj(
          DivEdgeInsets.fromJson(json['paddings']),
          fallback: const DivEdgeInsets(),
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivCloudBackground?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivCloudBackground(
        color: (await safeParseColorExprAsync(
          json['color'],
        ))!,
        cornerRadius: (await safeParseIntExprAsync(
          json['corner_radius'],
        ))!,
        paddings: (await safeParseObjAsync(
          DivEdgeInsets.fromJson(json['paddings']),
          fallback: const DivEdgeInsets(),
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
      await color.preload(context);
      await cornerRadius.preload(context);
      await paddings.preload(context);
    } catch (e) {
      return;
    }
  }
}

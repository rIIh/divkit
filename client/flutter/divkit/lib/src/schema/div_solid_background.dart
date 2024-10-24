// Generated code. Do not modify.

import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// Solid background color.
class DivSolidBackground extends Preloadable with EquatableMixin {
  const DivSolidBackground({
    required this.color,
  });

  static const type = "solid";

  /// Color.
  final Expression<Color> color;

  @override
  List<Object?> get props => [
        color,
      ];

  DivSolidBackground copyWith({
    Expression<Color>? color,
  }) =>
      DivSolidBackground(
        color: color ?? this.color.copy(),
      );

  static DivSolidBackground? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivSolidBackground(
        color: safeParseColorExpr(
          json['color'],
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivSolidBackground?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivSolidBackground(
        color: (await safeParseColorExprAsync(
          json['color'],
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
    } catch (e) {
      return;
    }
  }
}

// Generated code. Do not modify.

import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// Gaussian image blur.
class DivBlur extends Preloadable with EquatableMixin {
  const DivBlur({
    required this.radius,
  });

  static const type = "blur";

  /// Blur radius. Defines how many pixels blend into each other. Specified in: `dp`.
  // constraint: number >= 0
  final Expression<int> radius;

  @override
  List<Object?> get props => [
        radius,
      ];

  DivBlur copyWith({
    Expression<int>? radius,
  }) =>
      DivBlur(
        radius: radius ?? this.radius.copy(),
      );

  static DivBlur? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivBlur(
        radius: safeParseIntExpr(
          json['radius'],
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivBlur?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivBlur(
        radius: (await safeParseIntExprAsync(
          json['radius'],
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
      await radius.preload(context);
    } catch (e) {
      return;
    }
  }
}

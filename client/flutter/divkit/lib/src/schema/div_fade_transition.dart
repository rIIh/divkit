// Generated code. Do not modify.

import 'package:divkit/src/schema/div_animation_interpolator.dart';
import 'package:divkit/src/schema/div_transition_base.dart';
import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// Transparency animation.
class DivFadeTransition extends Preloadable
    with EquatableMixin
    implements DivTransitionBase {
  const DivFadeTransition({
    this.alpha = const ValueExpression(0.0),
    this.duration = const ValueExpression(200),
    this.interpolator =
        const ValueExpression(DivAnimationInterpolator.easeInOut),
    this.startDelay = const ValueExpression(0),
  });

  static const type = "fade";

  /// Value of the alpha channel which the element starts appearing from or at which it finishes disappearing.
  // constraint: number >= 0.0 && number <= 1.0; default value: 0.0
  final Expression<double> alpha;

  /// Animation duration in milliseconds.
  // constraint: number >= 0; default value: 200
  @override
  final Expression<int> duration;

  /// Transition speed nature.
  // default value: DivAnimationInterpolator.easeInOut
  @override
  final Expression<DivAnimationInterpolator> interpolator;

  /// Delay in milliseconds before animation starts.
  // constraint: number >= 0; default value: 0
  @override
  final Expression<int> startDelay;

  @override
  List<Object?> get props => [
        alpha,
        duration,
        interpolator,
        startDelay,
      ];

  DivFadeTransition copyWith({
    Expression<double>? alpha,
    Expression<int>? duration,
    Expression<DivAnimationInterpolator>? interpolator,
    Expression<int>? startDelay,
  }) =>
      DivFadeTransition(
        alpha: alpha ?? this.alpha.copy(),
        duration: duration ?? this.duration.copy(),
        interpolator: interpolator ?? this.interpolator.copy(),
        startDelay: startDelay ?? this.startDelay.copy(),
      );

  static DivFadeTransition? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivFadeTransition(
        alpha: safeParseDoubleExpr(
          json['alpha'],
          fallback: 0.0,
        )!,
        duration: safeParseIntExpr(
          json['duration'],
          fallback: 200,
        )!,
        interpolator: safeParseStrEnumExpr(
          json['interpolator'],
          parse: DivAnimationInterpolator.fromJson,
          fallback: DivAnimationInterpolator.easeInOut,
        )!,
        startDelay: safeParseIntExpr(
          json['start_delay'],
          fallback: 0,
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivFadeTransition?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivFadeTransition(
        alpha: (await safeParseDoubleExprAsync(
          json['alpha'],
          fallback: 0.0,
        ))!,
        duration: (await safeParseIntExprAsync(
          json['duration'],
          fallback: 200,
        ))!,
        interpolator: (await safeParseStrEnumExprAsync(
          json['interpolator'],
          parse: DivAnimationInterpolator.fromJson,
          fallback: DivAnimationInterpolator.easeInOut,
        ))!,
        startDelay: (await safeParseIntExprAsync(
          json['start_delay'],
          fallback: 0,
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
      await alpha.preload(context);
      await duration.preload(context);
      await interpolator.preload(context);
      await startDelay.preload(context);
    } catch (e) {
      return;
    }
  }
}

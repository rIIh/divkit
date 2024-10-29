// Generated code. Do not modify.

import 'package:divkit/src/schema/div_action.dart';
import 'package:divkit/src/schema/div_animation_direction.dart';
import 'package:divkit/src/schema/div_animation_interpolator.dart';
import 'package:divkit/src/schema/div_animator_base.dart';
import 'package:divkit/src/schema/div_count.dart';
import 'package:divkit/src/schema/div_fixed_count.dart';
import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// Color animator.
class DivColorAnimator extends Preloadable
    with EquatableMixin
    implements DivAnimatorBase {
  const DivColorAnimator({
    this.cancelActions,
    this.direction = const ValueExpression(DivAnimationDirection.normal),
    required this.duration,
    this.endActions,
    required this.endValue,
    required this.id,
    this.interpolator = const ValueExpression(DivAnimationInterpolator.linear),
    this.repeatCount = const DivCount.divFixedCount(
      DivFixedCount(
        value: ValueExpression(
          1,
        ),
      ),
    ),
    this.startDelay = const ValueExpression(0),
    this.startValue,
    required this.variableName,
  });

  static const type = "color_animator";

  /// Actions to be performed if the animator is canceled. For example, when a command with the type `animator_stop` is received.
  @override
  final List<DivAction>? cancelActions;

  /// Animation direction. Determines whether the animation should be played forward, backward, or alternate between forward and backward.
  // default value: DivAnimationDirection.normal
  @override
  final Expression<DivAnimationDirection> direction;

  /// Animation duration in milliseconds.
  // constraint: number >= 0
  @override
  final Expression<int> duration;

  /// Actions to be performed after the animator finishes.
  @override
  final List<DivAction>? endActions;

  /// The value the variable will have when the animation ends.
  final Expression<Color> endValue;

  /// Animator ID.
  @override
  final String id;

  /// Animated value interpolation function.
  // default value: DivAnimationInterpolator.linear
  @override
  final Expression<DivAnimationInterpolator> interpolator;

  /// Number of times the animation will repeat before stopping. A value of `0` enables infinite looping.
  // default value: const DivCount.divFixedCount(const DivFixedCount(value: ValueExpression(1,),),)
  @override
  final DivCount repeatCount;

  /// Delay before the animation is launched in milliseconds.
  // constraint: number >= 0; default value: 0
  @override
  final Expression<int> startDelay;

  /// The value the variable will have when the animation starts. If the property isn't specified, the current value of the variable will be used.
  final Expression<Color>? startValue;

  /// Name of the variable being animated.
  @override
  final String variableName;

  @override
  List<Object?> get props => [
        cancelActions,
        direction,
        duration,
        endActions,
        endValue,
        id,
        interpolator,
        repeatCount,
        startDelay,
        startValue,
        variableName,
      ];

  DivColorAnimator copyWith({
    List<DivAction>? Function()? cancelActions,
    Expression<DivAnimationDirection>? direction,
    Expression<int>? duration,
    List<DivAction>? Function()? endActions,
    Expression<Color>? endValue,
    String? id,
    Expression<DivAnimationInterpolator>? interpolator,
    DivCount? repeatCount,
    Expression<int>? startDelay,
    Expression<Color>? Function()? startValue,
    String? variableName,
  }) =>
      DivColorAnimator(
        cancelActions:
            cancelActions != null ? cancelActions.call() : this.cancelActions,
        direction: direction ?? this.direction.copy(),
        duration: duration ?? this.duration.copy(),
        endActions: endActions != null ? endActions.call() : this.endActions,
        endValue: endValue ?? this.endValue.copy(),
        id: id ?? this.id,
        interpolator: interpolator ?? this.interpolator.copy(),
        repeatCount: repeatCount ?? this.repeatCount,
        startDelay: startDelay ?? this.startDelay.copy(),
        startValue:
            startValue != null ? startValue.call() : this.startValue?.copy(),
        variableName: variableName ?? this.variableName,
      );

  static DivColorAnimator? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivColorAnimator(
        cancelActions: safeParseObj(
          safeListMap(
            json['cancel_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        direction: safeParseStrEnumExpr(
          json['direction'],
          parse: DivAnimationDirection.fromJson,
          fallback: DivAnimationDirection.normal,
        )!,
        duration: safeParseIntExpr(
          json['duration'],
        )!,
        endActions: safeParseObj(
          safeListMap(
            json['end_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        endValue: safeParseColorExpr(
          json['end_value'],
        )!,
        id: safeParseStr(
          json['id']?.toString(),
        )!,
        interpolator: safeParseStrEnumExpr(
          json['interpolator'],
          parse: DivAnimationInterpolator.fromJson,
          fallback: DivAnimationInterpolator.linear,
        )!,
        repeatCount: safeParseObj(
          DivCount.fromJson(json['repeat_count']),
          fallback: const DivCount.divFixedCount(
            DivFixedCount(
              value: ValueExpression(
                1,
              ),
            ),
          ),
        )!,
        startDelay: safeParseIntExpr(
          json['start_delay'],
          fallback: 0,
        )!,
        startValue: safeParseColorExpr(
          json['start_value'],
        ),
        variableName: safeParseStr(
          json['variable_name']?.toString(),
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivColorAnimator?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivColorAnimator(
        cancelActions: await safeParseObjAsync(
          await safeListMapAsync(
            json['cancel_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        direction: (await safeParseStrEnumExprAsync(
          json['direction'],
          parse: DivAnimationDirection.fromJson,
          fallback: DivAnimationDirection.normal,
        ))!,
        duration: (await safeParseIntExprAsync(
          json['duration'],
        ))!,
        endActions: await safeParseObjAsync(
          await safeListMapAsync(
            json['end_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        endValue: (await safeParseColorExprAsync(
          json['end_value'],
        ))!,
        id: (await safeParseStrAsync(
          json['id']?.toString(),
        ))!,
        interpolator: (await safeParseStrEnumExprAsync(
          json['interpolator'],
          parse: DivAnimationInterpolator.fromJson,
          fallback: DivAnimationInterpolator.linear,
        ))!,
        repeatCount: (await safeParseObjAsync(
          DivCount.fromJson(json['repeat_count']),
          fallback: const DivCount.divFixedCount(
            DivFixedCount(
              value: ValueExpression(
                1,
              ),
            ),
          ),
        ))!,
        startDelay: (await safeParseIntExprAsync(
          json['start_delay'],
          fallback: 0,
        ))!,
        startValue: await safeParseColorExprAsync(
          json['start_value'],
        ),
        variableName: (await safeParseStrAsync(
          json['variable_name']?.toString(),
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
      await safeFuturesWait(cancelActions, (v) => v.preload(context));
      await direction.preload(context);
      await duration.preload(context);
      await safeFuturesWait(endActions, (v) => v.preload(context));
      await endValue.preload(context);
      await interpolator.preload(context);
      await repeatCount.preload(context);
      await startDelay.preload(context);
      await startValue?.preload(context);
    } catch (e) {
      return;
    }
  }
}

// Generated code. Do not modify.

import 'package:divkit/src/schema/div_action.dart';
import 'package:divkit/src/schema/div_background.dart';
import 'package:divkit/src/schema/div_border.dart';
import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// Element behavior when focusing or losing focus.
class DivFocus extends Preloadable with EquatableMixin {
  const DivFocus({
    this.background,
    this.border = const DivBorder(),
    this.nextFocusIds,
    this.onBlur,
    this.onFocus,
  });

  /// Background of an element when it is in focus. It can contain multiple layers.
  final List<DivBackground>? background;

  /// Border of an element when it's in focus.
  final DivBorder border;

  /// IDs of elements that will be next to get focus.
  final DivFocusNextFocusIds? nextFocusIds;

  /// Actions when an element loses focus.
  final List<DivAction>? onBlur;

  /// Actions when an element gets focus.
  final List<DivAction>? onFocus;

  @override
  List<Object?> get props => [
        background,
        border,
        nextFocusIds,
        onBlur,
        onFocus,
      ];

  DivFocus copyWith({
    List<DivBackground>? Function()? background,
    DivBorder? border,
    DivFocusNextFocusIds? Function()? nextFocusIds,
    List<DivAction>? Function()? onBlur,
    List<DivAction>? Function()? onFocus,
  }) =>
      DivFocus(
        background: background != null ? background.call() : this.background,
        border: border ?? this.border,
        nextFocusIds:
            nextFocusIds != null ? nextFocusIds.call() : this.nextFocusIds,
        onBlur: onBlur != null ? onBlur.call() : this.onBlur,
        onFocus: onFocus != null ? onFocus.call() : this.onFocus,
      );

  static DivFocus? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivFocus(
        background: safeParseObj(
          safeListMap(
            json['background'],
            (v) => safeParseObj(
              DivBackground.fromJson(v),
            )!,
          ),
        ),
        border: safeParseObj(
          DivBorder.fromJson(json['border']),
          fallback: const DivBorder(),
        )!,
        nextFocusIds: safeParseObj(
          DivFocusNextFocusIds.fromJson(json['next_focus_ids']),
        ),
        onBlur: safeParseObj(
          safeListMap(
            json['on_blur'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        onFocus: safeParseObj(
          safeListMap(
            json['on_focus'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivFocus?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivFocus(
        background: await safeParseObjAsync(
          await safeListMapAsync(
            json['background'],
            (v) => safeParseObj(
              DivBackground.fromJson(v),
            )!,
          ),
        ),
        border: (await safeParseObjAsync(
          DivBorder.fromJson(json['border']),
          fallback: const DivBorder(),
        ))!,
        nextFocusIds: await safeParseObjAsync(
          DivFocusNextFocusIds.fromJson(json['next_focus_ids']),
        ),
        onBlur: await safeParseObjAsync(
          await safeListMapAsync(
            json['on_blur'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        onFocus: await safeParseObjAsync(
          await safeListMapAsync(
            json['on_focus'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
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
      await safeFuturesWait(background, (v) => v.preload(context));
      await border.preload(context);
      await nextFocusIds?.preload(context);
      await safeFuturesWait(onBlur, (v) => v.preload(context));
      await safeFuturesWait(onFocus, (v) => v.preload(context));
    } catch (e) {
      return;
    }
  }
}

/// IDs of elements that will be next to get focus.
class DivFocusNextFocusIds extends Preloadable with EquatableMixin {
  const DivFocusNextFocusIds({
    this.down,
    this.forward,
    this.left,
    this.right,
    this.up,
  });

  final Expression<String>? down;
  final Expression<String>? forward;
  final Expression<String>? left;
  final Expression<String>? right;
  final Expression<String>? up;

  @override
  List<Object?> get props => [
        down,
        forward,
        left,
        right,
        up,
      ];

  DivFocusNextFocusIds copyWith({
    Expression<String>? Function()? down,
    Expression<String>? Function()? forward,
    Expression<String>? Function()? left,
    Expression<String>? Function()? right,
    Expression<String>? Function()? up,
  }) =>
      DivFocusNextFocusIds(
        down: down != null ? down.call() : this.down?.copy(),
        forward: forward != null ? forward.call() : this.forward?.copy(),
        left: left != null ? left.call() : this.left?.copy(),
        right: right != null ? right.call() : this.right?.copy(),
        up: up != null ? up.call() : this.up?.copy(),
      );

  static DivFocusNextFocusIds? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivFocusNextFocusIds(
        down: safeParseStrExpr(
          json['down']?.toString(),
        ),
        forward: safeParseStrExpr(
          json['forward']?.toString(),
        ),
        left: safeParseStrExpr(
          json['left']?.toString(),
        ),
        right: safeParseStrExpr(
          json['right']?.toString(),
        ),
        up: safeParseStrExpr(
          json['up']?.toString(),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivFocusNextFocusIds?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivFocusNextFocusIds(
        down: await safeParseStrExprAsync(
          json['down']?.toString(),
        ),
        forward: await safeParseStrExprAsync(
          json['forward']?.toString(),
        ),
        left: await safeParseStrExprAsync(
          json['left']?.toString(),
        ),
        right: await safeParseStrExprAsync(
          json['right']?.toString(),
        ),
        up: await safeParseStrExprAsync(
          json['up']?.toString(),
        ),
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
      await down?.preload(context);
      await forward?.preload(context);
      await left?.preload(context);
      await right?.preload(context);
      await up?.preload(context);
    } catch (e) {
      return;
    }
  }
}

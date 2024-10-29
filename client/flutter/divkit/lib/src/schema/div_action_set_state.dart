// Generated code. Do not modify.

import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// Applies a new appearance to the content in `div-state'.
class DivActionSetState extends Preloadable with EquatableMixin {
  const DivActionSetState({
    required this.stateId,
    this.temporary = const ValueExpression(true),
  });

  static const type = "set_state";

  /// The path of the state inside `state` that needs to be activated. Set in the format `div_data_state_id/id/state_id'. Can be hierarchical: `div_data_state_id/id_1/state_id_1/../id_n/state_id_n`. Consists of:
  /// • `div_data_state_id` — the numeric value of the `state_id` of the `state` object in `data`
  /// • 'id` — the `id` value of the `state` object
  /// • `state_id` — the `state_id` value of the `state` object in `state`
  final Expression<String> stateId;

  /// Indicates a state change:
  /// • `true` — the change is temporary and will switch to the original one (default value) when the element is recreated
  /// • `false` — the change is permanent
  // default value: true
  final Expression<bool> temporary;

  @override
  List<Object?> get props => [
        stateId,
        temporary,
      ];

  DivActionSetState copyWith({
    Expression<String>? stateId,
    Expression<bool>? temporary,
  }) =>
      DivActionSetState(
        stateId: stateId ?? this.stateId.copy(),
        temporary: temporary ?? this.temporary.copy(),
      );

  static DivActionSetState? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivActionSetState(
        stateId: safeParseStrExpr(
          json['state_id']?.toString(),
        )!,
        temporary: safeParseBoolExpr(
          json['temporary'],
          fallback: true,
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivActionSetState?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivActionSetState(
        stateId: (await safeParseStrExprAsync(
          json['state_id']?.toString(),
        ))!,
        temporary: (await safeParseBoolExprAsync(
          json['temporary'],
          fallback: true,
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
      await stateId.preload(context);
      await temporary.preload(context);
    } catch (e) {
      return;
    }
  }
}

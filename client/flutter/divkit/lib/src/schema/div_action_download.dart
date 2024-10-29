// Generated code. Do not modify.

import 'package:divkit/src/schema/div_action.dart';
import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

<<<<<<< HEAD
/// Loads additional data in `div-patch` format and updates the current element.
=======
/// Loads more data in the form of a `div-patch` and updates current element,
>>>>>>> 6e628ef7b (chore: regenerate schema for copy-able expressions)
class DivActionDownload extends Preloadable with EquatableMixin {
  const DivActionDownload({
    this.onFailActions,
    this.onSuccessActions,
    required this.url,
  });

  static const type = "download";

  /// Actions in case of unsuccessful loading if the host reported it or the waiting time expired.
  final List<DivAction>? onFailActions;

  /// Actions in case of successful loading.
  final List<DivAction>? onSuccessActions;

<<<<<<< HEAD
  /// Link for receiving changes.
=======
  /// URL to get the patch.
>>>>>>> 6e628ef7b (chore: regenerate schema for copy-able expressions)
  final Expression<String> url;

  @override
  List<Object?> get props => [
        onFailActions,
        onSuccessActions,
        url,
      ];

  DivActionDownload copyWith({
    List<DivAction>? Function()? onFailActions,
    List<DivAction>? Function()? onSuccessActions,
    Expression<String>? url,
  }) =>
      DivActionDownload(
        onFailActions:
            onFailActions != null ? onFailActions.call() : this.onFailActions,
        onSuccessActions: onSuccessActions != null
            ? onSuccessActions.call()
            : this.onSuccessActions,
<<<<<<< HEAD
        url: url ?? this.url,
=======
        url: url ?? this.url.copy(),
>>>>>>> 6e628ef7b (chore: regenerate schema for copy-able expressions)
      );

  static DivActionDownload? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivActionDownload(
        onFailActions: safeParseObj(
          safeListMap(
            json['on_fail_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        onSuccessActions: safeParseObj(
          safeListMap(
            json['on_success_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        url: safeParseStrExpr(
          json['url']?.toString(),
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivActionDownload?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivActionDownload(
        onFailActions: await safeParseObjAsync(
          await safeListMapAsync(
            json['on_fail_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        onSuccessActions: await safeParseObjAsync(
          await safeListMapAsync(
            json['on_success_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        url: (await safeParseStrExprAsync(
          json['url']?.toString(),
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
      await safeFuturesWait(onFailActions, (v) => v.preload(context));
      await safeFuturesWait(onSuccessActions, (v) => v.preload(context));
      await url.preload(context);
    } catch (e) {
      return;
    }
  }
}

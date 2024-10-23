// Generated code. Do not modify.

import 'package:divkit/src/schema/div_action.dart';
import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// Sends variables from the container via a url. The data sending configuration can be determined by the host application. By default, variables are passed in body in json format, the request method is POST.
class DivActionSubmit extends Preloadable with EquatableMixin {
  const DivActionSubmit({
    required this.containerId,
    this.onFailActions,
    this.onSuccessActions,
    required this.request,
  });

  static const type = "submit";

  /// The identifier of the container that contains variables to submit.
  final Expression<String> containerId;

  /// Actions in case of unsuccessful submit.
  final List<DivAction>? onFailActions;

  /// Actions in case of successful submit.
  final List<DivAction>? onSuccessActions;

  /// The HTTP request parameters that are used to configure how data is sent.
  final DivActionSubmitRequest request;

  @override
  List<Object?> get props => [
        containerId,
        onFailActions,
        onSuccessActions,
        request,
      ];

  DivActionSubmit copyWith({
    Expression<String>? containerId,
    List<DivAction>? Function()? onFailActions,
    List<DivAction>? Function()? onSuccessActions,
    DivActionSubmitRequest? request,
  }) =>
      DivActionSubmit(
        containerId: containerId ?? this.containerId.copy(),
        onFailActions:
            onFailActions != null ? onFailActions.call() : this.onFailActions,
        onSuccessActions: onSuccessActions != null
            ? onSuccessActions.call()
            : this.onSuccessActions,
        request: request ?? this.request,
      );

  static DivActionSubmit? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivActionSubmit(
        containerId: safeParseStrExpr(
          json['container_id']?.toString(),
        )!,
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
        request: safeParseObj(
          DivActionSubmitRequest.fromJson(json['request']),
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivActionSubmit?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivActionSubmit(
        containerId: (await safeParseStrExprAsync(
          json['container_id']?.toString(),
        ))!,
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
        request: (await safeParseObjAsync(
          DivActionSubmitRequest.fromJson(json['request']),
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
      await containerId.preload(context);
      await safeFuturesWait(onFailActions, (v) => v.preload(context));
      await safeFuturesWait(onSuccessActions, (v) => v.preload(context));
      await request.preload(context);
    } catch (e) {
      return;
    }
  }
}

/// The HTTP request parameters that are used to configure how data is sent.
class DivActionSubmitRequest extends Preloadable with EquatableMixin {
  const DivActionSubmitRequest({
    this.headers,
    this.method = const ValueExpression(DivActionSubmitRequestMethod.post),
    required this.url,
  });

  /// The HTTP request headers.
  final List<DivActionSubmitRequestHeader>? headers;

  /// The HTTP request method.
  // default value: DivActionSubmitRequestMethod.post
  final Expression<DivActionSubmitRequestMethod> method;

  /// The url to which data from the container is sent.
  final Expression<Uri> url;

  @override
  List<Object?> get props => [
        headers,
        method,
        url,
      ];

  DivActionSubmitRequest copyWith({
    List<DivActionSubmitRequestHeader>? Function()? headers,
    Expression<DivActionSubmitRequestMethod>? method,
    Expression<Uri>? url,
  }) =>
      DivActionSubmitRequest(
        headers: headers != null ? headers.call() : this.headers,
        method: method ?? this.method.copy(),
        url: url ?? this.url.copy(),
      );

  static DivActionSubmitRequest? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivActionSubmitRequest(
        headers: safeParseObj(
          safeListMap(
            json['headers'],
            (v) => safeParseObj(
              DivActionSubmitRequestHeader.fromJson(v),
            )!,
          ),
        ),
        method: safeParseStrEnumExpr(
          json['method'],
          parse: DivActionSubmitRequestMethod.fromJson,
          fallback: DivActionSubmitRequestMethod.post,
        )!,
        url: safeParseUriExpr(json['url'])!,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivActionSubmitRequest?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivActionSubmitRequest(
        headers: await safeParseObjAsync(
          await safeListMapAsync(
            json['headers'],
            (v) => safeParseObj(
              DivActionSubmitRequestHeader.fromJson(v),
            )!,
          ),
        ),
        method: (await safeParseStrEnumExprAsync(
          json['method'],
          parse: DivActionSubmitRequestMethod.fromJson,
          fallback: DivActionSubmitRequestMethod.post,
        ))!,
        url: (await safeParseUriExprAsync(json['url']))!,
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
      await safeFuturesWait(headers, (v) => v.preload(context));
      await method.preload(context);
      await url.preload(context);
    } catch (e) {
      return;
    }
  }
}

class DivActionSubmitRequestHeader extends Preloadable with EquatableMixin {
  const DivActionSubmitRequestHeader({
    required this.name,
    required this.value,
  });

  final Expression<String> name;
  final Expression<String> value;

  @override
  List<Object?> get props => [
        name,
        value,
      ];

  DivActionSubmitRequestHeader copyWith({
    Expression<String>? name,
    Expression<String>? value,
  }) =>
      DivActionSubmitRequestHeader(
        name: name ?? this.name.copy(),
        value: value ?? this.value.copy(),
      );

  static DivActionSubmitRequestHeader? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivActionSubmitRequestHeader(
        name: safeParseStrExpr(
          json['name']?.toString(),
        )!,
        value: safeParseStrExpr(
          json['value']?.toString(),
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DivActionSubmitRequestHeader?> parse(
    Map<String, dynamic>? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      return DivActionSubmitRequestHeader(
        name: (await safeParseStrExprAsync(
          json['name']?.toString(),
        ))!,
        value: (await safeParseStrExprAsync(
          json['value']?.toString(),
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
      await name.preload(context);
      await value.preload(context);
    } catch (e) {
      return;
    }
  }
}

enum DivActionSubmitRequestMethod implements Preloadable {
  get('get'),
  post('post'),
  put('put'),
  patch('patch'),
  delete('delete'),
  head('head'),
  options('options');

  final String value;

  const DivActionSubmitRequestMethod(this.value);
  bool get isGet => this == get;

  bool get isPost => this == post;

  bool get isPut => this == put;

  bool get isPatch => this == patch;

  bool get isDelete => this == delete;

  bool get isHead => this == head;

  bool get isOptions => this == options;

  T map<T>({
    required T Function() get,
    required T Function() post,
    required T Function() put,
    required T Function() patch,
    required T Function() delete,
    required T Function() head,
    required T Function() options,
  }) {
    switch (this) {
      case DivActionSubmitRequestMethod.get:
        return get();
      case DivActionSubmitRequestMethod.post:
        return post();
      case DivActionSubmitRequestMethod.put:
        return put();
      case DivActionSubmitRequestMethod.patch:
        return patch();
      case DivActionSubmitRequestMethod.delete:
        return delete();
      case DivActionSubmitRequestMethod.head:
        return head();
      case DivActionSubmitRequestMethod.options:
        return options();
    }
  }

  T maybeMap<T>({
    T Function()? get,
    T Function()? post,
    T Function()? put,
    T Function()? patch,
    T Function()? delete,
    T Function()? head,
    T Function()? options,
    required T Function() orElse,
  }) {
    switch (this) {
      case DivActionSubmitRequestMethod.get:
        return get?.call() ?? orElse();
      case DivActionSubmitRequestMethod.post:
        return post?.call() ?? orElse();
      case DivActionSubmitRequestMethod.put:
        return put?.call() ?? orElse();
      case DivActionSubmitRequestMethod.patch:
        return patch?.call() ?? orElse();
      case DivActionSubmitRequestMethod.delete:
        return delete?.call() ?? orElse();
      case DivActionSubmitRequestMethod.head:
        return head?.call() ?? orElse();
      case DivActionSubmitRequestMethod.options:
        return options?.call() ?? orElse();
    }
  }

  @override
  Future<void> preload(Map<String, dynamic> context) async {}

  static DivActionSubmitRequestMethod? fromJson(
    String? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      switch (json) {
        case 'get':
          return DivActionSubmitRequestMethod.get;
        case 'post':
          return DivActionSubmitRequestMethod.post;
        case 'put':
          return DivActionSubmitRequestMethod.put;
        case 'patch':
          return DivActionSubmitRequestMethod.patch;
        case 'delete':
          return DivActionSubmitRequestMethod.delete;
        case 'head':
          return DivActionSubmitRequestMethod.head;
        case 'options':
          return DivActionSubmitRequestMethod.options;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<DivActionSubmitRequestMethod?> parse(
    String? json,
  ) async {
    if (json == null) {
      return null;
    }
    try {
      switch (json) {
        case 'get':
          return DivActionSubmitRequestMethod.get;
        case 'post':
          return DivActionSubmitRequestMethod.post;
        case 'put':
          return DivActionSubmitRequestMethod.put;
        case 'patch':
          return DivActionSubmitRequestMethod.patch;
        case 'delete':
          return DivActionSubmitRequestMethod.delete;
        case 'head':
          return DivActionSubmitRequestMethod.head;
        case 'options':
          return DivActionSubmitRequestMethod.options;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

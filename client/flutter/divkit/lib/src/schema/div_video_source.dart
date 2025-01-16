// Generated code. Do not modify.

import 'package:divkit/src/utils/parsing.dart';
import 'package:equatable/equatable.dart';

class DivVideoSource with EquatableMixin {
  const DivVideoSource({
    this.bitrate,
    required this.mimeType,
    this.resolution,
    required this.url,
  });

  static const type = "video_source";

  /// Media file bitrate: Data transfer rate in a video stream, measured in kilobits per second (kbps).
  final Expression<int>? bitrate;

  /// MIME type (Multipurpose Internet Mail Extensions): A string that defines the file type and helps process it correctly.
  final Expression<String> mimeType;

  /// Media file resolution.
  final DivVideoSourceResolution? resolution;

  /// Link to the media file available for playback or download.
  final Expression<Uri> url;

  @override
  List<Object?> get props => [
        bitrate,
        mimeType,
        resolution,
        url,
      ];

  DivVideoSource copyWith({
    Expression<int>? Function()? bitrate,
    Expression<String>? mimeType,
    DivVideoSourceResolution? Function()? resolution,
    Expression<Uri>? url,
  }) =>
      DivVideoSource(
        bitrate: bitrate != null ? bitrate.call() : this.bitrate?.copy(),
        mimeType: mimeType ?? this.mimeType.copy(),
        resolution: resolution != null ? resolution.call() : this.resolution,
        url: url ?? this.url.copy(),
      );

  static DivVideoSource? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivVideoSource(
        bitrate: safeParseIntExpr(
          json['bitrate'],
        ),
        mimeType: reqVProp<String>(
          safeParseStrExpr(
            json['mime_type'],
          ),
          name: 'mime_type',
        ),
        resolution: safeParseObject(
          json['resolution'],
          parse: DivVideoSourceResolution.fromJson,
        ),
        url: reqVProp<Uri>(
          safeParseUriExpr(
            json['url'],
          ),
          name: 'url',
        ),
      );
    } catch (e, st) {
      logger.warning("Parsing error", error: e, stackTrace: st);
      return null;
    }
  }
}

/// Media file resolution.
class DivVideoSourceResolution with EquatableMixin {
  const DivVideoSourceResolution({
    required this.height,
    required this.width,
  });

  static const type = "resolution";

  /// Media file frame height.
  // constraint: number > 0
  final Expression<int> height;

  /// Media file frame width.
  // constraint: number > 0
  final Expression<int> width;

  @override
  List<Object?> get props => [
        height,
        width,
      ];

  DivVideoSourceResolution copyWith({
    Expression<int>? height,
    Expression<int>? width,
  }) =>
      DivVideoSourceResolution(
        height: height ?? this.height.copy(),
        width: width ?? this.width.copy(),
      );

  static DivVideoSourceResolution? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivVideoSourceResolution(
        height: reqVProp<int>(
          safeParseIntExpr(
            json['height'],
          ),
          name: 'height',
        ),
        width: reqVProp<int>(
          safeParseIntExpr(
            json['width'],
          ),
          name: 'width',
        ),
      );
    } catch (e, st) {
      logger.warning("Parsing error", error: e, stackTrace: st);
      return null;
    }
  }
}

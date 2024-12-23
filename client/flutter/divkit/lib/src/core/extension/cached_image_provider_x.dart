import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

extension CachedImageProviderX on ImageProvider<Object> {
  ImageProvider<Object> withScale(double scale) {
    if (this is! CachedNetworkImageProvider) return this;

    final provider = this as CachedNetworkImageProvider;
    return CachedNetworkImageProvider(
      provider.url,
      cacheKey: provider.cacheKey,
      cacheManager: provider.cacheManager,
      errorListener: provider.errorListener,
      headers: provider.headers,
      imageRenderMethodForWeb: provider.imageRenderMethodForWeb,
      maxHeight: provider.maxHeight,
      maxWidth: provider.maxWidth,
      scale: scale,
    );
  }
}

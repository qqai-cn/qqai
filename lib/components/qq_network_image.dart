import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qqai/util/media_url.dart';

class QqNetworkImage extends StatelessWidget {
  const QqNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.borderRadius,
    this.placeholderColor = const Color(0xFFE5E7EB),
    this.errorIconColor = const Color(0xFF9CA3AF),
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BorderRadius? borderRadius;
  final Color placeholderColor;
  final Color errorIconColor;

  @override
  Widget build(BuildContext context) {
    Widget image = Image(
      image: CachedNetworkImageProvider(
        url,
        cacheKey: mediaCacheKey(url),
        maxWidth: cacheWidth,
        maxHeight: cacheHeight,
      ),
      fit: fit,
      width: width,
      height: height,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return _ImagePlaceholder(
          color: placeholderColor,
          indicatorColor: errorIconColor,
        );
      },
      errorBuilder: (_, _, _) =>
          _ImageError(color: placeholderColor, iconColor: errorIconColor),
    );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.color, required this.indicatorColor});

  final Color color;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: indicatorColor,
          ),
        ),
      ),
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError({required this.color, required this.iconColor});

  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Center(child: Icon(Icons.broken_image_outlined, color: iconColor)),
    );
  }
}

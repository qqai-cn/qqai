import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qqai/constant/constant.dart';

class DefaultAssetImage extends StatelessWidget {
  const DefaultAssetImage({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return AssetImageView(
      Constant.DEFAULT_USER_AVATAR,
      width: width,
      height: height,
      fit: fit,
    );
  }
}

class DefaultPlaceholderImage extends StatelessWidget {
  const DefaultPlaceholderImage({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return AssetImageView(
      Constant.DEFAULT_IMAGE_PLACEHOLDER,
      width: width,
      height: height,
      fit: fit,
    );
  }
}

class AssetImageView extends StatelessWidget {
  const AssetImageView(
    this.assetName, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.errorBuilder,
  });

  final String assetName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final source = _normalizeImageSource(assetName);
    final isNetwork = _isNetworkImageSource(source);

    if (_isSvgImageSource(source)) {
      if (isNetwork) {
        return SvgPicture.network(
          source,
          width: width,
          height: height,
          fit: fit,
        );
      }
      return SvgPicture.asset(source, width: width, height: height, fit: fit);
    }

    if (isNetwork) {
      return Image.network(
        source,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorBuilder,
      );
    }

    return Image.asset(
      source,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}

String _normalizeImageSource(String value) {
  final source = value.trim();
  if (source.startsWith('//')) return 'https:$source';
  return source;
}

bool _isNetworkImageSource(String value) =>
    value.startsWith('http://') || value.startsWith('https://');

bool _isSvgImageSource(String value) {
  final path = value.toLowerCase().split('?').first.split('#').first;
  return path.endsWith('.svg');
}

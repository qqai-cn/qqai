import 'package:flutter/material.dart';
import 'package:qqai/components/contain_with_blurred_backdrop.dart';
import 'package:qqai/components/default_asset_image.dart';
import 'package:qqai/components/letterbox_backdrop.dart';
import 'package:qqai/components/qq_network_image.dart';

bool _isLocalAssetPath(String value) =>
    !value.startsWith('http://') &&
    !value.startsWith('https://') &&
    !value.startsWith('//');

bool _isSvgPath(String value) {
  final path = value.toLowerCase().split('?').first.split('#').first;
  return path.endsWith('.svg');
}

enum VideoCoverFitMode {
  /// 铺满容器，可能裁切封面。
  fill,

  /// 完整显示封面；留白区域模糊延伸，降级时为灰黑实底。
  showFull,
}

/// 在固定视频容器内展示封面。
class VideoCoverFit extends StatelessWidget {
  const VideoCoverFit({
    super.key,
    required this.url,
    this.mode = VideoCoverFitMode.fill,
    this.backgroundColor = const Color(0xFF1F1F28),
    this.placeholderColor = const Color(0xFF1F1F28),
    this.errorIconColor = const Color(0xFF6B6B78),
  });

  final String url;
  final VideoCoverFitMode mode;
  final Color backgroundColor;
  final Color placeholderColor;
  final Color errorIconColor;

  @override
  Widget build(BuildContext context) {
    if (mode == VideoCoverFitMode.showFull) {
      return ContainWithBlurredBackdrop(
        backgroundColor: backgroundColor,
        backdropMode: resolveCoverLetterboxBackdropMode(),
        builder: (fit) => _buildImage(fit: fit),
      );
    }

    return ColoredBox(
      color: backgroundColor,
      child: _buildImage(fit: BoxFit.cover),
    );
  }

  Widget _buildImage({required BoxFit fit}) {
    if (_isLocalAssetPath(url) || _isSvgPath(url)) {
      return AssetImageView(
        url,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return QqNetworkImage(
      url: url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      placeholderColor: placeholderColor,
      errorIconColor: errorIconColor,
    );
  }
}

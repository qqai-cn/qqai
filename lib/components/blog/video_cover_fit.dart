import 'package:flutter/material.dart';
import 'package:qqai/components/qq_network_image.dart';

/// 在固定视频容器内铺满封面（[BoxFit.cover]），宽高撑满容器。
class VideoCoverFit extends StatelessWidget {
  const VideoCoverFit({
    super.key,
    required this.url,
    this.backgroundColor = const Color(0xFF1F1F28),
    this.placeholderColor = const Color(0xFF1F1F28),
    this.errorIconColor = const Color(0xFF6B6B78),
  });

  final String url;
  final Color backgroundColor;
  final Color placeholderColor;
  final Color errorIconColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: QqNetworkImage(
        url: url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholderColor: placeholderColor,
        errorIconColor: errorIconColor,
      ),
    );
  }
}

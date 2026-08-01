import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/brand/qqai_brand_logo.dart';
import 'package:qqai/features/search/theme/search_ai_theme.dart';
import 'package:qqai/util/media_url.dart';

/// AI 助手头像：默认千千用 AppBar 同款旋转 logo；自定义可用网络图。
class AiAssistantAvatar extends StatelessWidget {
  const AiAssistantAvatar({
    super.key,
    required this.isDefault,
    this.avatarUrl,
    this.size = 52,
    this.borderRadius,
    this.circular = true,
  });

  final bool isDefault;
  final String? avatarUrl;
  final double size;
  final BorderRadius? borderRadius;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ??
        (circular
            ? BorderRadius.circular(size / 2)
            : BorderRadius.circular(4));

    if (isDefault) {
      return SizedBox(
        width: size,
        height: size,
        child: QqaiBrandLogo(
          size: size,
          borderRadius: radius,
        ),
      );
    }

    final url = resolveMediaUrl(avatarUrl);
    final Widget child;
    if (url != null && url.isNotEmpty) {
      child = CachedNetworkImage(
        key: ValueKey(url),
        imageUrl: url,
        cacheKey: mediaCacheKey(url),
        width: size,
        height: size,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 150),
        errorWidget: (_, _, _) => _gradientFallback(),
      );
    } else {
      child = _gradientFallback();
    }

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(width: size, height: size, child: child),
    );
  }

  Widget _gradientFallback() {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [SearchAiTheme.cyan, SearchAiTheme.mint],
        ),
      ),
      child: Icon(
        Icons.auto_awesome,
        color: Colors.white,
        size: size * 0.45,
      ),
    );
  }
}

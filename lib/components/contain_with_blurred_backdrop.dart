import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:qqai/components/letterbox_backdrop.dart';

/// 子内容完整显示；撑不满的区域用模糊或纯色底填充。
///
/// - [builder]：同内容按不同 [BoxFit] 渲染（图片封面等）。
/// - [backdrop] + [foreground]：背景/前景为不同 Widget（如模糊封面 + contain 视频）。
class ContainWithBlurredBackdrop extends StatelessWidget {
  const ContainWithBlurredBackdrop({
    super.key,
    this.builder,
    this.backdrop,
    this.foreground,
    this.backgroundColor = kLetterboxBackdropColor,
    this.backdropMode = LetterboxBackdropMode.blur,
    this.backdropFit = BoxFit.cover,
    this.foregroundFit = BoxFit.contain,
    this.blurSigma = 14,
    this.overlayColor,
    this.alignment = Alignment.center,
  }) : assert(
         builder != null || (backdrop != null && foreground != null),
         'Provide builder or both backdrop and foreground.',
       ),
       assert(
         builder == null || (backdrop == null && foreground == null),
         'Cannot combine builder with backdrop/foreground.',
       );

  /// 按给定 [BoxFit] 构建前景/背景内容（通常为同一张图）。
  final Widget Function(BoxFit fit)? builder;

  /// 铺满容器并做模糊的背景层（通常 [BoxFit.cover]）。
  final Widget? backdrop;

  /// 完整显示的前景层（通常 [BoxFit.contain] 或由子组件自行 contain）。
  final Widget? foreground;

  /// 容器底色；[LetterboxBackdropMode.solid] 时即留区域颜色。
  final Color backgroundColor;

  final LetterboxBackdropMode backdropMode;
  final BoxFit backdropFit;
  final BoxFit foregroundFit;
  final double blurSigma;

  /// 模糊层上的半透明遮罩；默认 [backgroundColor] 35% 透明度。
  final Color? overlayColor;

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final backdropChild = backdrop ?? builder!(backdropFit);
    final foregroundChild = foreground ?? builder!(foregroundFit);

    if (backdropMode == LetterboxBackdropMode.solid) {
      return ColoredBox(
        color: backgroundColor,
        child: Stack(
          fit: StackFit.expand,
          alignment: alignment,
          children: [Positioned.fill(child: foregroundChild)],
        ),
      );
    }

    return ColoredBox(
      color: backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        alignment: alignment,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blurSigma,
              sigmaY: blurSigma,
            ),
            child: backdropChild,
          ),
          ColoredBox(
            color: overlayColor ?? backgroundColor.withValues(alpha: 0.35),
          ),
          Positioned.fill(child: foregroundChild),
        ],
      ),
    );
  }
}

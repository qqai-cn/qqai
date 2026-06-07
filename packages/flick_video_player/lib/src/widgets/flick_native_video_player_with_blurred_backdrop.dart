import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flick_video_player/src/widgets/flick_native_video_player.dart';
import 'package:flick_video_player/src/widgets/letterbox_backdrop.dart';
import 'package:video_player/video_player.dart';

/// 同一 [VideoPlayerController] 渲染两层：[cover] 模糊底 + [contain] 清晰前景。
///
/// [LetterboxBackdropMode.solid] 时仅灰黑底 + contain，不做模糊。
/// Flutter [Texture] 允许多个 Widget 引用同一 textureId，因此无需第二路解码。
class FlickNativeVideoPlayerWithBlurredBackdrop extends StatelessWidget {
  const FlickNativeVideoPlayerWithBlurredBackdrop({
    super.key,
    required this.videoPlayerController,
    this.aspectRatioWhenLoading = 16 / 9,
    this.backgroundColor = kLetterboxBackdropColor,
    this.backdropMode = LetterboxBackdropMode.blur,
    this.blurSigma = 14,
    this.overlayOpacity = 0.35,
  });

  final VideoPlayerController videoPlayerController;
  final double aspectRatioWhenLoading;
  final Color backgroundColor;
  final LetterboxBackdropMode backdropMode;
  final double blurSigma;
  final double overlayOpacity;

  @override
  Widget build(BuildContext context) {
    if (!videoPlayerController.value.isInitialized) {
      return const SizedBox.shrink();
    }

    Widget layer(BoxFit fit) {
      return FlickNativeVideoPlayer(
        videoPlayerController: videoPlayerController,
        fit: fit,
        aspectRatioWhenLoading: aspectRatioWhenLoading,
      );
    }

    if (backdropMode == LetterboxBackdropMode.solid) {
      return ColoredBox(
        color: backgroundColor,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [layer(BoxFit.contain)],
        ),
      );
    }

    return ColoredBox(
      color: backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blurSigma,
              sigmaY: blurSigma,
            ),
            child: layer(BoxFit.cover),
          ),
          ColoredBox(color: backgroundColor.withValues(alpha: overlayOpacity)),
          Positioned.fill(child: layer(BoxFit.contain)),
        ],
      ),
    );
  }
}

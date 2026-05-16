import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 博客详情视频画面：暂停时居中播放按钮；播放中点击画面可暂停。
class BlogDetailVideoSurfaceControls extends StatelessWidget {
  const BlogDetailVideoSurfaceControls({
    super.key,
    this.centerToggleSize = 56,
  });

  final double centerToggleSize;

  @override
  Widget build(BuildContext context) {
    return FlickShowControlsAction(
      handleVideoTap: () => _onVideoTap(context),
      child: FlickSeekVideoAction(
        child: Center(
          child: FlickVideoBuffer(
            child: _CenterPlayWhenPaused(centerToggleSize: centerToggleSize),
          ),
        ),
      ),
    );
  }

  void _onVideoTap(BuildContext context) {
    final videoManager = Provider.of<FlickVideoManager>(context, listen: false);
    final controlManager =
        Provider.of<FlickControlManager>(context, listen: false);
    final displayManager =
        Provider.of<FlickDisplayManager>(context, listen: false);

    if (videoManager.isVideoEnded) {
      controlManager.replay();
      return;
    }
    if (videoManager.isPlaying) {
      controlManager.pause();
      displayManager.handleShowPlayerControls(showWithTimeout: false);
      return;
    }
    controlManager.play();
    displayManager.hidePlayerControls();
  }
}

/// 仅暂停/结束时显示居中按钮，避免播放中 [FlickPlayToggle] 的空 decoration 圆点。
class _CenterPlayWhenPaused extends StatelessWidget {
  const _CenterPlayWhenPaused({required this.centerToggleSize});

  final double centerToggleSize;

  @override
  Widget build(BuildContext context) {
    final videoManager = Provider.of<FlickVideoManager>(context);
    if (videoManager.isPlaying && !videoManager.isVideoEnded) {
      return const SizedBox.shrink();
    }
    return FlickPlayToggle(
      size: centerToggleSize,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.black38,
        shape: BoxShape.circle,
      ),
    );
  }
}

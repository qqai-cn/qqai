import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 博客列表内嵌视频：控件叠在画面上（详情页请用 BlogVideoDetailPlayer）。
class ItemControls extends StatelessWidget {
  const ItemControls({
    super.key,
    this.centerToggleSize = 40,
    this.progressBarSettings,
  });

  final double centerToggleSize;
  final FlickProgressBarSettings? progressBarSettings;

  static final _progressBarSettings = FlickProgressBarSettings(
    height: 5,
    handleRadius: 5.5,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: FlickShowControlsAction(
            handleVideoTap: () => _onVideoTap(context),
            child: FlickSeekVideoAction(
              child: Center(
                child: FlickVideoBuffer(
                  child: FlickAutoHideChild(
                    showIfVideoNotInitialized: false,
                    child: _FeedCenterPlayWhenPaused(
                      centerToggleSize: centerToggleSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: FlickAutoHideChild(
            showIfVideoNotInitialized: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const FlickLeftDuration(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlickVideoProgressBar(
                    flickProgressBarSettings:
                        progressBarSettings ?? _progressBarSettings,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeedCenterPlayWhenPaused extends StatelessWidget {
  const _FeedCenterPlayWhenPaused({required this.centerToggleSize});

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

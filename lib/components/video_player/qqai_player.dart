import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class QqaiPlayer extends StatefulWidget {
  QqaiPlayer({
    Key? key,
    this.image,
    required this.controls,
    required this.url,
    required this.autoPlay,
    /// 默认 [BoxFit.contain]：父区域横竖与视频横竖不一致时仍完整显示（留边不裁切）。
    /// 竖滑全屏沉浸场景可设为 [BoxFit.cover]。
    this.videoFit = BoxFit.contain,
  }) : super(key: key);

  final String? image;
  final String url;
  final Widget controls;
  final bool autoPlay;
  final BoxFit videoFit;

  @override
  _QqaiPlayerState createState() => _QqaiPlayerState();
}

class _QqaiPlayerState extends State<QqaiPlayer> {
  late FlickManager flickManager;
  late VideoPlayerController videoController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));

    // 添加监听器，当视频初始化完成后设置音量
    videoController.addListener(_videoListener);

    flickManager = FlickManager(
      videoPlayerController: videoController,
      autoPlay: widget.autoPlay,
      autoInitialize: true,
    );

    // 使用 postFrameCallback 延迟设置音量，确保 FlickManager 完全初始化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && mounted) {
        _setVolumeIfNeeded();
      }
    });
  }

  void _videoListener() {
    if (!_isDisposed && mounted && videoController.value.isInitialized) {
      // 每次状态变化时都检查音量
      if (videoController.value.volume == 0.0) {
        _setVolumeIfNeeded();
      }
    }
  }

  void _setVolumeIfNeeded() {
    if (!_isDisposed && mounted) {
      if (videoController.value.isInitialized) {
        // 始终设置音量为 1.0（不检查 _volumeSet，因为可能被重置）
        if (videoController.value.volume != 1.0) {
          videoController.setVolume(1.0);
        }
        // 确保 FlickManager 不是静音状态
        flickManager.flickControlManager?.unmute();
      }
    }
  }

  ///If you have subtitle assets

  Future<ClosedCaptionFile> _loadCaptions() async {
    if (!_isDisposed && mounted) {
      final String fileContents = await DefaultAssetBundle.of(
        context,
      ).loadString('imgs/defbak.png');
      flickManager.flickControlManager!.toggleSubtitle();
      return SubRipCaptionFile(fileContents);
    }
    return SubRipCaptionFile('');
  }

  @override
  void dispose() {
    _isDisposed = true;
    // 移除监听器
    videoController.removeListener(_videoListener);
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (!_isDisposed && mounted) {
          if (visibility.visibleFraction > 0.9 && widget.autoPlay) {
            flickManager.flickControlManager?.autoResume();
            // 每次恢复播放时确保音量正确
            _setVolumeIfNeeded();
          }
          if (visibility.visibleFraction == 0) {
            flickManager.flickControlManager?.autoPause();
          }
        }
      },
      child: Container(
        child: FlickVideoPlayer(
          flickManager: flickManager,
          flickVideoWithControls: FlickVideoWithControls(
            videoFit: widget.videoFit,
            playerLoadingFallback: Positioned.fill(
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.network(widget.image!, fit: BoxFit.fitWidth),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            controls: widget.controls,
          ),
          flickVideoWithControlsFullscreen: FlickVideoWithControls(
            videoFit: widget.videoFit,
            playerLoadingFallback: Center(
              child: Image.network(widget.image!, fit: BoxFit.fitWidth),
            ),
            controls: FlickLandscapeControls(),
            iconThemeData: IconThemeData(size: 40, color: Colors.white),
            textStyle: context.typo.body.copyWith(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

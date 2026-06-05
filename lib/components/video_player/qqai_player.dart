import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/video_player/safe_flick_video_player.dart';
import 'package:qqai/components/video_player/shared_video_playback_session.dart';
import 'package:qqai/components/video_player/video_aspect_ratio.dart';
import 'package:qqai/components/video_player/video_ad_overlay.dart';
import 'package:qqai/components/video_player/video_loading_placeholder.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:video_player/video_player.dart';
import 'package:qqai/util/visibility_safe.dart';
import 'package:visibility_detector/visibility_detector.dart';

class QqaiPlayer extends StatefulWidget {
  const QqaiPlayer({
    super.key,
    this.image,
    required this.controls,
    required this.url,
    required this.autoPlay,
    this.videoId,
    this.isActive = true,
    this.showLoadingPoster = true,
    this.sharedPlaybackKey,

    /// 默认 [BoxFit.contain]：父区域横竖与视频横竖不一致时仍完整显示（留边不裁切）。
    /// 竖滑全屏沉浸场景可设为 [BoxFit.cover]。
    this.videoFit = BoxFit.contain,
    this.fallbackAspectRatio = 15 / 9,
    this.videoAdInitialState,
    this.onVideoAdStateChanged,
    this.onCompleted,
  });

  final String? image;
  final String url;
  final Widget controls;
  final bool autoPlay;
  final int? videoId;
  final bool isActive;
  final bool showLoadingPoster;
  final String? sharedPlaybackKey;
  final BoxFit videoFit;
  final double fallbackAspectRatio;
  final VideoAdPlaybackState? videoAdInitialState;
  final ValueChanged<VideoAdPlaybackState>? onVideoAdStateChanged;
  final VoidCallback? onCompleted;

  @override
  State<QqaiPlayer> createState() => _QqaiPlayerState();
}

class _QqaiPlayerState extends State<QqaiPlayer> {
  late FlickManager flickManager;
  late VideoPlayerController videoController;
  SharedVideoPlaybackSession? _sharedSession;
  Timer? _completionTimer;
  bool _isDisposed = false;
  bool _didNotifyCompleted = false;
  bool _didAutoResumeAfterInit = false;

  @override
  void initState() {
    super.initState();
    _attachPlayback();

    // 添加监听器，当视频初始化完成后设置音量
    videoController.addListener(_videoListener);
    _startCompletionPolling();

    // 使用 postFrameCallback 延迟设置音量，确保 FlickManager 完全初始化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && mounted && widget.isActive) {
        if (widget.autoPlay) {
          _startAutoPlayback();
        }
        _setVolumeIfNeeded();
      }
    });
  }

  @override
  void didUpdateWidget(QqaiPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url ||
        oldWidget.sharedPlaybackKey != widget.sharedPlaybackKey) {
      videoController.removeListener(_videoListener);
      _detachPlayback();
      _attachPlayback();
      videoController.addListener(_videoListener);
      _didNotifyCompleted = false;
      _didAutoResumeAfterInit = false;
      _startCompletionPolling();
    }
    if (oldWidget.isActive != widget.isActive ||
        oldWidget.autoPlay != widget.autoPlay) {
      if (widget.isActive && widget.autoPlay) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_isDisposed && mounted && widget.isActive) {
            _startAutoPlayback();
            _setVolumeIfNeeded();
          }
        });
      } else {
        _pause();
      }
    }
  }

  void _attachPlayback() {
    final sharedKey = widget.sharedPlaybackKey;
    if (sharedKey != null && sharedKey.isNotEmpty) {
      final session = acquireSharedVideoPlaybackSession(sharedKey);
      _sharedSession = session;
      videoController = session.videoController;
      flickManager = session.flickManager;
      return;
    }

    videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    flickManager = FlickManager(
      videoPlayerController: videoController,
      autoPlay: widget.autoPlay && widget.isActive,
      autoInitialize: true,
    );
  }

  void _detachPlayback() {
    _completionTimer?.cancel();
    _completionTimer = null;
    final session = _sharedSession;
    if (session != null) {
      session.release();
      _sharedSession = null;
      return;
    }
    flickManager.dispose();
  }

  void _videoListener() {
    if (!_isDisposed &&
        mounted &&
        widget.isActive &&
        videoController.value.isInitialized) {
      // 每次状态变化时都检查音量
      if (videoController.value.volume == 0.0) {
        _setVolumeIfNeeded();
      }
      final value = videoController.value;
      if (!_didAutoResumeAfterInit && widget.autoPlay && value.isInitialized) {
        _didAutoResumeAfterInit = true;
        _startAutoPlayback();
      }
      _checkCompleted(value);
    }
  }

  void _startAutoPlayback() {
    if (_isDisposed || !mounted || !widget.isActive || !widget.autoPlay) return;
    if (videoController.value.isInitialized &&
        videoController.value.position >= videoController.value.duration &&
        videoController.value.duration > Duration.zero) {
      videoController.seekTo(Duration.zero);
    }
    _setVolumeIfNeeded();
    flickManager.flickControlManager?.play();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isDisposed || !mounted || !widget.isActive || !widget.autoPlay) {
        return;
      }
      flickManager.flickControlManager?.play();
    });
    Timer(const Duration(milliseconds: 200), () {
      if (_isDisposed || !mounted || !widget.isActive || !widget.autoPlay) {
        return;
      }
      if (videoController.value.isInitialized &&
          !videoController.value.isPlaying) {
        flickManager.flickControlManager?.play();
      }
    });
  }

  void _startCompletionPolling() {
    _completionTimer?.cancel();
    if (widget.onCompleted == null) return;
    _completionTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (_isDisposed || !mounted || !widget.isActive) return;
      final value = videoController.value;
      if (!value.isInitialized) return;
      _checkCompleted(value);
    });
  }

  void _checkCompleted(VideoPlayerValue value) {
    if (_didNotifyCompleted || widget.onCompleted == null) return;
    final duration = value.duration;
    final nearEnd =
        duration > Duration.zero &&
        value.position >= duration - const Duration(milliseconds: 700);
    final flickEnded = flickManager.flickVideoManager?.isVideoEnded == true;
    if (!value.isCompleted && !flickEnded && !nearEnd) return;
    _didNotifyCompleted = true;
    widget.onCompleted?.call();
  }

  void _setVolumeIfNeeded() {
    if (!_isDisposed && mounted && widget.isActive) {
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

  void _pause() {
    if (_isDisposed || !mounted) return;
    flickManager.flickControlManager?.autoPause();
  }

  @override
  void dispose() {
    _isDisposed = true;
    // 移除监听器
    videoController.removeListener(_videoListener);
    _completionTimer?.cancel();
    _detachPlayback();
    super.dispose();
  }

  Widget _buildLoadingFallback() {
    return Positioned.fill(
      child: VideoLoadingPlaceholder(
        imageUrl: widget.image,
        showPoster: widget.showLoadingPoster,
      ),
    );
  }

  Widget _buildFullscreenLoadingFallback() {
    return VideoLoadingPlaceholder(
      imageUrl: widget.image,
      showPoster: widget.showLoadingPoster,
      showIndicator: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (!_isDisposed && mounted) {
          final fraction = safeVisibleFraction(visibility);
          if (widget.isActive && fraction > 0.9 && widget.autoPlay) {
            flickManager.flickControlManager?.autoResume();
            // 每次恢复播放时确保音量正确
            _setVolumeIfNeeded();
          }
          if (!widget.isActive || fraction == 0) {
            _pause();
          }
        }
      },
      child: ValueListenableBuilder<VideoPlayerValue>(
        valueListenable: videoController,
        builder: (context, value, child) {
          return AspectRatio(
            aspectRatio: effectiveVideoAspectRatio(
              value,
              widget.fallbackAspectRatio,
            ),
            child: child!,
          );
        },
        child: VideoAdOverlay(
          videoController: videoController,
          flickManager: flickManager,
          videoId: widget.videoId,
          initialPlaybackState: widget.videoAdInitialState,
          onPlaybackStateChanged: widget.onVideoAdStateChanged,
          child: SafeFlickVideoPlayer(
            flickManager: flickManager,
            flickVideoWithControls: FlickVideoWithControls(
              videoFit: widget.videoFit,
              playerLoadingFallback: _buildLoadingFallback(),
              controls: widget.controls,
            ),
            flickVideoWithControlsFullscreen: FlickVideoWithControls(
              videoFit: widget.videoFit,
              playerLoadingFallback: _buildFullscreenLoadingFallback(),
              controls: FlickLandscapeControls(),
              iconThemeData: IconThemeData(size: 40, color: Colors.white),
              textStyle: context.typo.body.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

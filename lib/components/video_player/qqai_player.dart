import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/blog/video_cover_fit.dart';
import 'package:qqai/components/letterbox_backdrop.dart';
import 'package:qqai/components/video_player/safe_flick_video_player.dart';
import 'package:qqai/components/video_player/shared_video_playback_session.dart';
import 'package:qqai/components/video_player/video_aspect_ratio.dart';
import 'package:qqai/components/video_player/video_ad_overlay.dart';
import 'package:qqai/components/video_player/video_loading_placeholder.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/media_url.dart';
import 'package:qqai/util/media_video_cache.dart';
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
    this.coverFitMode = VideoCoverFitMode.fill,
    this.sharedPlaybackKey,

    /// 默认 [BoxFit.contain]：父区域横竖与视频横竖不一致时仍完整显示（留边不裁切）。
    /// 竖滑全屏沉浸场景可设为 [BoxFit.cover]。
    this.videoFit = BoxFit.contain,
    this.fallbackAspectRatio = 15 / 9,
    this.videoAdInitialState,
    this.onVideoAdStateChanged,
    this.onCompleted,
    this.overlayBuilder,
  });

  final String? image;
  final String url;
  final Widget controls;
  final bool autoPlay;
  final int? videoId;
  final bool isActive;
  final bool showLoadingPoster;
  final VideoCoverFitMode coverFitMode;
  final String? sharedPlaybackKey;
  final BoxFit videoFit;
  final double fallbackAspectRatio;
  final VideoAdPlaybackState? videoAdInitialState;
  final ValueChanged<VideoAdPlaybackState>? onVideoAdStateChanged;
  final VoidCallback? onCompleted;
  final Widget Function(
    BuildContext context,
    ValueListenable<VideoPlayerValue> positionListenable,
  )?
  overlayBuilder;

  @override
  State<QqaiPlayer> createState() => _QqaiPlayerState();
}

class _QqaiPlayerState extends State<QqaiPlayer> {
  FlickManager? flickManager;
  VideoPlayerController? videoController;
  SharedVideoPlaybackSession? _sharedSession;
  Timer? _completionTimer;
  bool _isDisposed = false;
  bool _didNotifyCompleted = false;
  bool _didAutoResumeAfterInit = false;
  int _playbackGeneration = 0;

  @override
  void initState() {
    super.initState();
    precacheVideo(widget.url);
    unawaited(_attachPlayback());
  }

  @override
  void didUpdateWidget(QqaiPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final urlChanged =
        mediaCacheKey(oldWidget.url) != mediaCacheKey(widget.url);
    final sessionChanged =
        oldWidget.sharedPlaybackKey != widget.sharedPlaybackKey;
    if (urlChanged || sessionChanged) {
      precacheVideo(widget.url);
      videoController?.removeListener(_videoListener);
      _detachPlayback(clearControllers: true);
      _didNotifyCompleted = false;
      _didAutoResumeAfterInit = false;
      unawaited(_attachPlayback());
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

  Future<void> _attachPlayback() async {
    final generation = ++_playbackGeneration;
    final sharedKey = widget.sharedPlaybackKey;

    try {
      if (sharedKey != null && sharedKey.isNotEmpty) {
        final session = await acquireSharedVideoPlaybackSession(
          playbackUrl: widget.url,
          sessionKey: sharedKey,
        );
        if (_isDisposed || !mounted || generation != _playbackGeneration) {
          session.release();
          return;
        }
        _sharedSession = session;
        videoController = session.videoController;
        flickManager = session.flickManager;
      } else {
        final controller = await createVideoPlayerController(widget.url);
        if (_isDisposed || !mounted || generation != _playbackGeneration) {
          await controller.dispose();
          return;
        }
        videoController = controller;
        flickManager = FlickManager(
          videoPlayerController: controller,
          autoPlay: widget.autoPlay && widget.isActive,
          autoInitialize: true,
        );
      }

      videoController!.addListener(_videoListener);
      _startCompletionPolling();
      setState(() {});

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed && mounted && widget.isActive) {
          if (widget.autoPlay) {
            _startAutoPlayback();
          }
          _setVolumeIfNeeded();
        }
      });
    } catch (e, st) {
      if (e is! TimeoutException) {
        debugPrint('QqaiPlayer init failed: $e\n$st');
      }
      if (mounted && generation == _playbackGeneration) {
        setState(() {});
      }
    }
  }

  void _detachPlayback({bool clearControllers = false}) {
    _completionTimer?.cancel();
    _completionTimer = null;
    final session = _sharedSession;
    if (session != null) {
      session.release();
      _sharedSession = null;
    } else {
      flickManager?.dispose();
    }
    if (clearControllers) {
      videoController = null;
      flickManager = null;
    }
  }

  void _videoListener() {
    final controller = videoController;
    final manager = flickManager;
    if (controller == null || manager == null) return;
    if (!_isDisposed &&
        mounted &&
        widget.isActive &&
        controller.value.isInitialized) {
      if (controller.value.volume == 0.0) {
        _setVolumeIfNeeded();
      }
      final value = controller.value;
      if (!_didAutoResumeAfterInit && widget.autoPlay && value.isInitialized) {
        _didAutoResumeAfterInit = true;
        _startAutoPlayback();
      }
      _checkCompleted(value, manager);
    }
  }

  void _startAutoPlayback() {
    final controller = videoController;
    final manager = flickManager;
    if (controller == null ||
        manager == null ||
        _isDisposed ||
        !mounted ||
        !widget.isActive ||
        !widget.autoPlay) {
      return;
    }
    if (controller.value.isInitialized &&
        controller.value.position >= controller.value.duration &&
        controller.value.duration > Duration.zero) {
      controller.seekTo(Duration.zero);
    }
    _setVolumeIfNeeded();
    manager.flickControlManager?.play();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isDisposed || !mounted || !widget.isActive || !widget.autoPlay) {
        return;
      }
      manager.flickControlManager?.play();
    });
    Timer(const Duration(milliseconds: 200), () {
      if (_isDisposed || !mounted || !widget.isActive || !widget.autoPlay) {
        return;
      }
      if (controller.value.isInitialized && !controller.value.isPlaying) {
        manager.flickControlManager?.play();
      }
    });
  }

  void _startCompletionPolling() {
    _completionTimer?.cancel();
    if (widget.onCompleted == null) return;
    _completionTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (_isDisposed || !mounted || !widget.isActive) return;
      final controller = videoController;
      final manager = flickManager;
      if (controller == null || manager == null) return;
      final value = controller.value;
      if (!value.isInitialized) return;
      _checkCompleted(value, manager);
    });
  }

  void _checkCompleted(VideoPlayerValue value, FlickManager manager) {
    if (_didNotifyCompleted || widget.onCompleted == null) return;
    final duration = value.duration;
    final nearEnd =
        duration > Duration.zero &&
        value.position >= duration - const Duration(milliseconds: 700);
    final flickEnded = manager.flickVideoManager?.isVideoEnded == true;
    if (!value.isCompleted && !flickEnded && !nearEnd) return;
    _didNotifyCompleted = true;
    widget.onCompleted?.call();
  }

  void _setVolumeIfNeeded() {
    final controller = videoController;
    final manager = flickManager;
    if (controller == null || manager == null) return;
    if (!_isDisposed && mounted && widget.isActive) {
      if (controller.value.isInitialized) {
        if (controller.value.volume != 1.0) {
          controller.setVolume(1.0);
        }
        manager.flickControlManager?.unmute();
      }
    }
  }

  void _pause() {
    if (_isDisposed || !mounted) return;
    flickManager?.flickControlManager?.autoPause();
  }

  @override
  void dispose() {
    _isDisposed = true;
    videoController?.removeListener(_videoListener);
    _completionTimer?.cancel();
    _detachPlayback();
    super.dispose();
  }

  Widget _buildLoadingFallback() {
    return Positioned.fill(
      child: VideoLoadingPlaceholder(
        imageUrl: widget.image,
        showPoster: widget.showLoadingPoster,
        coverFitMode: widget.coverFitMode,
      ),
    );
  }

  Widget _buildFullscreenLoadingFallback() {
    return VideoLoadingPlaceholder(
      imageUrl: widget.image,
      showPoster: widget.showLoadingPoster,
      showIndicator: false,
      coverFitMode: widget.coverFitMode,
    );
  }

  bool get _useBlurredVideoBackdrop =>
      widget.coverFitMode == VideoCoverFitMode.showFull &&
      widget.videoFit == BoxFit.contain;

  Widget _buildFlickPlayer({required bool transparentBackground}) {
    final manager = flickManager!;
    final controlsShell = FlickVideoWithControls(
      videoFit: widget.videoFit,
      blurredBackdrop: _useBlurredVideoBackdrop,
      letterboxBackdropMode: resolveVideoLetterboxBackdropMode(),
      backgroundColor: transparentBackground ? Colors.transparent : Colors.black,
      playerLoadingFallback: _buildLoadingFallback(),
      controls: widget.controls,
    );

    return SafeFlickVideoPlayer(
      flickManager: manager,
      flickVideoWithControls: controlsShell,
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
    );
  }

  Widget _buildLoadingShell() {
    return AspectRatio(
      aspectRatio: widget.fallbackAspectRatio,
      child: VideoLoadingPlaceholder(
        imageUrl: widget.image,
        showPoster: widget.showLoadingPoster,
        coverFitMode: widget.coverFitMode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = videoController;
    final manager = flickManager;
    if (controller == null || manager == null) {
      return _buildLoadingShell();
    }

    return VisibilityDetector(
      key: ObjectKey(manager),
      onVisibilityChanged: (visibility) {
        if (!_isDisposed && mounted) {
          final fraction = safeVisibleFraction(visibility);
          if (widget.isActive && fraction > 0.9 && widget.autoPlay) {
            manager.flickControlManager?.autoResume();
            _setVolumeIfNeeded();
          }
          if (!widget.isActive || fraction == 0) {
            _pause();
          }
        }
      },
      child: ValueListenableBuilder<VideoPlayerValue>(
        valueListenable: controller,
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
          videoController: controller,
          flickManager: manager,
          videoId: widget.videoId,
          initialPlaybackState: widget.videoAdInitialState,
          onPlaybackStateChanged: widget.onVideoAdStateChanged,
          child: Stack(
            children: [
              _buildFlickPlayer(transparentBackground: _useBlurredVideoBackdrop),
              if (widget.overlayBuilder != null)
                Positioned.fill(
                  child: widget.overlayBuilder!(context, controller),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

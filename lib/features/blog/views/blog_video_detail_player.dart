import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/components/video_player/safe_flick_video_player.dart';
import 'package:qqai/components/video_player/shared_video_playback_session.dart';
import 'package:qqai/components/video_player/video_ad_overlay.dart';
import 'package:qqai/components/video_player/video_loading_placeholder.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/media_url.dart';
import 'package:video_player/video_player.dart';
import 'package:qqai/util/visibility_safe.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../data/models/blog_page_model.dart';
import 'blog_detail_video_surface_controls.dart';
import 'blog_detail_video_toolbar.dart';

/// 仅博客详情页使用：上方视频 + 下方 [BlogDetailVideoToolbar]。
///
/// 列表内嵌视频请用 [VideoItemPlayer] + [ItemControls]（控件叠在画面上）。
class BlogVideoDetailPlayer extends StatefulWidget {
  final BlogItem blog;
  final String? mediaHeroTag;
  final VoidCallback? onCompleted;
  final double? adTopInset;
  final double? adSkipRightInset;
  final bool isActive;
  final VideoAdPlaybackState? videoAdInitialState;
  final ValueChanged<VideoAdPlaybackState>? onVideoAdStateChanged;

  /// 为 false 时底部工具条仅保留进度条（窄屏推荐流等）。
  final bool showToolbarControlsRow;

  const BlogVideoDetailPlayer({
    super.key,
    required this.blog,
    this.mediaHeroTag,
    this.onCompleted,
    this.adTopInset,
    this.adSkipRightInset,
    this.isActive = true,
    this.videoAdInitialState,
    this.onVideoAdStateChanged,
    this.showToolbarControlsRow = true,
  });

  @override
  State<BlogVideoDetailPlayer> createState() => _BlogVideoDetailPlayerState();
}

class _BlogVideoDetailPlayerState extends State<BlogVideoDetailPlayer> {
  late FlickManager flickManager;
  late VideoPlayerController videoController;
  SharedVideoPlaybackSession? _sharedSession;
  bool _isDisposed = false;
  bool _didNotifyCompleted = false;

  @override
  void initState() {
    super.initState();
    final rawVideo = firstPlayableVideoUrlFromResources(widget.blog.resources);
    final videoUrl = resolveMediaUrl(rawVideo) ?? '';
    _sharedSession = videoUrl.isEmpty
        ? null
        : acquireSharedVideoPlaybackSession(videoUrl);
    videoController =
        _sharedSession?.videoController ??
        VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    videoController.addListener(_videoListener);
    flickManager =
        _sharedSession?.flickManager ??
        FlickManager(
          videoPlayerController: videoController,
          autoPlay: widget.isActive,
          autoInitialize: true,
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && mounted && widget.isActive) {
        flickManager.flickControlManager?.autoResume();
        _setVolumeIfNeeded();
      }
    });
  }

  @override
  void didUpdateWidget(BlogVideoDetailPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_isDisposed && mounted && widget.isActive) {
            flickManager.flickControlManager?.autoResume();
            _setVolumeIfNeeded();
          }
        });
      } else {
        _pause();
      }
    }
  }

  void _videoListener() {
    if (!_isDisposed &&
        mounted &&
        widget.isActive &&
        videoController.value.isInitialized) {
      if (videoController.value.volume == 0.0) {
        _setVolumeIfNeeded();
      }
      final value = videoController.value;
      final duration = value.duration;
      if (!_didNotifyCompleted &&
          duration > Duration.zero &&
          value.position >= duration - const Duration(milliseconds: 300)) {
        _didNotifyCompleted = true;
        widget.onCompleted?.call();
      }
    }
  }

  void _setVolumeIfNeeded() {
    if (!_isDisposed &&
        mounted &&
        widget.isActive &&
        videoController.value.isInitialized) {
      if (videoController.value.volume != 1.0) {
        videoController.setVolume(1.0);
      }
      flickManager.flickControlManager?.unmute();
    }
  }

  void _pause() {
    if (_isDisposed || !mounted) return;
    flickManager.flickControlManager?.autoPause();
  }

  @override
  void dispose() {
    _isDisposed = true;
    videoController.removeListener(_videoListener);
    final session = _sharedSession;
    if (session != null) {
      session.release();
    } else {
      flickManager.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rawVideo = firstPlayableVideoUrlFromResources(widget.blog.resources);
    final videoUrl = resolveMediaUrl(rawVideo);
    if (videoUrl == null || videoUrl.isEmpty) {
      return const Center(
        child: Text('暂无视频', style: TextStyle(color: Colors.white70)),
      );
    }
    final poster = resolveMediaUrl(resolveBlogCoverUrl(widget.blog));

    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (!_isDisposed && mounted) {
          final fraction = safeVisibleFraction(visibility);
          if (widget.isActive && fraction > 0.9) {
            flickManager.flickControlManager?.autoResume();
            _setVolumeIfNeeded();
          }
          if (!widget.isActive || fraction == 0) {
            _pause();
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _VideoSurfaceHero(
              tag: widget.mediaHeroTag,
              child: VideoAdOverlay(
                videoController: videoController,
                flickManager: flickManager,
                videoId: widget.blog.id,
                adTopInset: widget.adTopInset ?? 12,
                adSkipRightInset:
                    widget.adSkipRightInset ?? kVideoAdDetailSkipRightInset,
                initialPlaybackState: widget.videoAdInitialState,
                onPlaybackStateChanged: widget.onVideoAdStateChanged,
                child: SafeFlickVideoPlayer(
                  flickManager: flickManager,
                  flickVideoWithControls: FlickVideoWithControls(
                    videoFit: BoxFit.contain,
                    playerLoadingFallback: Positioned.fill(
                      child: VideoLoadingPlaceholder(
                        imageUrl: poster,
                        showPoster: true,
                      ),
                    ),
                    controls: const BlogDetailVideoSurfaceControls(),
                  ),
                  flickVideoWithControlsFullscreen: FlickVideoWithControls(
                    videoFit: BoxFit.contain,
                    playerLoadingFallback: VideoLoadingPlaceholder(
                      imageUrl: poster,
                      showPoster: true,
                      showIndicator: false,
                    ),
                    controls: FlickLandscapeControls(),
                    iconThemeData: const IconThemeData(
                      size: 40,
                      color: Colors.white,
                    ),
                    textStyle: context.typo.body.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          FlickManagerBuilder(
            flickManager: flickManager,
            child: BlogDetailVideoToolbar(
              showControlsRow: widget.showToolbarControlsRow,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoSurfaceHero extends StatelessWidget {
  const _VideoSurfaceHero({required this.child, this.tag});

  final Widget child;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    final heroTag = tag;
    if (heroTag == null || heroTag.isEmpty) return child;
    return Hero(tag: heroTag, transitionOnUserGestures: true, child: child);
  }
}

import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/blog/blog_danmaku.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/components/blog/video_cover_fit.dart';
import 'package:qqai/components/letterbox_backdrop.dart';
import 'package:qqai/components/video_player/safe_flick_video_player.dart';
import 'package:qqai/components/video_player/shared_video_playback_session.dart';
import 'package:qqai/components/video_player/video_ad_overlay.dart';
import 'package:qqai/components/video_player/video_loading_placeholder.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/media_url.dart';
import 'package:qqai/util/media_video_cache.dart';
import 'package:qqai/util/media_video_precache.dart';
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

  /// 留区域用模糊/灰黑底完整展示封面与视频（影视 Tab 推荐流等）。
  final VideoCoverFitMode coverFitMode;

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
    this.coverFitMode = VideoCoverFitMode.fill,
  });

  @override
  State<BlogVideoDetailPlayer> createState() => _BlogVideoDetailPlayerState();
}

class _BlogVideoDetailPlayerState extends State<BlogVideoDetailPlayer> {
  late final PageController _segmentsPageController;
  int _segmentIndex = 0;

  @override
  void initState() {
    super.initState();
    _segmentsPageController = PageController();
  }

  @override
  void dispose() {
    _segmentsPageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BlogVideoDetailPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.blog.id != widget.blog.id ||
        oldWidget.blog.resources != widget.blog.resources) {
      _segmentIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_segmentsPageController.hasClients) return;
        _segmentsPageController.jumpToPage(0);
      });
    }
  }

  Future<void> _handleSegmentCompleted(int segmentCount) async {
    final nextIndex = _segmentIndex + 1;
    if (nextIndex < segmentCount) {
      await _switchToSegment(nextIndex);
      return;
    }
    widget.onCompleted?.call();
  }

  Future<void> _switchToSegment(int index) async {
    if (index == _segmentIndex) return;
    if (!_segmentsPageController.hasClients) {
      if (mounted) setState(() => _segmentIndex = index);
      return;
    }
    await _segmentsPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
    if (!mounted) return;
    if (_segmentIndex != index) {
      setState(() => _segmentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rawVideos = playableVideoUrlsFromResources(widget.blog.resources);
    final videoUrls = rawVideos
        .map(resolveMediaUrl)
        .whereType<String>()
        .where((url) => url.isNotEmpty)
        .toList();

    if (videoUrls.isEmpty) {
      return const Center(
        child: Text('暂无视频', style: TextStyle(color: Colors.white70)),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheUpcomingBlogSegments(
        widget.blog.resources,
        currentSegmentIndex: _segmentIndex,
        aheadCount: 1,
      );
    });

    if (videoUrls.length == 1) {
      return _SingleVideoDetailPlayer(
        blog: widget.blog,
        videoUrl: videoUrls.first,
        mediaHeroTag: widget.mediaHeroTag,
        onCompleted: widget.onCompleted,
        adTopInset: widget.adTopInset,
        adSkipRightInset: widget.adSkipRightInset,
        isActive: widget.isActive,
        videoAdInitialState: widget.videoAdInitialState,
        onVideoAdStateChanged: widget.onVideoAdStateChanged,
        showToolbarControlsRow: widget.showToolbarControlsRow,
        coverFitMode: widget.coverFitMode,
        segmentCount: 1,
        segmentIndex: 0,
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _segmentsPageController,
          scrollDirection: Axis.horizontal,
          itemCount: videoUrls.length,
          onPageChanged: (index) {
            setState(() => _segmentIndex = index);
            precacheUpcomingBlogSegments(
              widget.blog.resources,
              currentSegmentIndex: index,
              aheadCount: 1,
            );
          },
          itemBuilder: (context, index) {
            return _SingleVideoDetailPlayer(
              key: ValueKey('blog_video_segment_${widget.blog.id}_$index'),
              blog: widget.blog,
              videoUrl: videoUrls[index],
              mediaHeroTag: index == 0 ? widget.mediaHeroTag : null,
              onCompleted: () => _handleSegmentCompleted(videoUrls.length),
              adTopInset: widget.adTopInset,
              adSkipRightInset: widget.adSkipRightInset,
              isActive: widget.isActive && index == _segmentIndex,
              videoAdInitialState: index == 0
                  ? widget.videoAdInitialState
                  : null,
              onVideoAdStateChanged: index == 0
                  ? widget.onVideoAdStateChanged
                  : null,
              showToolbarControlsRow: widget.showToolbarControlsRow,
              coverFitMode: widget.coverFitMode,
              segmentCount: videoUrls.length,
              segmentIndex: _segmentIndex,
              onSegmentSelected: _switchToSegment,
            );
          },
        ),
      ],
    );
  }
}

class _SingleVideoDetailPlayer extends StatefulWidget {
  const _SingleVideoDetailPlayer({
    super.key,
    required this.blog,
    required this.videoUrl,
    this.mediaHeroTag,
    this.onCompleted,
    this.adTopInset,
    this.adSkipRightInset,
    this.isActive = true,
    this.videoAdInitialState,
    this.onVideoAdStateChanged,
    this.showToolbarControlsRow = true,
    this.coverFitMode = VideoCoverFitMode.fill,
    this.segmentCount = 0,
    this.segmentIndex = 0,
    this.onSegmentSelected,
  });

  final BlogItem blog;
  final String videoUrl;
  final String? mediaHeroTag;
  final VoidCallback? onCompleted;
  final double? adTopInset;
  final double? adSkipRightInset;
  final bool isActive;
  final VideoAdPlaybackState? videoAdInitialState;
  final ValueChanged<VideoAdPlaybackState>? onVideoAdStateChanged;
  final bool showToolbarControlsRow;
  final VideoCoverFitMode coverFitMode;
  final int segmentCount;
  final int segmentIndex;
  final ValueChanged<int>? onSegmentSelected;

  @override
  State<_SingleVideoDetailPlayer> createState() =>
      _SingleVideoDetailPlayerState();
}

class _SingleVideoDetailPlayerState extends State<_SingleVideoDetailPlayer> {
  FlickManager? flickManager;
  VideoPlayerController? videoController;
  SharedVideoPlaybackSession? _sharedSession;
  bool _isDisposed = false;
  bool _didNotifyCompleted = false;
  bool _initializing = false;
  int _playbackGeneration = 0;

  /// Hero 过渡才复用共享会话；推荐流等场景独立初始化，避免滑动时复用失败控制器。
  bool get _usesSharedPlaybackSession {
    final tag = widget.mediaHeroTag;
    return tag != null && tag.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    precacheVideo(widget.videoUrl);
    unawaited(_attachPlayback());
  }

  Future<void> _attachPlayback() async {
    final generation = ++_playbackGeneration;
    final videoUrl = widget.videoUrl;

    try {
      if (_usesSharedPlaybackSession && videoUrl.isNotEmpty) {
        final session = await acquireSharedVideoPlaybackSession(
          playbackUrl: videoUrl,
          sessionKey: mediaCacheKey(videoUrl),
        );
        if (_isDisposed || !mounted || generation != _playbackGeneration) {
          session.release();
          return;
        }
        _sharedSession = session;
        videoController = session.videoController;
        flickManager = session.flickManager;
      } else {
        final controller = await createVideoPlayerController(videoUrl);
        if (_isDisposed || !mounted || generation != _playbackGeneration) {
          await controller.dispose();
          return;
        }
        _sharedSession = null;
        videoController = controller;
        flickManager = FlickManager(
          videoPlayerController: controller,
          autoPlay: false,
          autoInitialize: false,
        );
      }

      videoController!.addListener(_videoListener);
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) => _resumeIfActive());
    } catch (e, st) {
      debugPrint('BlogVideoDetailPlayer init failed: $e\n$st');
      if (mounted && generation == _playbackGeneration) {
        setState(() {});
      }
    }
  }

  void _detachPlayback({bool clearControllers = false}) {
    videoController?.removeListener(_videoListener);
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

  Future<void> _ensureInitialized() async {
    final controller = videoController;
    final manager = flickManager;
    if (controller == null || manager == null) return;
    if (_isDisposed || !mounted || !widget.isActive) return;
    if (controller.value.isInitialized || _initializing) return;
    if (controller.value.hasError) return;

    _initializing = true;
    try {
      await controller.initialize();
      if (!_isDisposed && mounted && widget.isActive) {
        manager.flickControlManager?.play();
        _setVolumeIfNeeded();
      }
    } catch (_) {
      // [VideoPlayerController] 会写入 hasError。
    } finally {
      _initializing = false;
      if (mounted) setState(() {});
    }
  }

  void _resumeIfActive() {
    if (_isDisposed || !mounted || !widget.isActive) return;
    unawaited(_ensureInitialized());
    flickManager?.flickControlManager?.autoResume();
    _setVolumeIfNeeded();
  }

  Future<void> _retryPlayback() async {
    if (_isDisposed || !mounted) return;
    _didNotifyCompleted = false;
    if (_usesSharedPlaybackSession) {
      invalidateSharedVideoPlaybackSession(widget.videoUrl);
    }
    _detachPlayback(clearControllers: true);
    await _attachPlayback();
  }

  @override
  void didUpdateWidget(_SingleVideoDetailPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mediaCacheKey(oldWidget.videoUrl) != mediaCacheKey(widget.videoUrl) ||
        oldWidget.mediaHeroTag != widget.mediaHeroTag) {
      precacheVideo(widget.videoUrl);
      _detachPlayback(clearControllers: true);
      _didNotifyCompleted = false;
      unawaited(_attachPlayback());
      return;
    }
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _resumeIfActive());
      } else {
        _pause();
      }
    }
  }

  void _videoListener() {
    final controller = videoController;
    if (controller == null) return;
    if (!_isDisposed && mounted && controller.value.hasError) {
      setState(() {});
      return;
    }
    if (!_isDisposed &&
        mounted &&
        widget.isActive &&
        controller.value.isInitialized) {
      if (controller.value.volume == 0.0) {
        _setVolumeIfNeeded();
      }
      final value = controller.value;
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
    final controller = videoController;
    final manager = flickManager;
    if (controller == null || manager == null) return;
    if (!_isDisposed &&
        mounted &&
        widget.isActive &&
        controller.value.isInitialized) {
      if (controller.value.volume != 1.0) {
        controller.setVolume(1.0);
      }
      manager.flickControlManager?.unmute();
    }
  }

  void _pause() {
    if (_isDisposed || !mounted) return;
    flickManager?.flickControlManager?.autoPause();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _detachPlayback();
    super.dispose();
  }

  Widget _buildPlayerErrorFallback(String? poster) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (poster != null && poster.isNotEmpty)
            VideoLoadingPlaceholder(
              imageUrl: poster,
              showPoster: true,
              showIndicator: false,
              coverFitMode: widget.coverFitMode,
            )
          else
            const ColoredBox(color: Colors.black),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '视频加载失败',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: _retryPlayback,
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoUrl = widget.videoUrl;
    if (videoUrl.isEmpty) {
      return const Center(
        child: Text('暂无视频', style: TextStyle(color: Colors.white70)),
      );
    }
    final poster = resolveMediaUrl(resolveBlogCoverUrl(widget.blog));
    final showToolbarDanmakuComposer = MediaQuery.sizeOf(context).width > 900;
    final letterboxShowFull = widget.coverFitMode == VideoCoverFitMode.showFull;
    final controller = videoController;
    final manager = flickManager;
    if (controller == null || manager == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: VideoLoadingPlaceholder(
              imageUrl: poster,
              showPoster: true,
              coverFitMode: widget.coverFitMode,
            ),
          ),
        ],
      );
    }

    return VisibilityDetector(
      key: ObjectKey(manager),
      onVisibilityChanged: (visibility) {
        if (!_isDisposed && mounted) {
          final fraction = safeVisibleFraction(visibility);
          if (widget.isActive && fraction > 0.9) {
            unawaited(_ensureInitialized());
            manager.flickControlManager?.autoResume();
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
                videoController: controller,
                flickManager: manager,
                videoId: widget.blog.id,
                adTopInset: widget.adTopInset ?? 12,
                adSkipRightInset:
                    widget.adSkipRightInset ?? kVideoAdDetailSkipRightInset,
                initialPlaybackState: widget.videoAdInitialState,
                onPlaybackStateChanged: widget.onVideoAdStateChanged,
                child: Stack(
                  children: [
                    SafeFlickVideoPlayer(
                      flickManager: manager,
                      flickVideoWithControls: FlickVideoWithControls(
                        videoFit: BoxFit.contain,
                        blurredBackdrop: letterboxShowFull,
                        letterboxBackdropMode:
                            resolveVideoLetterboxBackdropMode(),
                        backgroundColor: letterboxShowFull
                            ? Colors.transparent
                            : Colors.black,
                        playerLoadingFallback: Positioned.fill(
                          child: VideoLoadingPlaceholder(
                            imageUrl: poster,
                            showPoster: true,
                            coverFitMode: widget.coverFitMode,
                          ),
                        ),
                        playerErrorFallback: _buildPlayerErrorFallback(poster),
                        controls: const BlogDetailVideoSurfaceControls(),
                      ),
                      flickVideoWithControlsFullscreen: FlickVideoWithControls(
                        videoFit: BoxFit.contain,
                        playerLoadingFallback: VideoLoadingPlaceholder(
                          imageUrl: poster,
                          showPoster: true,
                          showIndicator: false,
                          coverFitMode: widget.coverFitMode,
                        ),
                        playerErrorFallback: _buildPlayerErrorFallback(poster),
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
                    Positioned.fill(
                      child: BlogDanmakuOverlay(
                        blogId: widget.blog.id,
                        positionListenable: controller,
                        bottomPadding: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FlickManagerBuilder(
            flickManager: manager,
            child: BlogDetailVideoToolbar(
              showControlsRow: widget.showToolbarControlsRow,
              segmentCount: widget.segmentCount,
              segmentIndex: widget.segmentIndex,
              onSegmentSelected: widget.onSegmentSelected,
              danmakuComposer: showToolbarDanmakuComposer
                  ? BlogDanmakuComposer(
                      blogId: widget.blog.id,
                      positionMillisGetter: () =>
                          controller.value.position.inMilliseconds,
                    )
                  : null,
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

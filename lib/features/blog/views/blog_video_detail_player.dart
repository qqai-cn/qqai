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
          onPageChanged: (index) => setState(() => _segmentIndex = index),
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
  late FlickManager flickManager;
  late VideoPlayerController videoController;
  SharedVideoPlaybackSession? _sharedSession;
  bool _isDisposed = false;
  bool _didNotifyCompleted = false;
  bool _initializing = false;

  /// Hero 过渡才复用共享会话；推荐流等场景独立初始化，避免滑动时复用失败控制器。
  bool get _usesSharedPlaybackSession {
    final tag = widget.mediaHeroTag;
    return tag != null && tag.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _attachPlayback();
    videoController.addListener(_videoListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resumeIfActive();
    });
  }

  void _attachPlayback() {
    final videoUrl = widget.videoUrl;
    if (_usesSharedPlaybackSession && videoUrl.isNotEmpty) {
      _sharedSession = acquireSharedVideoPlaybackSession(videoUrl);
      videoController = _sharedSession!.videoController;
      flickManager = _sharedSession!.flickManager;
      return;
    }

    _sharedSession = null;
    videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    flickManager = FlickManager(
      videoPlayerController: videoController,
      autoPlay: false,
      autoInitialize: false,
    );
  }

  void _detachPlayback() {
    videoController.removeListener(_videoListener);
    final session = _sharedSession;
    if (session != null) {
      session.release();
      _sharedSession = null;
    } else {
      flickManager.dispose();
    }
  }

  Future<void> _ensureInitialized() async {
    if (_isDisposed || !mounted || !widget.isActive) return;
    if (videoController.value.isInitialized || _initializing) return;
    if (videoController.value.hasError) return;

    _initializing = true;
    try {
      await videoController.initialize();
      if (!_isDisposed && mounted && widget.isActive) {
        flickManager.flickControlManager?.play();
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
    flickManager.flickControlManager?.autoResume();
    _setVolumeIfNeeded();
  }

  Future<void> _retryPlayback() async {
    if (_isDisposed || !mounted) return;
    _didNotifyCompleted = false;
    _detachPlayback();
    if (_usesSharedPlaybackSession) {
      invalidateSharedVideoPlaybackSession(widget.videoUrl);
    }
    _attachPlayback();
    videoController.addListener(_videoListener);
    setState(() {});
    _resumeIfActive();
  }

  @override
  void didUpdateWidget(_SingleVideoDetailPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl ||
        oldWidget.mediaHeroTag != widget.mediaHeroTag) {
      _detachPlayback();
      _didNotifyCompleted = false;
      _attachPlayback();
      videoController.addListener(_videoListener);
      WidgetsBinding.instance.addPostFrameCallback((_) => _resumeIfActive());
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
    if (!_isDisposed && mounted && videoController.value.hasError) {
      setState(() {});
      return;
    }
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

    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (!_isDisposed && mounted) {
          final fraction = safeVisibleFraction(visibility);
          if (widget.isActive && fraction > 0.9) {
            unawaited(_ensureInitialized());
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
                child: Stack(
                  children: [
                    SafeFlickVideoPlayer(
                      flickManager: flickManager,
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
                        positionListenable: videoController,
                        bottomPadding: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FlickManagerBuilder(
            flickManager: flickManager,
            child: BlogDetailVideoToolbar(
              showControlsRow: widget.showToolbarControlsRow,
              segmentCount: widget.segmentCount,
              segmentIndex: widget.segmentIndex,
              onSegmentSelected: widget.onSegmentSelected,
              danmakuComposer: showToolbarDanmakuComposer
                  ? BlogDanmakuComposer(
                      blogId: widget.blog.id,
                      positionMillisGetter: () =>
                          videoController.value.position.inMilliseconds,
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

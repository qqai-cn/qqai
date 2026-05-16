import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/components/video_player/safe_flick_video_player.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/media_url.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../data/models/blog_page_model.dart';
import 'blog_detail_video_surface_controls.dart';
import 'blog_detail_video_toolbar.dart';

/// 仅博客详情页使用：上方视频 + 下方 [BlogDetailVideoToolbar]。
///
/// 列表内嵌视频请用 [VideoItemPlayer] + [ItemControls]（控件叠在画面上）。
class BlogVideoDetailPlayer extends StatefulWidget {
  final BlogItem blog;

  const BlogVideoDetailPlayer({super.key, required this.blog});

  @override
  State<BlogVideoDetailPlayer> createState() => _BlogVideoDetailPlayerState();
}

class _BlogVideoDetailPlayerState extends State<BlogVideoDetailPlayer> {
  static const _defaultPoster =
      'https://file.qqai.cn/qqai/2025/09/1.webp';

  late FlickManager flickManager;
  late VideoPlayerController videoController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    final rawVideo = firstPlayableVideoUrlFromResources(widget.blog.resources);
    final videoUrl = resolveMediaUrl(rawVideo) ?? '';
    videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    videoController.addListener(_videoListener);

    flickManager = FlickManager(
      videoPlayerController: videoController,
      autoPlay: true,
      autoInitialize: true,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && mounted) {
        _setVolumeIfNeeded();
      }
    });
  }

  void _videoListener() {
    if (!_isDisposed && mounted && videoController.value.isInitialized) {
      if (videoController.value.volume == 0.0) {
        _setVolumeIfNeeded();
      }
    }
  }

  void _setVolumeIfNeeded() {
    if (!_isDisposed && mounted && videoController.value.isInitialized) {
      if (videoController.value.volume != 1.0) {
        videoController.setVolume(1.0);
      }
      flickManager.flickControlManager?.unmute();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    videoController.removeListener(_videoListener);
    flickManager.dispose();
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

    final posterRaw = firstStillImageUrlFromResources(
      widget.blog.resources,
      fallback: _defaultPoster,
    );
    final poster = resolveMediaUrl(posterRaw) ?? _defaultPoster;

    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (!_isDisposed && mounted) {
          if (visibility.visibleFraction > 0.9) {
            flickManager.flickControlManager?.autoResume();
            _setVolumeIfNeeded();
          }
          if (visibility.visibleFraction == 0) {
            flickManager.flickControlManager?.autoPause();
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SafeFlickVideoPlayer(
              flickManager: flickManager,
              flickVideoWithControls: FlickVideoWithControls(
                videoFit: BoxFit.contain,
                playerLoadingFallback: Positioned.fill(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(poster, fit: BoxFit.contain),
                      ),
                      const Positioned(
                        right: 10,
                        top: 10,
                        child: SizedBox(
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
                controls: const BlogDetailVideoSurfaceControls(),
              ),
              flickVideoWithControlsFullscreen: FlickVideoWithControls(
                videoFit: BoxFit.contain,
                playerLoadingFallback: Center(
                  child: Image.network(poster, fit: BoxFit.contain),
                ),
                controls: FlickLandscapeControls(),
                iconThemeData: const IconThemeData(size: 40, color: Colors.white),
                textStyle: context.typo.body.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          FlickManagerBuilder(
            flickManager: flickManager,
            child: const BlogDetailVideoToolbar(),
          ),
        ],
      ),
    );
  }
}

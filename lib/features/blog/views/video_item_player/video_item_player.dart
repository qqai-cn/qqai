import 'package:flutter/material.dart';

import '../../../../components/blog/blog_danmaku.dart';
import '../../../../components/blog/video_cover_fit.dart';
import '../../../../components/video_player/item_controls.dart';
import '../../../../components/video_player/qqai_player.dart';
import '../../../../components/video_player/video_ad_overlay.dart';

class VideoItemPlayer extends StatefulWidget {
  final String url;
  final String imgUrl;
  final int? videoId;
  final double fallbackAspectRatio;
  final VideoAdPlaybackState? videoAdInitialState;
  final ValueChanged<VideoAdPlaybackState>? onVideoAdStateChanged;
  final VoidCallback? onCompleted;
  final bool autoPlay;
  final VideoCoverFitMode coverFitMode;

  const VideoItemPlayer({
    super.key,
    required this.url,
    required this.imgUrl,
    this.videoId,
    this.fallbackAspectRatio = 15 / 9,
    this.videoAdInitialState,
    this.onVideoAdStateChanged,
    this.onCompleted,
    this.autoPlay = false,
    this.coverFitMode = VideoCoverFitMode.fill,
  });

  @override
  State<VideoItemPlayer> createState() => _FeedPlayerState();
}

class _FeedPlayerState extends State<VideoItemPlayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: QqaiPlayer(
          controls: ItemControls(),
          image: widget.imgUrl,
          url: widget.url,
          autoPlay: widget.autoPlay,
          videoId: widget.videoId,
          fallbackAspectRatio: widget.fallbackAspectRatio,
          showLoadingPoster: true,
          coverFitMode: widget.coverFitMode,
          sharedPlaybackKey: widget.url,
          videoAdInitialState: widget.videoAdInitialState,
          onVideoAdStateChanged: widget.onVideoAdStateChanged,
          onCompleted: widget.onCompleted,
          overlayBuilder: (context, positionListenable) => BlogDanmakuOverlay(
            blogId: widget.videoId,
            positionListenable: positionListenable,
            topPadding: 12,
            bottomPadding: 26,
          ),
        ),
      ),
    );
  }
}

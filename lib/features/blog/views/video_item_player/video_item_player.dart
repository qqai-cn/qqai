import 'package:flutter/material.dart';

import '../../../../components/video_player/item_controls.dart';
import '../../../../components/video_player/qqai_player.dart';

class VideoItemPlayer extends StatefulWidget {
  final String url;
  final String imgUrl;
  final int? videoId;
  final double fallbackAspectRatio;

  const VideoItemPlayer({
    super.key,
    required this.url,
    required this.imgUrl,
    this.videoId,
    this.fallbackAspectRatio = 15 / 9,
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
          autoPlay: false,
          videoId: widget.videoId,
          fallbackAspectRatio: widget.fallbackAspectRatio,
          showLoadingPoster: false,
          sharedPlaybackKey: widget.url,
        ),
      ),
    );
  }
}

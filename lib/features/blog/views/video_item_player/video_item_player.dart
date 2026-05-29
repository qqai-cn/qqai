import 'package:flutter/material.dart';

import '../../../../components/video_player/item_controls.dart';
import '../../../../components/video_player/qqai_player.dart';

class VideoItemPlayer extends StatefulWidget {
  final String url;
  final String imgUrl;
  final int? videoId;

  const VideoItemPlayer({
    super.key,
    required this.url,
    required this.imgUrl,
    this.videoId,
  });

  @override
  _FeedPlayerState createState() => _FeedPlayerState();
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
        ),
      ),
    );
  }
}

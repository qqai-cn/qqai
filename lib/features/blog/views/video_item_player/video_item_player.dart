import 'package:flutter/material.dart';

import '../../../../components/video_player/item_controls.dart';
import '../../../../components/video_player/qqai_player.dart';

class VideoItemPlayer extends StatefulWidget {
  String url;
  String imgUrl;

  VideoItemPlayer({Key? key, required this.url, required this.imgUrl})
    : super(key: key);

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
        ),
      ),
    );
  }
}

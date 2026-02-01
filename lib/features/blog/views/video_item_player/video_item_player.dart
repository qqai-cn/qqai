import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'multi_manager/flick_multi_manager.dart';
import 'multi_manager/flick_multi_player.dart';

class VideoItemPlayer extends StatefulWidget {
  String url;
  String imgUrl;

  VideoItemPlayer({Key? key, required this.url, required this.imgUrl})
    : super(key: key);

  @override
  _FeedPlayerState createState() => _FeedPlayerState();
}

class _FeedPlayerState extends State<VideoItemPlayer> {
  late FlickMultiManager flickMultiManager;

  @override
  void initState() {
    super.initState();
    flickMultiManager = FlickMultiManager();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickMultiManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction > 0.9 && this.mounted && 1.sw < 800) {
          flickMultiManager.play();
        }
      },
      child: Container(
        height: 800,
        margin: const EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: FlickMultiPlayer(
            url: widget.url,
            flickMultiManager: flickMultiManager,
            image: widget.imgUrl,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qqai/features/video/views/video_service.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:qqai/features/video/views/feed_video/feed_video_manager.dart';
import 'package:qqai/features/video/views/feed_video/feed_video_player.dart';

import '../../../video/data/mock_data.dart';

class VideoDetailPlayers extends StatefulWidget {
  const VideoDetailPlayers({Key? key}) : super(key: key);

  @override
  _VideoDetailPlayers createState() => _VideoDetailPlayers();
}

class _VideoDetailPlayers extends State<VideoDetailPlayers> {

  late FeedVideoManager feedVideoManager;
  List items = shortVideoMockData['items'];

  @override
  void initState() {
    super.initState();
    // getVideoData();
    feedVideoManager = FeedVideoManager();
  }

  Future<void> getVideoData() async {
    List<String> paths = await Future.wait([
      for (var data in shortVideoMockData['items'])
        VideoService.getVideoPath(data['trailer_url']),
    ]);
    items.addAll(paths);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(feedVideoManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          feedVideoManager.pause();
        }
      },
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            height: 800,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FeedVideoPlayer(
                url: items[index]['trailer_url'],
                thumbnailUrl: shortVideoMockData['items'][index]['image'],
                manager: feedVideoManager,
              ),
            ),
          );
        },
      ),
    );
  }
}

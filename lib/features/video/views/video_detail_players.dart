import 'package:flutter/material.dart';
import 'package:qqai/components/video_player/detail_controls.dart';
import 'package:qqai/components/video_player/qqai_player.dart';

import '../../../components/video_player/video_service.dart';
import '../../demo/flickvideo/short_video_player/data/mock_data.dart';

class VideoDetailPlayers extends StatefulWidget {
  const VideoDetailPlayers({Key? key}) : super(key: key);

  @override
  _VideoDetailPlayers createState() => _VideoDetailPlayers();
}

class _VideoDetailPlayers extends State<VideoDetailPlayers> {
  List items = shortVideoMockData['items'];

  @override
  void initState() {
    super.initState();
    // getVideoData();
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
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: QqaiPlayer(
              url: items[index]['trailer_url'],
              image: shortVideoMockData['items'][index]['image'],
              controls: DetailControls(),
              autoPlay: true,
            ),
          ),
        );
      },
    );
  }
}

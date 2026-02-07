import 'package:flutter/material.dart';

import 'package:qqai/features/video/views/feed_video/feed_video_player.dart';

/// 博客卡片内单视频播放（独立模式，无 manager）
class VideoItemPlayer extends StatelessWidget {
  const VideoItemPlayer({
    super.key,
    required this.url,
    required this.imgUrl,
  });

  final String url;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: FeedVideoPlayer(
          url: url,
          thumbnailUrl: imgUrl,
          manager: null,
        ),
      ),
    );
  }
}

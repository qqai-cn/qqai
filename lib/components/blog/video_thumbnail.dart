import 'package:flutter/material.dart';
import 'package:qqai/components/blog/video_cover_fit.dart';

class VideoThumbnail extends StatelessWidget {
  const VideoThumbnail({
    super.key,
    required this.imgUrl,
    required this.aspectRatio,
  });

  final String imgUrl;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          VideoCoverFit(url: imgUrl),
          const Icon(Icons.play_circle_fill, size: 56, color: Colors.white70),
        ],
      ),
    );
  }
}

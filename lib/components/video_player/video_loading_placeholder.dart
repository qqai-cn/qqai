import 'package:flutter/material.dart';
import 'package:qqai/components/blog/video_cover_fit.dart';

class VideoLoadingPlaceholder extends StatelessWidget {
  const VideoLoadingPlaceholder({
    super.key,
    this.imageUrl,
    this.showPoster = false,
    this.showIndicator = true,
  });

  final String? imageUrl;
  final bool showPoster;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    final shouldShowPoster =
        showPoster && imageUrl != null && imageUrl!.isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        shouldShowPoster
            ? VideoCoverFit(url: imageUrl!)
            : const ColoredBox(color: Colors.black),
        if (showIndicator)
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
    );
  }
}

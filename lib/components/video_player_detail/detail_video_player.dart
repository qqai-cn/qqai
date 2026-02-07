import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../features/video/data/mock_data.dart';


class DetailVideoPlayer extends StatefulWidget {
  DetailVideoPlayer({super.key});

  @override
  State<DetailVideoPlayer> createState() => _DetailVideoPlayerState();
}

class _DetailVideoPlayerState extends State<DetailVideoPlayer> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(shortVideoMockData["items"][1]["trailer_url"]),
    );
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
    );
    _videoController.initialize().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(_videoController),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          _videoController.pause();
        } else if (visibility.visibleFraction == 1 && mounted) {
          _videoController.play();
        }
      },
      child: _videoController.value.isInitialized
          ? Chewie(controller: _chewieController)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

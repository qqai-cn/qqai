import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:qqai/app/components/video_player_public/public_video_control.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../pages/demo/flickvideo/utils/mock_data.dart';
import 'public_data_manager.dart';

class PublicVideoPlayer extends StatefulWidget {
  PublicVideoPlayer({Key? key}) : super(key: key);

  @override
  _PublicVideoPlayer createState() => _PublicVideoPlayer();
}

class _PublicVideoPlayer extends State<PublicVideoPlayer> {
  late FlickManager flickManager;
  late PublicDataManager dataManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      autoPlay: false,
      videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(mockData["items"][1]["trailer_url"])),
    );
    List<String> urls = (mockData["items"] as List)
        .map<String>((item) => item["trailer_url"])
        .toList();

    dataManager = PublicDataManager(flickManager: flickManager, urls: urls);
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager?.autoResume();
        }
      },
      child: Container(
        child: FlickVideoPlayer(
          flickManager: flickManager,
          flickVideoWithControls: FlickVideoWithControls(
            controls: PublicVideoControl(
              dataManager: dataManager,
              iconSize: 30,
              fontSize: 14,
              progressBarSettings: FlickProgressBarSettings(
                height: 5,
                handleRadius: 5.5,
              ),
            ),
            videoFit: BoxFit.contain,
            // aspectRatioWhenLoading: 4 / 3,
          ),
        ),
      ),
    );
  }
}

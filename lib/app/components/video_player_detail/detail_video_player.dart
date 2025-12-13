import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../pages/demo/flickvideo/utils/mock_data.dart';
import 'detail_data_manager.dart';
import 'detail_video_control.dart';

class DetailVideoPlayer extends StatefulWidget {
  DetailVideoPlayer({Key? key}) : super(key: key);

  @override
  _DetailVideoPlayer createState() => _DetailVideoPlayer();
}

class _DetailVideoPlayer extends State<DetailVideoPlayer> {
  late FlickManager flickManager;
  late DetailDataManager dataManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.networkUrl(Uri.parse(mockData["items"][1]["trailer_url"])),
    );
    List<String> urls = (mockData["items"] as List)
        .map<String>((item) => item["trailer_url"])
        .toList();

    dataManager = DetailDataManager(flickManager: flickManager, urls: urls);
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
            controls: DetailVideoControl(
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

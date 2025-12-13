import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../pages/demo/flickvideo/utils/mock_data.dart';
import 'index_data_manager.dart';
import 'index_video_control.dart';

class IndexVideoPlayer extends StatefulWidget {
  IndexVideoPlayer({Key? key, required this.url, required this.allUrls})
      : super(key: key);
  final String url;
  final String allUrls;

  @override
  _IndexVideoPlayer createState() => _IndexVideoPlayer();
}

class _IndexVideoPlayer extends State<IndexVideoPlayer> {
  late FlickManager flickManager;
  late IndexDataManager dataManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      // autoInitialize: 1.sw > 1000 ? false : true,
      autoPlay: false,
      videoPlayerController:
          VideoPlayerController.networkUrl(Uri.parse(widget.url)),
      // Uri.parse(mockData["items"][1]["trailer_url"])),
    );
    List<String> urls = widget.allUrls.split(",").toList();
    // List<String> urls = (mockData["items"] as List)
    //     .map<String>((item) => item["trailer_url"])
    //     .toList();
    dataManager = IndexDataManager(flickManager: flickManager, urls: urls);
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
            controls: IndexVideoControl(
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

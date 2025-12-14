import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'index_data_manager.dart';

/// Default portrait controls.
class IndexVideoControl extends StatelessWidget {
  const IndexVideoControl(
      {Key? key,
      this.iconSize = 20,
      this.fontSize = 12,
      this.progressBarSettings,
      this.dataManager})
      : super(key: key);

  /// Icon size.
  ///
  /// This size is used for all the player icons.
  final double iconSize;

  /// [dataManager] is used to handle video controls.
  final IndexDataManager? dataManager;

  /// Font size.
  ///
  /// This size is used for all the text.
  final double fontSize;

  /// [FlickProgressBarSettings] settings.
  final FlickProgressBarSettings? progressBarSettings;

  @override
  Widget build(BuildContext context) {
    FlickVideoManager flickVideoManager =
        Provider.of<FlickVideoManager>(context);

    return FlickShowControlsActionWeb(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: FlickAnimatedVolumeLevel(
                decoration: BoxDecoration(
                  color: Colors.black26,
                ),
                textStyle: TextStyle(color: Colors.white, fontSize: 20),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
          ),
          Positioned.fill(
            child: FlickShowControlsAction(
              child: FlickSeekVideoAction(),
            ),
          ),
          Positioned.fill(
            child: FlickAutoHideChild(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlickVideoProgressBar(
                      flickProgressBarSettings: progressBarSettings,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlickPlayToggle(
                            size: iconSize,
                          ),
                          SizedBox(
                            width: iconSize / 2,
                          ),
                          FlickSoundToggle(
                            size: iconSize,
                          ),
                          SizedBox(
                            width: iconSize / 2,
                          ),
                          Row(
                            children: <Widget>[
                              FlickCurrentPosition(
                                fontSize: fontSize,
                              ),
                              FlickAutoHideChild(
                                child: Text(
                                  ' / ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: fontSize),
                                ),
                              ),
                              FlickTotalDuration(
                                fontSize: fontSize,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

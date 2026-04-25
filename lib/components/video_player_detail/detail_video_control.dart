import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

import 'detail_data_manager.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// Default portrait controls.
class DetailVideoControl extends StatelessWidget {
  const DetailVideoControl({
    Key? key,
    this.iconSize = 20,
    this.fontSize = 12,
    this.progressBarSettings,
    this.dataManager,
  }) : super(key: key);

  /// Icon size.
  ///
  /// This size is used for all the player icons.
  final double iconSize;

  /// [dataManager] is used to handle video controls.
  final DetailDataManager? dataManager;

  /// Font size.
  ///
  /// This size is used for all the text.
  final double fontSize;

  /// [FlickProgressBarSettings] settings.
  final FlickProgressBarSettings? progressBarSettings;

  @override
  Widget build(BuildContext context) {
    return FlickShowControlsActionWeb(
      child: Stack(
        children: <Widget>[
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
                          FlickPlayToggle(size: iconSize),
                          SizedBox(width: iconSize / 2),
                          FlickSoundToggle(size: iconSize),
                          SizedBox(width: iconSize / 2),
                          Row(
                            children: <Widget>[
                              FlickCurrentPosition(fontSize: fontSize),
                              FlickAutoHideChild(
                                child: Text(
                                  ' / ',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                    fontSize: fontSize,
                                  ),
                                ),
                              ),
                              FlickTotalDuration(fontSize: fontSize),
                            ],
                          ),
                          Spacer(),
                          FlickFullScreenToggle(size: iconSize),
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

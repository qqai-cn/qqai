import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

class ItemControls extends StatelessWidget {
  const ItemControls({Key? key}) : super(key: key);

  final double iconSize = 30;
  final double fontSize = 14;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FlickAutoHideChild(
            showIfVideoNotInitialized: false,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FlickLeftDuration(),
              ),
            ),
          ),
          Expanded(
            child: FlickTogglePlayAction(
              child: FlickSeekVideoAction(child: FlickVideoBuffer()),
            ),
          ),
          FlickAutoHideChild(
            autoHide: true,
            showIfVideoNotInitialized: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlickPlayToggle(size: iconSize),
                SizedBox(width: iconSize / 2),
                Row(
                  children: <Widget>[
                    FlickCurrentPosition(fontSize: fontSize),
                    FlickAutoHideChild(
                      child: Text(
                        ' / ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                    FlickTotalDuration(fontSize: fontSize),
                  ],
                ),
                Expanded(child: Container()),
                FlickSoundToggle(size: iconSize),
              ],
            ),
          ),
          FlickAutoHideChild(
            autoHide: true,
            child: FlickVideoProgressBar(
              flickProgressBarSettings: FlickProgressBarSettings(
                height: 5,
                handleRadius: 5.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

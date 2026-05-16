import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 底部视频工具条高度，供 overlay 避让。
const double kBlogDetailVideoToolbarHeight = 72;

/// 仅博客详情页：播放器下方的进度条与播放控制（白色、常显）。
class BlogDetailVideoToolbar extends StatelessWidget {
  const BlogDetailVideoToolbar({
    super.key,
    this.iconSize = 30,
    this.fontSize = 14,
  });

  final double iconSize;
  final double fontSize;

  static const _controlColor = Colors.white;

  static final _progressBarSettings = FlickProgressBarSettings(
    height: 5,
    handleRadius: 5.5,
    playedColor: Colors.white,
    bufferedColor: Color.fromRGBO(255, 255, 255, 0.38),
    handleColor: Colors.white,
    backgroundColor: Color.fromRGBO(255, 255, 255, 0.24),
  );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlickVideoProgressBar(
              flickProgressBarSettings: _progressBarSettings,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                FlickPlayToggle(size: iconSize, color: _controlColor),
                SizedBox(width: iconSize / 2),
                FlickSoundToggle(size: iconSize, color: _controlColor),
                SizedBox(width: iconSize / 2),
                FlickCurrentPosition(
                  fontSize: fontSize,
                  color: _controlColor,
                ),
                Text(
                  ' / ',
                  style: context.typo.body.copyWith(
                    color: _controlColor,
                    fontSize: fontSize,
                  ),
                ),
                FlickTotalDuration(
                  fontSize: fontSize,
                  color: _controlColor,
                ),
                const Spacer(),
                FlickFullScreenToggle(size: iconSize, color: _controlColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

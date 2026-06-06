import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 底部视频工具条高度（含控制行），供 overlay 避让。
const double kBlogDetailVideoToolbarHeight = 84;

/// 仅进度条、无控制行时的工具条高度。
const double kBlogDetailVideoToolbarProgressOnlyHeight = 37;

double blogDetailVideoToolbarHeight({bool showControlsRow = true}) =>
    showControlsRow
    ? kBlogDetailVideoToolbarHeight
    : kBlogDetailVideoToolbarProgressOnlyHeight;

double blogDetailVideoToolbarHeightForSegments({
  bool showControlsRow = true,
  int segmentCount = 0,
}) =>
    blogDetailVideoToolbarHeight(showControlsRow: showControlsRow) +
    (segmentCount > 1 && !showControlsRow ? 9 : 0);

/// 仅博客详情页：播放器下方的进度条与播放控制（白色、常显）。
class BlogDetailVideoToolbar extends StatelessWidget {
  const BlogDetailVideoToolbar({
    super.key,
    this.iconSize = 30,
    this.fontSize = 14,
    this.showControlsRow = true,
    this.segmentCount = 0,
    this.segmentIndex = 0,
    this.onSegmentSelected,
    this.danmakuComposer,
  });

  final double iconSize;
  final double fontSize;

  /// 为 false 时仅显示进度条（窄屏推荐流等场景）。
  final bool showControlsRow;

  /// 分段视频总段数；大于 1 时在工具栏内显示分段进度条。
  final int segmentCount;

  /// 当前分段下标。
  final int segmentIndex;

  /// 点击分段进度条时切换到对应分段。
  final ValueChanged<int>? onSegmentSelected;

  /// 可选弹幕发布组件，显示在时间与全屏按钮之间。
  final Widget? danmakuComposer;

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
            if (showControlsRow) ...[
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
                  FlickTotalDuration(fontSize: fontSize, color: _controlColor),
                  if (danmakuComposer != null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: danmakuComposer!,
                      ),
                    )
                  else if (segmentCount > 1)
                    Expanded(
                      child: Center(
                        child: _ToolbarSegmentProgressRow(
                          count: segmentCount,
                          selectedIndex: segmentIndex,
                          onSelected: onSegmentSelected,
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  FlickFullScreenToggle(size: iconSize, color: _controlColor),
                ],
              ),
            ] else if (segmentCount > 1) ...[
              const SizedBox(height: 6),
              Center(
                child: _ToolbarSegmentProgressRow(
                  count: segmentCount,
                  selectedIndex: segmentIndex,
                  onSelected: onSegmentSelected,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ToolbarSegmentProgressRow extends StatelessWidget {
  const _ToolbarSegmentProgressRow({
    required this.count,
    required this.selectedIndex,
    this.onSelected,
  });

  final int count;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width - 48;
    final width = (count * 34.0 + (count - 1) * 5).clamp(
      64.0,
      maxWidth.clamp(64.0, 180.0),
    );
    return SizedBox(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(count, (index) {
          final selected = index == selectedIndex;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index == count - 1 ? 0 : 5),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: onSelected == null ? null : () => onSelected!(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

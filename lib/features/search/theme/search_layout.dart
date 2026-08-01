import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 窄屏单列时内容最大宽度（居中），避免超宽屏一条拉满。
const double kSearchNarrowContentMaxWidth = 600;

/// 大于等于此宽度时：左侧落地 + 右侧结果，贴边分栏。
const double kSearchWideSplitBreakpoint = 1200;

/// 宽屏分栏时落地栏内容最大宽度。 
const double kSearchWideLandingPanelMaxWidth = 560;

/// 宽屏分栏时结果栏内容最大宽度（略宽以利双列）。
const double kSearchWideResultPanelMaxWidth = 720;

/// 结果列表可用宽度达到此值时双列展示横向卡片。
const double kSearchResultGridTwoColMinWidth = 520;

/// 搜索结果分类吸顶栏高度。
const double kSearchResultCategoryBarHeight = 52;

/// 分类 Tab 最大宽度，避免超宽屏三段拉得过散、字像「消失」。
const double kSearchCategoryBarMaxWidth = 420;

bool searchIsWideSplit(double width) => width >= kSearchWideSplitBreakpoint;

double searchPageHorizontalGap(double width) {
  if (width >= kSearchWideSplitBreakpoint) return 16;
  return 10.w;
}

int searchResultGridCrossAxisCount(double maxWidth) =>
    maxWidth >= kSearchResultGridTwoColMinWidth ? 2 : 1;

/// 窄屏：居中 + 限宽；宽屏 AppBar 可关闭居中。
Widget searchNarrowContent(Widget child, {bool centerPanel = true}) {
  if (!centerPanel) return child;
  return Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: kSearchNarrowContentMaxWidth),
      child: child,
    ),
  );
}

Widget searchWidePanelContent(Widget child, {required double maxWidth}) {
  return Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}

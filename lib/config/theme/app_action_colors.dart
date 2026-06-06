import 'package:flutter/material.dart';

import 'dark_theme_colors.dart';
import 'light_theme_colors.dart';

/// 顶栏 / 列表操作按钮（发布、搜索、喜欢、评论、分享等）统一前景色。
abstract final class AppActionColors {
  static Color foreground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? LightThemeColors.actionButtonForegroundColor
        : DarkThemeColors.actionButtonForegroundColor;
  }

  /// 已点赞等高亮态，保留语义色。
  static const Color liked = Colors.red;
}

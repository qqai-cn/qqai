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

  /// 次要文字（标签、副标题、分享渠道名等）。
  static Color muted(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black54
        : DarkThemeColors.bodyTextColor;
  }

  /// 更淡的辅助文字（时间、播放量、「回复」前缀等）。
  static Color subtle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black45
        : DarkThemeColors.bodySmallTextColor;
  }

  /// 强调文字（选中态背景上的反色文字除外时的主文字色）。
  static Color strong(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black87
        : DarkThemeColors.displayTextColor;
  }

  /// 分隔线、描边等低对比边界色。
  static Color borderSubtle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black12
        : Colors.white.withValues(alpha: 0.12);
  }

  /// 弹出菜单项文字（收藏 / 举报 / 不感兴趣等）。
  static Color menuItemForeground(BuildContext context) {
    return muted(context);
  }

  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color onSurface(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color onSurfaceVariant(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;
}

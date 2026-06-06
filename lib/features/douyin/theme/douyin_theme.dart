import 'package:flutter/material.dart';

import '../../../config/theme/dark_theme_colors.dart';

/// 抖音布局风格 + 浅色/深色自适应
abstract final class DouyinTheme {
  static const bgLight = Color(0xFFFFFFFF);
  static const cardLight = Color(0xFFF7F8FA);
  static const lineLight = Color(0xFFEBEDF0);
  static const accent = Color(0xFFFE2C55);
  static const textLight = Color(0xFF161823);
  static const subLight = Color(0xFF86878A);
  static const chipLight = Color(0xFFF5F5F5);

  static Color bg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? bgLight
        : DarkThemeColors.scaffoldBackgroundColor;
  }

  static Color card(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? cardLight
        : DarkThemeColors.cardColor;
  }

  static Color line(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lineLight
        : Colors.white.withValues(alpha: 0.12);
  }

  static Color text(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? textLight
        : DarkThemeColors.displayTextColor;
  }

  static Color sub(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? subLight
        : DarkThemeColors.bodySmallTextColor;
  }

  static Color chip(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? chipLight
        : DarkThemeColors.listTileBackgroundColor;
  }
}

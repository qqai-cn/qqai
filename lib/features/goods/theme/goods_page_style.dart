import 'package:flutter/material.dart';

import '../../../config/theme/dark_theme_colors.dart';

/// 商城页（详情 / 购物车 / 确认订单）统一视觉
abstract final class GoodsPageStyle {
  /// 浅色默认值，供尚未迁移的调用方使用。
  static const pageBgLight = Color(0xFFF6F7F9);
  static const cardBgLight = Colors.white;
  static const textLight = Color(0xFF202124);
  static const subLight = Color(0xFF6B7280);
  static const borderLight = Color(0xFFECEEF2);
  static const imageBgLight = Color(0xFFF3F5F8);

  static const accent = Color(0xFFE11D48);
  static const pageMaxWidth = 880.0;
  static const sidePanelWidth = 300.0;
  static const gutter = 16.0;
  static const wideBreakpoint = 900.0;

  static Color pageBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? pageBgLight
        : DarkThemeColors.scaffoldBackgroundColor;
  }

  static Color cardBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? cardBgLight
        : DarkThemeColors.cardColor;
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

  static Color border(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? borderLight
        : Colors.white.withValues(alpha: 0.12);
  }

  static Color imageBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? imageBgLight
        : DarkThemeColors.listTileBackgroundColor;
  }
}

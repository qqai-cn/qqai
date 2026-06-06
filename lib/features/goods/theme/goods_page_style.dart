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

  /// 相册区、顶栏留白等区块背景。
  static Color sectionBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFF7F7F7)
        : DarkThemeColors.listTileBackgroundColor;
  }

  static Color cardShadow(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Colors.black.withValues(alpha: isLight ? 0.03 : 0.35);
  }

  /// 评价摘要条、筛选 chip 等非卡片浅底。
  static Color tintedSurface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFF5F4FF)
        : cardBg(context);
  }

  static Color chipInactiveBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFF2F4F8)
        : imageBg(context);
  }

  static Color chipActiveBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFFFF2E5)
        : const Color(0xFF3D2E20);
  }

  static Color chipInactiveText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF4F5561)
        : sub(context);
  }

  static Color chipActiveText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFA46C2B)
        : const Color(0xFFE8A86E);
  }

  static Color skuChipActiveBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFFFEEE9)
        : const Color(0xFF3D2520);
  }

  static const skuAccent = Color(0xFFE6462D);
  static const commentAccent = Color(0xFFE85B43);
  static const starColor = Color(0xFFFFC54D);
}

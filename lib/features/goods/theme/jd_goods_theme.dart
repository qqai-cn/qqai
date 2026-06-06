import 'package:flutter/material.dart';

import '../../../config/theme/dark_theme_colors.dart';

/// 与商品详情评价区一致的京东系配色（购物车 / 结算 / 搜索页复用）
abstract final class JdGoodsTheme {
  static const Color red = Color(0xFFE4393C);
  static const Color text = Color(0xFF333333);
  static const Color sub = Color(0xFF999999);
  static const Color pageBg = Color(0xFFF5F5F5);
  static const Color line = Color(0xFFE5E5E5);
  static const Color white = Color(0xFFFFFFFF);

  static bool _isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  static Color textColor(BuildContext context) =>
      _isLight(context) ? text : DarkThemeColors.displayTextColor;

  static Color subColor(BuildContext context) =>
      _isLight(context) ? sub : DarkThemeColors.bodySmallTextColor;

  static Color pageBgColor(BuildContext context) =>
      _isLight(context) ? pageBg : DarkThemeColors.scaffoldBackgroundColor;

  static Color surfaceColor(BuildContext context) =>
      _isLight(context) ? white : DarkThemeColors.cardColor;

  static Color lineColor(BuildContext context) =>
      _isLight(context) ? line : Colors.white.withValues(alpha: 0.12);

  static Color chipBgColor(BuildContext context) =>
      _isLight(context)
          ? const Color(0xFFF2F2F2)
          : DarkThemeColors.listTileBackgroundColor;

  static Color searchBarBgColor(BuildContext context) => chipBgColor(context);

  static Color rankPanelGradientTop(BuildContext context) =>
      _isLight(context)
          ? const Color(0xFFFFF9F5)
          : const Color(0xFF3D2E28);

  static Color rankTitleColor(BuildContext context) =>
      _isLight(context)
          ? const Color(0xFF5C4033)
          : DarkThemeColors.displayTextColor;

  static Color rankIndexMutedColor(BuildContext context) =>
      _isLight(context)
          ? const Color(0xFF8D6E63)
          : DarkThemeColors.bodySmallTextColor;
}

import 'package:flutter/material.dart';

import 'dark_theme_colors.dart';
import 'light_theme_colors.dart';

/// 主 Shell 底部 / 宽屏左侧导航共用配色。
abstract final class ShellNavColors {
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color background(BuildContext context) => isDark(context)
      ? DarkThemeColors.bottomBarBackground
      : LightThemeColors.bottomBarBackground;

  static Color border(BuildContext context) => isDark(context)
      ? Colors.white.withValues(alpha: 0.08)
      : Colors.black.withValues(alpha: 0.06);

  static Color label(BuildContext context, {required bool isSelected, Color? lightAccent}) {
    if (isDark(context)) {
      return isSelected
          ? DarkThemeColors.bottomBarForeground
          : DarkThemeColors.bottomBarForegroundMuted;
    }
    return lightAccent ?? LightThemeColors.bottomBarForeground;
  }

  static Color selectedBackground(BuildContext context, {required Color lightAccent}) {
    if (isDark(context)) {
      return Colors.white.withValues(alpha: 0.12);
    }
    return lightAccent.withValues(alpha: 0.15);
  }

  static ColorFilter? iconColorFilter(
    BuildContext context, {
    required bool isSelected,
  }) {
    if (!isDark(context)) return null;
    return ColorFilter.mode(
      isSelected
          ? DarkThemeColors.bottomBarForeground
          : DarkThemeColors.bottomBarForegroundMuted,
      BlendMode.srcIn,
    );
  }

  /// 夜间模式统一用线框图标，避免 `-sel` 资源大面积底色被染成实心块。
  static String iconPath(
    BuildContext context, {
    required bool isSelected,
    required String selectPath,
    required String unSelectPath,
  }) {
    if (isDark(context)) return unSelectPath;
    return isSelected ? selectPath : unSelectPath;
  }
}

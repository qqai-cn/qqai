import 'package:flutter/material.dart';

/// 应用主题偏好：默认跟随系统，可手动指定浅色/深色。
enum AppThemePreference {
  system,
  light,
  dark,
}

ThemeMode themeModeFor(AppThemePreference preference) {
  return switch (preference) {
    AppThemePreference.system => ThemeMode.system,
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
  };
}

bool appThemeIsLight(
  AppThemePreference preference,
  Brightness platformBrightness,
) {
  return switch (preference) {
    AppThemePreference.system => platformBrightness == Brightness.light,
    AppThemePreference.light => true,
    AppThemePreference.dark => false,
  };
}

AppThemePreference oppositeThemePreference(
  AppThemePreference preference,
  Brightness platformBrightness,
) {
  final currentlyLight = appThemeIsLight(preference, platformBrightness);
  return currentlyLight ? AppThemePreference.dark : AppThemePreference.light;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../util/my_shared_pref.dart';
import 'app_theme_preference.dart';

part 'app_config_providers.g.dart';

// 主题模式 Provider - 使用 Riverpod 3 代码生成（可变的）
@riverpod
class AppThemeMode extends _$AppThemeMode {
  @override
  AppThemePreference build() => MySharedPref.getThemePreference();

  Future<void> setPreference(AppThemePreference preference) async {
    await MySharedPref.setThemePreference(preference);
    state = preference;
  }

  Future<void> toggleForPlatform(Brightness platformBrightness) async {
    await setPreference(
      oppositeThemePreference(state, platformBrightness),
    );
  }
}

// 语言 Locale Provider - 使用 Riverpod 3 代码生成（可变的）
@riverpod
class AppLocale extends _$AppLocale {
  @override
  Locale build() => MySharedPref.getCurrentLocal();

  Future<void> change(Locale newLocale) async {
    await MySharedPref.setCurrentLanguage(newLocale.languageCode);
    state = newLocale;
  }
}

// 工具函数：切换主题（保持向后兼容）
void toggleTheme(WidgetRef ref) {
  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  ref.read(appThemeModeProvider.notifier).toggleForPlatform(brightness);
}

// 工具函数：切换语言（保持向后兼容）
void changeLocale(WidgetRef ref, Locale newLocale) async {
  await ref.read(appLocaleProvider.notifier).change(newLocale);
}

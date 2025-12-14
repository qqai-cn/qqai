import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../util/my_shared_pref.dart';

part 'app_config_providers.g.dart';

// 主题模式 Provider - 使用 Riverpod 3 代码生成（可变的）
@riverpod
class AppThemeMode extends _$AppThemeMode {
  @override
  bool build() => MySharedPref.getThemeIsLight();

  void toggle() {
    final newMode = !state;
    MySharedPref.setThemeIsLight(newMode);
    state = newMode;
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
  ref.read(appThemeModeProvider.notifier).toggle();
}

// 工具函数：切换语言（保持向后兼容）
void changeLocale(WidgetRef ref, Locale newLocale) async {
  await ref.read(appLocaleProvider.notifier).change(newLocale);
}

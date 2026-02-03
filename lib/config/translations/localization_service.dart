import 'package:flutter/material.dart';

import '../../util/my_shared_pref.dart';
import 'ar_AR/ar_ar_translation.dart';
import 'en_US/en_us_translation.dart';
import 'zh_CN/zh_cn_translation.dart';

class LocalizationService {
  // prevent creating instance
  LocalizationService._();

  static LocalizationService? _instance;

  static LocalizationService getInstance() {
    _instance ??= LocalizationService._();
    return _instance!;
  }

  // default language
  // todo change the default language
  static Locale defaultLanguage = supportedLanguages['zh']!;

  // supported languages
  static Map<String, Locale> supportedLanguages = {
    'en': const Locale('en', 'US'),
    // Arabic
    // 'ar': const Locale('ar', 'AR'),
    // Chinese
    'zh': const Locale('zh', 'CN'),
  };

  // Supported languages font style.
  // 中文使用阿里巴巴普惠体（见 pubspec fonts + assets/fonts/）
  static Map<String, TextStyle> supportedLanguagesFontsFamilies = {
    'en': const TextStyle(
      fontFamily: 'Alibaba PuHuiTi',
      fontFamilyFallback: ['Alibaba PuHuiTi', 'Roboto'],
    ),
    // 'ar': const TextStyle(fontFamily: 'Cairo'),
    'zh': const TextStyle(
      fontFamily: 'Alibaba PuHuiTi',
      fontFamilyFallback: ['Alibaba PuHuiTi', 'Roboto'],
    ),
  };

  // Translation keys for supported languages
  static Map<String, Map<String, String>> get keys => {
    'en_US': enUs,
    'zh_CN': zhCN,
  };

  /// check if the language is supported
  static bool isLanguageSupported(String languageCode) =>
      supportedLanguages.keys.contains(languageCode);

  /// update app language by code language for example (en,ar..etc)
  /// Note: This method is deprecated. Use changeLocale from app_config_providers.dart instead.
  /// This method only updates SharedPreferences but doesn't update the UI.
  @Deprecated('Use changeLocale from app_config_providers.dart instead')
  static Future<void> updateLanguage(String languageCode) async {
    // check if the language is supported
    if (!isLanguageSupported(languageCode)) return;
    // update current language in shared pref
    await MySharedPref.setCurrentLanguage(languageCode);
    // Note: UI update should be done through Riverpod provider
    // Use changeLocale(ref, supportedLanguages[languageCode]!) instead
  }

  /// check if the language is english
  static bool isItEnglish() =>
      MySharedPref.getCurrentLocal().languageCode.toLowerCase().contains('en');

  /// get current locale
  static Locale getCurrentLocal() => MySharedPref.getCurrentLocal();
}

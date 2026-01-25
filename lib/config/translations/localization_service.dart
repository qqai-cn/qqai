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
    'ar': const Locale('ar', 'AR'),
    // Chinese
    'zh': const Locale('zh', 'CN'),
  };

  // supported languages fonts family (must be in assets & pubspec yaml) or you can use google fonts
  static Map<String, TextStyle> supportedLanguagesFontsFamilies = {
    // todo add your English font families (add to assets/fonts, pubspec and name it here) default is poppins for english and cairo for arabic
    'en': const TextStyle(fontFamily: 'Poppins'),
    // 'ar': const TextStyle(fontFamily: 'Cairo'),
    // Chinese: prefer system font unless you bundle a font asset and set its family here (e.g. 'Alibaba PuHuiTi')
    'zh': const TextStyle(fontFamily: '"PingFang SC", "Microsoft YaHei", sans-serif',),
  };

  // Translation keys for supported languages
  static Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        // 'ar_AR': arAR,
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


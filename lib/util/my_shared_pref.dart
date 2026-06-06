import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/translations/localization_service.dart';
import '../providers/app_theme_preference.dart';

class MySharedPref {
  // prevent making instance
  MySharedPref._();

  // get storage
  static late SharedPreferences _sharedPreferences;

  // STORING KEYS
  static const String _fcmTokenKey = 'fcm_token';
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _watchHistoryKey = 'watch_history_v1';
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';
  static const String _themePreferenceKey = 'theme_preference';

  /// init get storage services
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  /// set theme current type as light theme
  @Deprecated('Use setThemePreference instead')
  static Future<void> setThemeIsLight(bool lightTheme) =>
      setThemePreference(
        lightTheme ? AppThemePreference.light : AppThemePreference.dark,
      );

  /// get if the current theme type is light
  @Deprecated('Use getThemePreference instead')
  static bool getThemeIsLight() {
    final preference = getThemePreference();
    if (preference == AppThemePreference.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.light;
    }
    return preference == AppThemePreference.light;
  }

  static Future<void> setThemePreference(AppThemePreference preference) =>
      _sharedPreferences.setString(_themePreferenceKey, preference.name);

  static AppThemePreference getThemePreference() {
    final stored = _sharedPreferences.getString(_themePreferenceKey);
    if (stored != null) {
      for (final preference in AppThemePreference.values) {
        if (preference.name == stored) return preference;
      }
    }
    if (_sharedPreferences.containsKey(_lightThemeKey)) {
      final isLight = _sharedPreferences.getBool(_lightThemeKey)!;
      return isLight ? AppThemePreference.light : AppThemePreference.dark;
    }
    return AppThemePreference.system;
  }

  /// save current locale
  static Future<void> setCurrentLanguage(String languageCode) =>
      _sharedPreferences.setString(_currentLocalKey, languageCode);

  /// get current locale
  static Locale getCurrentLocal(){
      String? langCode = _sharedPreferences.getString(_currentLocalKey);
      // default language is english
      if(langCode == null){
        return LocalizationService.defaultLanguage;
      }
      return LocalizationService.supportedLanguages[langCode]!;
  }

  /// save generated fcm token
  static Future<void> setFcmToken(String token) =>
      _sharedPreferences.setString(_fcmTokenKey, token);

  /// get authorization token
  static String? getFcmToken() =>
      _sharedPreferences.getString(_fcmTokenKey);

  /// save auth token
  static Future<void> setAuthToken(String token) =>
      _sharedPreferences.setString(_authTokenKey, token);

  /// get auth token
  static String? getAuthToken() => _sharedPreferences.getString(_authTokenKey);

  /// save refresh token
  static Future<void> setRefreshToken(String token) =>
      _sharedPreferences.setString(_refreshTokenKey, token);

  /// get refresh token
  static String? getRefreshToken() => _sharedPreferences.getString(_refreshTokenKey);

  /// save logged-in user id
  static Future<void> setUserId(String userId) =>
      _sharedPreferences.setString(_userIdKey, userId);

  /// get logged-in user id
  static String? getUserId() => _sharedPreferences.getString(_userIdKey);

  /// clear auth tokens only
  static Future<void> clearAuthTokens() async {
    await _sharedPreferences.remove(_authTokenKey);
    await _sharedPreferences.remove(_refreshTokenKey);
    await _sharedPreferences.remove(_userIdKey);
  }

  /// clear auth token only (keep for backward compatibility)
  static Future<void> clearAuthToken() async =>
      _sharedPreferences.remove(_authTokenKey);

  /// clear all data from shared pref
  static Future<void> clear() async => await _sharedPreferences.clear();

  /// 观看历史（JSON 数组字符串）
  static Future<void> setWatchHistoryJson(String json) =>
      _sharedPreferences.setString(_watchHistoryKey, json);

  static String getWatchHistoryJson() =>
      _sharedPreferences.getString(_watchHistoryKey) ?? '[]';

}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../util/my_shared_pref.dart';
import 'dark_theme_colors.dart';
import 'light_theme_colors.dart';
import 'my_styles.dart';

class MyTheme {
  static ThemeData getThemeData({required bool isLight}) {
    // 使用 Material 默认 Roboto；Web 由引擎从 fonts.gstatic.com 拉取（含中文回退 Noto）。
    return ThemeData(
      primaryColor: isLight
          ? LightThemeColors.primaryColor
          : DarkThemeColors.primaryColor,

      // secondary & background color
      colorScheme:
          ColorScheme.fromSwatch(
            primarySwatch: Colors.green,
            accentColor: isLight
                ? LightThemeColors.accentColor
                : DarkThemeColors.accentColor,
            backgroundColor: isLight
                ? LightThemeColors.backgroundColor
                : DarkThemeColors.backgroundColor,
            brightness: isLight ? Brightness.light : Brightness.dark,
          ).copyWith(
            secondary: isLight
                ? LightThemeColors.accentColor
                : DarkThemeColors.accentColor,
          ),

      // color contrast (if the theme is dark text should be white for example)
      brightness: isLight ? Brightness.light : Brightness.dark,

      // card widget background color
      cardColor: isLight
          ? LightThemeColors.cardColor
          : DarkThemeColors.cardColor,

      // hint text color
      hintColor: isLight
          ? LightThemeColors.hintTextColor
          : DarkThemeColors.hintTextColor,

      // divider color
      dividerColor: isLight
          ? LightThemeColors.dividerColor
          : DarkThemeColors.dividerColor,

      // app background color
      scaffoldBackgroundColor: isLight
          ? LightThemeColors.scaffoldBackgroundColor
          : DarkThemeColors.scaffoldBackgroundColor,

      // progress bar theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: isLight
            ? LightThemeColors.primaryColor
            : DarkThemeColors.primaryColor,
      ),

      // appBar theme
      appBarTheme: MyStyles.getAppBarTheme(isLightTheme: isLight),

      // elevated button theme
      elevatedButtonTheme: MyStyles.getElevatedButtonTheme(
        isLightTheme: isLight,
      ),

      // text button theme (feed actions, share, etc.)
      textButtonTheme: MyStyles.getTextButtonTheme(isLightTheme: isLight),

      // text theme
      textTheme: MyStyles.getTextTheme(isLightTheme: isLight),

      // chip theme
      chipTheme: MyStyles.getChipTheme(isLightTheme: isLight),

      // icon theme
      iconTheme: MyStyles.getIconTheme(isLightTheme: isLight),
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent, // ← 关键！隐藏底部横线
      ),

      // list tile theme
      listTileTheme: MyStyles.getListTileThemeData(isLightTheme: isLight),
      switchTheme: MyStyles.getSwitchTheme(isLightTheme: isLight),
      inputDecorationTheme: MyStyles.getInputDecorationTheme(),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.lightGreen,
        width: 400,
        insetPadding: EdgeInsets.only(bottom: 0.2.sh, left: 200.w),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.lightGreen,
      ),
      // custom themes
      extensions: [
        MyStyles.getHeaderContainerTheme(isLightTheme: isLight),
        MyStyles.getEmployeeListItemTheme(isLightTheme: isLight),
      ],
    );
  }

  /// update app theme and save theme type to shared pref
  /// (so when the app is killed and up again theme will remain the same)
  /// Note: This method is deprecated. Use toggleTheme from app_config_providers.dart instead.
  /// This method is kept for backward compatibility but does nothing.
  @Deprecated('Use toggleTheme from app_config_providers.dart instead')
  static void changeTheme() {
    // This method is deprecated. Use toggleTheme(WidgetRef ref) from app_config_providers.dart
    // to change theme with Riverpod.
    // Example: toggleTheme(ref) where ref is WidgetRef from ConsumerWidget or Consumer
  }

  /// check if the theme is light or dark
  static bool get getThemeIsLight => MySharedPref.getThemeIsLight();
}

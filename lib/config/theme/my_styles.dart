import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/theme_extensions/header_container_theme_data.dart';

import 'dark_theme_colors.dart';
import 'my_fonts.dart';
import 'light_theme_colors.dart';
import 'theme_extensions/employee_list_item_theme_data.dart';

class MyStyles {
  /// custom employee list item theme
  static EmployeeListItemThemeData getEmployeeListItemTheme(
      {required bool isLightTheme}) {
    return EmployeeListItemThemeData(
      backgroundColor: isLightTheme
          ? LightThemeColors.employeeListItemBackgroundColor
          : DarkThemeColors.employeeListItemBackgroundColor,
      iconTheme: IconThemeData(
        color: isLightTheme
            ? LightThemeColors.employeeListItemIconsColor
            : DarkThemeColors.employeeListItemIconsColor,
      ),
      nameTextStyle: MyFonts.bodyTextStyle.copyWith(
        fontSize: MyFonts.employeeListItemNameSize,
        fontWeight: FontWeight.bold,
        color: isLightTheme
            ? LightThemeColors.employeeListItemNameColor
            : DarkThemeColors.employeeListItemNameColor,
      ),
      subtitleTextStyle: MyFonts.bodyTextStyle.copyWith(
        fontSize: MyFonts.employeeListItemSubtitleSize,
        fontWeight: FontWeight.normal,
        color: isLightTheme
            ? LightThemeColors.employeeListItemSubtitleColor
            : DarkThemeColors.employeeListItemSubtitleColor,
      ),
    );
  }

  /// custom header theme
  static HeaderContainerThemeData getHeaderContainerTheme(
          {required bool isLightTheme}) =>
      HeaderContainerThemeData(
          decoration: BoxDecoration(
        color: isLightTheme
            ? LightThemeColors.headerContainerBackgroundColor
            : DarkThemeColors.headerContainerBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ));

  ///icons theme
  static IconThemeData getIconTheme({required bool isLightTheme}) =>
      IconThemeData(
        color: isLightTheme
            ? LightThemeColors.iconColor
            : DarkThemeColors.iconColor,
      );

  static TabBarThemeData getTabBarTheme({required bool isLightTheme}) {
    return TabBarThemeData(
      dividerColor: Colors.transparent,
      labelColor: isLightTheme
          ? LightThemeColors.actionButtonForegroundColor
          : DarkThemeColors.bottomBarForeground,
      unselectedLabelColor: isLightTheme
          ? LightThemeColors.bodySmallTextColor
          : DarkThemeColors.bottomBarForegroundMuted,
      indicatorColor: isLightTheme
          ? const Color(0xFF00BD5F)
          : DarkThemeColors.bottomBarForeground,
    );
  }

  static CardThemeData getCardTheme({required bool isLightTheme}) {
    return CardThemeData(
      color: isLightTheme
          ? LightThemeColors.cardColor
          : DarkThemeColors.cardColor,
      elevation: isLightTheme ? 1 : 0,
      shadowColor: Colors.black26,
      surfaceTintColor: Colors.transparent,
    );
  }

  static PopupMenuThemeData getPopupMenuTheme({required bool isLightTheme}) {
    return PopupMenuThemeData(
      color: isLightTheme
          ? LightThemeColors.cardColor
          : DarkThemeColors.cardColor,
      surfaceTintColor: Colors.transparent,
      textStyle: MyFonts.bodyTextStyle.copyWith(
        fontSize: MyFonts.bodyMediumSize,
        color: isLightTheme
            ? Colors.black54
            : DarkThemeColors.bodyTextColor,
      ),
    );
  }

  ///app bar theme
  static AppBarTheme getAppBarTheme({required bool isLightTheme}) =>
      AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: isLightTheme
            ? LightThemeColors.actionButtonForegroundColor
            : DarkThemeColors.bottomBarForeground,
        titleTextStyle:
            getTextTheme(isLightTheme: isLightTheme).bodyMedium!.copyWith(
                  color: isLightTheme
                      ? LightThemeColors.actionButtonForegroundColor
                      : DarkThemeColors.bottomBarForeground,
                  fontSize: MyFonts.appBarTittleSize,
                ),
        iconTheme: IconThemeData(
            color: isLightTheme
                ? LightThemeColors.appBarIconsColor
                : DarkThemeColors.appBarIconsColor),
        backgroundColor: isLightTheme
            ? LightThemeColors.appBarColor
            : DarkThemeColors.appbarColor,
      );

  ///text theme
  static TextTheme getTextTheme({required bool isLightTheme}) => TextTheme(
        labelLarge: MyFonts.buttonTextStyle.copyWith(
          fontSize: MyFonts.buttonTextSize,
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        labelMedium: MyFonts.buttonTextStyle.copyWith(
          fontSize: MyFonts.buttonTextSize,
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        labelSmall: MyFonts.buttonTextStyle.copyWith(
          fontSize: MyFonts.buttonTextSize,
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        bodyLarge: (MyFonts.bodyTextStyle).copyWith(
          fontWeight: FontWeight.bold,
          fontSize: MyFonts.bodyLargeSize,
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        bodyMedium: (MyFonts.bodyTextStyle).copyWith(
          fontSize: MyFonts.bodyMediumSize,
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        displayLarge: (MyFonts.displayTextStyle).copyWith(
          fontSize: MyFonts.displayLargeSize,
          fontWeight: FontWeight.bold,
          color: isLightTheme
              ? LightThemeColors.displayTextColor
              : DarkThemeColors.displayTextColor,
        ),
        bodySmall: MyFonts.bodyTextStyle.copyWith(
            color: isLightTheme
                ? LightThemeColors.bodySmallTextColor
                : DarkThemeColors.bodySmallTextColor,
            fontSize: MyFonts.bodySmallTextSize),
        displayMedium: (MyFonts.displayTextStyle).copyWith(
            fontSize: MyFonts.displayMediumSize,
            fontWeight: FontWeight.bold,
            color: isLightTheme
                ? LightThemeColors.displayTextColor
                : DarkThemeColors.displayTextColor),
        displaySmall: (MyFonts.displayTextStyle).copyWith(
          fontSize: MyFonts.displaySmallSize,
          fontWeight: FontWeight.bold,
          color: isLightTheme
              ? LightThemeColors.displayTextColor
              : DarkThemeColors.displayTextColor,
        ),
      );

  static ChipThemeData getChipTheme({required bool isLightTheme}) {
    return ChipThemeData(
      backgroundColor: isLightTheme
          ? LightThemeColors.chipBackground
          : DarkThemeColors.chipBackground,
      brightness: Brightness.light,
      labelStyle: getChipTextStyle(isLightTheme: isLightTheme),
      secondaryLabelStyle: getChipTextStyle(isLightTheme: isLightTheme),
      selectedColor: Colors.black,
      disabledColor: Colors.green,
      padding: const EdgeInsets.all(5),
      secondarySelectedColor: Colors.purple,
    );
  }

  ///Chips text style
  static TextStyle getChipTextStyle({required bool isLightTheme}) {
    return MyFonts.chipTextStyle.copyWith(
      fontSize: MyFonts.chipTextSize,
      color: isLightTheme
          ? LightThemeColors.chipTextColor
          : DarkThemeColors.chipTextColor,
    );
  }

  // elevated button text style
  static WidgetStateProperty<TextStyle?>? getElevatedButtonTextStyle(
      bool isLightTheme,
      {bool isBold = true,
      double? fontSize}) {
    return WidgetStateProperty.resolveWith<TextStyle>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return MyFonts.buttonTextStyle.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize ?? MyFonts.buttonTextSize,
            color: isLightTheme
                ? LightThemeColors.buttonTextColor
                : DarkThemeColors.buttonTextColor,
          );
        } else if (states.contains(WidgetState.disabled)) {
          return MyFonts.buttonTextStyle.copyWith(
            fontSize: fontSize ?? MyFonts.buttonTextSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isLightTheme
                ? LightThemeColors.buttonDisabledTextColor
                : DarkThemeColors.buttonDisabledTextColor,
          );
        }
        return MyFonts.buttonTextStyle.copyWith(
          fontSize: fontSize ?? MyFonts.buttonTextSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isLightTheme
              ? LightThemeColors.buttonTextColor
              : DarkThemeColors.buttonTextColor,
        ); // Use the component's default.
      },
    );
  }

  //elevated button theme data
  static ElevatedButtonThemeData getElevatedButtonTheme(
          {required bool isLightTheme}) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      );

  /// 列表/顶栏 TextButton.icon（喜欢、评论、分享等）统一前景色。
  static TextButtonThemeData getTextButtonTheme({required bool isLightTheme}) {
    final foreground = isLightTheme
        ? LightThemeColors.actionButtonForegroundColor
        : DarkThemeColors.actionButtonForegroundColor;
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: foreground,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  /// list tile theme data
  static ListTileThemeData getListTileThemeData({required bool isLightTheme}) {
    return ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      iconColor: isLightTheme
          ? LightThemeColors.listTileIconColor
          : DarkThemeColors.listTileIconColor,
      tileColor: isLightTheme
          ? LightThemeColors.listTileBackgroundColor
          : DarkThemeColors.listTileBackgroundColor,
      titleTextStyle: TextStyle(
        fontSize: MyFonts.listTileTitleSize,
        color: isLightTheme
            ? LightThemeColors.listTileTitleColor
            : DarkThemeColors.listTileTitleColor,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: MyFonts.listTileSubtitleSize,
        color: isLightTheme
            ? LightThemeColors.listTileSubtitleColor
            : DarkThemeColors.listTileSubtitleColor,
      ),
    );
  }

  static InputDecorationTheme getInputDecorationTheme() {
    return InputDecorationTheme(
      hintStyle: MyFonts.bodyTextStyle.copyWith(
        fontSize: MyFonts.bodySmallTextSize,
        color: Colors.grey,
      ),
    );
  }

  /// Switch / SwitchListTile 统一对比度（个人中心夜间模式等）。
  static DividerThemeData getDividerTheme({required bool isLightTheme}) {
    return DividerThemeData(
      color: isLightTheme
          ? LightThemeColors.dividerColor
          : DarkThemeColors.dividerColor,
      thickness: 1,
      space: 1,
    );
  }

  static DialogThemeData getDialogTheme({required bool isLightTheme}) {
    return DialogThemeData(
      backgroundColor: isLightTheme
          ? LightThemeColors.cardColor
          : DarkThemeColors.cardColor,
      surfaceTintColor: Colors.transparent,
      elevation: isLightTheme ? 8 : 4,
      titleTextStyle: MyFonts.displayTextStyle.copyWith(
        fontSize: MyFonts.displaySmallSize,
        fontWeight: FontWeight.bold,
        color: isLightTheme
            ? LightThemeColors.displayTextColor
            : DarkThemeColors.displayTextColor,
      ),
      contentTextStyle: MyFonts.bodyTextStyle.copyWith(
        fontSize: MyFonts.bodyMediumSize,
        color: isLightTheme
            ? LightThemeColors.bodyTextColor
            : DarkThemeColors.bodyTextColor,
      ),
    );
  }

  static BottomSheetThemeData getBottomSheetTheme({required bool isLightTheme}) {
    return BottomSheetThemeData(
      backgroundColor: isLightTheme
          ? LightThemeColors.cardColor
          : DarkThemeColors.cardColor,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: Colors.black54,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  static SwitchThemeData getSwitchTheme({required bool isLightTheme}) {
    final trackOff = isLightTheme
        ? LightThemeColors.switchTrackOff
        : DarkThemeColors.switchTrackOff;
    final trackOutlineOff = isLightTheme
        ? LightThemeColors.switchTrackOutlineOff
        : DarkThemeColors.switchTrackOutlineOff;
    final trackOn = isLightTheme
        ? LightThemeColors.switchTrackOn
        : DarkThemeColors.switchTrackOn;
    final thumb = isLightTheme
        ? LightThemeColors.switchThumb
        : DarkThemeColors.switchThumb;
    final trackDisabled = isLightTheme
        ? LightThemeColors.switchTrackDisabled
        : DarkThemeColors.switchTrackDisabled;
    final thumbDisabled = isLightTheme
        ? LightThemeColors.switchThumbDisabled
        : DarkThemeColors.switchThumbDisabled;

    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return thumbDisabled;
        }
        return thumb;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return trackDisabled;
        }
        if (states.contains(WidgetState.selected)) {
          return trackOn;
        }
        return trackOff;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return trackOutlineOff;
      }),
    );
  }
}

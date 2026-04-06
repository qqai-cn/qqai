import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../util/my_shared_pref.dart';
import '../translations/localization_service.dart';

//  configure text family and size
class MyFonts
{
  // return the right font depending on app language
  static TextStyle get getAppFontType => LocalizationService.supportedLanguagesFontsFamilies[MySharedPref.getCurrentLocal().languageCode]!;

  // headlines text font
  static TextStyle get displayTextStyle => getAppFontType;

  // body text font
  static TextStyle get bodyTextStyle => getAppFontType;

  // button text font
  static TextStyle get buttonTextStyle => getAppFontType;

  // app bar text font
  static TextStyle get appBarTextStyle  => getAppFontType;

  // chips text font
  static TextStyle get chipTextStyle  => getAppFontType;

  // appbar font size
  // static double get appBarTittleSize => 18.sp;
  static double get appBarTittleSize => 18.sp.clamp(20, 40);

  // body font size
  static double get bodySmallTextSize => 11.sp.clamp(10, 20);
  static double get bodyMediumSize => 13.sp.clamp(10, 30); // default font
  static double get bodyLargeSize => 16.sp.clamp(10, 50);
  // display font size
  static double get displayLargeSize => 20.sp.clamp(10, 50);
  static double get displayMediumSize => 17.sp.clamp(10, 50);
  static double get displaySmallSize => 14.sp.clamp(10, 50);

  //button font size
  // static double get buttonTextSize => 20.sp;
  static double get buttonTextSize => 18;

  //chip font size
  static double get chipTextSize => 10.sp.clamp(10, 50);

  // list tile fonts sizes
  // static double get listTileTitleSize => 13.sp;
  // static double get listTileSubtitleSize => 12.sp;
  static double get listTileTitleSize => 15;
  static double get listTileSubtitleSize => 12;

  // custom themes (extensions)
  static double get employeeListItemNameSize => 13;
  static double get employeeListItemSubtitleSize => 13;
  static double get labelSize => 8.sp.clamp(5, 15);
}
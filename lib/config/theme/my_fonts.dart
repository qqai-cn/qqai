import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/constant/constant.dart';

import '../../util/my_shared_pref.dart';
import '../translations/localization_service.dart';
import 'dark_theme_colors.dart';

//  configure text family and size
class MyFonts
{
  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color _onSurface(BuildContext context) => _isDark(context)
      ? DarkThemeColors.displayTextColor
      : Colors.black;

  static Color _onSurfaceVariant(BuildContext context) => _isDark(context)
      ? DarkThemeColors.bodyTextColor
      : Colors.black87;

  static Color _onSurfaceMuted(BuildContext context) => _isDark(context)
      ? DarkThemeColors.bodySmallTextColor
      : Colors.black54;

  static Color _captionColor(BuildContext context) {
    if (_isDark(context)) {
      return Theme.of(context).colorScheme.onSurfaceVariant;
    }
    return Colors.grey;
  }

  static Color _labelColor(BuildContext context) => _isDark(context)
      ? DarkThemeColors.bodySmallTextColor
      : Colors.black45;
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
  static double get appBarTittleSize => 20;
  static double get appBarTittleSizeW => 22;

  // body font size
  static double get bodySmallTextSize => 11;
  static double get bodyMediumSize => 18; // default font
  static double get bodyMediumSizeW => 20;
  static double get bodyLargeSize => 16;
  // display font size
  static double get displayLargeSize => 20;
  static double get displayMediumSize => 17;
  static double get displaySmallSize => 14;

  //button font size
  // static double get buttonTextSize => 20.sp;
  static double get buttonTextSize => 18;

  //chip font size
  static double get chipTextSize => 10;

  // list tile fonts sizes
  // static double get listTileTitleSize => 13.sp;
  // static double get listTileSubtitleSize => 12.sp;
  static double get listTileTitleSize => 15;
  static double get listTileSubtitleSize => 12;

  // custom themes (extensions)
  static double get employeeListItemNameSize => 13;
  static double get employeeListItemSubtitleSize => 13;
  static double get labelSize => 8.sp.clamp(5, 15);

  static bool isWideScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width > Constant.SQUARE_SPLIT_WIDTH;
  }

  // 卡片主标题：用于信息流卡片标题、商品标题、内容卡片第一层级标题。
  static TextStyle cardTitle(BuildContext context) {
    if (isWideScreen(context)) {
      return displayTextStyle.copyWith(
        fontSize: 20,
        height: 1.3,
        color: _onSurface(context),
        fontWeight: FontWeight.w500,
      );
    }
    return displayTextStyle.copyWith(
      fontSize: 18,
      height: 1.3,
      color: _onSurface(context),
      fontWeight: FontWeight.w500,
    );
  }

  // 卡片主标题：用于信息流卡片标题、商品标题、内容卡片第一层级标题。
  static TextStyle cardTitle2(BuildContext context) {
    if (isWideScreen(context)) {
      return displayTextStyle.copyWith(
        fontSize: 15,
        height: 1.3,
        color: _onSurface(context),
        fontWeight: FontWeight.w500,
      );
    }
    return displayTextStyle.copyWith(
      fontSize: 13,
      height: 1.3,
      color: _onSurface(context),
      fontWeight: FontWeight.w500,
    );
  }

  // 卡片元信息：用于时间、热度、浏览量、作者辅助信息等次级说明文本。
  static TextStyle caption(BuildContext context) {
    if (isWideScreen(context)) {
      return bodyTextStyle.copyWith(
        fontSize: 13,
        height: 1.2,
        color: _captionColor(context),
      );
    }
    return bodyTextStyle.copyWith(
      fontSize: 11,
      height: 1.2,
      color: _captionColor(context),
    );
  }

  // 区块标题：用于页面内模块标题、筛选分组标题、列表分段标题。
  static TextStyle sectionTitle(BuildContext context) {
    if (isWideScreen(context)) {
      return displayTextStyle.copyWith(
        fontSize: 16,
        height: 1.3,
        color: _onSurface(context),
        fontWeight: FontWeight.w600,
      );
    }
    return displayTextStyle.copyWith(
      fontSize: 14,
      height: 1.3,
      color: _onSurface(context),
      fontWeight: FontWeight.w600,
    );
  }

  // 页面主标题：用于页面 Header 大标题、个人页统计数字等强层级标题。
  static TextStyle pageTitle(BuildContext context) {
    if (isWideScreen(context)) {
      return displayTextStyle.copyWith(
        fontSize: 22,
        height: 1.25,
        color: _onSurface(context),
        fontWeight: FontWeight.w700,
      );
    }
    return displayTextStyle.copyWith(
      fontSize: 20,
      height: 1.25,
      color: _onSurface(context),
      fontWeight: FontWeight.w700,
    );
  }

  // 页面副标题/描述：用于页面说明文字、引导文案、空状态补充说明。
  static TextStyle pageSubtitle(BuildContext context) {
    if (isWideScreen(context)) {
      return bodyTextStyle.copyWith(
        fontSize: 14,
        height: 1.35,
        color: _onSurfaceMuted(context),
        fontWeight: FontWeight.w400,
      );
    }
    return bodyTextStyle.copyWith(
      fontSize: 12,
      height: 1.35,
      color: _onSurfaceMuted(context),
      fontWeight: FontWeight.w400,
    );
  }

  // 导航栏标题：用于 AppBar 标题、顶部导航的主要标题文本。
  static TextStyle appBarTitle(BuildContext context) {
    if (isWideScreen(context)) {
      return appBarTextStyle.copyWith(
        fontSize: appBarTittleSizeW,
        height: 1.2,
        color: _onSurface(context),
        fontWeight: FontWeight.w600,
      );
    }
    return appBarTextStyle.copyWith(
      fontSize: appBarTittleSize,
      height: 1.2,
      color: _onSurface(context),
      fontWeight: FontWeight.w600,
    );
  }

  // 卡片副标题：用于卡片内第二层信息，如作者名、标签描述、统计说明。
  static TextStyle cardSubtitle(BuildContext context) {
    if (isWideScreen(context)) {
      return bodyTextStyle.copyWith(
        fontSize: 13,
        height: 1.3,
        color: _onSurfaceMuted(context),
        fontWeight: FontWeight.w400,
      );
    }
    return bodyTextStyle.copyWith(
      fontSize: 12,
      height: 1.3,
      color: _onSurfaceMuted(context),
      fontWeight: FontWeight.w400,
    );
  }

  // 正文默认样式：用于段落正文、内容描述、普通列表文本。
  static TextStyle body(BuildContext context) {
    if (isWideScreen(context)) {
      return bodyTextStyle.copyWith(
        fontSize: bodyMediumSizeW,
        height: 1.4,
        color: _onSurfaceVariant(context),
        fontWeight: FontWeight.w400,
      );
    }
    return bodyTextStyle.copyWith(
      fontSize: bodyMediumSize,
      height: 1.4,
      color: _onSurfaceVariant(context),
      fontWeight: FontWeight.w400,
    );
  }

  // 正文强调样式：用于正文内强调词、关键数据、需要加重的关键信息。
  static TextStyle bodyStrong(BuildContext context) {
    return body(context).copyWith(
      fontWeight: FontWeight.w600,
      color: _onSurface(context),
    );
  }

  // 小标签样式：用于角标、badge、短标签、行内微文案（如“AI”“置顶”）。
  static TextStyle label(BuildContext context) {
    if (isWideScreen(context)) {
      return bodyTextStyle.copyWith(
        fontSize: 11,
        height: 1.2,
        color: _labelColor(context),
        fontWeight: FontWeight.w500,
      );
    }
    return bodyTextStyle.copyWith(
      fontSize: 10,
      height: 1.2,
      color: _labelColor(context),
      fontWeight: FontWeight.w500,
    );
  }

  // 按钮文本样式：用于主按钮/次按钮文案，支持在业务处覆盖颜色。
  static TextStyle button(BuildContext context) {
    if (isWideScreen(context)) {
      return buttonTextStyle.copyWith(
        fontSize: buttonTextSize,
        height: 1.2,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      );
    }
    return buttonTextStyle.copyWith(
      fontSize: 16,
      height: 1.2,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
  }

  // 次要按钮文本：用于文本按钮、弹窗次操作、轻量操作入口。
  static TextStyle buttonSecondary(BuildContext context) {
    if (isWideScreen(context)) {
      return buttonTextStyle.copyWith(
        fontSize: 14,
        height: 1.2,
        color: _onSurfaceVariant(context),
        fontWeight: FontWeight.w500,
      );
    }
    return buttonTextStyle.copyWith(
      fontSize: 13,
      height: 1.2,
      color: _onSurfaceVariant(context),
      fontWeight: FontWeight.w500,
    );
  }

  // 输入框提示样式：用于 TextField 的 hint、placeholder、label 辅助提示。
  static TextStyle inputHint(BuildContext context) {
    if (isWideScreen(context)) {
      return bodyTextStyle.copyWith(
        fontSize: 13,
        height: 1.3,
        color: _captionColor(context),
        fontWeight: FontWeight.w400,
      );
    }
    return bodyTextStyle.copyWith(
      fontSize: 12,
      height: 1.3,
      color: _captionColor(context),
      fontWeight: FontWeight.w400,
    );
  }

  // 输入框正文：用于 TextField/TextFormField 实际输入内容。
  static TextStyle inputText(BuildContext context) {
    if (isWideScreen(context)) {
      return bodyTextStyle.copyWith(
        fontSize: 14,
        height: 1.3,
        color: _onSurfaceVariant(context),
        fontWeight: FontWeight.w400,
      );
    }
    return bodyTextStyle.copyWith(
      fontSize: 13,
      height: 1.3,
      color: _onSurfaceVariant(context),
      fontWeight: FontWeight.w400,
    );
  }

  // Tab 文本：用于 TabBar 选中/未选中状态的标题文字。
  static TextStyle tab(BuildContext context) {
    if (isWideScreen(context)) {
      return bodyTextStyle.copyWith(
        fontSize: 14,
        height: 1.2,
        color: _onSurfaceVariant(context),
        fontWeight: FontWeight.w600,
      );
    }
    return bodyTextStyle.copyWith(
      fontSize: 13,
      height: 1.2,
      color: _onSurfaceVariant(context),
      fontWeight: FontWeight.w600,
    );
  }

  // 链接文本：用于可点击文字、跳转入口、@用户、话题标签等。
  static TextStyle link(BuildContext context) {
    if (isWideScreen(context)) {
      return bodyTextStyle.copyWith(
        fontSize: 13,
        height: 1.3,
        color: Colors.blue,
        fontWeight: FontWeight.w500,
      );
    }
    return bodyTextStyle.copyWith(
      fontSize: 12,
      height: 1.3,
      color: Colors.blue,
      fontWeight: FontWeight.w500,
    );
  }

  // 价格文本：用于商品价格、金额、费用等需要强调数值的场景。
  static TextStyle price(BuildContext context) {
    if (isWideScreen(context)) {
      return bodyTextStyle.copyWith(
        fontSize: 16,
        height: 1.2,
        color: Colors.red,
        fontWeight: FontWeight.w700,
      );
    }
    return bodyTextStyle.copyWith(
      fontSize: 14,
      height: 1.2,
      color: Colors.red,
      fontWeight: FontWeight.w700,
    );
  }

  // 删除线价格：用于原价、划线价、优惠前价格展示。
  static TextStyle priceStrikethrough(BuildContext context) {
    if (isWideScreen(context)) {
      return caption(context).copyWith(
        fontSize: 12,
        color: _captionColor(context),
        decoration: TextDecoration.lineThrough,
      );
    }
    return caption(context).copyWith(
      fontSize: 11,
      color: _captionColor(context),
      decoration: TextDecoration.lineThrough,
    );
  }

  // 成功提示：用于成功状态文案，如“已完成”“发布成功”等。
  static TextStyle success(BuildContext context) {
    return body(context).copyWith(
      color: Colors.green,
      fontWeight: FontWeight.w500,
    );
  }

  // 警告/错误提示：用于校验报错、失败提示、风险提醒等。
  static TextStyle danger(BuildContext context) {
    return body(context).copyWith(
      color: Colors.red,
      fontWeight: FontWeight.w500,
    );
  }

  // 等宽文本：用于代码片段、JSON、日志、行号等技术文本展示。
  static TextStyle mono(BuildContext context) {
    if (isWideScreen(context)) {
      return bodyTextStyle.copyWith(
        fontFamily: 'monospace',
        fontSize: 13,
        height: 1.35,
        color: _onSurfaceVariant(context),
        fontWeight: FontWeight.w400,
      );
    }
    return bodyTextStyle.copyWith(
      fontFamily: 'monospace',
      fontSize: 12,
      height: 1.35,
      color: _onSurfaceVariant(context),
      fontWeight: FontWeight.w400,
    );
  }

  // 欢迎/登录大标题：用于登录页、欢迎页、品牌页等视觉主标题场景。
  static TextStyle heroTitle(BuildContext context) {
    if (isWideScreen(context)) {
      return displayTextStyle.copyWith(
        fontSize: 32,
        height: 1.2,
        color: _onSurface(context),
        fontWeight: FontWeight.w700,
      );
    }
    return displayTextStyle.copyWith(
      fontSize: 28,
      height: 1.2,
      color: _onSurface(context),
      fontWeight: FontWeight.w700,
    );
  }

  // 兼容旧命名：等价于 cardTitle，建议新代码优先使用 cardTitle。
  static TextStyle adaptiveTitle(BuildContext context) {
    return cardTitle(context);
  }

  // 兼容旧命名：等价于 caption，建议新代码优先使用 caption。
  static TextStyle adaptiveMeta(BuildContext context) {
    return caption(context);
  }
}
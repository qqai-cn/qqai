import 'package:flutter/material.dart';

import 'my_fonts.dart';

/// 全局语义字体入口：
/// 使用 `context.typo.xxx` 获取文本样式，避免散落的 TextStyle 硬编码。
extension AppTypographyContext on BuildContext {
  AppTypography get typo => AppTypography(this);
}

class AppTypography {
  const AppTypography(this.context);

  final BuildContext context;

  TextStyle get heroTitle => MyFonts.heroTitle(context);
  TextStyle get appBarTitle => MyFonts.appBarTitle(context);
  TextStyle get pageTitle => MyFonts.pageTitle(context);
  TextStyle get pageSubtitle => MyFonts.pageSubtitle(context);
  TextStyle get sectionTitle => MyFonts.sectionTitle(context);
  TextStyle get cardTitle => MyFonts.cardTitle(context);
  TextStyle get cardSubtitle => MyFonts.cardSubtitle(context);
  TextStyle get body => MyFonts.body(context);
  TextStyle get bodyStrong => MyFonts.bodyStrong(context);
  TextStyle get caption => MyFonts.caption(context);
  TextStyle get label => MyFonts.label(context);
  TextStyle get button => MyFonts.button(context);
  TextStyle get buttonSecondary => MyFonts.buttonSecondary(context);
  TextStyle get inputText => MyFonts.inputText(context);
  TextStyle get inputHint => MyFonts.inputHint(context);
  TextStyle get tab => MyFonts.tab(context);
  TextStyle get link => MyFonts.link(context);
  TextStyle get price => MyFonts.price(context);
  TextStyle get priceStrikethrough => MyFonts.priceStrikethrough(context);
  TextStyle get success => MyFonts.success(context);
  TextStyle get danger => MyFonts.danger(context);
  TextStyle get mono => MyFonts.mono(context);
}

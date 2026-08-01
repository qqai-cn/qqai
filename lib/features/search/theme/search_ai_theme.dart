import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 搜索页 AI 风格配色：品牌红 + 青mint，兼容浅色 / 深色。
///
/// 对齐登录页与工具页的 cyan 点缀，避免通用紫色「AI」观感。
class SearchAiTheme {
  SearchAiTheme._(this.isDark);

  final bool isDark;

  factory SearchAiTheme.of(BuildContext context) {
    return SearchAiTheme._(Theme.of(context).brightness == Brightness.dark);
  }

  static const Color brandRed = Color(0xFFE53935);
  static const Color brandRedDeep = Color(0xFFB71C1C);
  static const Color brandRedSoft = Color(0xFFFF8A80);
  static const Color cyan = Color(0xFF00D9F5);
  static const Color mint = Color(0xFF00F5A0);

  List<Color> get pageGradient => isDark
      ? const [Color(0xFF0A1220), Color(0xFF121C30), Color(0xFF0E1828)]
      : const [Color(0xFFF0F7FC), Color(0xFFF7F4F8), Color(0xFFEEF6FA)];

  Color get appBarBg =>
      isDark ? const Color(0xE6121C30) : const Color(0xE6FFFFFF);

  Color get text => isDark ? const Color(0xFFE8F0FA) : const Color(0xFF15202B);

  Color get textSecondary =>
      isDark ? const Color(0xFF8CA0BC) : const Color(0xFF5A6B7D);

  Color get line =>
      isDark ? const Color(0x3348C8E0) : const Color(0x2200A8CC);

  Color get cardBg =>
      isDark ? const Color(0xCC152238) : const Color(0xE6FFFFFF);

  Color get cardBorder =>
      isDark ? const Color(0x4400D9F5) : const Color(0x3300A8CC);

  List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: isDark
              ? const Color(0x3300D9F5)
              : const Color(0x1400A8CC),
          blurRadius: isDark ? 18 : 14,
          offset: const Offset(0, 6),
        ),
      ];

  Color get chipBg =>
      isDark ? const Color(0x331A2A40) : const Color(0xFFF0F6FA);

  Color get chipBorder =>
      isDark ? const Color(0x3300D9F5) : const Color(0x2200A8CC);

  Color get searchBarBg =>
      isDark ? const Color(0xCC0E1828) : const Color(0xF2FFFFFF);

  Color get searchBarBorder =>
      isDark ? const Color(0x5500D9F5) : const Color(0x4400C6E0);

  Color get accent => isDark ? cyan : const Color(0xFF00A8CC);

  Color get accentSoft => cyan.withValues(alpha: isDark ? 0.22 : 0.14);

  Color get selectedFg => brandRed;

  Color get categoryTrack =>
      isDark ? const Color(0xFF152438) : const Color(0xFFE8F2F8);

  Color get categorySelectedBg =>
      isDark ? const Color(0xFF1E3048) : Colors.white;

  /// 结果区不透明底，避免背景光晕透出干扰 Tab。
  Color get resultPanelBg =>
      isDark ? const Color(0xFF0E1828) : const Color(0xFFF5FAFD);

  LinearGradient get brandTitleGradient => const LinearGradient(
        colors: [brandRedDeep, brandRed, brandRedSoft],
      );

  LinearGradient get searchButtonGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [brandRedDeep, brandRed, Color(0xFFFF6B6B)],
      );

  LinearGradient get aiBadgeGradient => const LinearGradient(
        colors: [cyan, mint],
      );

  LinearGradient get orbCyanGradient => LinearGradient(
        colors: [
          cyan.withValues(alpha: isDark ? 0.14 : 0.10),
          mint.withValues(alpha: isDark ? 0.04 : 0.03),
        ],
      );

  LinearGradient get orbRedGradient => LinearGradient(
        colors: [
          brandRed.withValues(alpha: isDark ? 0.12 : 0.08),
          brandRedSoft.withValues(alpha: isDark ? 0.04 : 0.03),
        ],
      );

  LinearGradient get rankPanelGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? const [Color(0xFF1A2438), Color(0xFF152238)]
            : const [Color(0xFFF3FAFF), Color(0xFFFFFFFF)],
      );

  SystemUiOverlayStyle get overlayStyle => isDark
      ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
      : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent);
}

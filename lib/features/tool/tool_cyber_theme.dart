import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// IP 查询等工具页共用的赛博风配色，支持浅色 / 深色。
class ToolCyberTheme {
  ToolCyberTheme(this.brightness);

  final Brightness brightness;

  factory ToolCyberTheme.of(BuildContext context) {
    return ToolCyberTheme(Theme.of(context).brightness);
  }

  bool get isLight => brightness == Brightness.light;

  Color get scaffoldBg => isLight ? const Color(0xFFE8F4FC) : const Color(0xFF050B1B);

  List<Color> get gradientColors => isLight
      ? const [Color(0xFFE8F4FC), Color(0xFFD6EBF8), Color(0xFFC5E2F5)]
      : const [Color(0xFF050B1B), Color(0xFF0B1630), Color(0xFF102447)];

  Color get appBarFg => isLight ? const Color(0xFF1A3A5C) : const Color(0xFFE7F0FF);

  Color get appBarIcon => isLight ? const Color(0xFF0088AA) : const Color(0xFF8EEFFF);

  Color get cardBg => isLight ? const Color(0xE6FFFFFF) : const Color(0xCC101A2D);

  Color get cardBorder => isLight ? const Color(0x6600A8CC) : const Color(0x5500E5FF);

  Color get cardShadow => isLight ? const Color(0x2200A8CC) : const Color(0x3000E5FF);

  Color get title => isLight ? const Color(0xFF006688) : const Color(0xFF8EEFFF);

  Color get subtitle => isLight ? const Color(0xFF5A7A99) : const Color(0xFF7C91B5);

  Color get body => isLight ? const Color(0xFF1E3A52) : const Color(0xFFE7F0FF);

  Color get label => isLight ? const Color(0xFF4A6A88) : const Color(0xFF8CA8D8);

  Color get accent => isLight ? const Color(0xFF00A8CC) : const Color(0xFF00E5FF);

  Color get accentIcon => isLight ? const Color(0xFF0088BB) : const Color(0xFF53E5FF);

  Color get primaryButton => const Color(0xFF00C6FF);

  Color get surfaceFill => isLight ? const Color(0xAAF0F8FC) : const Color(0xAA0A1328);

  Color get imagePlaceholder => isLight ? const Color(0xFFD8EEF8) : const Color(0xFF0A1328);

  Color get innerBorder => isLight ? const Color(0x4400A8CC) : const Color(0x3300E5FF);

  List<Color> get innerGradient => isLight
      ? const [Color(0x1A00A8CC), Color(0x1200C6FF)]
      : const [Color(0x1A00E5FF), Color(0x1400FF95)];

  List<Color> get scanGradient => isLight
      ? const [Color(0x0000A8CC), Color(0x1800A8CC), Color(0x0000A8CC)]
      : const [Color(0x0000E5FF), Color(0x2000E5FF), Color(0x0000E5FF)];

  Color get link => isLight ? const Color(0xFF0077AA) : const Color(0xFF8EEFFF);

  SystemUiOverlayStyle get overlayStyle => isLight
      ? SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent)
      : SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent);

  ButtonStyle get filledButtonStyle => FilledButton.styleFrom(
        backgroundColor: primaryButton,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  ButtonStyle outlinedButtonStyle({bool selected = false}) {
    return OutlinedButton.styleFrom(
      foregroundColor: selected ? Colors.white : title,
      backgroundColor: selected ? primaryButton : Colors.transparent,
      side: BorderSide(color: selected ? primaryButton : cardBorder, width: 1.2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  ButtonStyle get slotButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: body,
        minimumSize: const Size(40, 40),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        side: BorderSide(color: innerBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );
}

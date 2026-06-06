import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';

/// 发布页明暗主题色，供表单、弹层与 AppBar 共用。
abstract final class FabuPublishTheme {
  /// 品牌主色（发布按钮、选中态），明暗一致。
  static const accent = Color(0xFFFE2C55);

  static Color pageBg(BuildContext context) => GoodsPageStyle.pageBg(context);

  static Color panelBg(BuildContext context) => GoodsPageStyle.imageBg(context);

  static Color border(BuildContext context) => GoodsPageStyle.border(context);

  static Color text(BuildContext context) => GoodsPageStyle.text(context);

  static Color onAccent(BuildContext context) => Colors.white;

  /// 信息/链接色（上传图标、封面样式 Chip 等）。
  static Color infoBlue(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF3578E5)
        : const Color(0xFF7EB4FF);
  }

  static Color accentTintBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFEAF2FF)
        : const Color(0xFF3578E5).withValues(alpha: 0.18);
  }

  static double cardShadowAlpha(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? 0.05 : 0.35;
  }

  static Color rewardSelectedBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFFFF3D7)
        : const Color(0xFFFFC54D).withValues(alpha: 0.18);
  }

  static const rewardBorder = Color(0xFFFFC54D);

  static Color rewardTextSelected(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFE58A00)
        : const Color(0xFFFFB84D);
  }

  static const rewardBadgeBg = Color(0xFFFFD31A);

  static Color balanceAmount(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFFF8A00)
        : const Color(0xFFFFB84D);
  }

  static const starYellow = Color(0xFFFFD633);

  static Color dragHandle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFD6D6D6)
        : Colors.white.withValues(alpha: 0.24);
  }

  /// 封面类型 Chip 未选中背景。
  static Color coverStyleChipBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? panelBg(context)
        : const Color(0xFF414141);
  }

  static Color coverStyleChipLabel(
    BuildContext context, {
    required bool selected,
  }) {
    if (selected) return infoBlue(context);
    return Theme.of(context).brightness == Brightness.light
        ? AppActionColors.muted(context)
        : Colors.white;
  }

  static Color chipLabel(BuildContext context) => text(context);

  static ButtonStyle publishButtonStyle(BuildContext context) {
    return FilledButton.styleFrom(
      backgroundColor: accent,
      foregroundColor: onAccent(context),
      disabledBackgroundColor: AppActionColors.borderSubtle(context),
      disabledForegroundColor: AppActionColors.subtle(context),
    );
  }

  /// 视频封面区「选择封面 / 使用当前帧 / 生成预览」等描边按钮。
  static ButtonStyle coverActionButtonStyle(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return OutlinedButton.styleFrom(
        foregroundColor: infoBlue(context),
        side: BorderSide(color: border(context)),
      );
    }
    return OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      disabledForegroundColor: Colors.white.withValues(alpha: 0.38),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.45)),
    );
  }
}

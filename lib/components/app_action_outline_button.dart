import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 个人页 / 工具页等使用的描边胶囊操作按钮（与顶栏操作色系统一）。
class AppActionOutlineButton extends StatelessWidget {
  const AppActionOutlineButton({
    super.key,
    required this.label,
    required this.onTap,
    this.loading = false,
    this.horizontalPadding = 18,
    this.fontSize = 13,
  });

  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final double horizontalPadding;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final textColor = AppActionColors.foreground(context);
    final borderColor = AppActionColors.borderSubtle(context);
    final labelStyle = context.typo.button.copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      height: 1.2,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: loading ? null : onTap,
        borderRadius: BorderRadius.circular(999),
        splashColor: textColor.withValues(alpha: 0.08),
        highlightColor: textColor.withValues(alpha: 0.04),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor, width: 1),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 4,
          ),
          child: loading
              ? SizedBox(
                  width: fontSize * 3.6,
                  height: fontSize * 1.2,
                  child: Center(
                    child: SizedBox(
                      width: fontSize,
                      height: fontSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: textColor,
                      ),
                    ),
                  ),
                )
              : Text(
                  label,
                  style: labelStyle.copyWith(color: textColor),
                ),
        ),
      ),
    );
  }
}

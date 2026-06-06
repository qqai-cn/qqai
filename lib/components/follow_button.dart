import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 关注 / 已关注 公共胶囊按钮（描边样式）。
enum FollowButtonSize {
  /// 标准文字胶囊，用于列表作者行等。
  standard,

  /// 紧凑圆形图标，用于空间受限的卡片 footer。
  compactIcon,
}

class FollowButton extends StatelessWidget {
  const FollowButton({
    super.key,
    required this.followed,
    required this.onTap,
    this.followLabel = '关注',
    this.followedLabel = '已关注',
    this.size = FollowButtonSize.standard,
    this.loading = false,
    this.compactIconSize = 30,
    this.horizontalPadding = 18,
    this.fontSize = 13,
  });

  final bool followed;
  final VoidCallback? onTap;
  final String followLabel;
  final String followedLabel;
  final FollowButtonSize size;
  final bool loading;
  final double compactIconSize;
  final double horizontalPadding;
  final double fontSize;

  static const Color followAccent = Color(0xFFE95F63);
  static const Color followedBorder = Color(0xFFD1D5DB);
  static const Color followedText = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    if (size == FollowButtonSize.compactIcon) {
      return _CompactIconFollowButton(
        followed: followed,
        onTap: loading ? null : onTap,
        loading: loading,
        iconSize: compactIconSize,
      );
    }

    final labelStyle = context.typo.button.copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      height: 1.2,
    );
    final borderColor = followed ? followedBorder : followAccent;
    final textColor = followed ? followedText : followAccent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: loading ? null : onTap,
        borderRadius: BorderRadius.circular(999),
        splashColor: followAccent.withValues(alpha: 0.08),
        highlightColor: followAccent.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
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
                  width: fontSize * 2.4,
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
                  followed ? followedLabel : followLabel,
                  style: labelStyle.copyWith(color: textColor),
                ),
        ),
      ),
    );
  }
}

class _CompactIconFollowButton extends StatelessWidget {
  const _CompactIconFollowButton({
    required this.followed,
    required this.onTap,
    required this.loading,
    required this.iconSize,
  });

  final bool followed;
  final VoidCallback? onTap;
  final bool loading;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        followed ? FollowButton.followedBorder : FollowButton.followAccent;
    final iconColor =
        followed ? FollowButton.followedText : FollowButton.followAccent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        splashColor: FollowButton.followAccent.withValues(alpha: 0.08),
        highlightColor: FollowButton.followAccent.withValues(alpha: 0.04),
        child: Ink(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: loading
              ? Center(
                  child: SizedBox(
                    width: iconSize * 0.45,
                    height: iconSize * 0.45,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: iconColor,
                    ),
                  ),
                )
              : Icon(
                  followed ? Icons.check_rounded : Icons.add_rounded,
                  size: iconSize * 0.52,
                  color: iconColor,
                ),
        ),
      ),
    );
  }
}

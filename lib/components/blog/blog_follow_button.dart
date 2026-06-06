import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/constant/color_constant.dart';

/// 列表卡片作者行「关注 / 已关注」胶囊按钮。
class BlogFollowButton extends StatelessWidget {
  const BlogFollowButton({
    super.key,
    required this.followed,
    required this.onTap,
  });

  final bool followed;
  final VoidCallback onTap;

  static const Color _followedBorder = Color(0xFFE5E7EB);
  static const Color _followedBg = Color(0xFFF9FAFB);
  static const Color _followedText = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.typo.button.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: 0.2,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: followed ? _followedBg : ColorConstant.ThemeGreen,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: followed ? _followedBorder : ColorConstant.ThemeGreen,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (followed)
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: Icon(
                    Icons.check_rounded,
                    size: 13,
                    color: _followedText.withValues(alpha: 0.85),
                  ),
                ),
              Text(
                followed ? '已关注' : '关注',
                style: labelStyle.copyWith(
                  color: followed ? _followedText : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

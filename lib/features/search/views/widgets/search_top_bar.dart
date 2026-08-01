import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../theme/search_ai_theme.dart';

/// AppBar 内 AI 搜索输入条。
class SearchTopBar extends StatelessWidget {
  const SearchTopBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.aiSearch,
    required this.onAiSearchChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool aiSearch;
  final ValueChanged<bool> onAiSearchChanged;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 40.h,
      padding: EdgeInsets.only(left: 10.w, right: 6.w),
      decoration: BoxDecoration(
        color: ai.searchBarBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: aiSearch ? ai.searchBarBorder : ai.line,
          width: aiSearch ? 1.2 : 1,
        ),
        boxShadow: aiSearch
            ? [
                BoxShadow(
                  color: SearchAiTheme.cyan.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => ai.aiBadgeGradient.createShader(bounds),
            child: Icon(Icons.auto_awesome, size: 16, color: ai.accent),
          ),
          SizedBox(width: 4.w),
          Text(
            'AI',
            style: context.typo.label.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: ai.accent,
            ),
          ),
          Transform.scale(
            scale: 0.62,
            child: Switch.adaptive(
              value: aiSearch,
              onChanged: onAiSearchChanged,
              activeTrackColor: SearchAiTheme.cyan.withValues(alpha: 0.5),
              activeThumbColor: SearchAiTheme.mint,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSubmitted(),
              style: context.typo.body.copyWith(
                fontSize: 14,
                color: ai.text,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: '搜索商品或博客',
                hintStyle: context.typo.inputHint.copyWith(
                  fontSize: 14,
                  color: ai.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(
                  Icons.photo_camera_outlined,
                  size: 22,
                  color: ai.textSecondary,
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 36.w, minHeight: 36.h),
              ),
              Positioned(
                right: 2.w,
                top: 4.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    gradient: ai.aiBadgeGradient,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Text(
                    'AI',
                    style: context.typo.label.copyWith(
                      fontSize: 8,
                      color: Colors.white,
                      height: 1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// AppBar 红色「搜索」按钮。
class SearchActionButton extends StatelessWidget {
  const SearchActionButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: ai.searchButtonGradient,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: SearchAiTheme.brandRed.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Text(
              '搜索',
              style: context.typo.button.copyWith(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

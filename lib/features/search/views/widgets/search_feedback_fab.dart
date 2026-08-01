import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../theme/search_ai_theme.dart';

class SearchFeedbackFab extends StatelessWidget {
  const SearchFeedbackFab({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return Material(
      color: ai.cardBg,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: ai.cardBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.feedback_outlined, size: 16, color: ai.accent),
              SizedBox(width: 4.w),
              Text(
                '反馈',
                style: context.typo.label.copyWith(
                  fontSize: 12,
                  color: ai.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

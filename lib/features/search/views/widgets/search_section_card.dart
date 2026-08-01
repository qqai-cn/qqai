import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../theme/search_layout.dart';
import '../../theme/search_ai_theme.dart';

/// 落地区块玻璃卡片。
class SearchSectionCard extends StatelessWidget {
  const SearchSectionCard({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final ai = SearchAiTheme.of(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: searchPageHorizontalGap(w)),
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ai.cardBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ai.cardBorder),
        boxShadow: ai.cardShadow,
      ),
      child: child,
    );
  }
}

/// 区块标题行。
class SearchSectionTitleRow extends StatelessWidget {
  const SearchSectionTitleRow({
    super.key,
    required this.title,
    required this.trailing,
    this.icon,
  });

  final String title;
  final Widget trailing;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: ai.accent),
          const SizedBox(width: 6),
        ],
        Text(
          title,
          style: context.typo.sectionTitle.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: ai.text,
          ),
        ),
        const Spacer(),
        trailing,
      ],
    );
  }
}

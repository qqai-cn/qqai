import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/douyin_theme.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 主播中心（数据看板 + 功能入口）
class DouyinAnchorCenterPage extends StatelessWidget {
  const DouyinAnchorCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DouyinTheme.bg(context),
      appBar: AppBar(
        backgroundColor: DouyinTheme.bg(context),
        foregroundColor: DouyinTheme.text(context),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          '主播中心',
          style: context.typo.appBarTitle.copyWith(
            color: DouyinTheme.text(context),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        children: [
          _StatRow(),
          SizedBox(height: 20.h),
          _SectionTitle('直播服务'),
          _tile(context, Icons.analytics_outlined, '直播数据', '场次、时长、观众与互动'),
          _tile(context, Icons.gavel_outlined, '违规记录', '近期审核与申诉'),
          _tile(context, Icons.settings_outlined, '直播设置', '封面、分类与预告'),
          SizedBox(height: 16.h),
          _SectionTitle('成长'),
          _tile(context, Icons.school_outlined, '主播课堂', '规则与技巧'),
          _tile(context, Icons.campaign_outlined, '活动报名', '平台活动与流量扶持'),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, String sub) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: DouyinTheme.card(context),
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Icon(icon, color: DouyinTheme.text(context), size: 22),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.typo.cardTitle2.copyWith(
                          color: DouyinTheme.text(context),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        sub,
                        style: context.typo.caption.copyWith(
                          color: DouyinTheme.sub(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: DouyinTheme.sub(context),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        text,
        style: context.typo.caption.copyWith(
          color: DouyinTheme.sub(context),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = [
      _Stat('今日直播', '0', '场'),
      _Stat('累计观众', '--', ''),
      _Stat('预估收益', '--', ''),
    ];
    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          Expanded(child: _StatCard(stat: stats[i])),
          if (i < stats.length - 1) SizedBox(width: 10.w),
        ],
      ],
    );
  }
}

class _Stat {
  const _Stat(this.label, this.value, this.unit);

  final String label;
  final String value;
  final String unit;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final _Stat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: DouyinTheme.card(context),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            stat.label,
            style: context.typo.caption.copyWith(color: DouyinTheme.sub(context)),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                stat.value,
                style: context.typo.pageTitle.copyWith(
                  color: DouyinTheme.text(context),
                  fontSize: 20,
                ),
              ),
              if (stat.unit.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 2.w, bottom: 2.h),
                  child: Text(
                    stat.unit,
                    style: context.typo.caption.copyWith(
                      color: DouyinTheme.sub(context),
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

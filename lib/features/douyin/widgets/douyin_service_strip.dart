import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../components/icon_button_h.dart';
import '../../../router/app_routes.dart';
import '../theme/douyin_theme.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 抖音「我的」顶部横向入口：圆标 + 文案
class DouyinServiceStrip extends StatelessWidget {
  const DouyinServiceStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_Entry>[
      _Entry(
        icon: Icons.storefront_rounded,
        label: '团购带货',
        route: Routes.douyinGroupBuy,
      ),
      _Entry(
        icon: Icons.live_tv_rounded,
        label: '主播中心',
        route: Routes.douyinAnchorCenter,
      ),
      _Entry(
        icon: Icons.receipt_long_rounded,
        label: '我的订单',
        route: Routes.douyinMyOrders,
      ),
      _Entry(
        icon: Icons.history_rounded,
        label: '观看历史',
        route: Routes.douyinWatchHistory,
      ),
      _Entry(
        icon: Icons.grid_view_rounded,
        label: '全部功能',
        route: Routes.douyinAllFeatures,
      ),
    ];

    // 固定高度，保证横向 ScrollView 有明确竖直约束，避免图标与文字叠在一起
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(color: DouyinTheme.bg),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                IconButtonH(
                  icon: items[i].icon,
                  text: items[i].label,
                  textSize: 13,
                  onPress: () {
                    context.push(items[i].route);
                  },
                  textColor: Colors.black,
                ),
                // if (i < items.length - 1) SizedBox(width: 12.w),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Entry {
  const _Entry({required this.icon, required this.label, required this.route});

  final IconData icon;
  final String label;
  final String route;
}

class _DouyinEntryTile extends StatelessWidget {
  const _DouyinEntryTile({required this.entry});

  final _Entry entry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(entry.route),
      borderRadius: BorderRadius.circular(12.r),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: DouyinTheme.chip,
              shape: BoxShape.circle,
              border: Border.all(color: DouyinTheme.line),
            ),
            child: Icon(entry.icon, color: DouyinTheme.text, size: 20),
          ),
          SizedBox(height: 6.h),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                entry.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: context.typo.caption.copyWith(fontSize: 11.sp, color: DouyinTheme.sub, height: 1.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

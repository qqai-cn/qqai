import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_routes.dart';
import '../theme/douyin_theme.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 全部功能：宫格跳转站内能力
class DouyinAllFeaturesPage extends StatelessWidget {
  const DouyinAllFeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = [
      _FeatureGroup(
        title: '交易',
        items: [
          _FeatureItem('商品', Icons.shopping_bag_outlined, Routes.goodsPageUrl),
          _FeatureItem('购物车', Icons.shopping_cart_outlined, Routes.cartPageUrl),
          _FeatureItem('我的订单', Icons.receipt_long_outlined, Routes.douyinMyOrders),
        ],
      ),
      _FeatureGroup(
        title: '内容',
        items: [
          _FeatureItem('搜索', Icons.search, Routes.searchPage),
          _FeatureItem('发布作品', Icons.add_circle_outline, Routes.publishZuoPinPageUrl),
          _FeatureItem('观看历史', Icons.history, Routes.douyinWatchHistory),
        ],
      ),
      _FeatureGroup(
        title: '工具与服务',
        items: [
          _FeatureItem('天气', Icons.wb_sunny_outlined, Routes.weatherPageUrl),
          _FeatureItem('AI 助手', Icons.auto_awesome, Routes.aiPageUrl),
          _FeatureItem('二维码', Icons.qr_code_2, Routes.qrCodePageUrl),
          _FeatureItem('日历', Icons.calendar_today_outlined, Routes.calendarToolPageUrl),
          _FeatureItem('团购带货', Icons.storefront_outlined, Routes.douyinGroupBuy),
          _FeatureItem('主播中心', Icons.live_tv_outlined, Routes.douyinAnchorCenter),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: DouyinTheme.bg,
      appBar: AppBar(
        backgroundColor: DouyinTheme.bg,
        foregroundColor: DouyinTheme.text,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          '全部功能',
          style: context.typo.sectionTitle.copyWith(fontSize: 17.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        children: [
          for (final g in groups) ...[
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                g.title,
                style: context.typo.caption.copyWith(color: DouyinTheme.sub, fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
            ),
            _FeatureGrid(items: g.items),
            SizedBox(height: 20.h),
          ],
        ],
      ),
    );
  }
}

class _FeatureGroup {
  const _FeatureGroup({required this.title, required this.items});

  final String title;
  final List<_FeatureItem> items;
}

class _FeatureItem {
  const _FeatureItem(this.label, this.icon, this.route);

  final String label;
  final IconData icon;
  final String route;
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.items});

  final List<_FeatureItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 8.w,
      childAspectRatio: 0.85,
      children: [
        for (final item in items)
          Material(
            color: DouyinTheme.card,
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              onTap: () => context.push(item.route),
              borderRadius: BorderRadius.circular(12.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: DouyinTheme.text, size: 26.sp),
                  SizedBox(height: 8.h),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.caption.copyWith(color: DouyinTheme.sub, fontSize: 11.sp),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

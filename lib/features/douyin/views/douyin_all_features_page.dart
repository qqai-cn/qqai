import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_routes.dart';
import '../theme/douyin_theme.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 全部功能：宫格跳转站内能力
class DouyinAllFeaturesPage extends StatelessWidget {
  const DouyinAllFeaturesPage({super.key});

  static const _contentMaxWidth = 640.0;

  @override
  Widget build(BuildContext context) {
    final groups = [
      _FeatureGroup(
        title: '交易',
        items: [
          _FeatureItem('商品', Icons.shopping_bag_outlined, Routes.goodsPageUrl),
          _FeatureItem('购物车', Icons.shopping_cart_outlined, Routes.cartPageUrl),
          _FeatureItem(
            '我的订单',
            Icons.receipt_long_outlined,
            Routes.douyinMyOrders,
          ),
        ],
      ),
      _FeatureGroup(
        title: '内容',
        items: [
          _FeatureItem('搜索', Icons.search, Routes.searchPage),
          _FeatureItem(
            '发布作品',
            Icons.add_circle_outline,
            Routes.publishZuoPinPageUrl,
          ),
          _FeatureItem('观看历史', Icons.history, Routes.footprint),
        ],
      ),
      _FeatureGroup(
        title: '工具与服务',
        items: [
          _FeatureItem('天气', Icons.wb_sunny_outlined, Routes.weatherPageUrl),
          _FeatureItem('AI 对话', Icons.auto_awesome, Routes.aiChatPageUrl),
          _FeatureItem('AI 助手', Icons.smart_toy_outlined, Routes.aiPageUrl),
          _FeatureItem('二维码', Icons.qr_code_2, Routes.qrCodePageUrl),
          _FeatureItem(
            '日历',
            Icons.calendar_today_outlined,
            Routes.calendarToolPageUrl,
          ),
          _FeatureItem(
            '团购带货',
            Icons.storefront_outlined,
            Routes.douyinGroupBuy,
          ),
          _FeatureItem(
            '主播中心',
            Icons.live_tv_outlined,
            Routes.douyinAnchorCenter,
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: DouyinTheme.bg(context),
      appBar: AppBar(
        backgroundColor: DouyinTheme.bg(context),
        foregroundColor: DouyinTheme.text(context),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          '全部功能',
          style: context.typo.appBarTitle.copyWith(color: DouyinTheme.text(context)),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              for (final g in groups) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    g.title,
                    style: context.typo.caption.copyWith(
                      color: DouyinTheme.sub(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _FeatureGrid(items: g.items),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
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

  static const _minCellWidth = 84.0;
  static const _maxColumns = 5;

  int _columnsForWidth(double width) {
    return (width / _minCellWidth).floor().clamp(3, _maxColumns);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = _columnsForWidth(constraints.maxWidth);
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: cols,
          mainAxisSpacing: 12,
          crossAxisSpacing: 8,
          childAspectRatio: 0.92,
          children: [
            for (final item in items)
              Material(
                color: DouyinTheme.card(context),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => context.push(item.route),
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, color: DouyinTheme.text(context), size: 26),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          item.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: context.typo.label.copyWith(
                            color: DouyinTheme.sub(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

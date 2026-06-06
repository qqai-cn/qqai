import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../components/horizontal_deal_layout.dart';
import '../../../router/app_routes.dart';
import '../theme/douyin_theme.dart';

/// 团购带货（抖音风格：深色 + 直播/团购卡片）
class DouyinGroupBuyPage extends StatelessWidget {
  const DouyinGroupBuyPage({super.key});

  static final _mockDeals = [
    _Deal(
      title: '限时秒杀 · 数码好物',
      tag: '直播中',
      price: '¥99',
      cover: 'https://file.qqai.cn/qqai/2025/09/1.webp',
    ),
    _Deal(
      title: '团购专场 · 日用精选',
      tag: '团购',
      price: '¥19.9',
      cover: 'https://file.qqai.cn/qqai/2025/09/1.webp',
    ),
    _Deal(
      title: '达人带货 · 爆款清单',
      tag: '热卖',
      price: '¥49',
      cover: 'https://file.qqai.cn/qqai/2025/09/1.webp',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cardStyle = HorizontalDealCardStyle.douyin(
      context: context,
      card: DouyinTheme.card,
      sub: DouyinTheme.sub,
      accent: DouyinTheme.accent,
    );

    return Scaffold(
      backgroundColor: DouyinTheme.bg(context),
      appBar: AppBar(
        backgroundColor: DouyinTheme.bg(context),
        foregroundColor: DouyinTheme.text(context),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: const Text('团购带货'),
        actions: [
          TextButton(
            onPressed: () => context.push(Routes.goodsPageUrl),
            child: const Text('进入商城'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: buildHorizontalDealRecommendationSlivers(
          context: context,
          sectionTitle: '为你推荐',
          sectionTitleColor: DouyinTheme.text(context),
          banner: const DealPromoBanner(
            title: '直播团购 边看边买',
            subtitle: '好价好物 · 限时活动 · 与视频同款',
          ),
          itemCount: _mockDeals.length,
          itemBuilder: (context, index) {
            final deal = _mockDeals[index];
            return HorizontalDealCard(
              tag: deal.tag,
              title: deal.title,
              priceText: deal.price,
              style: cardStyle,
              onTap: () => context.push(Routes.goodsPageUrl),
              image: Image.network(deal.cover, fit: BoxFit.cover),
            );
          },
        ),
      ),
    );
  }
}

class _Deal {
  const _Deal({
    required this.title,
    required this.tag,
    required this.price,
    required this.cover,
  });

  final String title;
  final String tag;
  final String price;
  final String cover;
}

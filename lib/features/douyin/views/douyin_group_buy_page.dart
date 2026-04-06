import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/my_fonts.dart';
import 'package:qqai/util/adaptive_sp.dart';

import '../../../router/app_routes.dart';
import '../theme/douyin_theme.dart';

bool _isWideLayout(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= 800;

/// 推荐卡片外框 **宽:高**（横版左图右文）。[SliverGrid] 的 `childAspectRatio` 控高。
/// 略扁一点，给双列多留纵向空间，减少文字与封面挤爆。
const double kDealCardAspectRatio = 4.0;

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
    final cols = _isWideLayout(context) ? 2 : 1;

    return Scaffold(
      backgroundColor: DouyinTheme.bg,
      appBar: AppBar(
        backgroundColor: DouyinTheme.bg,
        foregroundColor: DouyinTheme.text,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text('团购带货'),
        actions: [
          TextButton(
            onPressed: () => context.push(Routes.goodsPageUrl),
            child: Text('进入商城'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Banner 独占一整行，不参与下方分列逻辑。
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            sliver: SliverToBoxAdapter(
              child: SizedBox(width: double.infinity, child: _Banner()),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
            sliver: SliverToBoxAdapter(
              child: Text('为你推荐', style: MyFonts.getAppFontType),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: kDealCardAspectRatio,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _DealCard(deal: _mockDeals[index]),
                childCount: _mockDeals.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          colors: [Color(0xFFFE2C55), Color(0xFFFF6B8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '直播团购 边看边买',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.spClamp(maxSp: 30),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '好价好物 · 限时活动 · 与视频同款',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 15.spClamp(maxSp: 20),
            ),
          ),
        ],
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

class _DealCard extends StatelessWidget {
  const _DealCard({required this.deal});

  final _Deal deal;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DouyinTheme.card,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: () => context.push(Routes.goodsPageUrl),
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(deal.cover, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: DouyinTheme.accent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          deal.tag,
                          style: TextStyle(
                            color: DouyinTheme.accent,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                      Text(
                        deal.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        deal.price,
                        style: TextStyle(
                          color: DouyinTheme.accent,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: DouyinTheme.sub),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

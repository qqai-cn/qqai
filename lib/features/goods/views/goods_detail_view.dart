import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../router/app_routes.dart';
import '../models/cart_line.dart';
import '../providers/cart_session.dart';
import '../widgets/goods_comments_section.dart';

/// 详情展示用数据（后续可接 [GoodsModel] / 接口）
class GoodsDetailData {
  const GoodsDetailData({
    required this.id,
    required this.title,
    required this.price,
    required this.marketPrice,
    required this.coverAsset,
    required this.tags,
    required this.desc,
  });

  final String id;
  final String title;
  final double price;
  final double marketPrice;
  final String coverAsset;
  final List<String> tags;
  final String desc;
}

GoodsDetailData _detailForId(String id) {
  final idx = int.tryParse(id) ?? 0;
  final covers = [
    'imgs/defbak.png',
    'imgs/defbak1.png',
    'imgs/user_default.png',
  ];
  return GoodsDetailData(
    id: id,
    title: '蓝月亮洗衣液 · 商品 #$id',
    price: 18.88 + (idx % 5) * 2,
    marketPrice: 38.8 + (idx % 3) * 5,
    coverAsset: covers[idx % covers.length],
    tags: const ['包邮', '30天保价', '正品保障'],
    desc:
        '此为商品详情占位文案。商品编号：$id。\n'
        '接入后端后可在本页请求详情接口并替换标题、价格、图文等数据。',
  );
}

class GoodsDetailView extends ConsumerWidget {
  const GoodsDetailView({super.key, required this.goodsId});

  final String goodsId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final d = _detailForId(goodsId);

    void addToCart() {
      ref.read(cartSessionProvider.notifier).addFromGoods(
            id: d.id,
            title: d.title,
            price: d.price,
            coverAsset: d.coverAsset,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已加入购物车')),
      );
    }

    void buyNow() {
      final line = CartLine(
        id: d.id,
        title: d.title,
        price: d.price,
        coverAsset: d.coverAsset,
        quantity: 1,
        selected: true,
      );
      context.push(Routes.checkoutPageUrl, extra: <CartLine>[line.copy()]);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            flexibleSpace: FlexibleSpaceBar(
              background: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(d.coverAsset),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '¥',
                            style: context.typo.caption.copyWith(
                              fontSize: 16.sp,
                              color: theme.colorScheme.error,
                            ),
                          ),
                          Text(
                            d.price.toStringAsFixed(2),
                            style: context.typo.price.copyWith(
                              fontSize: 28.sp,
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '¥${d.marketPrice.toStringAsFixed(2)}',
                            style: context.typo.priceStrikethrough.copyWith(
                              fontSize: 14.sp,
                              color: theme.hintColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: d.tags
                            .map(
                              (t) => Chip(
                                label: Text(
                                  t,
                                  style: context.typo.label.copyWith(
                                    fontSize: 12.sp,
                                  ),
                                ),
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        '商品介绍',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        d.desc,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Divider(height: 1, color: theme.dividerColor),
                ),
                SizedBox(height: 8.h),
                GoodsCommentsSection(goodsId: d.id),
                // 底部购买栏 + 安全区，避免「发表评价」等被裁切
                SizedBox(
                  height: 120.h + MediaQuery.viewPaddingOf(context).bottom,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Material(
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.support_agent_outlined),
                  tooltip: '客服',
                ),
                IconButton(
                  onPressed: () => context.push(Routes.cartPageUrl),
                  icon: const Icon(Icons.shopping_cart_outlined),
                  tooltip: '购物车',
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: addToCart,
                  child: const Text('加入购物车'),
                ),
                SizedBox(width: 8.w),
                FilledButton(
                  onPressed: buyNow,
                  child: const Text('立即购买'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

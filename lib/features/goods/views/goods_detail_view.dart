import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repos/goods_repo.dart';
import '../data/models/mall_product_model.dart';
import '../goods_tab_navigator.dart';
import '../models/cart_line.dart';
import '../providers/cart_session.dart';
import '../providers/goods_comments.dart';
import '../widgets/goods_comments_section.dart';
import '../../../util/media_url.dart';

class GoodsDetailView extends ConsumerWidget {
  const GoodsDetailView({super.key, required this.goodsId});

  final String goodsId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(goodsId);
    if (id == null) {
      return const Scaffold(body: Center(child: Text('商品不存在')));
    }

    return FutureBuilder<MallProduct?>(
      future: ref.read(goodsRepoProvider).getMallProduct(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('加载失败：${snapshot.error}')),
          );
        }
        final product = snapshot.data;
        if (product == null) {
          return const Scaffold(body: Center(child: Text('商品已下架')));
        }
        return _GoodsDetailViewBody(product: product);
      },
    );
  }
}

class _GoodsDetailViewBody extends ConsumerWidget {
  const _GoodsDetailViewBody({required this.product});

  final MallProduct product;

  static String _plainText(String? html) {
    final raw = (html ?? '').trim();
    if (raw.isEmpty) return '';
    return raw
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = product.name?.trim().isNotEmpty == true
        ? product.name!.trim()
        : '商品';
    final imageUrls = product.sliderPicUrls
        .map(resolveMediaUrl)
        .whereType<String>()
        .toList();
    final coverUrl = resolveMediaUrl(product.coverUrl);
    final heroImage = imageUrls.isNotEmpty ? imageUrls.first : coverUrl;
    final introduction = product.introduction?.trim() ?? '';
    final description = _plainText(product.description);
    final detailText = [introduction, description]
        .where((item) => item.trim().isNotEmpty)
        .join('\n\n');
    final comments = ref.watch(goodsCommentsProvider('${product.id}'));

    void addToCart() {
      ref
          .read(cartSessionProvider.notifier)
          .addFromGoods(
            id: product.id?.toString() ?? '',
            title: title,
            price: product.priceYuan,
            coverAsset: 'imgs/defbak.png',
            addQty: 1,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已加入购物车')),
      );
    }

    void buyNow() {
      final line = CartLine(
        id: product.id?.toString() ?? '',
        title: title,
        price: product.priceYuan,
        coverAsset: 'imgs/defbak.png',
        quantity: 1,
        selected: true,
      );
      context.pushGoodsCheckout(<CartLine>[line.copy()]);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('商品详情')),
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: heroImage == null
                  ? const ColoredBox(
                      color: Color(0xFFF3F5F8),
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 56,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    )
                  : Image.network(
                      heroImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const ColoredBox(
                        color: Color(0xFFF3F5F8),
                        child: Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 56,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  '¥',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFE53935),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  product.priceYuan.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: Color(0xFFE53935),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (product.marketPriceYuan > 0)
                                  Text(
                                    '¥${product.marketPriceYuan.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF9E9E9E),
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _MetaChip(label: '库存 ${product.stock ?? 0}'),
                                _MetaChip(label: '销量 ${product.salesCount ?? 0}'),
                                _MetaChip(
                                  label: product.specType == true
                                      ? '多规格商品'
                                      : '默认规格',
                                ),
                                _MetaChip(label: '评价 ${comments.length}'),
                              ],
                            ),
                            if (imageUrls.length > 1) ...[
                              const SizedBox(height: 14),
                              Text(
                                '商品图集',
                                style: const TextStyle(
                                  color: Color(0xFF202124),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 86,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imageUrls.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: SizedBox(
                                        width: 86,
                                        child: Image.network(
                                          imageUrls[index],
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) =>
                                              const ColoredBox(
                                                color: Color(0xFFF3F5F8),
                                                child: Icon(
                                                  Icons.broken_image_outlined,
                                                  color: Color(0xFF9CA3AF),
                                                ),
                                              ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '商品介绍',
                          style: TextStyle(
                            color: Color(0xFF202124),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (detailText.isNotEmpty)
                          Text(
                            detailText,
                            style: const TextStyle(
                              color: Color(0xFF5F6368),
                              fontSize: 14,
                              height: 1.6,
                            ),
                          )
                        else
                          const Text(
                            '暂无商品介绍',
                            style: TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GoodsCommentsSection(goodsId: '${product.id}'),
                  ),
                  SizedBox(
                    height: 110 + MediaQuery.viewPaddingOf(context).bottom,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Material(
          elevation: 8,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: context.pushGoodsCart,
                  icon: const Icon(Icons.shopping_cart_outlined),
                  tooltip: '购物车',
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: addToCart,
                  child: const Text('加入购物车'),
                ),
                const SizedBox(width: 8),
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

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF666666),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

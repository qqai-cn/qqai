import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../util/media_url.dart';
import '../data/models/mall_product_model.dart';
import '../data/repos/goods_repo.dart';
import '../goods_tab_navigator.dart';
import '../models/cart_line.dart';
import '../models/goods_comment_item.dart';
import '../providers/cart_session.dart';
import '../providers/goods_comments.dart';
import '../theme/goods_page_style.dart';

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
        return _GoodsDetailPage(product: product);
      },
    );
  }
}

class _GoodsDetailPage extends ConsumerStatefulWidget {
  const _GoodsDetailPage({required this.product});

  final MallProduct product;

  @override
  ConsumerState<_GoodsDetailPage> createState() => _GoodsDetailPageState();
}

class _GoodsDetailPageState extends ConsumerState<_GoodsDetailPage> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  int? _selectedSkuIndex;
  int _selectedQty = 1;

  MallProduct get _product => widget.product;

  MallProductSku? get _selectedSku {
    final skus = _product.skus;
    if (skus.isEmpty) return null;
    final index = _selectedSkuIndex ?? 0;
    if (index < 0 || index >= skus.length) return skus.first;
    return skus[index];
  }

  MallProductSku? get _singleSpecSku {
    final skus = _product.skus;
    if (skus.isEmpty) return null;
    return skus.first;
  }

  List<String> get _galleryUrls {
    final sliderUrls = _product.sliderPicUrls
        .map(resolveMediaUrl)
        .whereType<String>()
        .toList();
    final coverUrl = resolveMediaUrl(_product.coverUrl);
    if (sliderUrls.isNotEmpty) return sliderUrls;
    if (coverUrl != null) return [coverUrl];
    return const [];
  }

  String get _title {
    final raw = _product.name?.trim();
    return raw == null || raw.isEmpty ? '商品' : raw;
  }

  String get _introduction => (_product.introduction ?? '').trim();

  String _plainText(String? html) {
    final raw = (html ?? '').trim();
    if (raw.isEmpty) return '';
    return raw
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  double get _price => _selectedSku?.priceYuan ?? _product.priceYuan;
  double get _marketPrice =>
      _selectedSku?.marketPriceYuan ?? _product.marketPriceYuan;
  bool get _hasMultipleSpecs =>
      _product.specType == true && _product.skus.isNotEmpty;

  String _formatMeasureValue(double? value, String unit) {
    if (value == null) return '--';
    final text = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(3).replaceFirst(RegExp(r'0+$'), '').replaceFirst(
            RegExp(r'\.$'),
            '',
          );
    return '$text $unit';
  }

  String get _specText {
    if (_hasMultipleSpecs) {
      return _selectedSku?.label ?? '请选择商品规格';
    }
    return '单规格商品';
  }

  String _recentPraiseText(List<GoodsCommentItem> comments) {
    final now = DateTime.now();
    final recent = comments.where((item) {
      final age = now.difference(item.createdAt);
      return age.inDays < 7;
    }).toList();
    if (recent.isEmpty) return '近7天好评率100%';
    final goodCount = recent.where((item) => item.stars >= 4).length;
    final rate = ((goodCount / recent.length) * 100).round();
    return '近7天好评率$rate%';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addToCart() {
    final sku = _selectedSku;
    ref
        .read(cartSessionProvider.notifier)
        .addFromGoods(
          id: sku?.id != null
              ? '${_product.id}-${sku!.id}'
              : _product.id?.toString() ?? '',
          title: sku == null ? _title : '$_title · ${sku.label}',
          price: _price,
          coverAsset: 'imgs/defbak.png',
          addQty: _selectedQty,
        );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已加入购物车')));
  }

  void _buyNow() {
    final sku = _selectedSku;
    final line = CartLine(
      id: sku?.id != null
          ? '${_product.id}-${sku!.id}'
          : _product.id?.toString() ?? '',
      title: sku == null ? _title : '$_title · ${sku.label}',
      price: _price,
      coverAsset: 'imgs/defbak.png',
      quantity: _selectedQty,
      selected: true,
    );
    context.pushGoodsCheckout(<CartLine>[line.copy()]);
  }

  Future<void> _openSkuSheet({
    required bool buyAfterConfirm,
    bool triggerActionWhenNoSku = true,
  }) async {
    final skus = _product.skus;
    if (skus.isEmpty) {
      if (!triggerActionWhenNoSku) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('当前商品暂无可选规格')),
        );
        return;
      }
      if (buyAfterConfirm) {
        _buyNow();
      } else {
        _addToCart();
      }
      return;
    }

    final result = await showModalBottomSheet<_SkuSelectionResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _SkuSelectorSheet(
        title: _title,
        skus: skus,
        initialIndex: (_selectedSkuIndex ?? 0).clamp(0, skus.length - 1),
        initialQty: _selectedQty,
        productCoverUrl: resolveMediaUrl(_product.coverUrl),
      ),
    );
    if (result == null || !mounted) return;

    setState(() {
      _selectedSkuIndex = result.index;
      _selectedQty = result.quantity;
    });

    if (buyAfterConfirm) {
      _buyNow();
    } else {
      _addToCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(goodsCommentsProvider('${_product.id}'));
    final recentPraiseText = _recentPraiseText(comments);
    final detailText = [_introduction, _plainText(_product.description)]
        .where((item) => item.trim().isNotEmpty)
        .join('\n\n');

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: GoodsPageStyle.pageMaxWidth,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildGallery(),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                      child: Column(
                        children: [
                          _PriceCard(
                            price: _price,
                            marketPrice: _marketPrice,
                            salesCount: _product.salesCount ?? 0,
                            title: _title,
                            subtitle: _introduction.isEmpty ? '暂无商品简介' : _introduction,
                          ),
                          const SizedBox(height: 8),
                          _hasMultipleSpecs
                              ? _CellCard(
                                  title: '选择',
                                  content: _specText,
                                  onTap: () => _openSkuSheet(
                                    buyAfterConfirm: false,
                                    triggerActionWhenNoSku: false,
                                  ),
                                )
                              : _SingleSpecCard(
                                  weightText: _formatMeasureValue(
                                    _singleSpecSku?.weight,
                                    'kg',
                                  ),
                                  volumeText: _formatMeasureValue(
                                    _singleSpecSku?.volume,
                                    'm3',
                                  ),
                                ),
                          const SizedBox(height: 8),
                          _CommentsCard(
                            comments: comments,
                            recentPraiseText: recentPraiseText,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => _GoodsCommentsPage(
                                    comments: comments,
                                    recentPraiseText: recentPraiseText,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          const _PromoBar(),
                          const SizedBox(height: 8),
                          _DetailTextCard(detailText: detailText),
                          SizedBox(
                            height: 90 + MediaQuery.viewPaddingOf(context).bottom,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            left: 12,
            right: 12,
            child: Row(
              children: [
                _BackIconButton(
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                const SizedBox(width: 8),
                _TopRoundButton(
                  icon: Icons.menu_rounded,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomActionBar(
        onCart: context.pushGoodsCart,
        onAddToCart: () => _openSkuSheet(buyAfterConfirm: false),
        onBuyNow: () => _openSkuSheet(buyAfterConfirm: true),
      ),
    );
  }

  Widget _buildGallery() {
    final galleryUrls = _galleryUrls;
    final topInset = MediaQuery.paddingOf(context).top;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final galleryHeight = screenWidth < 600 ? 360.0 : 420.0;

    return Container(
      color: const Color(0xFFF7F7F7),
      child: Column(
        children: [
          SizedBox(height: topInset + 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(18),
                ),
              ),
              child: SizedBox(
                height: galleryHeight,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white,
                              const Color(0xFFF7F7F7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (galleryUrls.isEmpty)
                      const Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: Color(0xFF9CA3AF),
                        ),
                      )
                    else
                      PageView.builder(
                        controller: _pageController,
                        itemCount: galleryUrls.length,
                        onPageChanged: (index) {
                          if (!mounted) return;
                          setState(() => _currentImageIndex = index);
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 18),
                            child: Image.network(
                              galleryUrls[index],
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 64,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    if (galleryUrls.length > 1)
                      Positioned(
                        right: 14,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.32),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${_currentImageIndex + 1} / ${galleryUrls.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopRoundButton extends StatelessWidget {
  const _TopRoundButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.96),
      borderRadius: BorderRadius.circular(15),
      elevation: 2,
      shadowColor: const Color(0x16000000),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 32,
          child: Icon(icon, size: 19, color: const Color(0xFF202124)),
        ),
      ),
    );
  }
}

class _BackIconButton extends StatelessWidget {
  const _BackIconButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 22,
        color: GoodsPageStyle.text,
      ),
      style: IconButton.styleFrom(
        foregroundColor: GoodsPageStyle.text,
        padding: EdgeInsets.zero,
        minimumSize: const Size(40, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({
    required this.price,
    required this.marketPrice,
    required this.salesCount,
    required this.title,
    required this.subtitle,
  });

  final double price;
  final double marketPrice;
  final int salesCount;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '¥',
                      style: TextStyle(
                        color: Color(0xFFE6462D),
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      price.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Color(0xFFE6462D),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (marketPrice > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        '¥${marketPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFFB9B9B9),
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '已售$salesCount',
                    style: const TextStyle(
                      color: Color(0xFFB9B9B9),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '领券',
                        style: TextStyle(
                          color: Color(0xFFE85B43),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 1),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFFE85B43),
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: const Color(0xFFF2F2F2)),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF111111),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF929292),
              fontSize: 13.5,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _CellCard extends StatelessWidget {
  const _CellCard({
    required this.title,
    required this.content,
    this.onTap,
  });

  final String title;
  final String content;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      shadowColor: Colors.black.withValues(alpha: 0.025),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF7D7D7D),
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  content,
                  style: TextStyle(
                    color: onTap == null
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF2B2B2B),
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFBDBDBD),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SingleSpecCard extends StatelessWidget {
  const _SingleSpecCard({
    required this.weightText,
    required this.volumeText,
  });

  final String weightText;
  final String volumeText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '规格',
                style: TextStyle(
                  color: Color(0xFF7D7D7D),
                  fontSize: 14.5,
                ),
              ),
              SizedBox(width: 18),
              Text(
                '单规格商品',
                style: TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SpecMetricItem(
                  label: '重量',
                  value: weightText,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SpecMetricItem(
                  label: '体积',
                  value: volumeText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpecMetricItem extends StatelessWidget {
  const _SpecMetricItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9AA0AE),
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF303133),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentsCard extends StatelessWidget {
  const _CommentsCard({
    required this.comments,
    required this.recentPraiseText,
    required this.onTap,
  });

  final List<GoodsCommentItem> comments;
  final String recentPraiseText;
  final VoidCallback onTap;

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final d = now.difference(t);
    if (d.inDays >= 7) {
      return '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
    }
    if (d.inDays >= 1) return '${d.inDays}天前';
    if (d.inHours >= 1) return '${d.inHours}小时前';
    if (d.inMinutes >= 1) return '${d.inMinutes}分钟前';
    return '刚刚';
  }

  @override
  Widget build(BuildContext context) {
    final previewCount = comments.length > 2 ? 2 : comments.length;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6462D),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '评价',
                    style: TextStyle(
                      color: Color(0xFF202124),
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${comments.length})',
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    recentPraiseText,
                    style: const TextStyle(
                      color: Color(0xFFE85B43),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFE85B43),
                    size: 17,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (comments.isEmpty)
                const Text(
                  '暂无评价',
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 14,
                  ),
                )
              else
                Column(
                  children: List.generate(previewCount, (index) {
                    final item = comments[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == previewCount - 1 ? 0 : 14,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                        decoration: BoxDecoration(
                          border: index == previewCount - 1
                              ? null
                              : const Border(
                                  bottom: BorderSide(color: Color(0xFFF1F1F1)),
                                ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF6F6F6),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.person_rounded,
                                    size: 18,
                                    color: Color(0xFF8E8E8E),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item.author,
                                    style: const TextStyle(
                                      color: Color(0xFF555555),
                                      fontSize: 13.5,
                                    ),
                                  ),
                                ),
                                Text(
                                  _formatTime(item.createdAt),
                                  style: const TextStyle(
                                    color: Color(0xFFB2B2B2),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (starIndex) => Icon(
                                    starIndex < item.stars
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    size: 17,
                                    color: const Color(0xFFFFC54D),
                                  ),
                                ),
                                if ((item.skuLabel ?? '').trim().isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.skuLabel!.trim(),
                                      style: const TextStyle(
                                        color: Color(0xFF9A9A9A),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.content,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF2B2B2B),
                                fontSize: 14.5,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoodsCommentsPage extends StatelessWidget {
  const _GoodsCommentsPage({
    required this.comments,
    required this.recentPraiseText,
  });

  final List<GoodsCommentItem> comments;
  final String recentPraiseText;

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final d = now.difference(t);
    if (d.inDays >= 7) {
      return '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
    }
    if (d.inDays >= 1) return '${d.inDays}天前';
    if (d.inHours >= 1) return '${d.inHours}小时前';
    if (d.inMinutes >= 1) return '${d.inMinutes}分钟前';
    return '刚刚';
  }

  String _summaryText() {
    if (comments.isEmpty) return '暂无近期评价总结';
    final highRated = comments.where((item) => item.stars >= 4).toList();
    if (highRated.isEmpty) return '近7天评价较少，欢迎成为首批高质量评价用户';
    return '• 近期买家普遍认可商品体验\n• $recentPraiseText，整体满意度较高\n• 多数用户反馈性价比和使用体验不错';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(title: const Text('评价')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _CommentFilterChip(
                  text: '全部 ${comments.isEmpty ? 0 : comments.length}',
                  active: true,
                ),
                _CommentFilterChip(text: recentPraiseText),
                _CommentFilterChip(
                  text: '有图/视频 ${comments.where((item) => item.helpfulCount > 10).length}',
                ),
                _CommentFilterChip(
                  text: 'PLUS ${comments.where((item) => item.isPlusMember).length}',
                ),
              ],
            ),
          ),
          Expanded(
            child: comments.isEmpty
                ? const Center(child: Text('暂无评价'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 18),
                    itemCount: comments.length + 2,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F4FF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _summaryText(),
                                style: const TextStyle(
                                  color: Color(0xFF596172),
                                  fontSize: 14,
                                  height: 1.75,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '总结自近期发布的真实买家评价',
                                style: TextStyle(
                                  color: Color(0xFF9AA0AE),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      if (index == 1) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.verified_outlined,
                                size: 18,
                                color: Color(0xFFB4B8C2),
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '鼓励真实、有用的评价',
                                  style: TextStyle(
                                    color: Color(0xFF9AA0AE),
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                              Text(
                                '最新',
                                style: TextStyle(
                                  color: Color(0xFF4B4F58),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '当前商品',
                                style: TextStyle(
                                  color: Color(0xFF4B4F58),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final item = comments[index - 2];
                      return Container(
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF3F3F3),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.person_rounded,
                                    color: Color(0xFF8D8D8D),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.author,
                                        style: const TextStyle(
                                          color: Color(0xFF202124),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          if (item.isPlusMember)
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 1,
                                              ),
                                              margin: const EdgeInsets.only(right: 6),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF6F4D2C),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                'PLUS',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ...List.generate(
                                            5,
                                            (starIndex) => Icon(
                                              starIndex < item.stars
                                                  ? Icons.star_rounded
                                                  : Icons.star_border_rounded,
                                              size: 17,
                                              color: const Color(0xFFFFC54D),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  _formatTime(item.createdAt),
                                  style: const TextStyle(
                                    color: Color(0xFF9A9A9A),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            if ((item.skuLabel ?? '').trim().isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                item.skuLabel!.trim(),
                                style: const TextStyle(
                                  color: Color(0xFF969696),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Text(
                              item.content,
                              style: const TextStyle(
                                color: Color(0xFF242424),
                                fontSize: 15,
                                height: 1.7,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.thumb_up_alt_outlined,
                                  size: 20,
                                  color: Color(0xFF8B8B8B),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.helpfulCount}',
                                  style: const TextStyle(
                                    color: Color(0xFF8B8B8B),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                const Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  size: 20,
                                  color: Color(0xFF8B8B8B),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '评论',
                                  style: TextStyle(
                                    color: Color(0xFF8B8B8B),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CommentFilterChip extends StatelessWidget {
  const _CommentFilterChip({required this.text, this.active = false});

  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFFFF2E5) : const Color(0xFFF2F4F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? const Color(0xFFA46C2B) : const Color(0xFF4F5561),
          fontSize: 14,
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _PromoBar extends StatelessWidget {
  const _PromoBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF3F23), Color(0xFFFF7A1A)],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.people_alt_outlined, color: Colors.white, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '该商品正在参与封神榜真好看活动',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(999)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 3),
              child: Text(
                'GO',
                style: TextStyle(
                  color: Color(0xFFFF6D0F),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailTextCard extends StatelessWidget {
  const _DetailTextCard({required this.detailText});

  final String detailText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '商品详情',
            style: TextStyle(
              color: Color(0xFF202124),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            detailText.isEmpty ? '暂无商品详情' : detailText,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.onCart,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  final VoidCallback onCart;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 5, 8, 7),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 18,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            _BottomIconButton(
              icon: Icons.star_border_rounded,
              label: '收藏',
              onTap: () {},
            ),
            _BottomIconButton(
              icon: Icons.headset_mic_outlined,
              label: '客服',
              onTap: () {},
            ),
            _BottomIconButton(
              icon: Icons.shopping_cart_outlined,
              label: '购物车',
              onTap: onCart,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _GradientButton(
                text: '加入购物车',
                colors: const [Color(0xFFFFEEE9), Color(0xFFFFD9CF)],
                textColor: const Color(0xFFD7674F),
                borderRadius: 22,
                height: 40,
                onTap: onAddToCart,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _GradientButton(
                text: '立即购买',
                colors: const [Color(0xFFFF5027), Color(0xFFFF7A73)],
                textColor: Colors.white,
                borderRadius: 22,
                height: 40,
                onTap: onBuyNow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomIconButton extends StatelessWidget {
  const _BottomIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 48,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: const Color(0xFF3B3B3B)),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF3B3B3B),
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.text,
    required this.colors,
    required this.textColor,
    required this.borderRadius,
    required this.height,
    required this.onTap,
  });

  final String text;
  final List<Color> colors;
  final Color textColor;
  final double borderRadius;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: SizedBox(
            height: height,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkuSelectorSheet extends StatefulWidget {
  const _SkuSelectorSheet({
    required this.title,
    required this.skus,
    required this.initialIndex,
    required this.initialQty,
    required this.productCoverUrl,
  });

  final String title;
  final List<MallProductSku> skus;
  final int initialIndex;
  final int initialQty;
  final String? productCoverUrl;

  @override
  State<_SkuSelectorSheet> createState() => _SkuSelectorSheetState();
}

class _SkuSelectorSheetState extends State<_SkuSelectorSheet> {
  late int _selectedIndex = widget.initialIndex;
  late int _qty = widget.initialQty < 1 ? 1 : widget.initialQty;

  @override
  Widget build(BuildContext context) {
    final sku = widget.skus[_selectedIndex];
    final coverUrl = resolveMediaUrl(sku.picUrl) ?? widget.productCoverUrl;

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 86,
                    height: 86,
                    child: coverUrl == null
                        ? const ColoredBox(
                            color: Color(0xFFF3F5F8),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: Color(0xFF9CA3AF),
                            ),
                          )
                        : Image.network(
                            coverUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const ColoredBox(
                              color: Color(0xFFF3F5F8),
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¥ ${sku.priceYuan.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFFE6462D),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF202124),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '已选 ${sku.label}  库存 ${sku.stock ?? 0}',
                        style: const TextStyle(
                          color: Color(0xFF8C8C8C),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              '规格',
              style: TextStyle(
                color: Color(0xFF202124),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(widget.skus.length, (index) {
                final item = widget.skus[index];
                final active = index == _selectedIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFFFFEEE9)
                          : const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: active
                            ? const Color(0xFFE6462D)
                            : const Color(0xFFE5E5E5),
                      ),
                    ),
                    child: Text(
                      item.label,
                      style: TextStyle(
                        color: active
                            ? const Color(0xFFE6462D)
                            : const Color(0xFF333333),
                        fontSize: 13,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Text(
                  '数量',
                  style: TextStyle(
                    color: Color(0xFF202124),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                _QuantityStepper(
                  value: _qty,
                  onChanged: (next) {
                    final stock = sku.stock ?? 0;
                    final maxQty = stock > 0 ? stock : 9999;
                    setState(() => _qty = next.clamp(1, maxQty));
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: _GradientButton(
                text: '确定',
                colors: const [Color(0xFFFF5027), Color(0xFFFF7A73)],
                textColor: Colors.white,
                borderRadius: 24,
                height: 46,
                onTap: () => Navigator.of(context).pop(
                  _SkuSelectionResult(index: _selectedIndex, quantity: _qty),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkuSelectionResult {
  const _SkuSelectionResult({required this.index, required this.quantity});

  final int index;
  final int quantity;
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperIconButton(
            icon: Icons.remove_rounded,
            onTap: value <= 1 ? null : () => onChanged(value - 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              '$value',
              style: const TextStyle(
                color: Color(0xFF202124),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _StepperIconButton(
            icon: Icons.add_rounded,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _StepperIconButton extends StatelessWidget {
  const _StepperIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: 34,
        height: 34,
        child: Icon(
          icon,
          size: 18,
          color: onTap == null
              ? const Color(0xFFCCCCCC)
              : const Color(0xFF202124),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/auth_providers.dart';
import '../../../router/app_routes.dart';
import '../../../util/media_url.dart';
import '../data/product_browse_record.dart';
import '../data/models/mall_product_model.dart';
import '../data/repos/goods_repo.dart';
import '../goods_tab_navigator.dart';
import '../models/cart_line.dart';
import '../models/goods_comment_item.dart';
import '../providers/cart_session.dart';
import '../providers/goods_comments.dart';
import '../widgets/coupon_claim_entry.dart';
import '../../chat/utils/open_member_conversation_chat.dart';
import '../widgets/goods_comment_submit_sheet.dart';
import '../widgets/goods_page_layout.dart';

String goodsRecentPraiseText(List<GoodsCommentItem> comments) {
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
        return _GoodsDetailPage(
          key: ValueKey('goods-detail-${product.id}'),
          product: product,
        );
      },
    );
  }
}

class _GoodsDetailPage extends ConsumerStatefulWidget {
  const _GoodsDetailPage({super.key, required this.product});

  final MallProduct product;

  @override
  ConsumerState<_GoodsDetailPage> createState() => _GoodsDetailPageState();
}

class _GoodsDetailPageState extends ConsumerState<_GoodsDetailPage> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  int? _selectedSkuIndex;
  int _selectedQty = 1;
  bool _collected = false;
  bool _collectLoading = false;
  bool _serviceLoading = false;

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

  String _recentPraiseText(List<GoodsCommentItem> comments) =>
      goodsRecentPraiseText(comments);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      recordProductBrowseSilently(ref, _product.id);
      _loadFavoriteStatus();
    });
  }

  Future<void> _loadFavoriteStatus() async {
    final spuId = _product.id;
    if (spuId == null) return;
    if (!ref.read(authProvider).isAuthenticated) return;
    try {
      final collected =
          await ref.read(goodsRepoProvider).isProductFavorite(spuId);
      if (!mounted) return;
      setState(() => _collected = collected);
    } catch (_) {
      // 静默失败，不影响详情页展示
    }
  }

  Future<void> _openCustomerService() async {
    if (_serviceLoading) return;
    final memberUserId = _product.serviceMemberUserId;
    if (memberUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('该商品分类暂未绑定客服会员')),
      );
      return;
    }
    setState(() => _serviceLoading = true);
    try {
      await openMemberConversationChat(context, ref, memberUserId);
    } finally {
      if (mounted) {
        setState(() => _serviceLoading = false);
      }
    }
  }

  Future<void> _toggleCollect() async {
    if (_collectLoading) return;
    if (!ref.read(authProvider).isAuthenticated) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先登录')),
      );
      context.push(Routes.login);
      return;
    }
    final spuId = _product.id;
    if (spuId == null) return;

    setState(() => _collectLoading = true);
    try {
      final nowCollected = await ref.read(goodsRepoProvider).toggleProductFavorite(
            spuId,
            currentlyCollected: _collected,
          );
      if (!mounted) return;
      setState(() => _collected = nowCollected);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(nowCollected ? '已收藏' : '已取消收藏')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('操作失败：$e')),
      );
    } finally {
      if (mounted) {
        setState(() => _collectLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _addToCart() async {
    final sku = _selectedSku ?? _singleSpecSku;
    final skuId = sku?.id;
    if (skuId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('当前商品暂无可购规格')),
      );
      return;
    }
    try {
      await ref.read(cartSessionProvider.notifier).addFromGoods(
            skuId: skuId,
            spuId: _product.id,
            title: sku == null ? _title : '$_title · ${sku.label}',
            price: _price,
            coverUrl: sku?.picUrl ?? _product.coverUrl,
            addQty: _selectedQty,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已加入购物车')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加入购物车失败：$e')),
      );
    }
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
    final commentsAsync = ref.watch(goodsCommentsProvider('${_product.id}'));
    final goodsId = '${_product.id}';
    final detailText = [_introduction, _plainText(_product.description)]
        .where((item) => item.trim().isNotEmpty)
        .join('\n\n');

    return GoodsPageScaffold(
      topBar: Row(
        children: [
          GoodsBackButton(onTap: () => Navigator.of(context).maybePop()),
          const SizedBox(width: 8),
          GoodsTopRoundButton(icon: Icons.menu_rounded, onTap: () {}),
        ],
      ),
      main: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildGallery()),
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
                    subtitle:
                        _introduction.isEmpty ? '暂无商品简介' : _introduction,
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
                  commentsAsync.when(
                    data: (state) => _CommentsCard(
                      comments: state.items,
                      recentPraiseText: _recentPraiseText(state.items),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => _GoodsCommentsPage(
                              goodsId: goodsId,
                            ),
                          ),
                        );
                      },
                    ),
                    loading: () => const _CommentsCardLoading(),
                    error: (error, _) => _CommentsCardError(
                      message: error.toString(),
                      onRetry: () =>
                          ref.invalidate(goodsCommentsProvider(goodsId)),
                    ),
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
      bottomBar: _BottomActionBar(
        collected: _collected,
        collectLoading: _collectLoading,
        serviceLoading: _serviceLoading,
        onCollect: _toggleCollect,
        onCustomerService: _openCustomerService,
        onCart: context.pushGoodsCart,
        onAddToCart: () => _openSkuSheet(buyAfterConfirm: false),
        onBuyNow: () => _openSkuSheet(buyAfterConfirm: true),
      ),
    );
  }

  Widget _buildGallery() {
    final galleryUrls = _galleryUrls;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final galleryHeight = screenWidth < 600 ? 360.0 : 420.0;

    return GoodsPageTopSection(
      sectionColor: const Color(0xFFF7F7F7),
      padding: EdgeInsets.zero,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(18),
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
                  const CouponClaimEntry(),
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

class _CommentsCardLoading extends StatelessWidget {
  const _CommentsCardLoading();

  @override
  Widget build(BuildContext context) {
    return const _CommentsCardShell(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}

class _CommentsCardError extends StatelessWidget {
  const _CommentsCardError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _CommentsCardShell(
      child: Column(
        children: [
          Text(
            message,
            style: const TextStyle(color: Color(0xFF999999), fontSize: 13),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('重新加载')),
        ],
      ),
    );
  }
}

class _CommentsCardShell extends StatelessWidget {
  const _CommentsCardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
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

class _GoodsCommentsPage extends ConsumerWidget {
  const _GoodsCommentsPage({required this.goodsId});

  final String goodsId;

  Widget _buildTitleBar(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        GoodsBackButton(onTap: () => Navigator.of(context).maybePop()),
        const Expanded(
          child: Text(
            '评价',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF202124),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        GoodsTopRoundButton(
          icon: Icons.edit_outlined,
          onTap: () => showGoodsCommentSubmitSheet(
            context,
            ref,
            goodsId: goodsId,
          ),
        ),
      ],
    );
  }

  static String _formatTime(DateTime t) {
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

  static String _summaryText(
    List<GoodsCommentItem> comments,
    String recentPraiseText,
  ) {
    if (comments.isEmpty) return '暂无评价，购买完成后欢迎发表真实评价';
    final highRated = comments.where((item) => item.stars >= 4).toList();
    if (highRated.isEmpty) return '评价较少，欢迎成为首批评价用户';
    return '• 近期买家普遍认可商品体验\n• $recentPraiseText，整体满意度较高\n• 多数用户反馈性价比和使用体验不错';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsync = ref.watch(goodsCommentsProvider(goodsId));

    return GoodsPageScaffold(
      main: commentsAsync.when(
        loading: () => GoodsPageMainColumn(
          header: _buildTitleBar(context, ref),
          body: const Expanded(
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
        error: (error, _) => GoodsPageMainColumn(
          header: _buildTitleBar(context, ref),
          body: Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(error.toString()),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () =>
                        ref.invalidate(goodsCommentsProvider(goodsId)),
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
          ),
        ),
        data: (state) {
          final comments = state.items;
          final recentPraiseText = goodsRecentPraiseText(comments);
          return GoodsPageMainColumn(
            header: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleBar(context, ref),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _CommentFilterChip(
                      text: '全部 ${state.total}',
                      active: state.filterType == 0,
                      onTap: () => ref
                          .read(goodsCommentsProvider(goodsId).notifier)
                          .setFilterType(0),
                    ),
                    _CommentFilterChip(
                      text: '好评 ${state.goodCount}',
                      active: state.filterType == 1,
                      onTap: () => ref
                          .read(goodsCommentsProvider(goodsId).notifier)
                          .setFilterType(1),
                    ),
                    _CommentFilterChip(
                      text: '中评',
                      active: state.filterType == 2,
                      onTap: () => ref
                          .read(goodsCommentsProvider(goodsId).notifier)
                          .setFilterType(2),
                    ),
                    _CommentFilterChip(
                      text: '差评',
                      active: state.filterType == 3,
                      onTap: () => ref
                          .read(goodsCommentsProvider(goodsId).notifier)
                          .setFilterType(3),
                    ),
                    _CommentFilterChip(
                      text: '有图 ${state.imageCount}',
                      active: false,
                    ),
                  ],
                ),
              ],
            ),
            body: Expanded(
              child: RefreshIndicator(
                  onRefresh: () => ref
                      .read(goodsCommentsProvider(goodsId).notifier)
                      .refresh(),
                  child: comments.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 120),
                            Center(child: Text('暂无评价')),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(8, 10, 8, 18),
                          itemCount: comments.length + 1,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Container(
                                padding: const EdgeInsets.fromLTRB(
                                  14,
                                  14,
                                  14,
                                  14,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F4FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _summaryText(
                                        comments,
                                        recentPraiseText,
                                      ),
                                      style: const TextStyle(
                                        color: Color(0xFF596172),
                                        fontSize: 14,
                                        height: 1.75,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '共 ${state.total} 条真实买家评价',
                                      style: const TextStyle(
                                        color: Color(0xFF9AA0AE),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            final item = comments[index - 1];
                            return _GoodsCommentListTile(
                              item: item,
                              timeLabel: _formatTime(item.createdAt),
                            );
                          },
                        ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GoodsCommentListTile extends StatelessWidget {
  const _GoodsCommentListTile({
    required this.item,
    required this.timeLabel,
  });

  final GoodsCommentItem item;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: const Color(0xFFF3F3F3),
                backgroundImage: (item.avatarUrl ?? '').isNotEmpty
                    ? NetworkImage(item.avatarUrl!)
                    : null,
                child: (item.avatarUrl ?? '').isEmpty
                    ? const Icon(Icons.person_rounded, color: Color(0xFF8D8D8D))
                    : null,
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
                      children: List.generate(
                        5,
                        (starIndex) => Icon(
                          starIndex < item.stars
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 17,
                          color: const Color(0xFFFFC54D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                timeLabel,
                style: const TextStyle(color: Color(0xFF9A9A9A), fontSize: 12),
              ),
            ],
          ),
          if ((item.skuLabel ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              item.skuLabel!.trim(),
              style: const TextStyle(color: Color(0xFF969696), fontSize: 13),
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
          if (item.picUrls.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: item.picUrls
                  .take(3)
                  .map(
                    (url) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        resolveMediaUrl(url) ?? url,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox(
                          width: 72,
                          height: 72,
                          child: ColoredBox(color: Color(0xFFF0F0F0)),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if ((item.replyContent ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '商家回复：${item.replyContent!.trim()}',
                style: const TextStyle(color: Color(0xFF666666), fontSize: 13),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CommentFilterChip extends StatelessWidget {
  const _CommentFilterChip({
    required this.text,
    this.active = false,
    this.onTap,
  });

  final String text;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? const Color(0xFFFFF2E5) : const Color(0xFFF2F4F8),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            text,
            style: TextStyle(
              color: active ? const Color(0xFFA46C2B) : const Color(0xFF4F5561),
              fontSize: 14,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
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
    required this.onCollect,
    required this.collected,
    required this.collectLoading,
    required this.serviceLoading,
    required this.onCustomerService,
    required this.onCart,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  final VoidCallback onCollect;
  final bool collected;
  final bool collectLoading;
  final bool serviceLoading;
  final VoidCallback onCustomerService;
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
              icon: collected ? Icons.star_rounded : Icons.star_border_rounded,
              label: '收藏',
              iconColor: collected ? const Color(0xFFFFA000) : null,
              onTap: collectLoading ? () {} : onCollect,
            ),
            _BottomIconButton(
              icon: Icons.headset_mic_outlined,
              label: '客服',
              onTap: serviceLoading ? () {} : onCustomerService,
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
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

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
            Icon(
              icon,
              size: 22,
              color: iconColor ?? const Color(0xFF3B3B3B),
            ),
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

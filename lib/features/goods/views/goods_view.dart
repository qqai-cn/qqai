import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../goods_tab_navigator.dart';
import '../../../util/media_url.dart';
import '../data/models/mall_product_model.dart';
import '../data/repos/goods_repo.dart';
import '../providers/goods_mall_tab_reselect_provider.dart';

class GoodsView extends ConsumerStatefulWidget {
  const GoodsView({super.key});

  @override
  ConsumerState<GoodsView> createState() => _GoodsViewState();
}

class _GoodsViewState extends ConsumerState<GoodsView> {
  static const _pageSize = 20;
  static const _pageMaxWidth = 1180.0;
  static const _minColumnWidth = 220.0;

  final _scrollController = ScrollController();
  final _items = <MallProduct>[];
  int _pageNo = 1;
  int _total = 0;
  bool _loading = true;
  bool _loadingMore = false;
  Object? _error;

  bool get _hasMore =>
      _items.length < _total || (_total == 0 && _items.isEmpty);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(_refresh);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_loading || _loadingMore || !_hasMore) return;
    final position = _scrollController.position;
    if (!position.hasContentDimensions || position.maxScrollExtent <= 0) return;
    if (position.maxScrollExtent - position.pixels > 260) return;
    _loadMore();
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
      _pageNo = 1;
    });
    try {
      final page = await ref
          .read(goodsRepoProvider)
          .getMallProductsPage(1, pageSize: _pageSize);
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(page.list);
        _total = page.total;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    try {
      final next = _pageNo + 1;
      final page = await ref
          .read(goodsRepoProvider)
          .getMallProductsPage(next, pageSize: _pageSize);
      if (!mounted) return;
      setState(() {
        _pageNo = next;
        _items.addAll(page.list);
        _total = page.total;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  int _columns(double width) {
    return math.max(1, (width / _minColumnWidth).floor()).clamp(1, 5);
  }

  double _topContentInset(BuildContext context) {
    return  kToolbarHeight;
  }

  void _onMallTabReselect() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(goodsMallTabReselectProvider, (previous, next) {
      if (previous == null || next <= previous) return;
      _onMallTabReselect();
    });

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ColoredBox(
        color: const Color(0xFFF6F7F9),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _pageMaxWidth),
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(height: _topContentInset(context)),
                  ),
                  const SliverToBoxAdapter(child: _MallHeader()),
                  ..._buildBodySlivers(),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBodySlivers() {
    if (_loading && _items.isEmpty) {
      return const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    if (_error != null && _items.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _MallError(message: _error.toString(), onRetry: _refresh),
        ),
      ];
    }
    if (_items.isEmpty) {
      return const [
        SliverFillRemaining(hasScrollBody: false, child: _MallEmpty()),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        sliver: SliverLayoutBuilder(
          builder: (context, constraints) {
            return SliverMasonryGrid.count(
              crossAxisCount: _columns(constraints.crossAxisExtent),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return _GoodsCard(
                  item: item,
                  index: index,
                  onTap: () {
                    final id = item.id;
                    if (id != null) {
                      context.pushGoodsDetail('$id');
                    }
                  },
                );
              },
            );
          },
        ),
      ),
      if (_loadingMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
    ];
  }
}

class _MallHeader extends StatelessWidget {
  const _MallHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 16),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFECEEF2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Color(0xFFE11D48),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '精选好物',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF202124),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '精选商城商品，看看今天有哪些新东西',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoodsCard extends StatelessWidget {
  const _GoodsCard({
    required this.item,
    required this.index,
    required this.onTap,
  });

  final MallProduct item;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final coverUrl = resolveMediaUrl(item.coverUrl);
    final imageRatio = index.isEven ? 0.78 : 0.92;
    final name = item.name?.trim().isNotEmpty == true
        ? item.name!.trim()
        : '商品';
    final intro = item.introduction?.trim();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFECEEF2)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: imageRatio,
                child: coverUrl == null
                    ? const _GoodsImageFallback()
                    : CachedNetworkImage(
                        imageUrl: coverUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => const _GoodsImageFallback(),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF202124),
                        fontSize: 15,
                        height: 1.22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '¥',
                          style: TextStyle(
                            color: Color(0xFFE11D48),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          item.priceYuan.toStringAsFixed(2),
                          style: const TextStyle(
                            color: Color(0xFFE11D48),
                            fontSize: 22,
                            height: 1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            '在售',
                            style: TextStyle(
                              color: Color(0xFFE11D48),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (intro != null && intro.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        intro,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department_outlined,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.salesCount ?? 0} 已售',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '库存 ${item.stock ?? 0}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoodsImageFallback extends StatelessWidget {
  const _GoodsImageFallback();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF3F5F8),
      child: Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          color: Colors.grey.shade500,
          size: 36,
        ),
      ),
    );
  }
}

class _MallError extends StatelessWidget {
  const _MallError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('重试')),
          ],
        ),
      ),
    );
  }
}

class _MallEmpty extends StatelessWidget {
  const _MallEmpty();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('暂无在售商品', style: TextStyle(color: Color(0xFF6B7280))),
    );
  }
}

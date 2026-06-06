import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/constant/constant.dart';
import '../goods_tab_navigator.dart';
import '../../../components/in_page_search_bar.dart';
import '../../../components/refresh_status_badge.dart';
import '../../../util/media_url.dart';
import '../data/models/mall_product_model.dart';
import '../data/repos/goods_repo.dart';
import '../providers/goods_mall_tab_reselect_provider.dart';
import '../theme/goods_page_style.dart';
import '../../../components/horizontal_deal_layout.dart';
import '../widgets/coupon_claim_entry.dart';
import '../widgets/mall_product_horizontal_card.dart';

enum _MallListLayout { grid, horizontalCards }

bool _isWideMallLayout(double width) => width > Constant.SQUARE_SPLIT_WIDTH;

class GoodsView extends ConsumerStatefulWidget {
  const GoodsView({super.key, this.reserveHomeTabTopInset = true});

  /// 首页 Tab 内嵌时为透明 AppBar 预留顶部空隙；独立路由页应设为 false。
  final bool reserveHomeTabTopInset;

  @override
  ConsumerState<GoodsView> createState() => _GoodsViewState();
}

class _GoodsViewState extends ConsumerState<GoodsView> {
  static const _pageSize = 20;
  static const _pageMaxWidth = 1180.0;
  static const _minColumnWidth = 220.0;

  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _items = <MallProduct>[];
  int _pageNo = 1;
  int _total = 0;
  bool _loading = true;
  bool _loadingMore = false;
  bool _isRefreshing = false;
  bool _searching = false;
  String _keyword = '';
  Object? _error;
  _MallListLayout _wideLayout = _MallListLayout.grid;

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
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_loading || _loadingMore || !_hasMore) return;
    final position = _scrollController.position;
    if (!position.hasContentDimensions || position.maxScrollExtent <= 0) return;
    if (position.maxScrollExtent - position.pixels > 260) return;
    _loadMore();
  }

  Future<void> _refresh({bool showIndicator = false}) async {
    setState(() {
      _loading = true;
      _isRefreshing = showIndicator;
      _error = null;
      _pageNo = 1;
    });
    try {
      final results = await Future.wait([
        ref
            .read(goodsRepoProvider)
            .getMallProductsPage(
              1,
              pageSize: _pageSize,
              keyword: _keyword.isEmpty ? null : _keyword,
            ),
        if (showIndicator)
          Future<void>.delayed(const Duration(milliseconds: 650)),
      ]);
      if (!mounted) return;
      final page = results.first as MallProductPageData;
      setState(() {
        _items
          ..clear()
          ..addAll(page.list);
        _total = page.total;
        _loading = false;
        _isRefreshing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
        _isRefreshing = false;
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    try {
      final next = _pageNo + 1;
      final page = await ref
          .read(goodsRepoProvider)
          .getMallProductsPage(
            next,
            pageSize: _pageSize,
            keyword: _keyword.isEmpty ? null : _keyword,
          );
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

  void _onSearchQuery(String query) {
    setState(() {
      _searching = query.isNotEmpty;
      _keyword = query;
    });
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    _refresh();
  }

  bool _useHorizontalCards(double width) {
    return !_isWideMallLayout(width) ||
        _wideLayout == _MallListLayout.horizontalCards;
  }

  Widget _layoutToggleButton(BuildContext context) {
    final useCards = _wideLayout == _MallListLayout.horizontalCards;
    return Tooltip(
      message: useCards ? '切换为网格' : '切换为列表',
      child: Material(
        color: AppActionColors.surface(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: GoodsPageStyle.border(context)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _wideLayout = useCards
                  ? _MallListLayout.grid
                  : _MallListLayout.horizontalCards;
            });
          },
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              useCards ? Icons.grid_view_rounded : Icons.view_list_rounded,
              color: AppActionColors.strong(context),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _horizontalCardSlivers({
    required BuildContext context,
    required void Function(MallProduct item) onItemTap,
  }) {
    final cols = horizontalDealGridCrossAxisCount(context);
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: kHorizontalDealCardAspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = _items[index];
              return MallProductHorizontalCard(
                item: item,
                onTap: () => onItemTap(item),
              );
            },
            childCount: _items.length,
          ),
        ),
      ),
      if (_loadingMore) _loadingMoreSliver(),
    ];
  }

  void _onMallTabReselect() {
    _searchController.clear();
    setState(() {
      _searching = false;
      _keyword = '';
    });
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
    _refresh(showIndicator: true);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(goodsMallListRefreshSignalProvider, (previous, next) {
      if (!context.mounted) return;
      if (previous == null || next <= previous) return;
      _onMallTabReselect();
    });

    final topInset = widget.reserveHomeTabTopInset
        ? InPageSearchBar.homeTabTopInset(context)
        : 8.0;
    final refreshBadgeTop = widget.reserveHomeTabTopInset ? kToolbarHeight : 8.0;

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ColoredBox(
        color: GoodsPageStyle.pageBg(context),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _pageMaxWidth),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final pageW = constraints.maxWidth;
                final isWide = _isWideMallLayout(pageW);
                final useHorizontalCards = _useHorizontalCards(pageW);

                return Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: _refresh,
                      color: Colors.white,
                      backgroundColor: const Color(0xFFFF8C00),
                      displacement: 54,
                      strokeWidth: 3,
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: InPageSearchBar(
                              controller: _searchController,
                              height: topInset,
                              hintText: '搜索商品名称',
                              onQueryChanged: _onSearchQuery,
                              trailing:
                                  isWide ? _layoutToggleButton(context) : null,
                            ),
                          ),
                          const SliverToBoxAdapter(child: _MallHeader()),
                          ..._buildBodySlivers(
                            context,
                            useHorizontalCards: useHorizontalCards,
                          ),
                          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
                        ],
                      ),
                    ),
                    Positioned(
                      top: refreshBadgeTop,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: _isRefreshing
                              ? const RefreshStatusBadge()
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBodySlivers(
    BuildContext context, {
    required bool useHorizontalCards,
  }) {
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
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _MallEmpty(searching: _searching),
        ),
      ];
    }

    void onItemTap(MallProduct item) {
      final id = item.id;
      if (id != null) {
        context.pushGoodsDetail('$id');
      }
    }

    if (useHorizontalCards) {
      return _horizontalCardSlivers(context: context, onItemTap: onItemTap);
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
                  onTap: () => onItemTap(item),
                );
              },
            );
          },
        ),
      ),
      if (_loadingMore) _loadingMoreSliver(),
    ];
  }

  Widget _loadingMoreSliver() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
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
        color: GoodsPageStyle.cardBg(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GoodsPageStyle.border(context)),
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
              color: GoodsPageStyle.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: GoodsPageStyle.accent,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '精选好物',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: GoodsPageStyle.text(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '精选商城商品，看看今天有哪些新东西',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: GoodsPageStyle.sub(context),
                  ),
                ),
              ],
            ),
          ),
          const CouponClaimEntry(),
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
      color: GoodsPageStyle.cardBg(context),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: GoodsPageStyle.border(context)),
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
                      style: TextStyle(
                        color: GoodsPageStyle.text(context),
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
                            color: GoodsPageStyle.accent,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          item.priceYuan.toStringAsFixed(2),
                          style: const TextStyle(
                            color: GoodsPageStyle.accent,
                            fontSize: 22,
                            height: 1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: GoodsPageStyle.accent.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const CouponClaimEntry(
                            style: CouponClaimStyle.chip,
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
                        style: TextStyle(
                          color: GoodsPageStyle.sub(context),
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
                          color: GoodsPageStyle.sub(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.salesCount ?? 0} 已售',
                          style: TextStyle(
                            color: GoodsPageStyle.sub(context),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: GoodsPageStyle.sub(context),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '库存 ${item.stock ?? 0}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: GoodsPageStyle.sub(context),
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
      color: GoodsPageStyle.imageBg(context),
      child: Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          color: GoodsPageStyle.sub(context),
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
  const _MallEmpty({this.searching = false});

  final bool searching;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        searching ? '未找到相关商品' : '暂无在售商品',
        style: TextStyle(color: AppActionColors.muted(context)),
      ),
    );
  }
}

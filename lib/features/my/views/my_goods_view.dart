import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../goods/data/models/mall_product_model.dart';
import '../../goods/data/repos/goods_repo.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/media_url.dart';

/// 「店铺」Tab：我发布的商城商品，支持上架/下架。
class MyGoodsView extends ConsumerStatefulWidget {
  final int tabIndex;
  final int currentIndex;
  final int? userId;

  const MyGoodsView({
    super.key,
    required this.tabIndex,
    required this.currentIndex,
    this.userId,
  });

  @override
  ConsumerState<MyGoodsView> createState() => _MyGoodsViewState();
}

class _MyGoodsViewState extends ConsumerState<MyGoodsView>
    with AutomaticKeepAliveClientMixin {
  static const int _pageSize = 12;
  static const String _placeholderCover =
      'https://file.qqai.cn/qqai/2025/09/1.webp';

  List<MallProduct> _items = [];
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  Object? _error;
  final Set<int> _statusUpdatingIds = {};

  @override
  void initState() {
    super.initState();
    if (widget.tabIndex == widget.currentIndex) {
      scheduleMicrotask(_loadFirstPage);
    }
  }

  @override
  void didUpdateWidget(MyGoodsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _items = [];
      _page = 1;
      _hasMore = true;
      _error = null;
      if (widget.tabIndex == widget.currentIndex) {
        unawaited(_loadFirstPage());
      }
      return;
    }
    if (widget.tabIndex == widget.currentIndex &&
        oldWidget.currentIndex != widget.currentIndex &&
        _items.isEmpty &&
        !_loading) {
      unawaited(_loadFirstPage());
    }
  }

  bool get _isSelf => widget.userId == null;

  bool _onScrollNotification(ScrollNotification notification) {
    if (!_hasMore || _loadingMore || _loading) return false;
    final metrics = notification.metrics;
    if (metrics.maxScrollExtent > 0 &&
        metrics.pixels >= metrics.maxScrollExtent - 400) {
      unawaited(_loadMore());
    }
    return false;
  }

  Future<void> _loadFirstPage() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(goodsRepoProvider);
      final userId = widget.userId;
      final data = userId != null
          ? await repo.getUserProductsPage(userId, 1, pageSize: _pageSize)
          : await repo.getMyProductsPage(1, pageSize: _pageSize);
      if (!mounted) return;
      setState(() {
        _items = List.from(data.list);
        _page = 1;
        _hasMore = data.list.length >= _pageSize;
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
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final repo = ref.read(goodsRepoProvider);
      final next = _page + 1;
      final userId = widget.userId;
      final data = userId != null
          ? await repo.getUserProductsPage(userId, next, pageSize: _pageSize)
          : await repo.getMyProductsPage(next, pageSize: _pageSize);
      final add = data.list;
      if (!mounted) return;
      setState(() {
        _items = [..._items, ...add];
        _page = next;
        _hasMore = add.length >= _pageSize;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  Future<void> _toggleShelfStatus(MallProduct product) async {
    final id = product.id;
    if (id == null || _statusUpdatingIds.contains(id)) return;
    final onShelf = product.status == 1;
    final nextStatus = onShelf ? 0 : 1;
    final actionLabel = onShelf ? '下架' : '上架';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$actionLabel商品'),
        content: Text('确定${actionLabel}「${product.name ?? ''}」吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(actionLabel)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _statusUpdatingIds.add(id));
    try {
      await ref.read(goodsRepoProvider).updateMyProductStatus(id, nextStatus);
      if (!mounted) return;
      setState(() {
        _statusUpdatingIds.remove(id);
        final index = _items.indexWhere((item) => item.id == id);
        if (index >= 0) {
          final old = _items[index];
          _items[index] = MallProduct(
            id: old.id,
            name: old.name,
            introduction: old.introduction,
            description: old.description,
            categoryId: old.categoryId,
            serviceMemberUserId: old.serviceMemberUserId,
            picUrl: old.picUrl,
            sliderPicUrls: old.sliderPicUrls,
            specType: old.specType,
            price: old.price,
            marketPrice: old.marketPrice,
            stock: old.stock,
            salesCount: old.salesCount,
            status: nextStatus,
            deliveryTypes: old.deliveryTypes,
            skus: old.skus,
          );
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已$actionLabel')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _statusUpdatingIds.remove(id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$actionLabel失败: $e')),
      );
    }
  }

  void _openProduct(MallProduct product) {
    final id = product.id;
    if (id == null) return;
    if (!_isSelf && product.status != 1) return;
    context.push('${Routes.goodsDetailPageUrl}/$id');
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.tabIndex != widget.currentIndex) {
      return const SizedBox.shrink();
    }
    final isWideScreen = 1.sw > 800;

    Widget body;
    if (_loading && _items.isEmpty) {
      body = CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    } else if (_error != null && _items.isEmpty) {
      body = CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('加载失败: $_error', style: context.typo.body),
                  TextButton(onPressed: _loadFirstPage, child: const Text('重试')),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (_items.isEmpty) {
      body = CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                _isSelf ? '暂无发布的商品' : '暂无商品',
                style: context.typo.body,
              ),
            ),
          ),
        ],
      );
    } else {
      body = NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: RefreshIndicator(
          onRefresh: _loadFirstPage,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWideScreen ? 4 : 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 2 / 3,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = _items[index];
                    final cover = resolveMediaUrl(product.coverUrl) ??
                        _placeholderCover;
                    final yuan = product.priceYuan;
                    final onShelf = product.status == 1;
                    final updating = product.id != null &&
                        _statusUpdatingIds.contains(product.id);
                    return Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => _openProduct(product),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: cover,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) => Image.network(
                                      _placeholderCover,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (!onShelf)
                                    Container(
                                      color: Colors.black26,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '已下架',
                                        style: context.typo.bodyStrong.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.w, top: 6, right: 8),
                              child: Text(
                                product.name ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: context.typo.cardTitle.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.w, top: 4, bottom: 6, right: 8),
                              child: Row(
                                children: [
                                  Text(
                                    '¥${yuan.toStringAsFixed(yuan == yuan.roundToDouble() ? 0 : 2)}',
                                    style: context.typo.bodyStrong.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (_isSelf)
                                    TextButton(
                                      onPressed: updating
                                          ? null
                                          : () => _toggleShelfStatus(product),
                                      style: TextButton.styleFrom(
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: updating
                                          ? SizedBox(
                                              width: 14,
                                              height: 14,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            )
                                          : Text(
                                              onShelf ? '下架' : '上架',
                                              style: context.typo.caption.copyWith(
                                                color: onShelf
                                                    ? Colors.orange
                                                    : Colors.green,
                                              ),
                                            ),
                                    )
                                  else
                                    Text(
                                      onShelf ? '在售' : '下架',
                                      style: context.typo.caption.copyWith(
                                        color: onShelf ? Colors.green : Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _items.length,
                ),
              ),
              if (_loadingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return body;
  }
}

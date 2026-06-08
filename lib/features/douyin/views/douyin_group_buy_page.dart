import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/util/api_error_message.dart';
import 'package:qqai/util/media_url.dart';

import '../../../components/horizontal_deal_layout.dart';
import '../../../router/app_routes.dart';
import '../../my/data/models/profile_models.dart';
import '../../my/data/repos/profile_repo.dart';
import '../theme/douyin_theme.dart';

/// 团购带货：展示本人在博客作品中挂载的带货商品。
class DouyinGroupBuyPage extends ConsumerStatefulWidget {
  const DouyinGroupBuyPage({super.key});

  @override
  ConsumerState<DouyinGroupBuyPage> createState() => _DouyinGroupBuyPageState();
}

class _DouyinGroupBuyPageState extends ConsumerState<DouyinGroupBuyPage> {
  static const _pageSize = 12;
  static const _placeholderCover =
      'https://file.qqai.cn/qqai/2025/09/1.webp';

  final List<BlogShopProductResp> _items = [];
  final ScrollController _scrollController = ScrollController();

  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  int _total = 0;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    scheduleMicrotask(_loadFirstPage);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _loadingMore || _loading) return;
    if (!_scrollController.hasClients) return;
    final metrics = _scrollController.position;
    if (metrics.pixels >= metrics.maxScrollExtent - 240) {
      unawaited(_loadMore());
    }
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ref
          .read(profileRepoProvider)
          .getMyBlogMountedProductsPage(1, pageSize: _pageSize);
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(data.list ?? const []);
        _page = 1;
        _total = data.total ?? _items.length;
        _hasMore = _items.length < _total;
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
    if (_loadingMore || !_hasMore || _loading) return;
    setState(() => _loadingMore = true);
    try {
      final next = _page + 1;
      final data = await ref
          .read(profileRepoProvider)
          .getMyBlogMountedProductsPage(next, pageSize: _pageSize);
      final add = data.list ?? const <BlogShopProductResp>[];
      if (!mounted) return;
      setState(() {
        _items.addAll(add);
        _page = next;
        _total = data.total ?? _items.length;
        _hasMore = add.length >= _pageSize && _items.length < _total;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  String _formatPrice(int? cents) {
    if (cents == null) return '';
    final yuan = cents / 100;
    if (cents % 100 == 0) return '¥${yuan.toStringAsFixed(0)}';
    return '¥${yuan.toStringAsFixed(2)}';
  }

  String _productTag(BlogShopProductResp product) {
    return product.status == 1 ? '带货' : '已下架';
  }

  void _openProduct(BlogShopProductResp product) {
    final id = product.id;
    if (id == null) return;
    context.push('${Routes.goodsDetailPageUrl}/$id');
  }

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
      body: _buildBody(cardStyle),
    );
  }

  Widget _buildBody(HorizontalDealCardStyle cardStyle) {
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                ApiErrorMessage.userMessage(_error!),
                textAlign: TextAlign.center,
                style: TextStyle(color: DouyinTheme.sub(context)),
              ),
            ),
            TextButton(onPressed: _loadFirstPage, child: const Text('重试')),
          ],
        ),
      );
    }
    if (_items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '暂无带货商品\n发布作品时可挂载商品，挂载后会显示在这里',
            textAlign: TextAlign.center,
            style: TextStyle(color: DouyinTheme.sub(context), height: 1.5),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFirstPage,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          ...buildHorizontalDealRecommendationSlivers(
            context: context,
            sectionTitle: '我的带货商品',
            sectionTitleColor: DouyinTheme.text(context),
            banner: const DealPromoBanner(
              title: '博客挂载 边看边买',
              subtitle: '以下为你发布作品时挂载的带货商品',
            ),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final product = _items[index];
              final coverUrl =
                  resolveMediaUrl(product.coverUrl) ?? _placeholderCover;
              return HorizontalDealCard(
                tag: _productTag(product),
                title: product.name ?? '商品',
                priceText: _formatPrice(product.price),
                style: cardStyle,
                onTap: () => _openProduct(product),
                image: CachedNetworkImage(
                  imageUrl: coverUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Image.network(
                    _placeholderCover,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          if (_loadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            ),
        ],
      ),
    );
  }
}

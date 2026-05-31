import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/components/qq_tab_bar.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/data/repos/blog_repo.dart';
import 'package:qqai/features/goods/data/models/trade_models.dart';
import 'package:qqai/features/goods/data/repos/goods_repo.dart';
import 'package:qqai/features/index/providers/home_index_tab_navigate_provider.dart';
import 'package:qqai/features/my/utils/footprint_timeline.dart';
import 'package:qqai/features/my/widgets/timeline_grid_list.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/format_count.dart';
import 'package:qqai/util/media_url.dart';

/// 我的收藏：博客 + 商品，按足迹页时间线网格展示。
class MyCollectPage extends ConsumerStatefulWidget {
  const MyCollectPage({super.key});

  @override
  ConsumerState<MyCollectPage> createState() => _MyCollectPageState();
}

class _MyCollectPageState extends ConsumerState<MyCollectPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);
  final _blogTabKey = GlobalKey<_BlogFavoriteTabState>();
  final _productTabKey = GlobalKey<_ProductFavoriteTabState>();

  @override
  void initState() {
    super.initState();
    _tab.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _blogTabKey.currentState?.reload();
      _productTabKey.currentState?.reload();
    });
  }

  void _onTabChanged() {
    if (_tab.indexIsChanging || !mounted) return;
    if (_tab.index == 0) {
      _blogTabKey.currentState?.reload();
    } else {
      _productTabKey.currentState?.reload();
    }
  }

  @override
  void dispose() {
    _tab.removeListener(_onTabChanged);
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
        bottom: QqTabBarBottom(
          controller: _tab,
          items: const [
            QqTabItem(label: '博客'),
            QqTabItem(label: '商品'),
          ],
        ),
      ),
      backgroundColor: Colors.black12,
      body: TabBarView(
        controller: _tab,
        children: [
          _BlogFavoriteTab(key: _blogTabKey),
          _ProductFavoriteTab(key: _productTabKey),
        ],
      ),
    );
  }
}

class _BlogFavoriteTab extends ConsumerStatefulWidget {
  const _BlogFavoriteTab({super.key});

  @override
  ConsumerState<_BlogFavoriteTab> createState() => _BlogFavoriteTabState();
}

class _BlogFavoriteTabState extends ConsumerState<_BlogFavoriteTab>
    with AutomaticKeepAliveClientMixin {
  final _items = <BlogItem>[];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = false;
  int _page = 1;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> reload() => _load(refresh: true);

  Future<void> _load({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _loading = true;
        _error = null;
        _page = 1;
      });
    }
    try {
      final page = await ref.read(blogRepoProvider).getMyFavoritesPage(
            1,
            pageSize: 20,
          );
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(page.list ?? const []);
        _page = 1;
        _hasMore = (page.list?.length ?? 0) >= 20;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final next = _page + 1;
      final page = await ref.read(blogRepoProvider).getMyFavoritesPage(
            next,
            pageSize: 20,
          );
      if (!mounted) return;
      setState(() {
        _items.addAll(page.list ?? const []);
        _page = next;
        _hasMore = (page.list?.length ?? 0) >= 20;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  Future<void> _unfavorite(BlogItem item) async {
    final blogId = item.id;
    if (blogId == null) return;
    try {
      await ref.read(blogRepoProvider).unfavoriteBlog(blogId);
      if (!mounted) return;
      setState(() => _items.removeWhere((e) => e.id == blogId));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('取消收藏失败：$e')),
      );
    }
  }

  void _openDetail(BlogItem item) {
    if (item.blogType == 1) {
      context.push(Routes.blogImgDetailView, extra: item);
    } else {
      context.push(Routes.blogVideoDetailView, extra: item);
    }
  }

  String _displayTitle(BlogItem item) {
    final title = item.title?.trim();
    if (title != null && title.isNotEmpty) return title;
    final content = item.content?.trim();
    if (content != null && content.isNotEmpty) return content;
    return item.creatorName ?? '博客';
  }

  String? _coverUrl(BlogItem item) {
    final cover = resolveBlogCoverUrlFromFields(
      coverUrl: item.coverUrl,
      resources: item.resources,
    );
    return resolveMediaUrl(cover);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildTimelineGridListBody(
      context: context,
      loading: _loading,
      error: _error,
      isEmpty: _items.isEmpty,
      emptyHint: '收藏博客后会显示在这里',
      emptyActionLabel: '去逛逛',
      onEmptyAction: () => context.go(Routes.HOME),
      onRetry: () => _load(refresh: true),
      child: RefreshIndicator(
        onRefresh: () => _load(refresh: true),
        child: TimelineGridScrollView(
          sections: groupFootprintByTimeline(
            items: _items,
            readTime: (item) => parseContentCreateTime(item.createTime),
          ),
          hasMore: _hasMore,
          loadingMore: _loadingMore,
          onLoadMore: _loadMore,
          itemBuilder: (item) {
            final name = item.creatorName ?? '用户';
            return TimelineBlogGridCard(
              coverUrl: _coverUrl(item),
              blogType: item.blogType,
              title: _displayTitle(item),
              subtitle: '@$name · ${formatCompactCount(item.zan)}赞',
              onTap: () => _openDetail(item),
              onDelete: () => _unfavorite(item),
            );
          },
        ),
      ),
    );
  }
}

class _ProductFavoriteTab extends ConsumerStatefulWidget {
  const _ProductFavoriteTab({super.key});

  @override
  ConsumerState<_ProductFavoriteTab> createState() =>
      _ProductFavoriteTabState();
}

class _ProductFavoriteTabState extends ConsumerState<_ProductFavoriteTab>
    with AutomaticKeepAliveClientMixin {
  final _items = <BrowseHistoryItem>[];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = false;
  int _page = 1;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> reload() => _load(refresh: true);

  Future<void> _load({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _loading = true;
        _error = null;
        _page = 1;
      });
    }
    try {
      final page = await ref.read(goodsRepoProvider).getProductFavoritePage(1);
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(page.list);
        _page = 1;
        _hasMore = page.list.length >= 20;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final next = _page + 1;
      final page =
          await ref.read(goodsRepoProvider).getProductFavoritePage(next);
      if (!mounted) return;
      setState(() {
        _items.addAll(page.list);
        _page = next;
        _hasMore = page.list.length >= 20;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  Future<void> _unfavorite(BrowseHistoryItem item) async {
    final spuId = item.spuId;
    if (spuId == null) return;
    try {
      await ref.read(goodsRepoProvider).unfavoriteProduct(spuId);
      if (!mounted) return;
      setState(() => _items.removeWhere((e) => e.spuId == spuId));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('取消收藏失败：$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildTimelineGridListBody(
      context: context,
      loading: _loading,
      error: _error,
      isEmpty: _items.isEmpty,
      emptyHint: '收藏商品后会显示在这里',
      emptyActionLabel: '去逛逛',
      onEmptyAction: () => openHomeMallTab(context, ref),
      onRetry: () => _load(refresh: true),
      child: RefreshIndicator(
        onRefresh: () => _load(refresh: true),
        child: TimelineGridScrollView(
          sections: groupFootprintByTimeline(
            items: _items,
            readTime: (item) => item.createTime,
          ),
          hasMore: _hasMore,
          loadingMore: _loadingMore,
          onLoadMore: _loadMore,
          itemBuilder: (item) => TimelineProductGridCard(
            picUrl: resolveMediaUrl(item.picUrl),
            name: item.spuName ?? '商品',
            priceYuan: item.priceYuan,
            onTap: () {
              final spuId = item.spuId;
              if (spuId != null) {
                context.push('${Routes.goodsDetailPageUrl}/$spuId');
              }
            },
            onDelete: () => _unfavorite(item),
          ),
        ),
      ),
    );
  }
}

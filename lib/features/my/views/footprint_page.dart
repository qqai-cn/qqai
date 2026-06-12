import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/qq_tab_bar.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/data/repos/blog_repo.dart';
import 'package:qqai/features/index/providers/home_index_tab_navigate_provider.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/format_count.dart';
import 'package:qqai/util/media_url.dart';

import '../../goods/data/models/trade_models.dart';
import '../../goods/data/repos/trade_repo.dart';
import '../utils/footprint_timeline.dart';

/// 个人中心「足迹」：博客 + 商品浏览记录
class FootprintPage extends ConsumerStatefulWidget {
  const FootprintPage({super.key});

  @override
  ConsumerState<FootprintPage> createState() => _FootprintPageState();
}

class _FootprintPageState extends ConsumerState<FootprintPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);
  final _blogTabKey = GlobalKey<_BlogFootprintTabState>();
  final _productTabKey = GlobalKey<_ProductFootprintTabState>();

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

  Future<void> _cleanCurrentTab() async {
    final isBlog = _tab.index == 0;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isBlog ? '清空博客足迹' : '清空商品足迹'),
        content: Text(isBlog ? '确定清空全部博客浏览记录？' : '确定清空全部商品浏览记录？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('清空'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      if (isBlog) {
        await ref.read(blogRepoProvider).cleanBlogBrowseHistory();
      } else {
        await ref.read(tradeRepoProvider).cleanBrowseHistory();
      }
      if (!mounted) return;
      if (_tab.index == 0) {
        _blogTabKey.currentState?.reload();
      } else {
        _productTabKey.currentState?.reload();
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已清空足迹')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('清空失败：$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('足迹'),
        bottom: QqTabBarBottom(
          controller: _tab,
          items: const [
            QqTabItem(label: '博客'),
            QqTabItem(label: '商品'),
          ],
        ),
        actions: [
          TextButton(onPressed: _cleanCurrentTab, child: const Text('清空')),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: TabBarView(
        controller: _tab,
        children: [
          _BlogFootprintTab(key: _blogTabKey),
          _ProductFootprintTab(key: _productTabKey),
        ],
      ),
    );
  }
}

class _BlogFootprintTab extends ConsumerStatefulWidget {
  const _BlogFootprintTab({super.key});

  @override
  ConsumerState<_BlogFootprintTab> createState() => _BlogFootprintTabState();
}

class _BlogFootprintTabState extends ConsumerState<_BlogFootprintTab>
    with AutomaticKeepAliveClientMixin {
  final _items = <BlogBrowseHistoryItem>[];
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
      final page = await ref.read(blogRepoProvider).getBlogBrowseHistoryPage(1);
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
      final page = await ref
          .read(blogRepoProvider)
          .getBlogBrowseHistoryPage(next);
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

  Future<void> _deleteItem(BlogBrowseHistoryItem item) async {
    final blogId = item.blogId;
    if (blogId == null) return;
    try {
      await ref.read(blogRepoProvider).deleteBlogBrowseHistoryIds([blogId]);
      if (!mounted) return;
      setState(() => _items.removeWhere((e) => e.blogId == blogId));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除失败：$e')));
    }
  }

  void _openDetail(BlogBrowseHistoryItem item) {
    final blogId = item.blogId;
    if (blogId == null) return;
    final blogItem = BlogItem(
      id: blogId,
      blogType: item.blogType,
      title: item.title,
      content: item.content,
      coverUrl: item.coverUrl,
      creatorName: item.creatorName,
      zan: item.zan,
    );
    if (item.blogType == 1) {
      context.push(Routes.blogImgDetailView, extra: blogItem);
    } else {
      context.push(Routes.blogVideoDetailView, extra: blogItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildListBody(
      context: context,
      loading: _loading,
      error: _error,
      isEmpty: _items.isEmpty,
      emptyHint: '浏览博客后会自动记录在这里',
      emptyActionLabel: '去逛逛',
      onEmptyAction: () => context.go(Routes.HOME),
      onRetry: () => _load(refresh: true),
      child: RefreshIndicator(
        onRefresh: () => _load(refresh: true),
        child: _FootprintTimelineScrollView(
          sections: groupFootprintByTimeline(
            items: _items,
            readTime: (item) => item.createTime,
          ),
          hasMore: _hasMore,
          loadingMore: _loadingMore,
          onLoadMore: _loadMore,
          itemBuilder: (item) => _BlogFootprintCard(
            item: item,
            onTap: () => _openDetail(item),
            onDelete: () => _deleteItem(item),
          ),
        ),
      ),
    );
  }
}

class _ProductFootprintTab extends ConsumerStatefulWidget {
  const _ProductFootprintTab({super.key});

  @override
  ConsumerState<_ProductFootprintTab> createState() =>
      _ProductFootprintTabState();
}

class _ProductFootprintTabState extends ConsumerState<_ProductFootprintTab>
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
      final page = await ref.read(tradeRepoProvider).getBrowseHistoryPage(1);
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
      final page = await ref.read(tradeRepoProvider).getBrowseHistoryPage(next);
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

  Future<void> _deleteItem(BrowseHistoryItem item) async {
    final spuId = item.spuId;
    if (spuId == null) return;
    try {
      await ref.read(tradeRepoProvider).deleteBrowseHistorySpuIds([spuId]);
      if (!mounted) return;
      setState(() => _items.removeWhere((e) => e.spuId == spuId));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除失败：$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildListBody(
      context: context,
      loading: _loading,
      error: _error,
      isEmpty: _items.isEmpty,
      emptyHint: '浏览商品后会自动记录在这里',
      emptyActionLabel: '去逛逛',
      onEmptyAction: () => openHomeMallTab(context, ref),
      onRetry: () => _load(refresh: true),
      child: RefreshIndicator(
        onRefresh: () => _load(refresh: true),
        child: _FootprintTimelineScrollView(
          sections: groupFootprintByTimeline(
            items: _items,
            readTime: (item) => item.createTime,
          ),
          hasMore: _hasMore,
          loadingMore: _loadingMore,
          onLoadMore: _loadMore,
          itemBuilder: (item) => _ProductFootprintCard(
            item: item,
            onTap: () {
              final spuId = item.spuId;
              if (spuId != null) {
                context.push('${Routes.goodsDetailPageUrl}/$spuId');
              }
            },
            onDelete: () => _deleteItem(item),
          ),
        ),
      ),
    );
  }
}

Widget _buildListBody({
  required BuildContext context,
  required bool loading,
  required String? error,
  required bool isEmpty,
  required String emptyHint,
  required String emptyActionLabel,
  required VoidCallback onEmptyAction,
  required VoidCallback onRetry,
  required Widget child,
}) {
  if (loading) {
    return const Center(child: CircularProgressIndicator());
  }
  if (error != null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('重试')),
        ],
      ),
    );
  }
  if (isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 56, color: AppActionColors.subtle(context)),
          const SizedBox(height: 12),
          Text('暂无浏览记录', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(emptyHint, style: TextStyle(color: AppActionColors.muted(context))),
          const SizedBox(height: 20),
          FilledButton(onPressed: onEmptyAction, child: Text(emptyActionLabel)),
        ],
      ),
    );
  }
  return child;
}

class _FootprintTimelineScrollView<T> extends StatefulWidget {
  const _FootprintTimelineScrollView({
    required this.sections,
    required this.itemBuilder,
    required this.hasMore,
    required this.loadingMore,
    required this.onLoadMore,
  });

  final List<FootprintTimelineSection<T>> sections;
  final Widget Function(T item) itemBuilder;
  final bool hasMore;
  final bool loadingMore;
  final VoidCallback onLoadMore;

  @override
  State<_FootprintTimelineScrollView<T>> createState() =>
      _FootprintTimelineScrollViewState<T>();
}

class _FootprintTimelineScrollViewState<T>
    extends State<_FootprintTimelineScrollView<T>> {
  @override
  Widget build(BuildContext context) {
    if (widget.sections.isEmpty && !widget.hasMore) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [SizedBox(height: 1)],
      );
    }

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        for (final section in widget.sections) ...[
          SliverToBoxAdapter(
            child: ContentTimelineSectionFrame(
              title: section.title,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: section.items.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) =>
                    widget.itemBuilder(section.items[index]),
              ),
            ),
          ),
        ],
        if (widget.hasMore)
          SliverToBoxAdapter(
            child: ContentTimelineLoadMoreFooter(
              loading: widget.loadingMore,
              onLoadMore: widget.onLoadMore,
            ),
          ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
      ],
    );
  }
}

class _BlogFootprintCard extends StatelessWidget {
  const _BlogFootprintCard({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final BlogBrowseHistoryItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final coverRaw = resolveBlogCoverUrlFromFields(coverUrl: item.coverUrl);
    final cover = resolveMediaUrl(coverRaw) ?? '';
    final name = item.creatorName ?? '用户';
    return Material(
      color: AppActionColors.surface(context),
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onDelete,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: cover.isEmpty
                  ? ColoredBox(
                      color: AppActionColors.borderSubtle(context),
                      child: Icon(
                        item.blogType == 2
                            ? Icons.play_circle_outline
                            : Icons.image_outlined,
                        color: AppActionColors.muted(context),
                        size: 40,
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: cover,
                      cacheKey: mediaCacheKey(cover),
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.displayTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.caption.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@$name · ${formatCompactCount(item.zan)}赞',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.caption.copyWith(
                      color: AppActionColors.subtle(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductFootprintCard extends StatelessWidget {
  const _ProductFootprintCard({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final BrowseHistoryItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cover = resolveMediaUrl(item.picUrl) ?? '';
    return Material(
      color: AppActionColors.surface(context),
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onDelete,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: cover.isEmpty
                  ? ColoredBox(
                      color: AppActionColors.borderSubtle(context),
                      child: Icon(
                        Icons.image_outlined,
                        color: AppActionColors.muted(context),
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: cover,
                      cacheKey: mediaCacheKey(cover),
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.spuName ?? '商品',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.caption.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '¥${item.priceYuan.toStringAsFixed(2)}',
                    style: context.typo.bodyStrong.copyWith(
                      color: const Color(0xFFE1251B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

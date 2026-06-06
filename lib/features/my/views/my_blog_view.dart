import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../blog/data/models/blog_page_model.dart';
import '../../blog/data/home_blog_tab.dart';
import '../../blog/providers/blog_providers.dart';
import '../data/repos/profile_repo.dart';
import '../utils/footprint_timeline.dart';
import 'my_blog_img_item_view.dart';
import 'my_blog_video_item_view.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/api_error_message.dart';

/// 「日常」Tab：我的/他人作品分页，仅 [blogType] = 1（图文），按时间线分组展示。
class MyBlogView extends ConsumerStatefulWidget {
  final int tabIndex;
  final int currentIndex;
  final int? userId;

  const MyBlogView({
    super.key,
    required this.tabIndex,
    required this.currentIndex,
    this.userId,
  });

  @override
  ConsumerState<MyBlogView> createState() => _MyBlogViewState();
}

class _MyBlogViewState extends ConsumerState<MyBlogView>
    with AutomaticKeepAliveClientMixin {
  static const int _pageSize = 10;
  static const int _blogTypeImage = 1;
  static const int _kCategory = 8;
  static const double _minColumnWidth = 400;

  List<BlogItem> _items = [];
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  Object? _error;

  @override
  void initState() {
    super.initState();
    if (widget.tabIndex == widget.currentIndex) {
      scheduleMicrotask(_loadFirstPage);
    }
  }

  @override
  void didUpdateWidget(MyBlogView oldWidget) {
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

  Future<BlogPageModelData> _fetchPage(int pageNo) {
    final repo = ref.read(profileRepoProvider);
    final userId = widget.userId;
    if (userId != null) {
      return repo.getUserWorksPage(
        userId,
        pageNo,
        pageSize: _pageSize,
        blogType: _blogTypeImage,
      );
    }
    return repo.getMyWorksPage(
      pageNo,
      pageSize: _pageSize,
      blogType: _blogTypeImage,
    );
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (!_hasMore || _loadingMore || _loading) return false;
    final metrics = notification.metrics;
    if (metrics.maxScrollExtent > 0 &&
        metrics.pixels >= metrics.maxScrollExtent - 480) {
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
      final data = await _fetchPage(1);
      if (!mounted) return;
      setState(() {
        _items = List.from(data.list ?? []);
        _page = 1;
        _hasMore = (data.list?.length ?? 0) >= _pageSize;
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
      final next = _page + 1;
      final data = await _fetchPage(next);
      final add = data.list ?? [];
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

  Widget _buildDailyCard({required Widget child}) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      color: const Color(0xFFFFFFFF),
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _buildBlogTile(BlogItem blogItem, double itemHeight) {
    return RepaintBoundary(
      child: blogItem.blogType == 1
          ? _buildDailyCard(
              child: MyBlogImgItemView(
                _kCategory,
                blogItem,
                heroScope: 'profile-${widget.userId ?? 'self'}',
              ),
            )
          : _buildDailyCard(
              child: SizedBox(
                height: itemHeight,
                child: MyBlogVideoItemView(_kCategory, blogItem),
              ),
            ),
    );
  }

  List<Widget> _buildTimelineSlivers(BuildContext context) {
    final isWide = 1.sw > 800;
    final blogNotifier = ref.read(blogProvider(HomeBlogTab.recommend).notifier);
    final itemHeight = blogNotifier.getVideoItemHeightWithWidth(
      isWide ? 2 : 1,
      1.sw,
    );
    final sections = groupFootprintByTimeline(
      items: _items,
      readTime: (item) => parseContentCreateTime(item.createTime),
    );

    final slivers = <Widget>[
      SliverOverlapInjector(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      ),
    ];

    for (final section in sections) {
      slivers.add(
        SliverToBoxAdapter(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final contentWidth = (constraints.maxWidth - 114).clamp(
                0,
                double.infinity,
              );
              if (contentWidth <= 0) return const SizedBox.shrink();
              final columns = (contentWidth / _minColumnWidth).floor().clamp(
                1,
                2,
              );
              return ContentTimelineSectionFrame(
                title: section.title,
                child: MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  crossAxisCount: columns,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: section.items.length,
                  itemBuilder: (context, index) =>
                      _buildBlogTile(section.items[index], itemHeight),
                ),
              );
            },
          ),
        ),
      );
    }

    if (_loadingMore) {
      slivers.add(
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ),
      );
    }

    slivers.add(const SliverPadding(padding: EdgeInsets.only(bottom: 24)));
    return slivers;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.tabIndex != widget.currentIndex) {
      return const SizedBox.shrink();
    }

    if (_loading && _items.isEmpty) {
      return CustomScrollView(
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
    }

    if (_error != null && _items.isEmpty) {
      return CustomScrollView(
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
                  Text(ApiErrorMessage.userMessage(_error!), style: context.typo.body),
                  TextButton(
                    onPressed: _loadFirstPage,
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (_items.isEmpty) {
      return CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('暂无图文动态', style: context.typo.body)),
          ),
        ],
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: RefreshIndicator(
        onRefresh: _loadFirstPage,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: _buildTimelineSlivers(context),
        ),
      ),
    );
  }
}

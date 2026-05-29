import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/responsive_masonry_grid.dart';
import '../../blog/data/models/blog_page_model.dart';
import '../../blog/data/home_blog_tab.dart';
import '../../blog/providers/blog_providers.dart';
import '../data/repos/profile_repo.dart';
import 'my_blog_img_item_view.dart';
import 'my_blog_video_item_view.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 「日常」Tab：我的作品分页，仅 [blogType] = 1（图文）。
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

  final ScrollController _scrollController = ScrollController();

  List<BlogItem> _items = [];
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.tabIndex == widget.currentIndex) {
      scheduleMicrotask(_loadFirstPage);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
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

  void _onScroll() {
    if (!_hasMore || _loadingMore || _loading) return;
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 480) {
      unawaited(_loadMore());
    }
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

  @override
  bool get wantKeepAlive => true;

  static const int _kCategory = 8;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.tabIndex != widget.currentIndex) {
      return const SizedBox.shrink();
    }

    const double kPinnedHeaderHeight = kToolbarHeight;
    final blogNotifier =
        ref.read(blogProvider(HomeBlogTab.recommend).notifier);

    if (_loading && _items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: kPinnedHeaderHeight),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null && _items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: kPinnedHeaderHeight),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '加载失败: $_error',
                style: context.typo.body,
              ),
              TextButton(onPressed: _loadFirstPage, child: const Text('重试')),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: kPinnedHeaderHeight),
        child: Center(
          child: Text('暂无图文动态', style: context.typo.body),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: kPinnedHeaderHeight),
      child: RefreshIndicator(
        onRefresh: _loadFirstPage,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ResponsiveMasonryGrid(
              controller: _scrollController,
              itemCount: _items.length,
              minColumnWidth: 400,
              itemBuilder: (context, index) {
                final blogItem = _items[index];
                final isWide = 1.sw > 800;
                final itemHeight = blogNotifier.getVideoItemHeightWithWidth(
                  isWide ? 2 : 1,
                  1.sw,
                );
                return RepaintBoundary(
                  child: blogItem.blogType == 1
                      ? Card(child: MyBlogImgItemView(_kCategory, blogItem))
                      : Card(
                          child: SizedBox(
                            height: itemHeight,
                            child: MyBlogVideoItemView(_kCategory, blogItem),
                          ),
                        ),
                );
              },
            ),
            if (_loadingMore)
              const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

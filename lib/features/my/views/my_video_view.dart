import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:qqai/config/theme/app_typography.dart';

import '../../blog/data/models/blog_page_model.dart';
import '../../blog/data/home_blog_tab.dart';
import '../../blog/providers/blog_providers.dart';
import '../data/repos/profile_repo.dart';

/// 「作品」与「喜欢」共用网格，由 [kind] 区分接口。
enum MyProfileWorkGridKind {
  works,
  likes,
}

String? _firstMediaUrl(BlogItem item) {
  final raw = item.resources?.trim();
  if (raw == null || raw.isEmpty) return null;
  final parts = raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
  if (parts.isEmpty) return null;
  return parts.first;
}

class MyVideoView extends ConsumerStatefulWidget {
  final int tabIndex;
  final int currentIndex;
  final MyProfileWorkGridKind kind;

  const MyVideoView({
    super.key,
    required this.tabIndex,
    required this.currentIndex,
    this.kind = MyProfileWorkGridKind.works,
  });

  @override
  ConsumerState<MyVideoView> createState() => _MyVideoViewState();
}

class _MyVideoViewState extends ConsumerState<MyVideoView>
    with AutomaticKeepAliveClientMixin {
  static const int _pageSize = 12;
  static const String _placeholderCover =
      'https://file.qqai.cn/qqai/2025/09/1.webp';

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
  void didUpdateWidget(MyVideoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabIndex == widget.currentIndex &&
        oldWidget.currentIndex != widget.currentIndex &&
        _items.isEmpty &&
        !_loading) {
      unawaited(_loadFirstPage());
    }
  }

  void _onScroll() {
    if (!_hasMore || _loadingMore || _loading) return;
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 320) {
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
      final repo = ref.read(profileRepoProvider);
      final BlogPageModelData data;
      if (widget.kind == MyProfileWorkGridKind.likes) {
        data = await repo.getMyLikesPage(1, pageSize: _pageSize);
      } else {
        data = await repo.getMyWorksPage(1, pageSize: _pageSize);
      }
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
      final repo = ref.read(profileRepoProvider);
      final next = _page + 1;
      final BlogPageModelData data;
      if (widget.kind == MyProfileWorkGridKind.likes) {
        data = await repo.getMyLikesPage(next, pageSize: _pageSize);
      } else {
        data = await repo.getMyWorksPage(next, pageSize: _pageSize);
      }
      final add = data.list ?? [];
      if (!mounted) return;
      setState(() {
        _items = [..._items, ...add];
        _page = next;
        _hasMore = add.length >= _pageSize;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
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
    final blogNotifier =
        ref.read(blogProvider(HomeBlogTab.recommend).notifier);

    if (_loading && _items.isEmpty) {
      return CustomScrollView(
        controller: _scrollController,
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
        controller: _scrollController,
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '加载失败: $_error',
                      textAlign: TextAlign.center,
                      style: context.typo.body,
                    ),
                  ),
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
        controller: _scrollController,
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                widget.kind == MyProfileWorkGridKind.likes
                    ? '暂无喜欢的作品'
                    : '暂无作品',
                style: context.typo.body,
              ),
            ),
          ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFirstPage,
      child: CustomScrollView(
        controller: _scrollController,
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
                final item = _items[index];
                final cover = _firstMediaUrl(item) ?? _placeholderCover;
                final isVideo = item.blogType == 2;
                return GestureDetector(
                  onTap: () => blogNotifier.onBlogItemTap(context, item),
                  child: Container(
                    color: Colors.black12,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: cover,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Image.network(
                              _placeholderCover,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (isVideo)
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Row(
                              spacing: 3,
                              children: [
                                const Icon(
                                  Icons.play_circle_outline_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                Text(
                                  '${item.zan ?? 0}',
                                  style: context.typo.label
                                      .copyWith(color: Colors.white),
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
    );
  }
}

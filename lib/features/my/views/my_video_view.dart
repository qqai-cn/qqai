import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/default_asset_image.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/api_error_message.dart';
import 'package:qqai/constant/constant.dart';

import '../../../../components/blog/network_image_carousel_pages.dart';
import '../../blog/data/models/blog_page_model.dart';
import '../../blog/data/home_blog_tab.dart';
import '../../blog/providers/blog_providers.dart';
import '../data/repos/profile_repo.dart';

/// 「作品」与「喜欢」共用网格，由 [kind] 区分接口。
enum MyProfileWorkGridKind { works, likes }

class MyVideoView extends ConsumerStatefulWidget {
  final int tabIndex;
  final int currentIndex;
  final MyProfileWorkGridKind kind;
  final int? userId;
  final int refreshNonce;

  const MyVideoView({
    super.key,
    required this.tabIndex,
    required this.currentIndex,
    this.kind = MyProfileWorkGridKind.works,
    this.userId,
    this.refreshNonce = 0,
  });

  @override
  ConsumerState<MyVideoView> createState() => _MyVideoViewState();
}

class _MyVideoViewState extends ConsumerState<MyVideoView>
    with AutomaticKeepAliveClientMixin {
  static const int _pageSize = 12;
  static const double _gridItemAspectRatio = 2 / 3;
  static const String _placeholderCover = Constant.DEFAULT_IMAGE_PLACEHOLDER;

  List<BlogItem> _items = [];
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  int _handledRefreshNonce = 0;
  Object? _error;

  @override
  void initState() {
    super.initState();
    if (widget.tabIndex == widget.currentIndex) {
      _handledRefreshNonce = widget.refreshNonce;
      scheduleMicrotask(_loadFirstPage);
    }
  }

  @override
  void didUpdateWidget(MyVideoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _items = [];
      _page = 1;
      _hasMore = true;
      _error = null;
      _handledRefreshNonce = widget.refreshNonce;
      if (widget.tabIndex == widget.currentIndex) {
        unawaited(_loadFirstPage());
      }
      return;
    }
    if (oldWidget.refreshNonce != widget.refreshNonce &&
        widget.tabIndex == widget.currentIndex) {
      _handledRefreshNonce = widget.refreshNonce;
      unawaited(_loadFirstPage());
      return;
    }
    if (widget.tabIndex == widget.currentIndex &&
        oldWidget.currentIndex != widget.currentIndex) {
      if (_handledRefreshNonce != widget.refreshNonce) {
        _handledRefreshNonce = widget.refreshNonce;
        unawaited(_loadFirstPage());
      } else if (_items.isEmpty && !_loading) {
        unawaited(_loadFirstPage());
      }
    }
  }

  bool get _isOtherUserLikes =>
      widget.userId != null && widget.kind == MyProfileWorkGridKind.likes;

  Future<BlogPageModelData> _fetchPage(int pageNo) {
    final repo = ref.read(profileRepoProvider);
    final userId = widget.userId;
    if (userId != null) {
      if (widget.kind == MyProfileWorkGridKind.likes) {
        return Future.value(BlogPageModelData(list: []));
      }
      return repo.getUserWorksPage(userId, pageNo, pageSize: _pageSize);
    }
    if (widget.kind == MyProfileWorkGridKind.likes) {
      return repo.getMyLikesPage(pageNo, pageSize: _pageSize);
    }
    return repo.getMyWorksPage(pageNo, pageSize: _pageSize);
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (!_hasMore || _loadingMore || _loading) return false;
    final metrics = notification.metrics;
    if (metrics.maxScrollExtent > 0 &&
        metrics.pixels >= metrics.maxScrollExtent - 320) {
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
    final blogNotifier = ref.read(blogProvider(HomeBlogTab.recommend).notifier);

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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      ApiErrorMessage.userMessage(_error!),
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
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                _isOtherUserLikes
                    ? '喜欢的作品仅本人可见'
                    : widget.kind == MyProfileWorkGridKind.likes
                    ? '暂无喜欢的作品'
                    : '暂无作品',
                style: context.typo.body,
              ),
            ),
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
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWideScreen ? 4 : 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: _gridItemAspectRatio,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = _items[index];
                final cover = resolveBlogCoverUrl(
                  item,
                  fallback: _placeholderCover,
                );
                final isLocalCover = cover == _placeholderCover;
                final isVideo = item.blogType == 2;
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final height = constraints.maxHeight;
                    final dpr = MediaQuery.devicePixelRatioOf(context);
                    final cacheWidth = (width * dpr).round().clamp(120, 900);
                    final cacheHeight = (height * dpr).round().clamp(80, 600);
                    return GestureDetector(
                      onTap: () => blogNotifier.onBlogItemTap(context, item),
                      child: SizedBox(
                        width: width,
                        height: height,
                        child: Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.hardEdge,
                          children: [
                            Positioned.fill(
                              child: isLocalCover
                                  ? AssetImageView(
                                      cover,
                                      fit: BoxFit.cover,
                                      width: width,
                                      height: height,
                                    )
                                  : Image(
                                      image: CachedNetworkImageProvider(
                                        cover,
                                        maxWidth: cacheWidth,
                                        maxHeight: cacheHeight,
                                      ),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                      filterQuality: FilterQuality.medium,
                                      gaplessPlayback: true,
                                      errorBuilder: (_, _, _) => AssetImageView(
                                        _placeholderCover,
                                        fit: BoxFit.cover,
                                        width: width,
                                        height: height,
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
                                      style: context.typo.label.copyWith(
                                        color: Colors.white,
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
                );
              }, childCount: _items.length),
            ),
            if (_loadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

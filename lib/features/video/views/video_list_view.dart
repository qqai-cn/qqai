import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/constant/constant.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/video/views/video_item_view.dart';

import '../providers/video_film_providers.dart';

const String _defaultVideoCover = Constant.DEFAULT_IMAGE_PLACEHOLDER;

const Color _filmListBg = Color(0xFF0E0E14);
const Color _filmListOnBg = Color(0xFFB8B8C4);

class VideoListView extends ConsumerStatefulWidget {
  const VideoListView({super.key});

  @override
  ConsumerState<VideoListView> createState() => _VideoListViewState();
}

class _VideoListViewState extends ConsumerState<VideoListView> {
  final ScrollController _scrollController = ScrollController();
  bool _loadMoreGuard = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  List<BlogItem> _gridItems(List<BlogItem> raw) {
    return raw
        .where((e) => firstPlayableVideoUrlFromResources(e.resources) != null)
        .toList();
  }

  void _onScroll() {
    _maybeLoadMore(fromScroll: true);
  }

  void _maybeLoadMore({bool fromScroll = false}) {
    final filmState = ref.read(videoFilmProvider);
    if (!filmState.hasMore || filmState.isLoadingMore || _loadMoreGuard) {
      return;
    }
    if (!_scrollController.hasClients) return;

    final metrics = _scrollController.position;
    if (!metrics.hasContentDimensions) return;

    final nearBottom =
        metrics.maxScrollExtent <= 0 ||
        metrics.pixels >= metrics.maxScrollExtent - 240;
    if (!nearBottom) return;

    _loadMoreGuard = true;
    unawaited(
      ref.read(videoFilmProvider.notifier).loadMore().whenComplete(() {
        _loadMoreGuard = false;
        if (!mounted) return;
        if (!fromScroll) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _maybeLoadMore();
          });
        }
      }),
    );
  }

  void _schedulePrefetchIfShort() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _maybeLoadMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filmState = ref.watch(videoFilmProvider);
    final filmNotifier = ref.read(videoFilmProvider.notifier);
    final isWideScreen = 1.sw > 800;
    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight;

    ref.listen(videoFilmProvider.select((s) => s.allItems.length), (
      previous,
      next,
    ) {
      if (previous != next) {
        _schedulePrefetchIfShort();
      }
    });

    return filmState.blogPageData.when(
      loading: () => const ColoredBox(
        color: _filmListBg,
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6B6B78),
            strokeWidth: 2,
          ),
        ),
      ),
      error: (e, _) => ColoredBox(
        color: _filmListBg,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: _filmListOnBg),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => filmNotifier.load(),
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (_) {
        final items = _gridItems(filmState.allItems);
        if (items.isEmpty && !filmState.isLoadingMore) {
          return ColoredBox(
            color: _filmListBg,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('暂无影视内容', style: TextStyle(color: _filmListOnBg)),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => filmNotifier.refresh(),
                    child: const Text('刷新'),
                  ),
                ],
              ),
            ),
          );
        }
        return ColoredBox(
          color: _filmListBg,
          child: RefreshIndicator(
            color: const Color(0xFF6B6B78),
            backgroundColor: const Color(0xFF1C1C28),
            onRefresh: () => filmNotifier.refresh(),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(10, topInset + 10, 10, 16),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final cross = isWideScreen ? 3 : 2;
                      const spacing = 8.0;
                      final maxW = constraints.crossAxisExtent;
                      final cellW = (maxW - spacing * (cross - 1)) / cross;
                      final aspect = filmGridChildAspectRatio(
                        cellW,
                        isWideScreen: isWideScreen,
                      );
                      return SliverGrid(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: cross,
                              mainAxisSpacing: spacing,
                              crossAxisSpacing: spacing,
                              childAspectRatio: aspect,
                            ),
                        delegate: SliverChildBuilderDelegate((
                          context,
                          index,
                        ) {
                          final blog = items[index];
                          return VideoItemView(
                            key: ValueKey('film_${blog.id ?? index}'),
                            item: blog,
                            defaultCover: _defaultVideoCover,
                            isWideScreen: isWideScreen,
                          );
                        }, childCount: items.length),
                      );
                    },
                  ),
                ),
                if (filmState.isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF6B6B78),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

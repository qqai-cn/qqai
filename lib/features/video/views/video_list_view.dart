import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/video/views/video_item_view.dart';

import '../providers/video_film_providers.dart';

const String _defaultVideoCover =
    'https://file.qqai.cn/qqai/2025/09/1.webp';

const Color _filmListBg = Color(0xFF0E0E14);
const Color _filmListOnBg = Color(0xFFB8B8C4);

class VideoListView extends ConsumerStatefulWidget {
  const VideoListView({super.key});

  @override
  ConsumerState<VideoListView> createState() => _VideoListViewState();
}

class _VideoListViewState extends ConsumerState<VideoListView> {
  List<BlogItem> _gridItems(List<BlogItem> raw) {
    return raw
        .where(
          (e) => firstPlayableVideoUrlFromResources(e.resources) != null,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filmState = ref.watch(videoFilmProvider);
    final filmNotifier = ref.read(videoFilmProvider.notifier);
    final isWideScreen = 1.sw > 800;

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
                  const Text(
                    '暂无影视内容',
                    style: TextStyle(color: _filmListOnBg),
                  ),
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
            child: NotificationListener<ScrollNotification>(
              onNotification: (n) {
                final m = n.metrics;
                if (m.maxScrollExtent > 0 &&
                    m.pixels >= m.maxScrollExtent - 240) {
                  filmNotifier.loadMore();
                }
                return false;
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
                    sliver: SliverLayoutBuilder(
                      builder: (context, constraints) {
                        final cross = isWideScreen ? 3 : 2;
                        const spacing = 8.0;
                        final maxW = constraints.crossAxisExtent;
                        final cellW =
                            (maxW - spacing * (cross - 1)) / cross;
                        final aspect = filmGridChildAspectRatio(cellW);
                        return SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: cross,
                            mainAxisSpacing: spacing,
                            crossAxisSpacing: spacing,
                            childAspectRatio: aspect,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final blog = items[index];
                              return VideoItemView(
                                key: ValueKey(
                                  'film_${blog.id ?? index}',
                                ),
                                item: blog,
                                defaultCover: _defaultVideoCover,
                              );
                            },
                            childCount: items.length,
                          ),
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
          ),
        );
      },
    );
  }
}

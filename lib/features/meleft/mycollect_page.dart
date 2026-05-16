import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/providers/my_favorites_providers.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/format_count.dart';
import 'package:qqai/util/media_url.dart';

import 'package:qqai/components/blog/network_image_carousel_pages.dart';

/// 我的收藏（`/app-api/blog/qqai/my/favorites/page`）。
class MyCollectPage extends ConsumerWidget {
  const MyCollectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myFavoritesProvider);
    final notifier = ref.read(myFavoritesProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('我的收藏')),
      backgroundColor: Colors.black12,
      body: state.pageData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$e', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: notifier.load, child: const Text('重试')),
            ],
          ),
        ),
        data: (_) {
          if (state.allItems.isEmpty) {
            return const Center(child: Text('暂无收藏'));
          }
          return RefreshIndicator(
            onRefresh: notifier.refresh,
            child: GridView.builder(
              padding: const EdgeInsets.all(5),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: state.allItems.length +
                  (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.allItems.length) {
                  if (!state.isLoadingMore) {
                    notifier.loadMore();
                  }
                  return const Center(child: CircularProgressIndicator());
                }
                return _FavoriteCard(item: state.allItems[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final BlogItem item;

  const _FavoriteCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cover = _coverUrl(item);
    final title = item.content?.trim() ?? '';
    final name = item.creatorName ?? '用户';

    return Material(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _openDetail(context, item),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: cover != null
                      ? CachedNetworkImage(
                          imageUrl: cover,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Container(
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_outlined),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title.isEmpty ? name : title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.typo.sectionTitle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                '@$name · ${formatCompactCount(item.zan)}赞',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typo.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _coverUrl(BlogItem item) {
    final first = firstStillImageUrlFromResources(item.resources) ??
        firstPlayableVideoUrlFromResources(item.resources);
    return resolveMediaUrl(first);
  }

  void _openDetail(BuildContext context, BlogItem item) {
    if (item.blogType == 1) {
      context.push(Routes.blogImgDetailView, extra: item);
    } else {
      context.push(Routes.blogVideoDetailView, extra: item);
    }
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/media_url.dart';

import '../utils/footprint_timeline.dart';

Widget buildTimelineGridListBody({
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
          Icon(Icons.star_border, size: 56, color: AppActionColors.muted(context)),
          const SizedBox(height: 12),
          Text('暂无收藏', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            emptyHint,
            style: TextStyle(color: AppActionColors.subtle(context)),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: onEmptyAction, child: Text(emptyActionLabel)),
        ],
      ),
    );
  }
  return child;
}

class TimelineGridScrollView<T> extends StatefulWidget {
  const TimelineGridScrollView({
    super.key,
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
  State<TimelineGridScrollView<T>> createState() =>
      _TimelineGridScrollViewState<T>();
}

class _TimelineGridScrollViewState<T> extends State<TimelineGridScrollView<T>> {
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
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
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
        const SliverPadding(padding: EdgeInsets.only(bottom: 12)),
      ],
    );
  }
}

class TimelineBlogGridCard extends StatelessWidget {
  const TimelineBlogGridCard({
    super.key,
    required this.coverUrl,
    required this.blogType,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.onDelete,
  });

  final String? coverUrl;
  final int? blogType;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final cover = coverUrl ?? '';
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
                        blogType == 2
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
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.caption.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
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

class TimelineProductGridCard extends StatelessWidget {
  const TimelineProductGridCard({
    super.key,
    required this.picUrl,
    required this.name,
    required this.priceYuan,
    required this.onTap,
    this.onDelete,
  });

  final String? picUrl;
  final String name;
  final double priceYuan;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final cover = picUrl ?? '';
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
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.caption.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '¥${priceYuan.toStringAsFixed(2)}',
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/components/responsive_masonry_grid.dart';
import 'package:qqai/config/theme/app_typography.dart';

class BlogFeedGrid<T> extends StatelessWidget {
  final AsyncValue<List<T>> asyncItems;
  final double minColumnWidth;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final VoidCallback onRetry;

  const BlogFeedGrid({
    super.key,
    required this.asyncItems,
    required this.itemBuilder,
    required this.onRetry,
    this.minColumnWidth = 400,
  });

  @override
  Widget build(BuildContext context) {
    return asyncItems.when(
      data: (items) => ResponsiveMasonryGrid(
        itemCount: items.length,
        minColumnWidth: minColumnWidth,
        itemBuilder: (context, index) {
          return itemBuilder(context, index, items[index]);
        },
      ),
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '加载失败: $err',
              style: context.typo.body.copyWith(color: Colors.white),
            ),
            ElevatedButton(onPressed: onRetry, child: const Text('重试')),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

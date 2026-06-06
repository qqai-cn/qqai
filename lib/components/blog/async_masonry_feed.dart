import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/components/responsive_masonry_grid.dart';
import 'package:qqai/components/refresh_status_badge.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/api_error_message.dart';

/// 异步列表 + 瀑布流 + 加载/错误占位 + 下拉刷新 + 上拉加载更多。
class AsyncMasonryFeed<T> extends StatefulWidget {
  final AsyncValue<List<T>> asyncItems;
  final List<T>? items;
  final double minColumnWidth;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final VoidCallback onRetry;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final bool isLoadingMore;
  final bool isRefreshing;
  final bool hasMore;

  const AsyncMasonryFeed({
    super.key,
    required this.asyncItems,
    this.items,
    required this.itemBuilder,
    required this.onRetry,
    this.minColumnWidth = 400,
    this.onRefresh,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.hasMore = true,
  });

  @override
  State<AsyncMasonryFeed<T>> createState() => _AsyncMasonryFeedState<T>();
}

class _AsyncMasonryFeedState<T> extends State<AsyncMasonryFeed<T>> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMoreLocally = false;
  bool _hideExternalRefreshStatus = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(AsyncMasonryFeed<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoadingMore && !widget.isLoadingMore) {
      _isLoadingMoreLocally = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMoreLocally &&
        !widget.isLoadingMore &&
        widget.hasMore &&
        widget.onLoadMore != null) {
      _isLoadingMoreLocally = true;
      await widget.onLoadMore!();
    }
  }

  Future<void> _handleRefresh() async {
    final onRefresh = widget.onRefresh;
    if (onRefresh == null || _hideExternalRefreshStatus) {
      return;
    }

    setState(() {
      _hideExternalRefreshStatus = true;
    });

    try {
      await onRefresh();
    } finally {
      if (mounted) {
        setState(() {
          _hideExternalRefreshStatus = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.asyncItems.when(
      data: (dataItems) {
        final displayItems = widget.items ?? dataItems;
        final List<Widget> footerWidgets = [];
        if (widget.isLoadingMore) {
          footerWidgets.add(
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (!widget.hasMore && displayItems.isNotEmpty) {
          footerWidgets.add(
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('没有更多了', style: TextStyle(color: Colors.white54)),
              ),
            ),
          );
        }
        final child = ResponsiveMasonryGrid(
          itemCount: displayItems.length,
          minColumnWidth: widget.minColumnWidth,
          controller: _scrollController,
          footerWidgets: footerWidgets,
          itemBuilder: (context, index) {
            return widget.itemBuilder(context, index, displayItems[index]);
          },
        );
        if (widget.onRefresh != null) {
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: _handleRefresh,
                color: Colors.white,
                backgroundColor: const Color(0xFFFF8C00),
                displacement: 54,
                strokeWidth: 3,
                child: child,
              ),
              Positioned(
                top: kToolbarHeight,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: widget.isRefreshing && !_hideExternalRefreshStatus
                        ? const RefreshStatusBadge()
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          );
        }
        return child;
      },
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ApiErrorMessage.userMessage(err),
              style: context.typo.body.copyWith(color: Colors.white),
            ),
            ElevatedButton(onPressed: widget.onRetry, child: const Text('重试')),
          ],
        ),
      ),
      loading: () => ResponsiveMasonryGrid(
        itemCount: 4,
        minColumnWidth: widget.minColumnWidth,
        controller: _scrollController,
        itemBuilder: (context, index) => const _FeedSkeletonCard(),
      ),
    );
  }
}

class _FeedSkeletonCard extends StatelessWidget {
  const _FeedSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _SkeletonBox(width: 38, height: 38, radius: 19),
                SizedBox(width: 10),
                Expanded(child: _SkeletonBox(height: 14)),
              ],
            ),
            SizedBox(height: 12),
            _SkeletonBox(height: 14),
            SizedBox(height: 8),
            _SkeletonBox(width: 180, height: 14),
            SizedBox(height: 12),
            AspectRatio(aspectRatio: 4 / 3, child: _SkeletonBox()),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({this.width, this.height, this.radius = 8});

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFE2E5EA),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: SizedBox(width: width, height: height),
    );
  }
}

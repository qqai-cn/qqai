import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/square_providers.dart';
import 'create_square_dialog.dart';
import 'square_item_view.dart';

class SquareView extends ConsumerStatefulWidget {
  const SquareView({super.key});

  @override
  ConsumerState<SquareView> createState() => _SquareViewState();
}

class _SquareViewState extends ConsumerState<SquareView> {
  static const _maxCross = 360.0;
  static const _crossGap = 14.0;
  static const _pageMaxWidth = 1180.0;

  final ScrollController _scrollController = ScrollController();
  bool _loadingMoreGuard = false;

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

  void _onScroll() {
    final squareState = ref.read(squareProvider);
    if (!squareState.hasMore ||
        squareState.isLoadingMore ||
        _loadingMoreGuard) {
      return;
    }
    final position = _scrollController.position;
    if (!position.hasContentDimensions || position.maxScrollExtent <= 0) {
      return;
    }
    if (position.maxScrollExtent - position.pixels > 200) return;
    _loadingMoreGuard = true;
    ref.read(squareProvider.notifier).loadMore();
  }

  Widget _createSquareRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 380;
        final title = Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                color: Color(0xFF3578E5),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '发现广场',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF202124),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '加入感兴趣的广场，浏览和发布作品',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
          ],
        );
        final createButton = FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF3578E5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            minimumSize: narrow ? const Size.fromHeight(42) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => showCreateSquareDialog(context, ref),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('创建'),
        );

        return Container(
          margin: const EdgeInsets.fromLTRB(14, 12, 14, 16),
          padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFECEEF2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: narrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [title, const SizedBox(height: 14), createButton],
                )
              : Row(
                  children: [
                    Expanded(child: title),
                    const SizedBox(width: 12),
                    createButton,
                  ],
                ),
        );
      },
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFECEEF2)),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.grid_view_rounded, color: Color(0xFF9CA3AF), size: 38),
              SizedBox(height: 12),
              Text(
                '暂无广场',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _topContentInset(BuildContext context) {
    return MediaQuery.paddingOf(context).top + kToolbarHeight;
  }

  /// 单格宽度（与 [SliverGridDelegateWithMaxCrossAxisExtent] 列数算法一致）
  double _tileWidth(double gridW) {
    final crossAxisCount = math.max(
      1,
      (gridW / (_maxCross + _crossGap)).ceil(),
    );
    return (gridW - _crossGap * (crossAxisCount - 1)) / crossAxisCount;
  }

  /// 卡片内图片:文字 = 2:1，据此反推网格 cell 宽高比
  SliverGridDelegate _gridDelegate(double gridW) {
    final tileW = _tileWidth(gridW);
    // 文字区最小高度；总高度 = 3 × 文字区（占 1/3）
    final textMinH = tileW < 260 ? 68.0 : 76.0;
    final tileH = math.max(textMinH * 3, tileW * 0.88);
    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: _maxCross,
      mainAxisSpacing: _crossGap,
      crossAxisSpacing: _crossGap,
      childAspectRatio: tileW / tileH,
    );
  }

  List<Widget> _bodySlivers({
    required double gridW,
    required SquareListState squareState,
    required SquareNotifier notifier,
  }) {
    return squareState.pageData.when(
      loading: () => const [
        SliverFillRemaining(
          hasScrollBody: true,
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
      error: (e, _) => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _SquareError(
            message: e.toString(),
            onRetry: () => notifier.load(),
          ),
        ),
      ],
      data: (_) {
        final items = squareState.allItems;
        if (items.isEmpty) {
          return [
            SliverFillRemaining(hasScrollBody: false, child: _emptyState()),
          ];
        }
        return [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            sliver: SliverGrid(
              gridDelegate: _gridDelegate(gridW),
              delegate: SliverChildBuilderDelegate(
                (context, index) => SizedBox.expand(
                  child: SquareItemView(square: items[index]),
                ),
                childCount: items.length,
              ),
            ),
          ),
          if (squareState.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final squareState = ref.watch(squareProvider);
    final notifier = ref.read(squareProvider.notifier);

    ref.listen(squareProvider, (prev, next) {
      if (prev?.isLoadingMore == true && !next.isLoadingMore) {
        _loadingMoreGuard = false;
      }
    });

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ColoredBox(
        color: const Color(0xFFF6F7F9),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _pageMaxWidth),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final gridW = math.max(1.0, constraints.maxWidth - 28);
                return RefreshIndicator(
                  onRefresh: notifier.refresh,
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(height: _topContentInset(context)),
                      ),
                      SliverToBoxAdapter(child: _createSquareRow()),
                      ..._bodySlivers(
                        gridW: gridW,
                        squareState: squareState,
                        notifier: notifier,
                      ),
                      const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SquareError extends StatelessWidget {
  const _SquareError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('重试')),
          ],
        ),
      ),
    );
  }
}

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
  static const _maxCross = 500.0;
  static const _crossGap = 2.0;

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: () => showCreateSquareDialog(context, ref),
          icon: const Icon(Icons.add_circle_outline, size: 20),
          label: const Text('创建广场'),
        ),
      ),
    );
  }

  /// 单格宽度（与 [SliverGridDelegateWithMaxCrossAxisExtent] 列数算法一致）
  double _tileWidth(double gridW) {
    final crossAxisCount =
        math.max(1, (gridW / (_maxCross + _crossGap)).ceil());
    return (gridW - _crossGap * (crossAxisCount - 1)) / crossAxisCount;
  }

  /// 卡片内图片:文字 = 2:1，据此反推网格 cell 宽高比
  SliverGridDelegate _gridDelegate(double gridW) {
    final tileW = _tileWidth(gridW);
    // 文字区最小高度；总高度 = 3 × 文字区（占 1/3）
    final textMinH = tileW < 260 ? 68.0 : 76.0;
    final tileH = textMinH * 3;
    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: _maxCross,
      mainAxisSpacing: 2,
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
          return const [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('暂无广场')),
            ),
          ];
        }
        return [
          SliverGrid(
            gridDelegate: _gridDelegate(gridW),
            delegate: SliverChildBuilderDelegate(
              (context, index) => SizedBox.expand(
                child: SquareItemView(square: items[index]),
              ),
              childCount: items.length,
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final gridW = constraints.maxWidth;
          return RefreshIndicator(
            onRefresh: notifier.refresh,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(height: 50, color: Colors.green[50]),
                ),
                SliverToBoxAdapter(child: _createSquareRow()),
                ..._bodySlivers(
                  gridW: gridW,
                  squareState: squareState,
                  notifier: notifier,
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
              ],
            ),
          );
        },
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

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

  SliverGridDelegate _gridDelegate(double gridW) {
    final crossAxisCount = math.max(1, (gridW / (_maxCross + _crossGap)).ceil());
    final double childAspectRatio;
    if (crossAxisCount == 1) {
      childAspectRatio = (gridW / 300).clamp(1.52, 3.15);
    } else if (gridW < 400) {
      childAspectRatio = 0.68;
    } else if (gridW < 560) {
      childAspectRatio = 0.78;
    } else if (gridW < 800) {
      childAspectRatio = 0.92;
    } else {
      childAspectRatio = 1.5;
    }
    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: _maxCross,
      mainAxisSpacing: 2,
      crossAxisSpacing: _crossGap,
      childAspectRatio: childAspectRatio,
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
              (context, index) => SquareItemView(square: items[index]),
              childCount: items.length,
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

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final gridW = constraints.maxWidth;
          return RefreshIndicator(
            onRefresh: notifier.refresh,
            child: CustomScrollView(
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

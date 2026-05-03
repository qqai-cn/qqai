import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/features/square/views/square_item_view.dart';

import '../providers/square_providers.dart';

class SquareView extends ConsumerStatefulWidget {
  const SquareView({super.key});

  @override
  ConsumerState<SquareView> createState() => _SquareViewState();
}

class _SquareViewState extends ConsumerState<SquareView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final squareState = ref.watch(squareProvider);
    final itemCount = squareState.items.maybeWhen(
      data: (list) => list.isEmpty ? 10 : list.length,
      orElse: () => 10,
    );
    const maxCross = 500.0;
    const crossGap = 2.0;

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
        children: [
          Container(height: 50, color: Colors.green[50]),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final gridW = c.maxWidth;
                // 与 Flutter SliverGridDelegateWithMaxCrossAxisExtent 一致
                final crossAxisCount = math.max(
                  1,
                  (gridW / (maxCross + crossGap)).ceil(),
                );
                // childAspectRatio = cross / main；单列时 cross≈gridW，ratio 过小会导致整卡过高。
                final double childAspectRatio;
                if (crossAxisCount == 1) {
                  // 目标主向高度约 260–340dp，超宽屏再略压（提高 ratio 上限）
                  childAspectRatio =
                      (gridW / 300).clamp(1.52, 3.15);
                } else if (gridW < 400) {
                  childAspectRatio = 0.68;
                } else if (gridW < 560) {
                  childAspectRatio = 0.78;
                } else if (gridW < 800) {
                  childAspectRatio = 0.92;
                } else {
                  childAspectRatio = 1.5;
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: maxCross,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: crossGap,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    return SquareItemView();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

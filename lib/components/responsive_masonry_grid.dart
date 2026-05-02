import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// 响应式 Masonry 网格（^0.7.0 兼容版）
class ResponsiveMasonryGrid extends StatelessWidget {
  final double minColumnWidth; // 每列最小宽度
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final IndexedWidgetBuilder itemBuilder;
  final int? itemCount;
  final int maxColumn;
  final ScrollController? controller;
  final List<Widget>? footerWidgets;

  const ResponsiveMasonryGrid({
    super.key,
    required this.minColumnWidth,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.maxColumn = 2,
    required this.itemBuilder,
    this.itemCount,
    this.controller,
    this.footerWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        // 处理 Infinity 情况（当约束未确定时）
        double useWidth;
        if (availableWidth.isInfinite || availableWidth <= 0) {
          useWidth = MediaQuery.of(context).size.width;
        } else {
          useWidth = availableWidth;
        }
        // 至少 1 列，最多 maxColumn 列
        final columns = (useWidth / minColumnWidth).floor().clamp(1, maxColumn);
        final totalCount = (itemCount ?? 0) + (footerWidgets?.length ?? 0);
        return MasonryGridView.builder(
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
          ),
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          itemCount: totalCount,
          controller: controller,
          itemBuilder: (context, index) {
            if (index < (itemCount ?? 0)) {
              return itemBuilder(context, index);
            } else {
              final footerIndex = index - (itemCount ?? 0);
              return SizedBox(
                width: double.infinity,
                child: footerWidgets![footerIndex],
              );
            }
          },
          cacheExtent: 400,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
        );
      },
    );
  }
}

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

  const ResponsiveMasonryGrid({
    super.key,
    required this.minColumnWidth,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.maxColumn = 2,
    required this.itemBuilder,
    this.itemCount,
  });

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        // 处理 Infinity 情况（当约束未确定时）
        if (availableWidth.isInfinite || availableWidth <= 0) {
          // 使用默认值或从 MediaQuery 获取屏幕宽度
          final screenWidth = MediaQuery.of(context).size.width;
          final columns = (screenWidth / minColumnWidth).floor().clamp(1, maxColumn);
          return MasonryGridView.builder(
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
            ),
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            itemCount: itemCount,
            itemBuilder: itemBuilder,
            cacheExtent: 400,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: true,
          );
        }
        // 至少 1 列，最多 2 列
        final columns = (availableWidth / minColumnWidth).floor().clamp(1, maxColumn);
        return MasonryGridView.builder(
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
          ),
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          itemCount: itemCount,
          itemBuilder: itemBuilder,
          cacheExtent: 400,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
        );
      },
    );
  }
}

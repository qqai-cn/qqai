import 'dart:math' as math;

// 广场网格与卡片共用的布局常量，保证 SquareView 的 cell 宽高比与
// SquareItemView 内部结构一致。

/// 封面目标宽高比（宽 : 高），仅用于网格高度估算；卡片内封面用 Expanded 填充剩余空间。
const double kSquareCoverAspect = 3 / 2;

const double kSquareGridCrossGap = 14.0;
const double kSquareGridMaxCross = 340.0;
const double kSquarePageMaxWidth = 1180.0;

enum SquareTileDensity { compact, normal, comfortable }

SquareTileDensity squareTileDensity(double tileWidth) {
  if (tileWidth < 220) return SquareTileDensity.compact;
  if (tileWidth < 320) return SquareTileDensity.normal;
  return SquareTileDensity.comfortable;
}

double squareFooterHeight(SquareTileDensity density) {
  return switch (density) {
    SquareTileDensity.compact => 56,
    SquareTileDensity.normal => 66,
    SquareTileDensity.comfortable => 74,
  };
}

double squareFooterHeightForWidth(double tileWidth) {
  return squareFooterHeight(squareTileDensity(tileWidth));
}

/// 与 Flutter [SliverGridDelegateWithMaxCrossAxisExtent] 列数算法完全一致。
int squareCrossAxisCount(double gridWidth) {
  return math.max(
    1,
    ((gridWidth + kSquareGridCrossGap) /
            (kSquareGridMaxCross + kSquareGridCrossGap))
        .ceil(),
  );
}

double squareTileWidth(double gridWidth) {
  final count = squareCrossAxisCount(gridWidth);
  return (gridWidth - kSquareGridCrossGap * (count - 1)) / count;
}

/// 网格 cell 宽高比：估算封面(≈3:2) + 固定底栏。
double squareGridChildAspectRatio(double cellWidth) {
  final coverH = cellWidth / kSquareCoverAspect;
  final footerH = squareFooterHeightForWidth(cellWidth);
  return cellWidth / (coverH + footerH);
}

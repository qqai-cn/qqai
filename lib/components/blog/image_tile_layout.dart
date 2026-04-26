/// 多图宫格中单格边长（与历史 `getImgGridHeight` 算法一致）。
double tileExtentForWrapImageGrid(int itemCount, double parentWidth) {
  if (itemCount == 1) {
    return 300;
  }
  if (itemCount == 3 || itemCount == 5 || itemCount == 6) {
    return (parentWidth - 30) / 3;
  }
  return parentWidth / 3;
}

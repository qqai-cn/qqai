double getImgGridHeight(int itemCount, double parentWidth) {
  if (itemCount == 1) {
    return 300;
  } else if (itemCount == 3 || itemCount == 5 || itemCount == 6) {
    return (parentWidth - 30) / 3;
  } else {
    return parentWidth / 3;
  }
}

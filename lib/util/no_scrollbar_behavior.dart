import 'package:flutter/material.dart';

/// 全局隐藏滚动条，保留滚轮、触摸与拖拽滚动。
class NoScrollbarScrollBehavior extends MaterialScrollBehavior {
  const NoScrollbarScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

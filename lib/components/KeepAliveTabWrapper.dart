import 'package:flutter/material.dart';

/// 一个通用的 Wrapper，用于保持其子 Widget 在 PageView/TabBarView 中的状态。
class KeepAliveTabWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveTabWrapper({super.key, required this.child});

  @override
  State<KeepAliveTabWrapper> createState() => _KeepAliveTabWrapperState();
}

class _KeepAliveTabWrapperState extends State<KeepAliveTabWrapper>
    with AutomaticKeepAliveClientMixin { // 1. 混入 mixin

  @override
  bool get wantKeepAlive => true; // 2. 重写 getter 返回 true

  @override
  Widget build(BuildContext context) {
    super.build(context); // 3. 必须调用 super.build(context)
    return widget.child; // 4. 返回子 Widget
  }
}
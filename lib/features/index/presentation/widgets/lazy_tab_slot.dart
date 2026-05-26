import 'package:flutter/material.dart';

/// TabBarView 子页懒挂载：未访问过的 index 不 build [builder]。
class LazyTabSlot extends StatelessWidget {
  const LazyTabSlot({
    super.key,
    required this.isMounted,
    required this.builder,
    this.placeholder = const ColoredBox(
      color: Colors.black12,
      child: SizedBox.expand(),
    ),
  });

  final bool isMounted;
  final WidgetBuilder builder;
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    if (!isMounted) return placeholder;
    return builder(context);
  }
}

/// 配合 [TabController]：监听切换并维护已挂载 Tab 索引集合。
mixin LazyTabMountMixin<T extends StatefulWidget> on State<T> {
  final Set<int> _lazyTabMountedIndices = {0};

  Set<int> get lazyTabMountedIndices => _lazyTabMountedIndices;

  void lazyTabMount(int index) {
    if (!_lazyTabMountedIndices.contains(index)) {
      setState(() => _lazyTabMountedIndices.add(index));
    }
  }

  void onLazyTabChanged(TabController controller, {VoidCallback? onSettled}) {
    if (controller.indexIsChanging || !mounted) return;
    lazyTabMount(controller.index);
    onSettled?.call();
    setState(() {});
  }
}

import 'package:flutter/material.dart';

/// 由 [HomePage] 注入，供 [LazyShellTab] 同步读取当前主壳 Tab 索引。
class MainShellIndexScope extends InheritedWidget {
  const MainShellIndexScope({
    super.key,
    required this.currentIndex,
    required super.child,
  });

  final int currentIndex;

  static MainShellIndexScope of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<MainShellIndexScope>();
    assert(scope != null, 'MainShellIndexScope not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(MainShellIndexScope oldWidget) {
    return oldWidget.currentIndex != currentIndex;
  }
}

/// 底部主壳 Tab 懒挂载：未访问过的分支不 build 子树，降低首屏 widget 与网络请求。
/// 一旦访问过则保持挂载，切换 Tab 时状态不丢。
class LazyShellTab extends StatefulWidget {
  const LazyShellTab({
    super.key,
    required this.tabIndex,
    required this.child,
  });

  final int tabIndex;
  final Widget child;

  @override
  State<LazyShellTab> createState() => _LazyShellTabState();
}

class _LazyShellTabState extends State<LazyShellTab> {
  bool _everMounted = false;

  @override
  Widget build(BuildContext context) {
    final shellIndex = MainShellIndexScope.of(context).currentIndex;
    final routeIsCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    if (shellIndex == widget.tabIndex || routeIsCurrent) {
      _everMounted = true;
    }
    if (!_everMounted) {
      return const ColoredBox(
        color: Colors.black12,
        child: SizedBox.expand(),
      );
    }
    return widget.child;
  }
}

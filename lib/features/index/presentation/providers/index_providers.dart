import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'index_providers.freezed.dart';
part 'index_providers.g.dart';

// IndexController 状态 - 使用 Freezed
// 注意：ScrollController 不能直接使用 Freezed，使用 Map 存储
@freezed
sealed class IndexState with _$IndexState {
  const factory IndexState({
    @Default(true) bool hasSearch,
    @Default({}) Map<int, ScrollController> controllers,
  }) = _IndexState;
}

// IndexController Provider - 使用 Riverpod 3 代码生成
@riverpod
class IndexNotifier extends _$IndexNotifier {
  @override
  IndexState build() {
    _setupDispose();
    return const IndexState();
  }

  ScrollController getScrollController(int tabIndex) {
    if (!state.controllers.containsKey(tabIndex)) {
      final newController = ScrollController();
      state = state.copyWith(
        controllers: {...state.controllers, tabIndex: newController},
      );
    }
    return state.controllers[tabIndex]!;
  }

  void changeShowSearch(bool ifShow) {
    if (state.hasSearch != ifShow) {
      state = state.copyWith(hasSearch: ifShow);
    }
  }

  void scrollToTop(int tabIndex) {
    final controller = state.controllers[tabIndex];
    if (controller != null && controller.hasClients) {
      controller.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      print(
          "⚠️ Cannot scroll Tab $tabIndex to top: Controller not initialized or no ScrollView attached.");
    }
  }

  // 使用 ref.onDispose 替代 dispose
  void _setupDispose() {
    ref.onDispose(() {
      state.controllers.values.forEach((controller) => controller.dispose());
    });
  }
}
// Provider 已通过代码生成自动创建为 indexNotifierProvider


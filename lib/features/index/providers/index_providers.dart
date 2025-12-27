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
  }) = _IndexState;
}

// IndexController Provider - 使用 Riverpod 3 代码生成
@riverpod
class IndexNotifier extends _$IndexNotifier {
  @override
  IndexState build() {
    return const IndexState();
  }

  static List<String> tabItems = [
    '推荐',
    '关注',
    '本地',
    '广场',
    '商场',
    '聚力',
    '共享',
    '工具'
  ];

  void changeShowSearch(bool ifShow) {
    if (state.hasSearch != ifShow) {
      state = state.copyWith(hasSearch: ifShow);
    }
  }

}
// Provider 已通过代码生成自动创建为 indexNotifierProvider

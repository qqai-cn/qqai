import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_providers.freezed.dart';
part 'message_providers.g.dart';

// MessageController 状态 - 使用 Freezed
@freezed
sealed class MessageState with _$MessageState {
  const factory MessageState({
    @Default([]) List<String> tabTitle,
    TabController? tabController,
  }) = _MessageState;
}

// MessageController Provider - 使用 Riverpod 3 代码生成
@riverpod
class MessageNotifier extends _$MessageNotifier {
  @override
  MessageState build() {
    const state = MessageState();
    ref.onDispose(() {
      this.state.tabController?.dispose();
    });
    return state;
  }
  // 初始化在外部通过 initTabView 完成

  void getTabviewMenu() {
    state = state.copyWith(
      tabTitle: ['消息', '好友'],
    );
  }

  void initTabView(TickerProvider vsync) {
    getTabviewMenu();
    final newController = TabController(
      length: state.tabTitle.length,
      vsync: vsync,
    );
    state = state.copyWith(tabController: newController);
  }

  // dispose 已通过 ref.onDispose 在 build 中设置
}

// Provider 已通过代码生成自动创建为 messageNotifierProvider


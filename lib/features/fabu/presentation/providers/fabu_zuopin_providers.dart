import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../views/fabu_aixin_page.dart';
import '../views/fabu_dynamic_page.dart';
import '../views/fabu_goods_page.dart';
import '../views/fabu_video_page.dart';


part 'fabu_zuopin_providers.freezed.dart';
part 'fabu_zuopin_providers.g.dart';

// FabuZuoPinController 状态 - 使用 Freezed
@freezed
sealed class FabuZuoPinState with _$FabuZuoPinState {
  const factory FabuZuoPinState({
    TabController? tabController,
    @Default([
      '发布动态',
      '发布视频',
      '发布商品',
      '发布爱心',
    ]) List<String> tabTitle,
    @Default([]) List<Widget> tabBoby,
  }) = _FabuZuoPinState;
}

// FabuZuoPinController Provider - 使用 Riverpod 3 代码生成（autoDispose）
// 注意：这个 provider 需要 TickerProvider，需要在 Widget 中创建
@Riverpod(keepAlive: false)
class FabuZuoPinNotifier extends _$FabuZuoPinNotifier {
  @override
  FabuZuoPinState build() {
    const state = FabuZuoPinState();
    ref.onDispose(() {
      this.state.tabController?.dispose();
    });
    return state;
  }
  
  // 初始化方法，需要在 Widget 中调用
  void init(TickerProvider vsync) {
    final tabController = TabController(
      length: state.tabTitle.length,
      vsync: vsync,
    );
    
    final tabBoby = [
      const FabuDynamicPage(),
      const FabuVideoPage(),
      const FabuGoodsPage(),
      const FabuAiXinPage(),
    ];
    
    state = state.copyWith(
      tabController: tabController,
      tabBoby: tabBoby,
    );
  }

  void fabu() {
    int index = state.tabController?.index ?? 0;
    // 根据 index 调用相应的 fabu 方法
    // 这需要在各自的 provider 中实现
  }

  // dispose 已通过 ref.onDispose 在 build 中设置
}

// Provider 已通过代码生成自动创建为 fabuZuoPinNotifierProvider
// 注意：需要在 Widget 中调用 init() 方法传入 TickerProvider


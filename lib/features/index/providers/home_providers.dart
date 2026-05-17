import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../components/AnimatedBottomBar.dart';
import '../data/home_tab_config.dart';
import '../presentation/views/index_page.dart';
import '../presentation/views/me_page.dart';
import '../presentation/views/message_page.dart';
import '../presentation/views/video_page.dart';

part 'home_providers.freezed.dart';

part 'home_providers.g.dart';

// HomeController 状态（不包含 TabController，它在 Widget 中管理）- 使用 Freezed
@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    @Default(0) int selected,
    int? bottomMenuType,
    int? headerType,
    @Default(false) bool isExtended,
  }) = _HomeState;
}

// HomeController Provider - 使用 Riverpod 3 代码生成
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    // 初始化状态，使用默认值
    return const HomeState();
  }

  final List<Widget Function()> mainPages = [
    () => IndexPage(),
    () => VideoPage(),
    () => MessagePage(),
    () => MePage(),
  ];
  static List<String> tabItems = homeTabConfigs
      .map((tab) => tab.title)
      .toList();
  static List<String> videoTabItems = ['推荐', '影视'];
  static List<String> messageTabItems = ['消息', '好友'];

  void changeMainPage(int index) {
    state = state.copyWith(selected: index);
  }

  void changeExtended() {
    state = state.copyWith(isExtended: !state.isExtended);
  }

  Widget getMainPage() {
    if (state.selected < 0 || state.selected >= mainPages.length) {
      return mainPages[0]();
    }
    return mainPages[state.selected]();
  }

  // 静态常量：底部导航栏项
  static final List<BarItem> barItems = [
    BarItem(
      text: "首页",
      selectPath: "imgs/index-selv2.svg",
      unSelectPath: "imgs/index.svg",
      color: Colors.indigo,
    ),
    BarItem(
      text: "影视",
      selectPath: "imgs/video-sel.svg",
      unSelectPath: "imgs/video.svg",
      color: Colors.purple,
    ),
    BarItem(
      text: "消息",
      selectPath: "imgs/msg-selv2.svg",
      unSelectPath: "imgs/msg.svg",
      color: Colors.yellow.shade900,
    ),
    BarItem(
      text: "我的",
      selectPath: "imgs/me-selv2.svg",
      unSelectPath: "imgs/me.svg",
      color: Colors.teal,
    ),
  ];
}

// Provider 已通过代码生成自动创建为 homeNotifierProvider

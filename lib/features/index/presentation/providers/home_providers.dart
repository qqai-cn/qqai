import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../components/AnimatedBottomBar.dart';
import '../../views/index_page.dart';
import '../../views/me_page.dart';
import '../../views/message_page.dart';
import '../../views/video_page.dart';

part 'home_providers.freezed.dart';
part 'home_providers.g.dart';

// HomeController 状态（不包含 TabController，它在 Widget 中管理）- 使用 Freezed
@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    @Default(true) bool hasSearch,
    @Default(0) int selected,
    @Default(1) int bottomMenuType,
    @Default([]) List<String> tabTitle,
    @Default(2) int colCount,
  }) = _HomeState;
}

// HomeController Provider - 使用 Riverpod 3 代码生成
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    // 初始化状态，设置默认值
    const state = HomeState();
    // 使用 Future.microtask 延迟初始化，避免在 build 中修改 state
    Future.microtask(() {
      changeMainPage(0);
    });
    return state;
  }

  List<Widget Function(TabController?)> get mainPageBuilders => [
    (tabController) => IndexPage(tabController: tabController),
    (tabController) => VideoPage(tabController: tabController),
    (tabController) => MessagePage(tabController: tabController),
    (tabController) => MePage(),
  ];

  List<String> getTabviewMenu(int index) {
    switch (index) {
      case 0:
        return ['推荐', '关注', '本地', '广场', '商场', '聚力', '共享', '工具'];
      case 1:
        return ['影视', '芊视'];
      case 2:
        return ['消息', '好友'];
      default:
        return [];
    }
  }

  void updateTabTitle(int index) {
    final titles = getTabviewMenu(index);
    state = state.copyWith(tabTitle: titles);
  }

  void handleTabChange(int selectedIndex, int tabIndex) {
    if (selectedIndex == 0 && tabIndex == 0) {
      state = state.copyWith(hasSearch: true);
    } else {
      state = state.copyWith(hasSearch: false);
    }
  }

  void changeMainPage(int index) {
    if (index >= 0 && index < mainPageBuilders.length) {
      updateTabTitle(index);
      state = state.copyWith(selected: index);
      // 重置 hasSearch 状态
      if (index == 0) {
        state = state.copyWith(hasSearch: true);
      } else {
        state = state.copyWith(hasSearch: false);
      }
    }
  }

  final List<BarItem> barItems = [
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

  void setColCount(double len) {
    int count = calculateColumnCount(10);
    state = state.copyWith(colCount: count);
  }

  int calculateColumnCount(double gutter) {
    int maxColumns = ((1.sw + gutter) / (1.sw + gutter)).floor();
    //todo
    return max(1, 3);
  }

  double calculateColumnWidth(int columnCount, double gutter) {
    return (1.sw - (columnCount - 1) * gutter) / columnCount;
  }
}

// Provider 已通过代码生成自动创建为 homeNotifierProvider


import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lookart_providers.freezed.dart';
part 'lookart_providers.g.dart';

// LookArtController 状态 - 使用 Freezed
@freezed
sealed class LookArtState with _$LookArtState {
  const factory LookArtState({
    @Default(4) int contentLine,
    @Default(false) bool hiddenRight,
    @Default(0) int selectItemIndex,
    @Default(true) bool allComment,
    @Default('在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。我真的很喜欢你这个让我看一眼就会笑的女孩子，只靠爱情是不可能在一起辈子的，白头偕老需要的很多，成为情侣可能只需要爱情，但成为家人需要是我们两个人厮守到老，不仅仅要靠爱情更多的是习惯与责任。想和你走到最后，我会口是心非但我想让你看透我的心，我生气也好冷战也罢，这只能证明我爱你，我会故意气气你会粘着你会和你吵架，但是不会轻易离开你，我会管着你但不想失去你。') String text,
    @Default(false) bool ifInputing,
    TabController? tabController,
  }) = _LookArtState;
}

// LookArtController Provider - 使用 Riverpod 3 代码生成
@riverpod
class LookArtNotifier extends _$LookArtNotifier {
  @override
  LookArtState build() {
    const state = LookArtState();
    ref.onDispose(() {
      this.state.tabController?.dispose();
    });
    return state;
  }

  final List<String> items = [
    '热度',
    '正序',
    '倒序',
  ];

  final List<String> tabValues = [
    '实时',
    '相关推荐',
  ];

  void initTabController(TickerProvider vsync) {
    final oldController = state.tabController;
    final newController = TabController(
      length: tabValues.length,
      vsync: vsync,
    );
    oldController?.dispose();
    state = state.copyWith(tabController: newController);
  }

  void resetWindow() {
    if (1.sw < 900) {
      state = state.copyWith(hiddenRight: false);
    } else {
      state = state.copyWith(hiddenRight: true);
    }
  }

  void setSelectItemIndex(int index) {
    state = state.copyWith(selectItemIndex: index);
  }

  String getSelectItemIndex() {
    return items[state.selectItemIndex];
  }

  void setIfInputing(bool ifInput) {
    state = state.copyWith(ifInputing: ifInput);
  }

  void changeSelectRange() {
    state = state.copyWith(allComment: !state.allComment);
  }

  // dispose 已通过 ref.onDispose 在 build 中设置
}

// Provider 已通过代码生成自动创建为 lookArtNotifierProvider


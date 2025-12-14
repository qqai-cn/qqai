import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/skuu_blog_page_entity.dart';


part 'me_providers.freezed.dart';
part 'me_providers.g.dart';

// MeController 状态 - 使用 Freezed
// 注意：TextEditingController 使用 required，在 build 中初始化
@freezed
sealed class MeState with _$MeState {
  const factory MeState({
    @Default(1) int name,
    List<dynamic>? data,
    required TextEditingController controller,
    @Default([]) List<SkuuBlogPageDataRecords> skuuBlogPageDataRecords,
  }) = _MeState;
  
  // 工厂构造函数用于初始化
  factory MeState.initial() => MeState(
    controller: TextEditingController(),
  );
}

// MeController Provider - 使用 Riverpod 3 代码生成
@riverpod
class MeNotifier extends _$MeNotifier {
  @override
  MeState build() {
    final state = MeState.initial();
    ref.onDispose(() {
      state.controller.dispose();
    });
    return state;
  }
}

// Provider 已通过代码生成自动创建为 meNotifierProvider


import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../thumbnail_page.dart';

part 'tool_providers.freezed.dart';
part 'tool_providers.g.dart';

// ToolController 状态 - 使用 Freezed
@freezed
sealed class ToolState with _$ToolState {
  const factory ToolState({
    @Default({}) Map<int, GenThumbnailImage> imgMap,
    @Default(1) int curStyle,
  }) = _ToolState;
}

// ToolController Provider - 使用 Riverpod 3 代码生成
@riverpod
class ToolNotifier extends _$ToolNotifier {
  @override
  ToolState build() => const ToolState();

  void setGenThumbnailImage(int index, GenThumbnailImage gen) {
    final newMap = Map<int, GenThumbnailImage>.from(state.imgMap);
    newMap[index] = gen;
    state = state.copyWith(imgMap: newMap);
  }

  void setStyle(int style) {
    state = state.copyWith(curStyle: style);
  }
}


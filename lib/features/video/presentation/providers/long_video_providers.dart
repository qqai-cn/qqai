import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'long_video_providers.freezed.dart';
part 'long_video_providers.g.dart';

// LongVideoController 状态 - 使用 Freezed
@freezed
sealed class LongVideoState with _$LongVideoState {
  const factory LongVideoState({
    @Default([]) List<String> videoItems,
  }) = _LongVideoState;
}

// LongVideoController Provider - 使用 Riverpod 3 代码生成（autoDispose）
@Riverpod(keepAlive: false)
class LongVideoNotifier extends _$LongVideoNotifier {
  @override
  LongVideoState build() => const LongVideoState(
    videoItems: ['1', '1', '1', '1', '1', '1', '1', '1', '1', '1'],
  );
}
// Provider 已通过代码生成自动创建为 longVideoNotifierProvider


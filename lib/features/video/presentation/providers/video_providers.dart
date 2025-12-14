import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_providers.freezed.dart';
part 'video_providers.g.dart';

// VideoController 状态（目前比较简单）- 使用 Freezed
@freezed
sealed class VideoState with _$VideoState {
  const factory VideoState() = _VideoState;
}

// VideoController Provider - 使用 Riverpod 3 代码生成
@riverpod
class VideoNotifier extends _$VideoNotifier {
  @override
  VideoState build() => const VideoState();
}
// Provider 已通过代码生成自动创建为 videoNotifierProvider


import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'short_video_providers.freezed.dart';
part 'short_video_providers.g.dart';

// ShortVideoController 状态 - 使用 Freezed
@freezed
sealed class ShortVideoState with _$ShortVideoState {
  const factory ShortVideoState({
    @Default([]) List<String> videoItems,
    @Default(1000.0) double maxCross,
  }) = _ShortVideoState;
}

// 扩展方法：计算比例
extension ShortVideoStateExtension on ShortVideoState {
  double getRatio() {
    double width = 1.sw;
    if (width > maxCross) {
      width = 0.5.sw;
    }
    return width / (width / (15 / 9) + 150);
  }
}

// ShortVideoController Provider - 使用 Riverpod 3 代码生成（autoDispose）
@Riverpod(keepAlive: false)
class ShortVideoNotifier extends _$ShortVideoNotifier {
  @override
  ShortVideoState build() => const ShortVideoState(
    videoItems: ['1', '1', '1', '1', '1', '1', '1', '1', '1', '1'],
  );
}
// Provider 已通过代码生成自动创建为 shortVideoNotifierProvider


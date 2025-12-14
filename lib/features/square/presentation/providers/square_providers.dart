import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'square_providers.freezed.dart';
part 'square_providers.g.dart';

// SquareController 状态 - 使用 Freezed
@freezed
sealed class SquareState with _$SquareState {
  const factory SquareState({
    @Default([]) List<String> items,
  }) = _SquareState;
}

// SquareController Provider - 使用 Riverpod 3 代码生成
@riverpod
class SquareNotifier extends _$SquareNotifier {
  @override
  SquareState build() {
    final state = const SquareState();
    _init();
    return state;
  }

  void _init() {
    state = state.copyWith(
      items: ['1', '1', '1', '1', '1', '1', '1'],
    );
  }
}
// Provider 已通过代码生成自动创建为 squareNotifierProvider


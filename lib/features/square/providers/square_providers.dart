import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../data/repos/square_repo.dart';
import '../data/models/square_model.dart';

part 'square_providers.freezed.dart';  
part 'square_providers.g.dart';

@freezed
sealed class SquareState with _$SquareState {
  const factory SquareState({
    // freezed 的 @Default 必须是 const
    @Default(const AsyncLoading()) AsyncValue<List<SquareModel>> items,
    String? error,
  }) = _SquareState;
}

@riverpod
class SquareNotifier extends _$SquareNotifier {
  late final ISquareRepo _repo;

  @override
  SquareState build() {
    _repo = ref.read(squareRepoProvider);
    return const SquareState();
  }

  Future<void> load() async {
    state = state.copyWith(items: const AsyncLoading(), error: null);
    try {
      final items = await _repo.getAllSquares();
      state = state.copyWith(items: AsyncData(items));
    } catch (e, st) {
      state = state.copyWith(items: AsyncError(e, st), error: e.toString());
    }
  }

  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    final newItem = SquareModel(
      id: const Uuid().v4(),
      title: title,
      isDone: false,
    );
    try {
      await _repo.addSquare(newItem);
      await load();
    } catch (e) {
      state = state.copyWith(error: '添加失败: $e');
    }
  }

  Future<void> toggle(String id) async {
    final item = await _repo.getSquareById(id);
    if (item == null) return;
    final updated = item.copyWith(isDone: !item.isDone);
    try {
      await _repo.updateSquare(updated);
      await load();
    } catch (e) {
      state = state.copyWith(error: '更新失败: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteSquare(id);
      await load();
    } catch (e) {
      state = state.copyWith(error: '删除失败: $e');
    }
  }
}


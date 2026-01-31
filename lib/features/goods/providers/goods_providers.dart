import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../data/repos/goods_repo.dart';
import '../data/models/goods_model.dart';

part 'goods_providers.freezed.dart';  
part 'goods_providers.g.dart';

@freezed
sealed class GoodsState with _$GoodsState {
  const factory GoodsState({
    // freezed 的 @Default 必须是 const
    @Default(const AsyncLoading()) AsyncValue<List<GoodsModel>> items,
    String? error,
  }) = _GoodsState;
}

@riverpod
class GoodsNotifier extends _$GoodsNotifier {
  late final IGoodsRepo _repo;

  @override
  GoodsState build() {
    _repo = ref.read(goodsRepoProvider);
    return const GoodsState();
  }

  Future<void> load() async {
    state = state.copyWith(items: const AsyncLoading(), error: null);
    try {
      final items = await _repo.getAllGoodss();
      state = state.copyWith(items: AsyncData(items));
    } catch (e, st) {
      state = state.copyWith(items: AsyncError(e, st), error: e.toString());
    }
  }

  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    final newItem = GoodsModel(
      id: const Uuid().v4(),
      title: title,
      isDone: false,
    );
    try {
      await _repo.addGoods(newItem);
      await load();
    } catch (e) {
      state = state.copyWith(error: '添加失败: $e');
    }
  }

  Future<void> toggle(String id) async {
    final item = await _repo.getGoodsById(id);
    if (item == null) return;
    final updated = item.copyWith(isDone: !item.isDone);
    try {
      await _repo.updateGoods(updated);
      await load();
    } catch (e) {
      state = state.copyWith(error: '更新失败: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteGoods(id);
      await load();
    } catch (e) {
      state = state.copyWith(error: '删除失败: $e');
    }
  }
}


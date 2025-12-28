import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../data/repos/flow_repo.dart';
import '../data/models/flow_model.dart';

part 'flow_providers.freezed.dart';  
part 'flow_providers.g.dart';

@freezed
sealed class FlowState with _$FlowState {
  const factory FlowState({
    @Default(AsyncLoading()) AsyncValue<List<FlowModel>> items,
    String? error,
  }) = _FlowState;
}

@riverpod
class FlowNotifier extends _$FlowNotifier {
  late final IFlowRepository _repo;

  @override
  FlowState build() {
    _repo = ref.read(flowRepositoryProvider);
    return const FlowState();
  }

  Future<void> load() async {
    state = state.copyWith(items: const AsyncLoading(), error: null);
    try {
      final items = await _repo.getAllFlows();
      state = state.copyWith(items: AsyncData(items));
    } catch (e, st) {
      state = state.copyWith(items: AsyncError(e, st), error: e.toString());
    }
  }

  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    final newItem = FlowModel(
      id: const Uuid().v4(),
      title: title,
      isDone: false,
    );
    try {
      await _repo.addFlow(newItem);
      await load();
    } catch (e) {
      state = state.copyWith(error: '添加失败: $e');
    }
  }

  Future<void> toggle(String id) async {
    final item = await _repo.getFlowById(id);
    if (item == null) return;
    final updated = item.copyWith(isDone: !item.isDone);
    try {
      await _repo.updateFlow(updated);
      await load();
    } catch (e) {
      state = state.copyWith(error: '更新失败: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteFlow(id);
      await load();
    } catch (e) {
      state = state.copyWith(error: '删除失败: $e');
    }
  }
}

final flowRepositoryProvider = Provider<IFlowRepository>(
  (ref) => FlowRepository(),
);

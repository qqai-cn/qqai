import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../data/repos/todolist_repo.dart';
import '../data/models/todolist_model.dart';

part 'todolist_providers.freezed.dart';  
part 'todolist_providers.g.dart';

@freezed
sealed class TodoListState with _$TodoListState {
  const factory TodoListState({
    @Default(AsyncLoading()) AsyncValue<List<TodoListModel>> items,
    String? error,
  }) = _TodoListState;
}

@riverpod
class TodoListNotifier extends _$TodoListNotifier {
  late final ITodoListRepository _repo;

  @override
  TodoListState build() {
    _repo = ref.read(todolistRepositoryProvider);
    return const TodoListState();
  }

  Future<void> load() async {
    state = state.copyWith(items: const AsyncLoading(), error: null);
    try {
      final items = await _repo.getAllTodoLists();
      state = state.copyWith(items: AsyncData(items));
    } catch (e, st) {
      state = state.copyWith(items: AsyncError(e, st), error: e.toString());
    }
  }

  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    final newItem = TodoListModel(
      id: const Uuid().v4(),
      title: title,
      isDone: false,
    );
    try {
      await _repo.addTodoList(newItem);
      await load();
    } catch (e) {
      state = state.copyWith(error: '添加失败: $e');
    }
  }

  Future<void> toggle(String id) async {
    final item = await _repo.getTodoListById(id);
    if (item == null) return;
    final updated = item.copyWith(isDone: !item.isDone);
    try {
      await _repo.updateTodoList(updated);
      await load();
    } catch (e) {
      state = state.copyWith(error: '更新失败: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteTodoList(id);
      await load();
    } catch (e) {
      state = state.copyWith(error: '删除失败: $e');
    }
  }
}

final todolistRepositoryProvider = Provider<ITodoListRepository>(
  (ref) => TodoListRepository(),
);

import '../models/todolist_model.dart';

abstract class ITodoListRepository {
  Future<List<TodoListModel>> getAllTodoLists();
  Future<TodoListModel?> getTodoListById(String id);
  Future<void> addTodoList(TodoListModel item);
  Future<void> updateTodoList(TodoListModel item);
  Future<void> deleteTodoList(String id);
}

class TodoListRepository implements ITodoListRepository {
  final List<TodoListModel> _items = [];

  @override
  Future<List<TodoListModel>> getAllTodoLists() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<TodoListModel?> getTodoListById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addTodoList(TodoListModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> updateTodoList(TodoListModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> deleteTodoList(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }
}

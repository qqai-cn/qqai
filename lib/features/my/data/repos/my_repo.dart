import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/my_model.dart';

// Repo Provider（按 blog 的格式：Provider 放在 repo 文件里）
final myRepoProvider = Provider<IMyRepo>(
  (ref) => MyRepo(),
);

abstract class IMyRepo {
  Future<List<MyModel>> getAllMys();
  Future<MyModel?> getMyById(String id);
  Future<void> addMy(MyModel item);
  Future<void> updateMy(MyModel item);
  Future<void> deleteMy(String id);
}

class MyRepo implements IMyRepo {
  final List<MyModel> _items = [];

  @override
  Future<List<MyModel>> getAllMys() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<MyModel?> getMyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addMy(MyModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> updateMy(MyModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> deleteMy(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }
}

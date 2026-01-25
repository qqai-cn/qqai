import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/square_model.dart';

// Repo Provider（按 blog 的格式：Provider 放在 repo 文件里）
final squareRepoProvider = Provider<ISquareRepo>(
  (ref) => SquareRepo(),
);

abstract class ISquareRepo {
  Future<List<SquareModel>> getAllSquares();
  Future<SquareModel?> getSquareById(String id);
  Future<void> addSquare(SquareModel item);
  Future<void> updateSquare(SquareModel item);
  Future<void> deleteSquare(String id);
}

class SquareRepo implements ISquareRepo {
  final List<SquareModel> _items = [];

  @override
  Future<List<SquareModel>> getAllSquares() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<SquareModel?> getSquareById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addSquare(SquareModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> updateSquare(SquareModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> deleteSquare(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }
}

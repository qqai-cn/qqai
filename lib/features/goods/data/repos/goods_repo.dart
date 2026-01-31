import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/goods_model.dart';

// Repo Provider（按 blog 的格式：Provider 放在 repo 文件里）
final goodsRepoProvider = Provider<IGoodsRepo>(
  (ref) => GoodsRepo(),
);

abstract class IGoodsRepo {
  Future<List<GoodsModel>> getAllGoodss();
  Future<GoodsModel?> getGoodsById(String id);
  Future<void> addGoods(GoodsModel item);
  Future<void> updateGoods(GoodsModel item);
  Future<void> deleteGoods(String id);
}

class GoodsRepo implements IGoodsRepo {
  final List<GoodsModel> _items = [];

  @override
  Future<List<GoodsModel>> getAllGoodss() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<GoodsModel?> getGoodsById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addGoods(GoodsModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> updateGoods(GoodsModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> deleteGoods(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }
}

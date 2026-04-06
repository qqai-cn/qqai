import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/cart_line.dart';

part 'cart_session.g.dart';

@Riverpod(keepAlive: true)
class CartSession extends _$CartSession {
  @override
  List<CartLine> build() => [
        CartLine(
          id: '1',
          title: '蓝月亮洗衣液 · 示例 1',
          price: 18.88,
          coverAsset: 'imgs/defbak.png',
          quantity: 1,
        ),
        CartLine(
          id: '2',
          title: '蓝月亮洗衣液 · 示例 2',
          price: 22.88,
          coverAsset: 'imgs/defbak1.png',
          quantity: 2,
        ),
      ];

  void _notify() => state = List<CartLine>.from(state);

  void toggleSelect(CartLine line, bool? value) {
    line.selected = value ?? false;
    _notify();
  }

  void selectAll(bool all) {
    for (final e in state) {
      e.selected = all;
    }
    _notify();
  }

  void setQty(CartLine line, int next) {
    if (next < 1) return;
    line.quantity = next;
    _notify();
  }

  void remove(CartLine line) {
    state = state.where((e) => e != line).toList();
  }

  /// 已勾选行快照（用于结算页）
  List<CartLine> selectedSnapshot() =>
      state.where((e) => e.selected).map((e) => e.copy()).toList();

  double selectedTotal() {
    var sum = 0.0;
    for (final e in state) {
      if (e.selected) sum += e.subtotal;
    }
    return sum;
  }

  int selectedCount() =>
      state.where((e) => e.selected).fold<int>(0, (a, e) => a + e.quantity);

  /// 提交订单后从购物车移除已结算商品（按 id）
  void removeByIds(Set<String> ids) {
    state = state.where((e) => !ids.contains(e.id)).toList();
  }

  /// 从商品详情加入购物车：同 id 已存在则数量 +1
  void addFromGoods({
    required String id,
    required String title,
    required double price,
    required String coverAsset,
    int addQty = 1,
  }) {
    final list = List<CartLine>.from(state);
    final idx = list.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      list[idx].quantity += addQty;
      state = list;
    } else {
      state = [
        ...list,
        CartLine(
          id: id,
          title: title,
          price: price,
          coverAsset: coverAsset,
          quantity: addQty,
          selected: true,
        ),
      ];
    }
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/trade_models.dart';
import '../data/repos/trade_repo.dart';
import '../models/cart_line.dart';

part 'cart_session.g.dart';

@Riverpod(keepAlive: true)
class CartSession extends _$CartSession {
  late final ITradeRepo _repo;

  @override
  CartSessionData build() {
    _repo = ref.read(tradeRepoProvider);
    Future.microtask(load);
    return const CartSessionData(loading: true);
  }

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final data = await _repo.getCartList();
      state = CartSessionData(lines: _mapCartItems(data.validList));
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  List<CartLine> _mapCartItems(List<TradeCartItem> items) {
    return items.map((item) {
      final cartId = item.id;
      return CartLine(
        id: cartId?.toString() ?? '${item.spuId}-${item.skuId}',
        cartId: cartId,
        skuId: item.skuId,
        spuId: item.spuId,
        title: item.title,
        price: item.priceYuan,
        coverUrl: item.coverUrl,
        quantity: item.count ?? 1,
        selected: item.selected ?? true,
      );
    }).toList();
  }

  void _notifyLines(List<CartLine> lines) {
    state = state.copyWith(lines: lines);
  }

  Future<void> toggleSelect(CartLine line, bool? value) async {
    final cartId = line.cartId;
    if (cartId == null) {
      line.selected = value ?? false;
      _notifyLines(List<CartLine>.from(state.lines));
      return;
    }
    final selected = value ?? false;
    line.selected = selected;
    _notifyLines(List<CartLine>.from(state.lines));
    try {
      await _repo.updateCartSelected(cartId: cartId, selected: selected);
    } catch (e) {
      line.selected = !selected;
      _notifyLines(List<CartLine>.from(state.lines));
      rethrow;
    }
  }

  Future<void> selectAll(bool all) async {
    final lines = List<CartLine>.from(state.lines);
    for (final e in lines) {
      e.selected = all;
    }
    _notifyLines(lines);
    for (final line in lines) {
      final cartId = line.cartId;
      if (cartId != null) {
        await _repo.updateCartSelected(cartId: cartId, selected: all);
      }
    }
  }

  Future<void> setQty(CartLine line, int next) async {
    if (next < 1) return;
    final cartId = line.cartId;
    final prev = line.quantity;
    line.quantity = next;
    _notifyLines(List<CartLine>.from(state.lines));
    if (cartId == null) return;
    try {
      await _repo.updateCartCount(cartId: cartId, count: next);
    } catch (e) {
      line.quantity = prev;
      _notifyLines(List<CartLine>.from(state.lines));
      rethrow;
    }
  }

  Future<void> remove(CartLine line) async {
    final cartId = line.cartId;
    state = state.copyWith(
      lines: state.lines.where((e) => e != line).toList(),
    );
    if (cartId == null) return;
    try {
      await _repo.deleteCartItems([cartId]);
    } catch (e) {
      await load();
      rethrow;
    }
  }

  List<CartLine> selectedSnapshot() =>
      state.lines.where((e) => e.selected).map((e) => e.copy()).toList();

  double selectedTotal() {
    var sum = 0.0;
    for (final e in state.lines) {
      if (e.selected) sum += e.subtotal;
    }
    return sum;
  }

  int selectedCount() => state.lines
      .where((e) => e.selected)
      .fold<int>(0, (a, e) => a + e.quantity);

  Future<void> removeByIds(Set<String> ids) async {
    final cartIds = state.lines
        .where((e) => ids.contains(e.id))
        .map((e) => e.cartId)
        .whereType<int>()
        .toList();
    state = state.copyWith(
      lines: state.lines.where((e) => !ids.contains(e.id)).toList(),
    );
    if (cartIds.isEmpty) return;
    try {
      await _repo.deleteCartItems(cartIds);
    } catch (e) {
      await load();
      rethrow;
    }
  }

  Future<void> addFromGoods({
    required int skuId,
    required String title,
    required double price,
    String? coverUrl,
    String? coverAsset,
    int addQty = 1,
    int? spuId,
  }) async {
    await _repo.addCart(skuId: skuId, count: addQty);
    await load();
  }
}

/// 购物车一行（可变更数量、勾选）
class CartLine {
  CartLine({
    required this.id,
    required this.title,
    required this.price,
    this.coverAsset,
    this.coverUrl,
    this.cartId,
    this.skuId,
    this.spuId,
    this.quantity = 1,
    this.selected = true,
  });

  /// 本地展示 key（优先 cartId）
  final String id;
  final int? cartId;
  final int? skuId;
  final int? spuId;
  final String title;
  final double price;
  final String? coverAsset;
  final String? coverUrl;
  int quantity;
  bool selected;

  double get subtotal => price * quantity;

  CartLine copy() => CartLine(
        id: id,
        cartId: cartId,
        skuId: skuId,
        spuId: spuId,
        title: title,
        price: price,
        coverAsset: coverAsset,
        coverUrl: coverUrl,
        quantity: quantity,
        selected: selected,
      );
}

class CartSessionData {
  const CartSessionData({
    this.lines = const [],
    this.loading = false,
    this.error,
  });

  final List<CartLine> lines;
  final bool loading;
  final String? error;

  CartSessionData copyWith({
    List<CartLine>? lines,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return CartSessionData(
      lines: lines ?? this.lines,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

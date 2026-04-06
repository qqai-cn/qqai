/// 购物车一行（可变更数量、勾选）
class CartLine {
  CartLine({
    required this.id,
    required this.title,
    required this.price,
    required this.coverAsset,
    this.quantity = 1,
    this.selected = true,
  });

  final String id;
  final String title;
  final double price;
  final String coverAsset;
  int quantity;
  bool selected;

  double get subtotal => price * quantity;

  CartLine copy() => CartLine(
        id: id,
        title: title,
        price: price,
        coverAsset: coverAsset,
        quantity: quantity,
        selected: selected,
      );
}

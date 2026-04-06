class GoodsCommentItem {
  const GoodsCommentItem({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    this.stars = 5,
    this.skuLabel,
    this.helpfulCount = 0,
    this.isPlusMember = false,
  });

  final String id;
  final String author;
  final String content;
  final DateTime createdAt;

  /// 1–5 星
  final int stars;

  /// 如「规格：2kg×1瓶」
  final String? skuLabel;

  final int helpfulCount;

  /// 是否展示 PLUS 标（样式用）
  final bool isPlusMember;
}

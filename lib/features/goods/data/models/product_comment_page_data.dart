import '../../models/goods_comment_item.dart';

class ProductCommentPageData {
  const ProductCommentPageData({
    required this.list,
    required this.total,
  });

  final List<GoodsCommentItem> list;
  final int total;
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/goods_comment_item.dart';

part 'goods_comments.g.dart';

@riverpod
class GoodsComments extends _$GoodsComments {
  @override
  List<GoodsCommentItem> build(String goodsId) {
    return [
      GoodsCommentItem(
        id: 'seed1',
        author: 'j***8',
        content:
            '京东物流一如既往的快，第二天就到了。包装严实无破损，洗衣液味道清新，去污效果不错，会回购。',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        stars: 5,
        skuLabel: '规格：2kg×1瓶',
        helpfulCount: 128,
        isPlusMember: true,
      ),
      GoodsCommentItem(
        id: 'seed2',
        author: '匿名用户',
        content: '性价比很高，比超市便宜不少，正品无疑。',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        stars: 5,
        skuLabel: '规格：1kg×2瓶',
        helpfulCount: 36,
        isPlusMember: false,
      ),
      GoodsCommentItem(
        id: 'seed3',
        author: '京***户',
        content: '一般般吧，能用，没有想象中那么香。',
        createdAt: DateTime.now().subtract(const Duration(hours: 20)),
        stars: 4,
        skuLabel: '规格：2kg×1瓶',
        helpfulCount: 7,
        isPlusMember: false,
      ),
    ];
  }

  void add(
    String author,
    String content, {
    int stars = 5,
    String? skuLabel,
  }) {
    final t = content.trim();
    if (t.isEmpty) return;
    state = [
      ...state,
      GoodsCommentItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        author: author.trim().isEmpty ? '匿名用户' : author.trim(),
        content: t,
        createdAt: DateTime.now(),
        stars: stars.clamp(1, 5),
        skuLabel: skuLabel,
        helpfulCount: 0,
        isPlusMember: false,
      ),
    ];
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/auth_providers.dart';
import '../data/models/trade_models.dart';
import '../data/repos/product_comment_repo.dart';
import '../data/repos/trade_repo.dart';
import '../models/goods_comment_item.dart';

part 'goods_comments.g.dart';

class GoodsCommentsState {
  const GoodsCommentsState({
    required this.items,
    required this.total,
    this.filterType = 0,
  });

  final List<GoodsCommentItem> items;
  final int total;
  final int filterType;

  int get goodCount => items.where((e) => e.stars >= 4).length;

  int get imageCount => items.where((e) => e.picUrls.isNotEmpty).length;

  String get goodRateLabel {
    if (items.isEmpty) return '—';
    final pct = ((goodCount / items.length) * 100).round();
    return '$pct%好评';
  }
}

@riverpod
class GoodsComments extends _$GoodsComments {
  @override
  Future<GoodsCommentsState> build(String goodsId) async {
    return _load(filterType: 0);
  }

  int? get _spuId => int.tryParse(goodsId);

  Future<GoodsCommentsState> _load({required int filterType}) async {
    final spuId = _spuId;
    if (spuId == null) {
      return const GoodsCommentsState(items: [], total: 0, filterType: 0);
    }
    final page = await ref.read(productCommentRepoProvider).getCommentPage(
          spuId: spuId,
          type: filterType,
        );
    return GoodsCommentsState(
      items: page.list,
      total: page.total,
      filterType: filterType,
    );
  }

  Future<void> setFilterType(int type) async {
    state = const AsyncLoading<GoodsCommentsState>();
    state = await AsyncValue.guard(() => _load(filterType: type));
  }

  Future<void> refresh() async {
    final type = switch (state) {
      AsyncData(:final value) => value.filterType,
      _ => 0,
    };
    state = const AsyncLoading<GoodsCommentsState>();
    state = await AsyncValue.guard(() => _load(filterType: type));
  }

  /// 提交评价；成功返回 null，失败返回错误文案。
  Future<String?> submitComment({
    required int stars,
    required String content,
    bool anonymous = false,
  }) async {
    final spuId = _spuId;
    if (spuId == null) return '商品无效';

    if (!ref.read(authProvider).isAuthenticated) {
      return '请先登录后再评价';
    }

    final trimmed = content.trim();
    if (trimmed.isEmpty) return '请填写评价内容';

    final orderItem =
        await ref.read(tradeRepoProvider).findPendingCommentItem(spuId);
    if (orderItem?.id == null) {
      return '暂无待评价订单，购买并完成订单后可评价';
    }

    try {
      await ref.read(tradeRepoProvider).createOrderItemComment(
            orderItemId: orderItem!.id!,
            content: trimmed,
            descriptionScores: stars,
            benefitScores: stars,
            anonymous: anonymous,
          );
      await refresh();
      ref.invalidate(pendingGoodsCommentOrderItemProvider(goodsId));
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

/// 当前用户对该商品可评价的订单项。
@riverpod
Future<TradeOrderItem?> pendingGoodsCommentOrderItem(
  Ref ref,
  String goodsId,
) async {
  if (!ref.watch(authProvider).isAuthenticated) return null;
  final spuId = int.tryParse(goodsId);
  if (spuId == null) return null;
  return ref.read(tradeRepoProvider).findPendingCommentItem(spuId);
}

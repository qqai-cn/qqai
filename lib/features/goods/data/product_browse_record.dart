import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_providers.dart';
import 'repos/goods_repo.dart';

/// 打开商品详情后记录浏览足迹（已登录时静默上报）。
void recordProductBrowseSilently(WidgetRef ref, int? spuId) {
  if (spuId == null) return;
  if (!ref.read(authProvider).isAuthenticated) return;
  ref.read(goodsRepoProvider).recordProductBrowse(spuId).ignore();
}

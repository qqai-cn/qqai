import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'goods_mall_tab_reselect_provider.g.dart';

/// 首页顶栏「商场」Tab 再次点击时递增，用于刷新列表并回到内嵌栈根页面。
@Riverpod(keepAlive: true)
class GoodsMallTabReselect extends _$GoodsMallTabReselect {
  @override
  int build() => 0;

  void bump() => state++;
}

void bumpGoodsMallTabReselect(WidgetRef ref) {
  ref.read(goodsMallTabReselectProvider.notifier).bump();
}

/// 商场列表刷新信号：由商场内嵌 Navigator 回到列表后触发，GoodsView 监听后刷新。
@Riverpod(keepAlive: true)
class GoodsMallListRefreshSignal extends _$GoodsMallListRefreshSignal {
  @override
  int build() => 0;

  void bump() => state++;
}

void bumpGoodsMallListRefreshSignal(WidgetRef ref) {
  ref.read(goodsMallListRefreshSignalProvider.notifier).bump();
}

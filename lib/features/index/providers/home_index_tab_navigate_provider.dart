import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../router/app_routes.dart';
import '../../goods/providers/goods_mall_tab_reselect_provider.dart';
import '../data/home_tab_config.dart';

part 'home_index_tab_navigate_provider.g.dart';

/// 首页顶栏 Tab 外部跳转请求（tabIndex + nonce，避免重复跳转不触发）。
typedef HomeIndexTabNavRequest = ({int tabIndex, int nonce});

@Riverpod(keepAlive: true)
class HomeIndexTabNavigate extends _$HomeIndexTabNavigate {
  @override
  HomeIndexTabNavRequest build() => (tabIndex: 0, nonce: 0);

  void request(int tabIndex) {
    state = (tabIndex: tabIndex, nonce: state.nonce + 1);
  }
}

/// 回到首页并打开顶栏「商场」Tab。
void openHomeMallTab(BuildContext context, WidgetRef ref) {
  ref.read(homeIndexTabNavigateProvider.notifier).request(kHomeMallTabIndex);
  bumpGoodsMallTabReselect(ref);
  context.go(Routes.HOME);
}

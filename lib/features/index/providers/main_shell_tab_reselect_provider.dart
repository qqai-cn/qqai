import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_shell_tab_reselect_provider.g.dart';

/// 底部主壳 Tab 激活事件。
///
/// [refresh] 为 true 表示重复点击当前 bottom tab，需要子页回到第一个 tab 后刷新。
class MainShellTabActivation {
  const MainShellTabActivation({this.nonce = 0, this.refresh = false});

  final int nonce;
  final bool refresh;
}

final mainShellTabActivationProvider =
    StateProvider.family<MainShellTabActivation, int>(
      (ref, branchIndex) => const MainShellTabActivation(),
    );

/// 底部主壳 Tab（首页 / 影视 / 消息 / 我的）重复点击时递增，子页通过 [ref.listen] 触发刷新。
@Riverpod(keepAlive: true)
class MainShellTabReselect extends _$MainShellTabReselect {
  @override
  int build(int branchIndex) => 0;

  void bump() {
    state++;
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_shell_tab_reselect_provider.g.dart';

/// 底部主壳 Tab（首页 / 影视 / 消息 / 我的）重复点击时递增，子页通过 [ref.listen] 触发刷新。
@Riverpod(keepAlive: true)
class MainShellTabReselect extends _$MainShellTabReselect {
  @override
  int build(int branchIndex) => 0;

  void bump() {
    state++;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../my/views/my_view.dart';

/// 好友详情：与底部「我的」主页共用 [MyView] 布局与 Tab。
class FriendsDetailView extends ConsumerWidget {
  const FriendsDetailView({
    super.key,
    required this.userId,
    required this.showAppBar,
  });

  final int userId;
  final bool showAppBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MyView(
      userId: userId,
      showLeadingBack: showAppBar,
    );
  }
}

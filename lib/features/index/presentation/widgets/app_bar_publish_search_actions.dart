import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_action_colors.dart';
import '../../../../router/app_routes.dart';

/// 顶栏「发布 / 搜索」按钮，与 [MePage] 样式一致。
class AppBarPublishSearchActions extends StatelessWidget {
  const AppBarPublishSearchActions({
    super.key,
    this.leading = const [],
  });

  final List<Widget> leading;

  @override
  Widget build(BuildContext context) {
    final color = AppActionColors.foreground(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...leading,
        IconButton(
          icon: Icon(Icons.add_circle_sharp, color: color),
          onPressed: () => context.push(Routes.publishZuoPinPageUrl),
        ),
        IconButton(
          icon: Icon(Icons.search, color: color),
          onPressed: () => context.push(Routes.searchPage),
        ),
      ],
    );
  }
}

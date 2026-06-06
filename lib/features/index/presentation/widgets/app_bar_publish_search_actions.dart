import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/router/app_routes.dart';

/// 顶栏「发布 / 搜索」按钮，与 [MePage] 样式一致。
class AppBarPublishSearchActions extends StatelessWidget {
  const AppBarPublishSearchActions({
    super.key,
    this.leading = const [],
    this.showSearch = true,
    this.onPublish,
  });

  final List<Widget> leading;

  /// 推荐 Tab 顶栏已展示搜索条时设为 false，避免重复搜索入口。
  final bool showSearch;

  /// 自定义发布入口；未设置时跳转默认发布页。
  final VoidCallback? onPublish;

  @override
  Widget build(BuildContext context) {
    final color = AppActionColors.foreground(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...leading,
        IconButton(
          icon: Icon(Icons.add_circle_sharp, color: color),
          tooltip: '发布作品',
          onPressed:
              onPublish ?? () => context.push(Routes.publishZuoPinPageUrl),
        ),
        if (showSearch)
          IconButton(
            icon: Icon(Icons.search, color: color),
            onPressed: () => context.push(Routes.searchPage),
          ),
      ],
    );
  }
}

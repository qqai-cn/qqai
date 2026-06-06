import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 动态/视频卡片「更多」菜单项文字样式（浅色 black54，深色浅灰）。
TextStyle feedMoreMenuTextStyle(BuildContext context) {
  return context.typo.body.copyWith(
    color: AppActionColors.menuItemForeground(context),
  );
}

/// 图文卡片「更多」：收藏、举报、不感兴趣。
List<PopupMenuEntry<String>> feedBlogMoreMenuEntries(
  BuildContext context, {
  required bool collected,
}) {
  final style = feedMoreMenuTextStyle(context);
  return <PopupMenuEntry<String>>[
    PopupMenuItem<String>(
      value: '0',
      child: Text(collected ? '取消收藏' : '收藏', style: style),
    ),
    PopupMenuItem<String>(
      value: '1',
      child: Text('举报', style: style),
    ),
    PopupMenuItem<String>(
      value: '2',
      child: Text('不感兴趣', style: style),
    ),
  ];
}

/// 视频卡片「更多」：收藏、举报、不感兴趣、加入播放队列。
List<PopupMenuEntry<String>> feedVideoMoreMenuEntries(
  BuildContext context, {
  String collectLabel = '收藏',
}) {
  final style = feedMoreMenuTextStyle(context);
  return <PopupMenuEntry<String>>[
    PopupMenuItem<String>(
      value: '0',
      child: Text(collectLabel, style: style),
    ),
    PopupMenuItem<String>(
      value: '1',
      child: Text('举报', style: style),
    ),
    PopupMenuItem<String>(
      value: '2',
      child: Text('不感兴趣', style: style),
    ),
    PopupMenuItem<String>(
      value: '3',
      child: Text('加入播放队列', style: style),
    ),
  ];
}

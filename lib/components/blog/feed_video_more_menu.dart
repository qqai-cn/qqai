import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 动态/视频卡片「更多」里常用的四个菜单项，供 [FeedActionBar]、视频网格卡等复用。
List<PopupMenuEntry<String>> feedVideoMoreMenuEntries(BuildContext context) {
  final style = context.typo.body.copyWith(color: Colors.black54);
  return <PopupMenuEntry<String>>[
    PopupMenuItem<String>(
      value: '0',
      child: Text('收藏', style: style),
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

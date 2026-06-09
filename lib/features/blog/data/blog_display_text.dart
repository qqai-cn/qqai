import 'package:flutter/material.dart';

import 'models/blog_page_model.dart';

/// 去掉互助帖正文里的「悬赏金额：」行。
String stripBlogRewardLines(String? content) {
  return (content ?? '')
      .split('\n')
      .where((line) => !line.trim().startsWith('悬赏金额：'))
      .join('\n')
      .trim();
}

/// 视频列表单行文案：`title#content`；缺一则只展示有的部分。
String blogVideoListPreview(BlogItem item) {
  final title = item.title?.trim() ?? '';
  final content = stripBlogRewardLines(item.content);
  if (title.isEmpty) return content;
  if (content.isEmpty) return title;
  return '$title#$content';
}

/// 侧栏推荐/合集条目：标题行（无则 null）。
String? blogVideoSidePanelTitle(BlogItem item) {
  final title = item.title?.trim();
  if (title == null || title.isEmpty) return null;
  return title;
}

/// 侧栏推荐/合集条目：正文行（无则 null）。
String? blogVideoSidePanelContent(BlogItem item) {
  final content = stripBlogRewardLines(item.content);
  if (content.isEmpty) return null;
  return content;
}

/// 视频详情：title 与 content 合并展示，最多 [maxLines] 行，超出省略。
String blogVideoDetailPreviewText(BlogItem item) => blogVideoListPreview(item);

Widget buildBlogVideoDetailText({
  required BlogItem item,
  required TextStyle bodyStyle,
  int maxLines = 3,
}) {
  final text = blogVideoDetailPreviewText(item);
  if (text.isEmpty) {
    return const SizedBox.shrink();
  }
  return Text(
    text,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: bodyStyle,
  );
}

/// 详情弹层用的完整文案。
String blogVideoDetailFullText(BlogItem item) {
  return blogVideoDetailPreviewText(item);
}

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

/// 视频详情：title 与 content 合并展示，最多 [maxLines] 行，超出省略。
Widget buildBlogVideoDetailText({
  required BlogItem item,
  required TextStyle titleStyle,
  required TextStyle bodyStyle,
  int maxLines = 3,
}) {
  final title = item.title?.trim() ?? '';
  final content = stripBlogRewardLines(item.content);

  if (title.isEmpty && content.isEmpty) {
    return const SizedBox.shrink();
  }
  if (title.isEmpty) {
    return Text(
      content,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: bodyStyle,
    );
  }
  if (content.isEmpty) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: titleStyle,
    );
  }
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(text: title, style: titleStyle),
        const TextSpan(text: '\n'),
        TextSpan(text: content, style: bodyStyle),
      ],
    ),
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
  );
}

/// 详情弹层用的完整文案。
String blogVideoDetailFullText(BlogItem item) {
  final title = item.title?.trim() ?? '';
  final content = stripBlogRewardLines(item.content);
  if (title.isEmpty) return content;
  if (content.isEmpty) return title;
  return '$title\n\n$content';
}

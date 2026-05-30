import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qqai/features/blog/data/repos/blog_repo.dart';

/// 打开博客详情时记录浏览足迹（静默失败）。
void recordBlogBrowseSilently(WidgetRef ref, int? blogId) {
  if (blogId == null) return;
  ref.read(blogRepoProvider).recordBlogBrowse(blogId).ignore();
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'blog_list_patch.dart';
import 'models/blog_page_model.dart';
import 'repos/blog_repo.dart';

/// 收藏/分享后更新瀑布流中的条目。
Future<
    ({
      List<BlogItem> allItems,
      AsyncValue<BlogPageModelData> blogPageData,
      String? errorMessage,
    })> toggleCollectForFeedLists(
  List<BlogItem> allItems,
  AsyncValue<BlogPageModelData> blogPageData,
  IBlogRepo repo,
  BlogItem blogItem,
) async {
  final id = blogItem.id;
  if (id == null) {
    return (
      allItems: allItems,
      blogPageData: blogPageData,
      errorMessage: '无法收藏：缺少博客编号',
    );
  }
  final wasCollected = blogCollectedByMe(blogItem);
  try {
    final nowCollected = await repo.toggleBlogFavorite(
      id,
      currentlyCollected: wasCollected,
    );
    final count = blogItem.collectCount ?? 0;
    final newCount = nowCollected
        ? count + 1
        : (count > 0 ? count - 1 : 0);
    final patched = patchBlogFeedLists(
      allItems,
      blogPageData,
      shouldPatch: (b) => b.id == id,
      patch: (b) => b.copyWith(
        collect: nowCollected ? 1 : 0,
        collectCount: newCount,
      ),
    );
    return (
      allItems: patched.allItems,
      blogPageData: patched.blogPageData,
      errorMessage: null,
    );
  } catch (e) {
    return (
      allItems: allItems,
      blogPageData: blogPageData,
      errorMessage: e.toString(),
    );
  }
}

Future<
    ({
      List<BlogItem> allItems,
      AsyncValue<BlogPageModelData> blogPageData,
      String? errorMessage,
    })> recordShareForFeedLists(
  List<BlogItem> allItems,
  AsyncValue<BlogPageModelData> blogPageData,
  IBlogRepo repo,
  BlogItem blogItem,
) async {
  final id = blogItem.id;
  if (id == null) {
    return (
      allItems: allItems,
      blogPageData: blogPageData,
      errorMessage: '无法分享：缺少博客编号',
    );
  }
  try {
    await repo.recordBlogShare(id);
    final count = blogItem.shareCount ?? 0;
    final patched = patchBlogFeedLists(
      allItems,
      blogPageData,
      shouldPatch: (b) => b.id == id,
      patch: (b) => b.copyWith(shareCount: count + 1),
    );
    return (
      allItems: patched.allItems,
      blogPageData: patched.blogPageData,
      errorMessage: null,
    );
  } catch (e) {
    return (
      allItems: allItems,
      blogPageData: blogPageData,
      errorMessage: e.toString(),
    );
  }
}

Future<
    ({
      List<BlogItem> allItems,
      AsyncValue<BlogPageModelData> blogPageData,
      String? errorMessage,
    })> markNotInterestedForFeedLists(
  List<BlogItem> allItems,
  AsyncValue<BlogPageModelData> blogPageData,
  IBlogRepo repo,
  BlogItem blogItem,
) async {
  final id = blogItem.id;
  if (id == null) {
    return (
      allItems: allItems,
      blogPageData: blogPageData,
      errorMessage: '无法操作：缺少博客编号',
    );
  }
  try {
    await repo.markBlogNotInterested(id);
    final patched = removeBlogFromFeedLists(allItems, blogPageData, id);
    return (
      allItems: patched.allItems,
      blogPageData: patched.blogPageData,
      errorMessage: null,
    );
  } catch (e) {
    return (
      allItems: allItems,
      blogPageData: blogPageData,
      errorMessage: e.toString(),
    );
  }
}

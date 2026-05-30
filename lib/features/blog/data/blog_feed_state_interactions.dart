import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../my/data/repos/profile_repo.dart';
import 'blog_interaction_patch.dart';
import 'blog_list_patch.dart';
import 'models/blog_page_model.dart';
import 'repos/blog_repo.dart';

/// 在任意「博客列表」Provider 状态上执行收藏/点赞等，避免各 Notifier 重复实现。
Future<void> runToggleCollectOnFeedState({
  required IBlogRepo repo,
  required List<BlogItem> allItems,
  required AsyncValue<BlogPageModelData> blogPageData,
  required BlogItem blogItem,
  required void Function({
    required List<BlogItem> allItems,
    required AsyncValue<BlogPageModelData> blogPageData,
    String? error,
  }) apply,
}) async {
  try {
    final r = await toggleCollectForFeedLists(
      allItems,
      blogPageData,
      repo,
      blogItem,
    );
    if (r.errorMessage != null) {
      apply(
        allItems: allItems,
        blogPageData: blogPageData,
        error: r.errorMessage,
      );
      return;
    }
    apply(
      allItems: r.allItems,
      blogPageData: r.blogPageData,
    );
  } catch (e) {
    apply(
      allItems: allItems,
      blogPageData: blogPageData,
      error: e.toString(),
    );
  }
}

Future<void> runToggleZanOnFeedState({
  required IBlogRepo repo,
  required List<BlogItem> allItems,
  required AsyncValue<BlogPageModelData> blogPageData,
  required BlogItem blogItem,
  required void Function({
    required List<BlogItem> allItems,
    required AsyncValue<BlogPageModelData> blogPageData,
    String? error,
  }) apply,
}) async {
  final id = blogItem.id;
  if (id == null) return;
  final wasLiked = blogItem.liked == 1;
  try {
    final nowLiked = await repo.toggleBlogLike(id, currentlyLiked: wasLiked);
    final count = blogItem.zan ?? 0;
    final newCount = nowLiked ? count + 1 : (count > 0 ? count - 1 : 0);
    final patched = patchBlogFeedLists(
      allItems,
      blogPageData,
      shouldPatch: (b) => b.id == id,
      patch: (b) => b.copyWith(liked: nowLiked ? 1 : 0, zan: newCount),
    );
    apply(
      allItems: patched.allItems,
      blogPageData: patched.blogPageData,
    );
  } catch (e) {
    apply(
      allItems: allItems,
      blogPageData: blogPageData,
      error: e.toString(),
    );
  }
}

Future<void> runToggleCareOnFeedState({
  required IProfileRepo profileRepo,
  required List<BlogItem> allItems,
  required AsyncValue<BlogPageModelData> blogPageData,
  required BlogItem blogItem,
  required void Function({
    required List<BlogItem> allItems,
    required AsyncValue<BlogPageModelData> blogPageData,
    String? error,
  }) apply,
}) async {
  try {
    final r = await toggleCareForFeedLists(
      allItems,
      blogPageData,
      profileRepo,
      blogItem,
    );
    if (r.errorMessage != null) {
      apply(
        allItems: allItems,
        blogPageData: blogPageData,
        error: r.errorMessage,
      );
      return;
    }
    apply(
      allItems: r.allItems,
      blogPageData: r.blogPageData,
    );
  } catch (e) {
    apply(
      allItems: allItems,
      blogPageData: blogPageData,
      error: e.toString(),
    );
  }
}

Future<void> runRecordShareOnFeedState({
  required IBlogRepo repo,
  required List<BlogItem> allItems,
  required AsyncValue<BlogPageModelData> blogPageData,
  required BlogItem blogItem,
  required void Function({
    required List<BlogItem> allItems,
    required AsyncValue<BlogPageModelData> blogPageData,
    String? error,
  }) apply,
}) async {
  try {
    final r = await recordShareForFeedLists(
      allItems,
      blogPageData,
      repo,
      blogItem,
    );
    if (r.errorMessage != null) {
      apply(
        allItems: allItems,
        blogPageData: blogPageData,
        error: r.errorMessage,
      );
      return;
    }
    apply(
      allItems: r.allItems,
      blogPageData: r.blogPageData,
    );
  } catch (e) {
    apply(
      allItems: allItems,
      blogPageData: blogPageData,
      error: e.toString(),
    );
  }
}

/// 条目不在任何已加载列表中时，仅调用接口并返回更新后的 [BlogItem]。
Future<({BlogItem? item, String? error})> toggleCollectStandalone(
  IBlogRepo repo,
  BlogItem blogItem,
) async {
  final id = blogItem.id;
  if (id == null) {
    return (item: null, error: '无法收藏：缺少博客编号');
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
    return (
      item: blogItem.copyWith(
        collect: nowCollected ? 1 : 0,
        collectCount: newCount,
      ),
      error: null,
    );
  } catch (e) {
    return (item: null, error: e.toString());
  }
}

Future<void> runNotInterestedOnFeedState({
  required IBlogRepo repo,
  required List<BlogItem> allItems,
  required AsyncValue<BlogPageModelData> blogPageData,
  required BlogItem blogItem,
  required void Function({
    required List<BlogItem> allItems,
    required AsyncValue<BlogPageModelData> blogPageData,
    String? error,
  }) apply,
}) async {
  try {
    final r = await markNotInterestedForFeedLists(
      allItems,
      blogPageData,
      repo,
      blogItem,
    );
    if (r.errorMessage != null) {
      apply(
        allItems: allItems,
        blogPageData: blogPageData,
        error: r.errorMessage,
      );
      return;
    }
    apply(
      allItems: r.allItems,
      blogPageData: r.blogPageData,
    );
  } catch (e) {
    apply(
      allItems: allItems,
      blogPageData: blogPageData,
      error: e.toString(),
    );
  }
}

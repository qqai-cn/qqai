import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../util/conversation_list_time_format.dart';
import '../../../util/format_count.dart';
import '../../../util/media_url.dart';
import '../../my/data/repos/profile_repo.dart';
import 'models/blog_page_model.dart';

/// 更新瀑布流中的条目（不涉及 [BlogState] 类型，避免与 `blog_providers` 循环依赖）。
({
  List<BlogItem> allItems,
  AsyncValue<BlogPageModelData> blogPageData,
}) patchBlogFeedLists(
  List<BlogItem> allItems,
  AsyncValue<BlogPageModelData> blogPageData, {
  required bool Function(BlogItem b) shouldPatch,
  required BlogItem Function(BlogItem b) patch,
}) {
  BlogItem mapOne(BlogItem b) => shouldPatch(b) ? patch(b) : b;
  final newItems = allItems.map(mapOne).toList();
  final newPageData = switch (blogPageData) {
    AsyncData(:final value) => AsyncData(
        value.copyWith(
          list: (value.list ?? []).map(mapOne).toList(),
        ),
      ),
    _ => blogPageData,
  };
  return (allItems: newItems, blogPageData: newPageData);
}

int? authorUserId(BlogItem b) =>
    b.userId ?? int.tryParse((b.creator ?? '').trim());

bool sameAuthor(BlogItem b, int userId) => authorUserId(b) == userId;

/// 是否为当前登录用户自己的作品（仅比较 [BlogItem.userId] 与本地 [currentUserId]）。
bool isOwnBlogPost(BlogItem b, String? currentUserId) {
  final postUserId = b.userId;
  final me = currentUserId?.trim();
  if (postUserId == null || me == null || me.isEmpty) return false;
  return postUserId.toString() == me;
}

/// 博客列表是否展示「关注」按钮（自己的作品不展示）。
bool shouldShowBlogFollowButton(BlogItem b, String? currentUserId) =>
    !isOwnBlogPost(b, currentUserId);

/// 关注按钮展示：接口 [care] 1 已关注，0 或其它为未关注。
int blogFollowCare(BlogItem b) => b.care == 1 ? 1 : 0;

/// 作者等级（接口 [creatorLevel]，供 [LevelIcon] 使用，限制在 1–6）。
int blogCreatorLevel(BlogItem b) {
  final lv = b.creatorLevel;
  if (lv == null || lv < 1) return 0;
  if (lv > 6) return 6;
  return lv;
}

/// 当前用户是否已点赞该博客。
bool blogLikedByMe(BlogItem b) => b.liked == 1;

/// 当前用户是否已收藏该博客。
bool blogCollectedByMe(BlogItem b) => b.collect == 1;

/// 作者行 meta：粉丝数、创建时间、距离（时间与聊天消息一致；距离在日期后）。
String authorFollowerMetaText(BlogItem b) {
  final parts = <String>[];
  final fans = b.followerCount;
  if (fans != null && fans > 0) {
    parts.add('粉丝 ${formatCompactCount(fans)}');
  }
  final time = formatConversationListTime(b.createTime);
  if (time.isNotEmpty) {
    parts.add(time);
  }
  final distance = formatBlogDistanceKm(b.distance);
  if (distance.isNotEmpty) {
    parts.add('距离$distance');
  }
  return parts.join(' · ');
}

/// 作者头像 URL（接口 [creatorAvatar] 为空时，自己的作品可用 [fallbackAvatarUrl]）。
String? blogCreatorAvatarUrl(
  BlogItem b, {
  String? currentUserId,
  String? fallbackAvatarUrl,
}) {
  final resolved = resolveMediaUrl(b.creatorAvatar);
  if (resolved != null) return resolved;

  if (fallbackAvatarUrl != null &&
      isOwnBlogPost(b, currentUserId)) {
    return resolveMediaUrl(fallbackAvatarUrl);
  }
  return null;
}

/// 关注/取消关注后返回更新后的列表与分页数据；[errorMessage] 非空表示未调用接口。
Future<
    ({
      List<BlogItem> allItems,
      AsyncValue<BlogPageModelData> blogPageData,
      String? errorMessage,
    })> toggleCareForFeedLists(
  List<BlogItem> allItems,
  AsyncValue<BlogPageModelData> blogPageData,
  IProfileRepo profile,
  BlogItem blogItem,
) async {
  final uid = authorUserId(blogItem);
  if (uid == null) {
    return (
      allItems: allItems,
      blogPageData: blogPageData,
      errorMessage: '无法关注：缺少作者用户编号',
    );
  }
  bool following;
  final c = blogItem.care;
  if (c == 0 || c == 1) {
    following = c == 1;
  } else {
    following = await profile.isFollowedByMe(uid);
  }
  if (following) {
    await profile.unfollowUser(uid);
  } else {
    await profile.followUser(uid);
  }
  final nextCare = following ? 0 : 1;
  final patched = patchBlogFeedLists(
    allItems,
    blogPageData,
    shouldPatch: (b) => sameAuthor(b, uid),
    patch: (b) => b.copyWith(care: nextCare),
  );
  return (
    allItems: patched.allItems,
    blogPageData: patched.blogPageData,
    errorMessage: null,
  );
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../index/providers/home_follow_feed_providers.dart';
import '../../video/providers/video_film_providers.dart';
import '../../video/providers/video_recommend_providers.dart';
import '../providers/blog_feed_list_actions.dart';
import '../providers/blog_providers.dart';
import 'home_blog_tab.dart';
import 'models/blog_page_model.dart';

BlogItem? _findInAllItems(List<BlogItem> items, int id) {
  for (final b in items) {
    if (b.id == id) return b;
  }
  return null;
}

BlogItem? _findInPageData(AsyncValue<BlogPageModelData> data, int id) {
  final pageList = switch (data) {
    AsyncData(:final value) => value.list,
    _ => null,
  };
  if (pageList == null) return null;
  return _findInAllItems(pageList, id);
}

BlogItem? findBlogInFeed({
  required int id,
  required List<BlogItem> allItems,
  required AsyncValue<BlogPageModelData> blogPageData,
}) {
  return _findInAllItems(allItems, id) ?? _findInPageData(blogPageData, id);
}

/// 从各 feed Provider 中取当前条目的最新状态（点赞/收藏等）。
BlogItem resolveBlogItem(WidgetRef ref, BlogItem initial) {
  final id = initial.id;
  if (id == null) return initial;

  final feeds = <({List<BlogItem> allItems, AsyncValue<BlogPageModelData> data})>[
    (
      allItems: ref.watch(videoRecommendProvider).allItems,
      data: ref.watch(videoRecommendProvider).blogPageData,
    ),
    (
      allItems: ref.watch(videoFilmProvider).allItems,
      data: ref.watch(videoFilmProvider).blogPageData,
    ),
    (
      allItems: ref.watch(homeFollowFeedProvider).allItems,
      data: ref.watch(homeFollowFeedProvider).blogPageData,
    ),
    (
      allItems: ref.watch(blogProvider(HomeBlogTab.recommend)).allItems,
      data: ref.watch(blogProvider(HomeBlogTab.recommend)).blogPageData,
    ),
    (
      allItems: ref.watch(blogProvider(HomeBlogTab.hot)).allItems,
      data: ref.watch(blogProvider(HomeBlogTab.hot)).blogPageData,
    ),
    (
      allItems: ref.watch(blogProvider(HomeBlogTab.local)).allItems,
      data: ref.watch(blogProvider(HomeBlogTab.local)).blogPageData,
    ),
  ];

  for (final feed in feeds) {
    final found = findBlogInFeed(
      id: id,
      allItems: feed.allItems,
      blogPageData: feed.data,
    );
    if (found != null) return found;
  }
  return initial;
}

BlogItem _resolveFromState(
  ({List<BlogItem> allItems, AsyncValue<BlogPageModelData> blogPageData}) state,
  BlogItem initial,
) {
  final id = initial.id;
  if (id == null) return initial;
  final found = findBlogInFeed(
    id: id,
    allItems: state.allItems,
    blogPageData: state.blogPageData,
  );
  return found ?? initial;
}

/// 从推荐/关注流列表取最新条目（点赞、收藏后同步按钮文案）。
BlogItem resolveFeedBlogItem(
  WidgetRef ref,
  BlogItem initial, {
  required bool followFeed,
  int feedCategory = HomeBlogTab.recommend,
}) {
  if (followFeed) {
    final state = ref.watch(homeFollowFeedProvider);
    return _resolveFromState(
      (allItems: state.allItems, blogPageData: state.blogPageData),
      initial,
    );
  }
  final id = initial.id;
  if (id != null) {
    final videoState = ref.watch(videoRecommendProvider);
    final inVideoRecommend = findBlogInFeed(
      id: id,
      allItems: videoState.allItems,
      blogPageData: videoState.blogPageData,
    );
    if (inVideoRecommend != null) return inVideoRecommend;
    final filmState = ref.watch(videoFilmProvider);
    final inVideoFilm = findBlogInFeed(
      id: id,
      allItems: filmState.allItems,
      blogPageData: filmState.blogPageData,
    );
    if (inVideoFilm != null) return inVideoFilm;
  }
  final state = ref.watch(blogProvider(feedCategory));
  return _resolveFromState(
    (allItems: state.allItems, blogPageData: state.blogPageData),
    initial,
  );
}

bool _feedContainsBlog({
  required int id,
  required List<BlogItem> allItems,
  required AsyncValue<BlogPageModelData> blogPageData,
}) {
  return findBlogInFeed(id: id, allItems: allItems, blogPageData: blogPageData) !=
      null;
}

/// 根据条目所在列表，选择对应的交互 Notifier（收藏/点赞等）。
BlogFeedListActions resolveBlogFeedActions(WidgetRef ref, BlogItem item) {
  final id = item.id;
  if (id != null) {
    final videoRecommend = ref.read(videoRecommendProvider);
    if (_feedContainsBlog(
      id: id,
      allItems: videoRecommend.allItems,
      blogPageData: videoRecommend.blogPageData,
    )) {
      return ref.read(videoRecommendProvider.notifier);
    }
    final videoFilm = ref.read(videoFilmProvider);
    if (_feedContainsBlog(
      id: id,
      allItems: videoFilm.allItems,
      blogPageData: videoFilm.blogPageData,
    )) {
      return ref.read(videoFilmProvider.notifier);
    }
    final follow = ref.read(homeFollowFeedProvider);
    if (_feedContainsBlog(
      id: id,
      allItems: follow.allItems,
      blogPageData: follow.blogPageData,
    )) {
      return ref.read(homeFollowFeedProvider.notifier);
    }
    for (final tab in [
      HomeBlogTab.recommend,
      HomeBlogTab.hot,
      HomeBlogTab.local,
    ]) {
      final state = ref.read(blogProvider(tab));
      if (_feedContainsBlog(
        id: id,
        allItems: state.allItems,
        blogPageData: state.blogPageData,
      )) {
        return ref.read(blogProvider(tab).notifier);
      }
    }
  }
  return ref.read(blogProvider(HomeBlogTab.recommend).notifier);
}

/// 条目是否已出现在任一已加载 feed 中。
bool blogItemExistsInKnownFeeds(WidgetRef ref, BlogItem item) {
  final id = item.id;
  if (id == null) return false;

  final feeds = <({List<BlogItem> allItems, AsyncValue<BlogPageModelData> data})>[
    (
      allItems: ref.read(videoRecommendProvider).allItems,
      data: ref.read(videoRecommendProvider).blogPageData,
    ),
    (
      allItems: ref.read(videoFilmProvider).allItems,
      data: ref.read(videoFilmProvider).blogPageData,
    ),
    (
      allItems: ref.read(homeFollowFeedProvider).allItems,
      data: ref.read(homeFollowFeedProvider).blogPageData,
    ),
    (
      allItems: ref.read(blogProvider(HomeBlogTab.recommend)).allItems,
      data: ref.read(blogProvider(HomeBlogTab.recommend)).blogPageData,
    ),
    (
      allItems: ref.read(blogProvider(HomeBlogTab.hot)).allItems,
      data: ref.read(blogProvider(HomeBlogTab.hot)).blogPageData,
    ),
    (
      allItems: ref.read(blogProvider(HomeBlogTab.local)).allItems,
      data: ref.read(blogProvider(HomeBlogTab.local)).blogPageData,
    ),
  ];

  for (final feed in feeds) {
    if (findBlogInFeed(
          id: id,
          allItems: feed.allItems,
          blogPageData: feed.data,
        ) !=
        null) {
      return true;
    }
  }
  return false;
}

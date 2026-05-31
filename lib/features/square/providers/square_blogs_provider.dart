import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../components/imgpreview/preview_img.dart';
import '../../../router/app_routes.dart';
import '../../blog/data/blog_interaction_patch.dart';
import '../../blog/data/blog_list_patch.dart';
import '../../blog/data/blog_route_extra.dart';
import '../../blog/data/models/blog_page_model.dart';
import '../../blog/data/repos/blog_repo.dart';
import '../../blog/providers/blog_feed_list_actions.dart';
import '../../blog/providers/blog_providers.dart';
import '../../blog/views/blog_avatar_preview.dart';
import '../../my/data/repos/profile_repo.dart';
import '../data/repos/square_repo.dart';

part 'square_blogs_provider.g.dart';

/// 单个广场下的公开博客瀑布流。
@riverpod
class SquareBlogsNotifier extends _$SquareBlogsNotifier
    implements BlogFeedListActions {
  static const int _pageSize = 10;

  late final ISquareRepo _squareRepo;
  late final IBlogRepo _blogRepo;
  late final IProfileRepo _profileRepo;
  late final int _squareId;
  bool _loading = false;

  @override
  BlogState build(int squareId) {
    _squareRepo = ref.read(squareRepoProvider);
    _blogRepo = ref.read(blogRepoProvider);
    _profileRepo = ref.read(profileRepoProvider);
    _squareId = squareId;
    return const BlogState();
  }

  Future<void> loadIfNeeded() async {
    if (_loading) return;
    if (state.blogPageData.hasValue || state.blogPageData.hasError) return;
    await load();
  }

  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    state = state.copyWith(blogPageData: const AsyncLoading(), error: null);
    try {
      final items = await _squareRepo.getSquareBlogsPage(
        _squareId,
        1,
        pageSize: _pageSize,
      );
      final list = items.list ?? [];
      state = state.copyWith(
        blogPageData: AsyncData(items),
        allItems: list,
        currentPage: 1,
        hasMore: list.length >= _pageSize,
      );
    } catch (e, st) {
      state = state.copyWith(
        blogPageData: AsyncError(e, st),
        error: e.toString(),
      );
    } finally {
      _loading = false;
    }
  }

  Future<void> refresh() async {
    try {
      final items = await _squareRepo.getSquareBlogsPage(
        _squareId,
        1,
        pageSize: _pageSize,
      );
      final list = items.list ?? [];
      state = state.copyWith(
        blogPageData: AsyncData(items),
        allItems: list,
        currentPage: 1,
        hasMore: list.length >= _pageSize,
        error: null,
      );
    } catch (e, st) {
      state = state.copyWith(
        blogPageData: AsyncError(e, st),
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.currentPage + 1;
      final items = await _squareRepo.getSquareBlogsPage(
        _squareId,
        nextPage,
        pageSize: _pageSize,
      );
      if (!ref.mounted) return;
      final newItems = items.list ?? [];
      state = state.copyWith(
        allItems: [...state.allItems, ...newItems],
        currentPage: nextPage,
        hasMore: newItems.length >= _pageSize,
        isLoadingMore: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  @override
  void onBlogItemTap(
    BuildContext context,
    BlogItem blogItem, {
    String? mediaHeroTag,
  }) {
    if (blogItem.blogType == 1) {
      context.push(
        Routes.blogImgDetailView,
        extra: blogDetailRouteExtra(blogItem, mediaHeroTag: mediaHeroTag),
      );
    } else {
      context.push(
        Routes.blogVideoDetailView,
        extra: blogDetailRouteExtra(blogItem, mediaHeroTag: mediaHeroTag),
      );
    }
  }

  @override
  void onBlogImgItemTap(
    BuildContext context,
    BlogItem blogItem,
    int index,
    String heroTag,
    List<String> imageUrls,
  ) {
    final previewImg = PreviewImg(
      id: blogItem.id?.toInt(),
      url: blogItem.resources,
      index: index,
      heroTag: heroTag,
      allUris: imageUrls,
    );
    context.push(Routes.watchImgUrl, extra: previewImg);
  }

  @override
  void onBlogAvatarTap(
    BuildContext context,
    BlogItem blogItem,
    String heroTag,
    String avatarUrl,
  ) {
    openBlogAvatarPreview(
      context,
      blog: blogItem,
      heroTag: heroTag,
      imageUrl: avatarUrl,
    );
  }

  @override
  void onZanTap(BlogItem blogItem) {
    unawaited(_toggleZan(blogItem));
  }

  Future<void> _toggleZan(BlogItem blogItem) async {
    final id = blogItem.id;
    if (id == null) return;
    final wasLiked = blogItem.liked == 1;
    try {
      final nowLiked = await _blogRepo.toggleBlogLike(
        id,
        currentlyLiked: wasLiked,
      );
      if (!ref.mounted) return;
      final count = blogItem.zan ?? 0;
      final newCount = nowLiked ? count + 1 : (count > 0 ? count - 1 : 0);
      final patched = patchBlogFeedLists(
        state.allItems,
        state.blogPageData,
        shouldPatch: (b) => b.id == id,
        patch: (b) => b.copyWith(liked: nowLiked ? 1 : 0, zan: newCount),
      );
      state = state.copyWith(
        allItems: patched.allItems,
        blogPageData: patched.blogPageData,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(error: e.toString());
    }
  }

  @override
  void onCareTap(BlogItem blogItem) {
    unawaited(_toggleCare(blogItem));
  }

  Future<void> _toggleCare(BlogItem blogItem) async {
    final userId = authorUserId(blogItem);
    if (userId == null) return;
    final wasFollowing = blogItem.care == 1;
    try {
      if (wasFollowing) {
        await _profileRepo.unfollowUser(userId);
      } else {
        await _profileRepo.followUser(userId);
      }
      if (!ref.mounted) return;
      final patched = patchBlogFeedLists(
        state.allItems,
        state.blogPageData,
        shouldPatch: (b) => sameAuthor(b, userId),
        patch: (b) => b.copyWith(care: wasFollowing ? 0 : 1),
      );
      state = state.copyWith(
        allItems: patched.allItems,
        blogPageData: patched.blogPageData,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(error: e.toString());
    }
  }

  @override
  void onCollectTap(BlogItem blogItem) {
    unawaited(_toggleCollect(blogItem));
  }

  @override
  Future<void> onNotInterestedTap(BlogItem blogItem) =>
      _markNotInterested(blogItem);

  Future<void> _markNotInterested(BlogItem blogItem) async {
    try {
      final r = await markNotInterestedForFeedLists(
        state.allItems,
        state.blogPageData,
        _blogRepo,
        blogItem,
      );
      if (!ref.mounted) return;
      if (r.errorMessage != null) {
        state = state.copyWith(error: r.errorMessage);
        return;
      }
      state = state.copyWith(
        allItems: r.allItems,
        blogPageData: r.blogPageData,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> _toggleCollect(BlogItem blogItem) async {
    try {
      final r = await toggleCollectForFeedLists(
        state.allItems,
        state.blogPageData,
        _blogRepo,
        blogItem,
      );
      if (!ref.mounted) return;
      if (r.errorMessage != null) {
        state = state.copyWith(error: r.errorMessage);
        return;
      }
      state = state.copyWith(
        allItems: r.allItems,
        blogPageData: r.blogPageData,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(error: e.toString());
    }
  }

  @override
  void onShareTap(BlogItem blogItem) {
    unawaited(_recordShare(blogItem));
  }

  Future<void> _recordShare(BlogItem blogItem) async {
    try {
      final r = await recordShareForFeedLists(
        state.allItems,
        state.blogPageData,
        _blogRepo,
        blogItem,
      );
      if (!ref.mounted) return;
      if (r.errorMessage != null) {
        state = state.copyWith(error: r.errorMessage);
        return;
      }
      state = state.copyWith(
        allItems: r.allItems,
        blogPageData: r.blogPageData,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(error: e.toString());
    }
  }

  @override
  double getVideoItemHeightWithWidth(int colCount, double screenWidth) {
    double widthItem = screenWidth;
    if (colCount > 1) {
      widthItem = widthItem * 0.5;
    }
    return widthItem / (15 / 9) + 150;
  }
}

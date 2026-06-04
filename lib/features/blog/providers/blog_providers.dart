import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../components/imgpreview/preview_img.dart';
import '../../../components/video_player/video_ad_overlay.dart';
import '../../../router/app_routes.dart';
import '../../my/data/repos/profile_repo.dart';
import '../data/blog_feed_location.dart';
import '../data/blog_feed_state_interactions.dart';
import '../data/blog_interaction_patch.dart';
import '../data/blog_list_patch.dart';
import '../data/blog_route_extra.dart';
import '../data/home_blog_tab.dart';
import '../data/models/blog_model.dart';
import '../data/models/blog_page_model.dart';
import '../data/repos/blog_repo.dart';
import '../data/models/blog_save_req_vo.dart';
import '../views/blog_avatar_preview.dart';
import 'blog_feed_list_actions.dart';

part 'blog_providers.freezed.dart';
part 'blog_providers.g.dart';

@freezed
sealed class BlogState with _$BlogState {
  const factory BlogState({
    // freezed 的 @Default 必须是 const
    @Default(AsyncLoading()) AsyncValue<BlogPageModelData> blogPageData,
    @Default([]) List<BlogItem> allItems,
    @Default(1) int currentPage,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    String? error,
  }) = _BlogState;
}

@Riverpod(keepAlive: true)
class BlogNotifier extends _$BlogNotifier implements BlogFeedListActions {
  static const int _pageSize = 6;
  late final IBlogRepo _repo;
  late final int _category;

  @override
  BlogState build(int category) {
    _repo = ref.read(blogRepoProvider);
    _category = category;
    Future.microtask(() {
      if (ref.mounted) load();
    });
    return const BlogState();
  }

  Future<BlogPageModelData> _fetchPage(int page) async {
    if (_category == HomeBlogTab.hot) {
      return _repo.getHotBlogPageModelDataWithPage(
        page,
        pageSize: _pageSize,
        shareType: blogShareTypePublic,
      );
    }
    if (_category == HomeBlogTab.local) {
      final geo = await readBlogFeedGeoPosition();
      return _repo.getBlogPageModelDataWithPage(
        page,
        pageSize: _pageSize,
        shareType: blogShareTypePublic,
        latitude: geo?.latitude,
        longitude: geo?.longitude,
        radiusKm: geo != null ? blogNearbyRadiusKmDefault : null,
      );
    }
    if (_category == HomeBlogTab.mutualAid) {
      return _repo.getBlogPageModelDataWithPage(
        page,
        pageSize: _pageSize,
        categary: HomeBlogTab.mutualAid,
        shareType: blogShareTypePublic,
      );
    }
    return _repo.getBlogPageModelDataWithPage(page, pageSize: _pageSize);
  }

  Future<void> load() async {
    state = state.copyWith(blogPageData: const AsyncLoading(), error: null);
    try {
      final items = await _fetchPage(1);
      if (!ref.mounted) return;
      state = state.copyWith(
        blogPageData: AsyncData(items),
        allItems: items.list ?? [],
        currentPage: 1,
        hasMore: (items.list?.length ?? 0) >= _pageSize,
      );
    } catch (e, st) {
      if (!ref.mounted) return;
      state = state.copyWith(
        blogPageData: AsyncError(e, st),
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    try {
      final items = await _fetchPage(1);
      if (!ref.mounted) return;
      state = state.copyWith(
        blogPageData: AsyncData(items),
        allItems: items.list ?? [],
        currentPage: 1,
        hasMore: (items.list?.length ?? 0) >= _pageSize,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.currentPage + 1;
      final items = await _fetchPage(nextPage);
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

  void _applyFeedPatch({
    required List<BlogItem> allItems,
    required AsyncValue<BlogPageModelData> blogPageData,
    String? error,
  }) {
    if (!ref.mounted) return;
    state = state.copyWith(
      allItems: allItems,
      blogPageData: blogPageData,
      error: error,
    );
  }

  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    final newItem = BlogModel(
      id: const Uuid().v4(),
      title: title,
      isDone: false,
    );
    try {
      await _repo.addBlog(newItem);
      await load();
    } catch (e) {
      state = state.copyWith(error: '添加失败: $e');
    }
  }

  Future<void> toggle(String id) async {
    final item = await _repo.getBlogById(id);
    if (item == null) return;
    final updated = item.copyWith(isDone: !item.isDone);
    try {
      await _repo.updateBlog(updated);
      await load();
    } catch (e) {
      state = state.copyWith(error: '更新失败: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteBlog(id);
      await load();
    } catch (e) {
      state = state.copyWith(error: '删除失败: $e');
    }
  }

  // 跳转到博客详情页
  @override
  void onBlogItemTap(
    BuildContext context,
    BlogItem blogItem, {
    String? mediaHeroTag,
    VideoAdPlaybackState? videoAdState,
  }) {
    if (blogItem.blogType == 1) {
      context.push(
        Routes.blogImgDetailView,
        extra: blogDetailRouteExtra(blogItem, mediaHeroTag: mediaHeroTag),
      );
    } else {
      context.push(
        Routes.blogVideoDetailView,
        extra: blogDetailRouteExtra(
          blogItem,
          mediaHeroTag: mediaHeroTag,
          videoAdState: videoAdState,
        ),
      );
    }
  }

  // 跳转到图片预览页
  @override
  void onBlogImgItemTap(
    BuildContext context,
    BlogItem blogItem,
    int index,
    String heroTag,
    List<String> imageUrls,
  ) {
    PreviewImg previewImg = PreviewImg(
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

  // 点击头像事件（非 Hero 预览场景保留）
  void onUserAvatarTap(BuildContext context, BlogItem blogItem) {
    context.push(Routes.whatArticle, extra: blogItem);
  }

  // 点赞：POST …/profile/blog/{id}/like；取消：DELETE 同路径
  @override
  void onZanTap(BlogItem blogItem) {
    unawaited(_toggleZan(blogItem));
  }

  Future<void> _toggleZan(BlogItem blogItem) async {
    await runToggleZanOnFeedState(
      repo: _repo,
      allItems: state.allItems,
      blogPageData: state.blogPageData,
      blogItem: blogItem,
      apply: _applyFeedPatch,
    );
  }

  // 关注：POST …/profile/follows/{userId}；取消：DELETE 同路径
  @override
  void onCareTap(BlogItem blogItem) {
    unawaited(_toggleCare(blogItem));
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
        _repo,
        blogItem,
      );
      if (r.errorMessage != null) {
        state = state.copyWith(error: r.errorMessage);
        return;
      }
      state = state.copyWith(
        allItems: r.allItems,
        blogPageData: r.blogPageData,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> _toggleCollect(BlogItem blogItem) async {
    await runToggleCollectOnFeedState(
      repo: _repo,
      allItems: state.allItems,
      blogPageData: state.blogPageData,
      blogItem: blogItem,
      apply: _applyFeedPatch,
    );
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
        _repo,
        blogItem,
      );
      if (r.errorMessage != null) {
        state = state.copyWith(error: r.errorMessage);
        return;
      }
      state = state.copyWith(
        allItems: r.allItems,
        blogPageData: r.blogPageData,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> _toggleCare(BlogItem blogItem) async {
    final profile = ref.read(profileRepoProvider);
    try {
      final r = await toggleCareForFeedLists(
        state.allItems,
        state.blogPageData,
        profile,
        blogItem,
      );
      if (r.errorMessage != null) {
        state = state.copyWith(error: r.errorMessage);
        return;
      }
      state = state.copyWith(
        allItems: r.allItems,
        blogPageData: r.blogPageData,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> createBlog(BlogSaveReqVO req) async {
    try {
      await _repo.createBlog(req);
    } catch (e) {
      state = state.copyWith(error: '发布失败: $e');
      rethrow;
    }
  }

  void setScrollOffset(double curScrollOffset) {
    // state = state.copyWith(scrollOffset: curScrollOffset);
  }

  double getImgGridHeight(int itemCount) {
    if (itemCount == 1) {
      return 500;
    } else if (itemCount > 1 && itemCount <= 3) {
      return 300;
    } else {
      return 600;
    }
  }

  // 动态根据图片个数算item高度
  static double getImgItemHeight(
    int itemCount,
    double length,
    int colCount,
    double screenWidth,
  ) {
    length = length == 0 ? 100 : length;
    double widthItem = screenWidth;
    if (colCount > 1) {
      widthItem = widthItem * 0.5;
    }
    length = '长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。'.length
        .toDouble();
    length = length * 22;
    double lineCount = (length / widthItem).ceilToDouble();
    double wordHeight = (lineCount > 3 ? 3 : lineCount) * 30 + 102;
    // 没有图片的时候
    if (itemCount == 0) {
      return wordHeight;
    }
    // 静态方法中调用静态方法计算图片网格高度
    double imgGridHeight = _getImgGridHeightStatic(itemCount);
    return imgGridHeight + wordHeight;
  }

  static double _getImgGridHeightStatic(int itemCount) {
    if (itemCount == 1) {
      return 500;
    } else if (itemCount > 1 && itemCount <= 3) {
      return 300;
    } else {
      return 600;
    }
  }

  double getVideoItemHeight(int colCount) {
    // 使用屏幕宽度，需要从外部传入
    // 这里返回一个基础值，实际使用时应该传入屏幕宽度
    return 300.0; // 临时值，需要在调用时传入实际屏幕宽度
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

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../components/video_player/video_ad_overlay.dart';
import '../../blog/data/blog_feed_state_interactions.dart';
import '../../blog/data/blog_list_patch.dart';
import '../../blog/data/home_blog_tab.dart';
import '../../blog/data/models/blog_page_model.dart';
import '../../blog/data/repos/blog_repo.dart';
import '../../blog/providers/blog_feed_list_actions.dart';
import '../../my/data/repos/profile_repo.dart';

part 'video_film_providers.freezed.dart';
part 'video_film_providers.g.dart';

/// 影视 Tab「影视」：SkuuBlog 分页，仅 [BlogContentType.video]。
@freezed
sealed class VideoFilmState with _$VideoFilmState {
  const factory VideoFilmState({
    @Default(AsyncLoading()) AsyncValue<BlogPageModelData> blogPageData,
    @Default([]) List<BlogItem> allItems,
    @Default(1) int currentPage,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    String? error,
  }) = _VideoFilmState;
}

@riverpod
class VideoFilmNotifier extends _$VideoFilmNotifier
    implements BlogFeedListActions {
  static const int _pageSize = 12;

  late final IBlogRepo _repo;
  late final IProfileRepo _profileRepo;

  @override
  VideoFilmState build() {
    _repo = ref.read(blogRepoProvider);
    _profileRepo = ref.read(profileRepoProvider);
    Future.microtask(load);
    return const VideoFilmState();
  }

  Future<void> load() async {
    state = state.copyWith(blogPageData: const AsyncLoading(), error: null);
    try {
      final items = await _repo.getBlogPageModelDataWithPage(
        1,
        pageSize: _pageSize,
        blogType: BlogContentType.video,
      );
      state = state.copyWith(
        blogPageData: AsyncData(items),
        allItems: items.list ?? [],
        currentPage: 1,
        hasMore: (items.list?.length ?? 0) >= _pageSize,
      );
    } catch (e, st) {
      state = state.copyWith(
        blogPageData: AsyncError(e, st),
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    try {
      final items = await _repo.getBlogPageModelDataWithPage(
        1,
        pageSize: _pageSize,
        blogType: BlogContentType.video,
      );
      state = state.copyWith(
        blogPageData: AsyncData(items),
        allItems: items.list ?? [],
        currentPage: 1,
        hasMore: (items.list?.length ?? 0) >= _pageSize,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.currentPage + 1;
      final items = await _repo.getBlogPageModelDataWithPage(
        nextPage,
        pageSize: _pageSize,
        blogType: BlogContentType.video,
      );
      final newItems = items.list ?? [];
      state = state.copyWith(
        allItems: [...state.allItems, ...newItems],
        currentPage: nextPage,
        hasMore: newItems.length >= _pageSize,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  void _applyFeedPatch({
    required List<BlogItem> allItems,
    required AsyncValue<BlogPageModelData> blogPageData,
    String? error,
  }) {
    state = state.copyWith(
      allItems: allItems,
      blogPageData: blogPageData,
      error: error,
    );
  }

  @override
  void onCollectTap(BlogItem blogItem) {
    unawaited(
      runToggleCollectOnFeedState(
        repo: _repo,
        allItems: state.allItems,
        blogPageData: state.blogPageData,
        blogItem: blogItem,
        apply: _applyFeedPatch,
      ),
    );
  }

  @override
  Future<void> onNotInterestedTap(BlogItem blogItem) {
    return runNotInterestedOnFeedState(
      repo: _repo,
      allItems: state.allItems,
      blogPageData: state.blogPageData,
      blogItem: blogItem,
      apply: _applyFeedPatch,
    );
  }

  @override
  Future<void> onBlogDeleted(BlogItem blogItem) async {
    final id = blogItem.id;
    if (id == null) return;
    final patched = removeBlogFromFeedLists(
      state.allItems,
      state.blogPageData,
      id,
    );
    state = state.copyWith(
      allItems: patched.allItems,
      blogPageData: patched.blogPageData,
    );
  }

  @override
  void onZanTap(BlogItem blogItem) {
    unawaited(
      runToggleZanOnFeedState(
        repo: _repo,
        allItems: state.allItems,
        blogPageData: state.blogPageData,
        blogItem: blogItem,
        apply: _applyFeedPatch,
      ),
    );
  }

  @override
  void onCareTap(BlogItem blogItem) {
    unawaited(
      runToggleCareOnFeedState(
        profileRepo: _profileRepo,
        allItems: state.allItems,
        blogPageData: state.blogPageData,
        blogItem: blogItem,
        apply: _applyFeedPatch,
      ),
    );
  }

  @override
  void onShareTap(BlogItem blogItem) {
    unawaited(
      runRecordShareOnFeedState(
        repo: _repo,
        allItems: state.allItems,
        blogPageData: state.blogPageData,
        blogItem: blogItem,
        apply: _applyFeedPatch,
      ),
    );
  }

  @override
  void onBlogItemTap(
    BuildContext context,
    BlogItem blogItem, {
    String? mediaHeroTag,
    VideoAdPlaybackState? videoAdState,
  }) {}

  @override
  void onBlogImgItemTap(
    BuildContext context,
    BlogItem blogItem,
    int index,
    String heroTag,
    List<String> imageUrls,
  ) {}

  @override
  void onBlogAvatarTap(
    BuildContext context,
    BlogItem blogItem,
    String heroTag,
    String avatarUrl,
  ) {}

  @override
  double getVideoItemHeightWithWidth(int colCount, double screenWidth) => 300;
}

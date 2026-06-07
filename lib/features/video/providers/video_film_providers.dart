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

@Riverpod(keepAlive: true)
class VideoFilmNotifier extends _$VideoFilmNotifier
    implements BlogFeedListActions {
  static const int _pageSize = 12;

  late final IBlogRepo _repo;
  late final IProfileRepo _profileRepo;
  bool _loading = false;

  @override
  VideoFilmState build() {
    _repo = ref.read(blogRepoProvider);
    _profileRepo = ref.read(profileRepoProvider);
    Future.microtask(() {
      if (ref.mounted) loadIfNeeded();
    });
    return const VideoFilmState();
  }

  Future<void> loadIfNeeded() async {
    if (_loading) return;
    if (state.blogPageData.hasValue || state.blogPageData.hasError) return;
    await load();
  }

  bool _hasMorePages(BlogPageModelData page, int loadedCount) {
    final total = page.total;
    if (total != null && total > 0) {
      return loadedCount < total;
    }
    return (page.list?.length ?? 0) >= _pageSize;
  }

  List<BlogItem> _mergeUniqueItems(List<BlogItem> existing, List<BlogItem> incoming) {
    if (incoming.isEmpty) return existing;
    final seen = {for (final item in existing) if (item.id != null) item.id};
    final merged = List<BlogItem>.from(existing);
    for (final item in incoming) {
      final id = item.id;
      if (id != null && !seen.add(id)) continue;
      merged.add(item);
    }
    return merged;
  }

  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    state = state.copyWith(blogPageData: const AsyncLoading(), error: null);
    try {
      final items = await _repo.getBlogPageModelDataWithPage(
        1,
        pageSize: _pageSize,
        blogType: BlogContentType.video,
      );
      if (!ref.mounted) return;
      final list = items.list ?? [];
      state = state.copyWith(
        blogPageData: AsyncData(items),
        allItems: list,
        currentPage: 1,
        hasMore: _hasMorePages(items, list.length),
      );
    } catch (e, st) {
      if (!ref.mounted) return;
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
      final items = await _repo.getBlogPageModelDataWithPage(
        1,
        pageSize: _pageSize,
        blogType: BlogContentType.video,
      );
      if (!ref.mounted) return;
      final list = items.list ?? [];
      state = state.copyWith(
        blogPageData: AsyncData(items),
        allItems: list,
        currentPage: 1,
        hasMore: _hasMorePages(items, list.length),
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
      final items = await _repo.getBlogPageModelDataWithPage(
        nextPage,
        pageSize: _pageSize,
        blogType: BlogContentType.video,
      );
      if (!ref.mounted) return;
      final newItems = items.list ?? [];
      final merged = _mergeUniqueItems(state.allItems, newItems);
      if (newItems.isNotEmpty && merged.length == state.allItems.length) {
        state = state.copyWith(isLoadingMore: false, hasMore: false);
        return;
      }
      state = state.copyWith(
        allItems: merged,
        currentPage: nextPage,
        hasMore: _hasMorePages(items, merged.length),
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
    if (!ref.mounted) return;
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

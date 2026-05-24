import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../blog/data/models/blog_page_model.dart';
import '../../blog/data/repos/blog_repo.dart';

part 'video_recommend_providers.freezed.dart';
part 'video_recommend_providers.g.dart';

/// 影视 Tab「推荐」：SkuuBlog 分页，[blogType] = 2（视频）。
@freezed
sealed class VideoRecommendState with _$VideoRecommendState {
  const factory VideoRecommendState({
    @Default(AsyncLoading()) AsyncValue<BlogPageModelData> blogPageData,
    @Default([]) List<BlogItem> allItems,
    @Default(1) int currentPage,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    String? error,
  }) = _VideoRecommendState;
}

@riverpod
class VideoRecommendNotifier extends _$VideoRecommendNotifier {
  static const int _pageSize = 10;
  static const int _blogTypeVideo = 2;

  late final IBlogRepo _repo;

  @override
  VideoRecommendState build() {
    _repo = ref.read(blogRepoProvider);
    Future.microtask(load);
    return const VideoRecommendState();
  }

  Future<void> load() async {
    state = state.copyWith(blogPageData: const AsyncLoading(), error: null);
    try {
      final items = await _repo.getBlogPageModelDataWithPage(
        1,
        pageSize: _pageSize,
        blogType: _blogTypeVideo,
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
        blogType: _blogTypeVideo,
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
        blogType: _blogTypeVideo,
      );
      final newItems = items.list ?? [];
      state = state.copyWith(
        allItems: [...state.allItems, ...newItems],
        currentPage: nextPage,
        hasMore: newItems.length >= _pageSize,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }
}

/// 影视 Tab「推荐」竖滑流当前播放条目（评论 / 相关推荐侧栏用）。
@riverpod
class VideoRecommendCurrentBlog extends _$VideoRecommendCurrentBlog {
  @override
  BlogItem? build() => null;

  void select(BlogItem? blog) {
    state = blog;
  }
}

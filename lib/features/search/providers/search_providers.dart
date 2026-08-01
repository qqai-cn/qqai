import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../blog/data/models/blog_page_model.dart';
import '../../goods/data/models/mall_product_model.dart';
import '../data/models/search_model.dart';
import '../data/repos/search_repo.dart';

part 'search_providers.freezed.dart';
part 'search_providers.g.dart';

@freezed
sealed class SearchState with _$SearchState {
  const SearchState._();

  const factory SearchState({
    @Default('') String keyword,
    @Default(SearchCategory.blog) SearchCategory category,
    @Default(SearchBlogBucket()) SearchBlogBucket blog,
    @Default(SearchBlogBucket()) SearchBlogBucket video,
    @Default(SearchGoodsBucket()) SearchGoodsBucket goods,
  }) = _SearchState;

  bool get loadingCurrent => switch (category) {
        SearchCategory.blog => blog.loading,
        SearchCategory.video => video.loading,
        SearchCategory.goods => goods.loading,
      };

  bool get loadingMoreCurrent => switch (category) {
        SearchCategory.blog => blog.loadingMore,
        SearchCategory.video => video.loadingMore,
        SearchCategory.goods => goods.loadingMore,
      };

  String? get currentError => switch (category) {
        SearchCategory.blog => blog.error,
        SearchCategory.video => video.error,
        SearchCategory.goods => goods.error,
      };

  bool get hasMoreCurrent => switch (category) {
        SearchCategory.blog => blog.hasMore,
        SearchCategory.video => video.hasMore,
        SearchCategory.goods => goods.hasMore,
      };
}

@riverpod
class SearchNotifier extends _$SearchNotifier {
  static const int pageSize = 20;

  late final ISearchRepo _repo;

  @override
  SearchState build() {
    _repo = ref.read(searchRepoProvider);
    return const SearchState();
  }

  void setCategory(SearchCategory category) {
    if (state.category == category) return;
    state = state.copyWith(category: category);
  }

  /// 切分类后若当前桶为空且曾失败，则重试当前分类。
  Future<void> retryCurrentIfNeeded() async {
    final keyword = state.keyword;
    if (keyword.isEmpty) return;
    final needs = switch (state.category) {
      SearchCategory.goods =>
        !state.goods.loading &&
            state.goods.items.isEmpty &&
            state.goods.error != null,
      SearchCategory.blog =>
        !state.blog.loading &&
            state.blog.items.isEmpty &&
            state.blog.error != null,
      SearchCategory.video =>
        !state.video.loading &&
            state.video.items.isEmpty &&
            state.video.error != null,
    };
    if (!needs) return;
    await search(keyword);
  }

  Future<void> search(String keyword) async {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return;

    state = state.copyWith(
      keyword: trimmed,
      blog: state.blog.copyWith(
        loading: true,
        loadingMore: false,
        error: null,
        pageNo: 1,
      ),
      video: state.video.copyWith(
        loading: true,
        loadingMore: false,
        error: null,
        pageNo: 1,
      ),
      goods: state.goods.copyWith(
        loading: true,
        loadingMore: false,
        error: null,
        pageNo: 1,
      ),
    );

    await Future.wait([
      _fetchBlog(keyword: trimmed, category: SearchCategory.blog),
      _fetchBlog(keyword: trimmed, category: SearchCategory.video),
      _fetchGoods(keyword: trimmed),
    ]);
  }

  Future<void> loadMore() async {
    final keyword = state.keyword;
    if (keyword.isEmpty) return;
    if (state.loadingCurrent || state.loadingMoreCurrent) return;
    if (!state.hasMoreCurrent) return;

    switch (state.category) {
      case SearchCategory.goods:
        await _fetchGoods(keyword: keyword, loadMore: true);
      case SearchCategory.blog:
      case SearchCategory.video:
        await _fetchBlog(
          keyword: keyword,
          category: state.category,
          loadMore: true,
        );
    }
  }

  Future<void> _fetchGoods({
    required String keyword,
    bool loadMore = false,
  }) async {
    if (!loadMore) {
      state = state.copyWith(
        goods: state.goods.copyWith(
          loading: true,
          loadingMore: false,
          error: null,
        ),
      );
    } else {
      state = state.copyWith(
        goods: state.goods.copyWith(loadingMore: true),
      );
    }

    try {
      final pageNo = loadMore ? state.goods.pageNo + 1 : 1;
      final page = await _repo.searchGoods(
        pageNo,
        keyword: keyword,
        pageSize: pageSize,
      );
      if (!ref.mounted || state.keyword != keyword) return;
      final nextItems = loadMore
          ? [...state.goods.items, ...page.list]
          : List<MallProduct>.from(page.list);
      state = state.copyWith(
        goods: state.goods.copyWith(
          items: nextItems,
          pageNo: pageNo,
          total: page.total,
          loading: false,
          loadingMore: false,
          error: null,
        ),
      );
    } catch (e) {
      if (!ref.mounted || state.keyword != keyword) return;
      state = state.copyWith(
        goods: state.goods.copyWith(
          loading: false,
          loadingMore: false,
          error: loadMore ? state.goods.error : e.toString(),
        ),
      );
    }
  }

  Future<void> _fetchBlog({
    required String keyword,
    required SearchCategory category,
    bool loadMore = false,
  }) async {
    assert(
      category == SearchCategory.blog || category == SearchCategory.video,
    );
    final blogType = category.blogTypeFilter!;
    final isVideo = category == SearchCategory.video;
    final bucket = isVideo ? state.video : state.blog;

    if (!loadMore) {
      final next = bucket.copyWith(
        loading: true,
        loadingMore: false,
        error: null,
      );
      state = isVideo
          ? state.copyWith(video: next)
          : state.copyWith(blog: next);
    } else {
      final next = bucket.copyWith(loadingMore: true);
      state = isVideo
          ? state.copyWith(video: next)
          : state.copyWith(blog: next);
    }

    try {
      final current = isVideo ? state.video : state.blog;
      final pageNo = loadMore ? current.pageNo + 1 : 1;
      final page = await _repo.searchBlogs(
        pageNo,
        keyword: keyword,
        blogType: blogType,
        pageSize: pageSize,
      );
      if (!ref.mounted || state.keyword != keyword) return;
      final list = page.list ?? const <BlogItem>[];
      final nextItems =
          loadMore ? [...current.items, ...list] : List<BlogItem>.from(list);
      final next = current.copyWith(
        items: nextItems,
        pageNo: pageNo,
        total: page.total ?? list.length,
        loading: false,
        loadingMore: false,
        error: null,
      );
      state = isVideo
          ? state.copyWith(video: next)
          : state.copyWith(blog: next);
    } catch (e) {
      if (!ref.mounted || state.keyword != keyword) return;
      final current = isVideo ? state.video : state.blog;
      final next = current.copyWith(
        loading: false,
        loadingMore: false,
        error: loadMore ? current.error : e.toString(),
      );
      state = isVideo
          ? state.copyWith(video: next)
          : state.copyWith(blog: next);
    }
  }
}

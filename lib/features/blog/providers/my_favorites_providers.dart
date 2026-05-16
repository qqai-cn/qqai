import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/blog_page_model.dart';
import '../data/repos/blog_repo.dart';

part 'my_favorites_providers.freezed.dart';
part 'my_favorites_providers.g.dart';

@freezed
sealed class MyFavoritesState with _$MyFavoritesState {
  const factory MyFavoritesState({
    @Default(const AsyncLoading()) AsyncValue<BlogPageModelData> pageData,
    @Default([]) List<BlogItem> allItems,
    @Default(1) int currentPage,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    String? error,
  }) = _MyFavoritesState;
}

@riverpod
class MyFavoritesNotifier extends _$MyFavoritesNotifier {
  late final IBlogRepo _repo;

  @override
  MyFavoritesState build() {
    _repo = ref.read(blogRepoProvider);
    Future.microtask(() => load());
    return const MyFavoritesState();
  }

  Future<void> load() async {
    state = state.copyWith(pageData: const AsyncLoading(), error: null);
    try {
      final page = await _repo.getMyFavoritesPage(1);
      state = state.copyWith(
        pageData: AsyncData(page),
        allItems: page.list ?? [],
        currentPage: 1,
        hasMore: (page.list?.length ?? 0) >= 10,
      );
    } catch (e, st) {
      state = state.copyWith(pageData: AsyncError(e, st), error: e.toString());
    }
  }

  Future<void> refresh() async {
    try {
      final page = await _repo.getMyFavoritesPage(1);
      state = state.copyWith(
        pageData: AsyncData(page),
        allItems: page.list ?? [],
        currentPage: 1,
        hasMore: (page.list?.length ?? 0) >= 10,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final next = state.currentPage + 1;
      final page = await _repo.getMyFavoritesPage(next);
      final list = page.list ?? [];
      state = state.copyWith(
        allItems: [...state.allItems, ...list],
        currentPage: next,
        hasMore: list.length >= 10,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/square_model.dart';
import '../data/repos/square_repo.dart';

part 'square_providers.freezed.dart';
part 'square_providers.g.dart';

@freezed
sealed class SquareListState with _$SquareListState {
  const factory SquareListState({
    @Default(AsyncLoading()) AsyncValue<SquarePageData> pageData,
    @Default([]) List<SquareItem> allItems,
    @Default(1) int currentPage,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    String? error,
  }) = _SquareListState;
}

@Riverpod(keepAlive: true)
class SquareNotifier extends _$SquareNotifier {
  static const int _pageSize = 20;

  late final ISquareRepo _repo;
  bool _loading = false;

  @override
  SquareListState build() {
    _repo = ref.read(squareRepoProvider);
    Future.microtask(() => load());
    return const SquareListState();
  }

  bool _computeHasMore(SquarePageData data, List<SquareItem> items) {
    final total = data.total;
    if (total != null) {
      return items.length < total;
    }
    return (data.list?.length ?? 0) >= _pageSize;
  }

  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    state = state.copyWith(pageData: const AsyncLoading(), error: null);
    try {
      final data = await _repo.getSquarePage(1, pageSize: _pageSize);
      if (!ref.mounted) return;
      final list = data.list ?? [];
      state = state.copyWith(
        pageData: AsyncData(data),
        allItems: list,
        currentPage: 1,
        hasMore: _computeHasMore(data, list),
        isLoadingMore: false,
      );
    } catch (e, st) {
      if (!ref.mounted) return;
      state = state.copyWith(
        pageData: AsyncError(e, st),
        error: e.toString(),
      );
    } finally {
      _loading = false;
    }
  }

  Future<void> refresh() async {
    try {
      final data = await _repo.getSquarePage(1, pageSize: _pageSize);
      if (!ref.mounted) return;
      final list = data.list ?? [];
      state = state.copyWith(
        pageData: AsyncData(data),
        allItems: list,
        currentPage: 1,
        hasMore: _computeHasMore(data, list),
        isLoadingMore: false,
        error: null,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || _loading) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.currentPage + 1;
      final data = await _repo.getSquarePage(nextPage, pageSize: _pageSize);
      if (!ref.mounted) return;
      final newItems = data.list ?? [];
      final merged = [...state.allItems, ...newItems];
      final total = state.pageData.value?.total ?? data.total;
      final pageData = state.pageData.value ?? data;
      state = state.copyWith(
        pageData: AsyncData(
          pageData.copyWith(total: total, list: merged),
        ),
        allItems: merged,
        currentPage: nextPage,
        hasMore: _computeHasMore(
          SquarePageData(total: total, list: newItems),
          merged,
        ),
        isLoadingMore: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> toggleFollow(SquareItem square) async {
    final squareId = square.id;
    if (squareId == null) return;

    final wasFollowed = square.followedByMe == true;
    _replaceSquare(squareId, square.copyWith(followedByMe: !wasFollowed));
    try {
      if (wasFollowed) {
        await _repo.unfollowSquare(squareId);
      } else {
        await _repo.followSquare(squareId);
      }
    } catch (e) {
      if (!ref.mounted) return;
      _replaceSquare(squareId, square.copyWith(followedByMe: wasFollowed));
      state = state.copyWith(error: e.toString());
    }
  }

  void _replaceSquare(int squareId, SquareItem next) {
    final items = [
      for (final item in state.allItems)
        if (item.id == squareId) next else item,
    ];
    final pageData = state.pageData.value;
    state = state.copyWith(
      allItems: items,
      pageData: pageData == null
          ? state.pageData
          : AsyncData(pageData.copyWith(list: items)),
    );
  }
}

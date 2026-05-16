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
    @Default(false) bool isLoadingMore,
    String? error,
  }) = _SquareListState;
}

@Riverpod(keepAlive: true)
class SquareNotifier extends _$SquareNotifier {
  late final ISquareRepo _repo;

  @override
  SquareListState build() {
    _repo = ref.read(squareRepoProvider);
    Future.microtask(() => load());
    return const SquareListState();
  }

  Future<void> load() async {
    state = state.copyWith(pageData: const AsyncLoading(), error: null);
    try {
      final list = await _repo.getSquareList();
      if (!ref.mounted) return;
      state = state.copyWith(
        pageData: AsyncData(SquarePageData(total: list.length, list: list)),
        allItems: list,
        isLoadingMore: false,
      );
    } catch (e, st) {
      if (!ref.mounted) return;
      state = state.copyWith(
        pageData: AsyncError(e, st),
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    try {
      final list = await _repo.getSquareList();
      if (!ref.mounted) return;
      state = state.copyWith(
        pageData: AsyncData(SquarePageData(total: list.length, list: list)),
        allItems: list,
        isLoadingMore: false,
        error: null,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(error: e.toString());
    }
  }
}

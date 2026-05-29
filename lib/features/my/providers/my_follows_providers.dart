import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/profile_models.dart';
import '../data/repos/profile_repo.dart';

part 'my_follows_providers.freezed.dart';
part 'my_follows_providers.g.dart';

@freezed
sealed class MyFollowsState with _$MyFollowsState {
  const factory MyFollowsState({
    @Default(AsyncLoading()) AsyncValue<BlogFollowMemberPageData> pageData,
    @Default([]) List<BlogFollowMember> allItems,
    @Default(1) int currentPage,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    String? error,
    @Default({}) Set<int> unfollowingIds,
  }) = _MyFollowsState;
}

@riverpod
class MyFollowsNotifier extends _$MyFollowsNotifier {
  late final IProfileRepo _repo;

  @override
  MyFollowsState build() {
    _repo = ref.read(profileRepoProvider);
    Future.microtask(() {
      if (ref.mounted) load();
    });
    return const MyFollowsState();
  }

  Future<void> load() async {
    state = state.copyWith(pageData: const AsyncLoading(), error: null);
    try {
      final page = await _repo.getMyFollowMembersPage(1);
      if (!ref.mounted) return;
      final list = page.list ?? [];
      state = state.copyWith(
        pageData: AsyncData(page),
        allItems: list,
        currentPage: 1,
        hasMore: list.length >= 20,
      );
    } catch (e, st) {
      if (!ref.mounted) return;
      state = state.copyWith(pageData: AsyncError(e, st), error: e.toString());
    }
  }

  Future<void> refresh() async {
    try {
      final page = await _repo.getMyFollowMembersPage(1);
      if (!ref.mounted) return;
      final list = page.list ?? [];
      state = state.copyWith(
        pageData: AsyncData(page),
        allItems: list,
        currentPage: 1,
        hasMore: list.length >= 20,
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
      final next = state.currentPage + 1;
      final page = await _repo.getMyFollowMembersPage(next);
      if (!ref.mounted) return;
      final list = page.list ?? [];
      state = state.copyWith(
        allItems: [...state.allItems, ...list],
        currentPage: next,
        hasMore: list.length >= 20,
        isLoadingMore: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  Future<String?> unfollow(BlogFollowMember member) async {
    final userId = member.memberUserId;
    if (userId == null) return '无法取消关注：缺少用户编号';
    if (state.unfollowingIds.contains(userId)) return null;
    state = state.copyWith(unfollowingIds: {...state.unfollowingIds, userId});
    try {
      await _repo.unfollowUser(userId);
      if (!ref.mounted) return null;
      final nextItems =
          state.allItems.where((m) => m.memberUserId != userId).toList();
      state = state.copyWith(
        allItems: nextItems,
        unfollowingIds: Set<int>.from(state.unfollowingIds)..remove(userId),
      );
      return null;
    } catch (e) {
      if (!ref.mounted) return e.toString();
      state = state.copyWith(
        unfollowingIds: Set<int>.from(state.unfollowingIds)..remove(userId),
        error: e.toString(),
      );
      return e.toString();
    }
  }
}

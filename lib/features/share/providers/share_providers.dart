import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../components/imgpreview/preview_img.dart';
import '../../../router/app_routes.dart';
import '../data/models/share_page_model.dart';
import '../data/repos/share_repo.dart';
import '../data/models/share_model.dart';

part 'share_providers.freezed.dart';  
part 'share_providers.g.dart';

@freezed
sealed class ShareState with _$ShareState {
  const factory ShareState({
    // freezed 的 @Default 必须是 const
    @Default(AsyncLoading()) AsyncValue<SharePageModelData> sharePageModelData,
    @Default([]) List<ShareItem> allItems,
    @Default(1) int currentPage,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    String? error,
  }) = _ShareState;
}

@riverpod
class ShareNotifier extends _$ShareNotifier {
  late final IShareRepo _repo;
  var _isDisposed = false;

  void _setStateIfAlive(ShareState newState) {
    if (_isDisposed) return;
    state = newState;
  }

  @override
  ShareState build() {
    _isDisposed = false;
    _repo = ref.read(shareRepoProvider);
    ref.onDispose(() {
      _isDisposed = true;
    });
    Future.microtask(() {
      if (_isDisposed) return;
      load();
    });
    return const ShareState();
  }

  Future<void> load() async {
    if (_isDisposed) return;
    _setStateIfAlive(
      state.copyWith(sharePageModelData: const AsyncLoading(), error: null),
    );
    try {
      final items = await _repo.getSharePageModelWithPage(1);
      if (_isDisposed) return;
      _setStateIfAlive(state.copyWith(
        sharePageModelData: AsyncData(items),
        allItems: items.list ?? [],
        currentPage: 1,
        hasMore: (items.list?.length ?? 0) >= 10,
      ));
    } catch (e, st) {
      if (_isDisposed) return;
      _setStateIfAlive(
        state.copyWith(
          sharePageModelData: AsyncError(e, st),
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> refresh() async {
    try {
      final items = await _repo.getSharePageModelWithPage(1);
      if (_isDisposed) return;
      _setStateIfAlive(state.copyWith(
        sharePageModelData: AsyncData(items),
        allItems: items.list ?? [],
        currentPage: 1,
        hasMore: (items.list?.length ?? 0) >= 10,
      ));
    } catch (e) {
      if (_isDisposed) return;
      _setStateIfAlive(state.copyWith(error: e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    _setStateIfAlive(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.currentPage + 1;
      final items = await _repo.getSharePageModelWithPage(nextPage);
      if (_isDisposed) return;
      final newItems = items.list ?? [];
      _setStateIfAlive(state.copyWith(
        allItems: [...state.allItems, ...newItems],
        currentPage: nextPage,
        hasMore: newItems.length >= 10,
        isLoadingMore: false,
      ));
    } catch (e) {
      if (_isDisposed) return;
      _setStateIfAlive(state.copyWith(isLoadingMore: false, error: e.toString()));
    }
  }

  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    final newItem = ShareModel(
      id: const Uuid().v4(),
      title: title,
      isDone: false,
    );
    try {
      await _repo.addShare(newItem);
      await load();
    } catch (e) {
      if (_isDisposed) return;
      _setStateIfAlive(state.copyWith(error: '添加失败: $e'));
    }
  }

  Future<void> toggle(String id) async {
    final item = await _repo.getShareById(id);
    if (item == null) return;
    final updated = item.copyWith(isDone: !item.isDone);
    try {
      await _repo.updateShare(updated);
      await load();
    } catch (e) {
      if (_isDisposed) return;
      _setStateIfAlive(state.copyWith(error: '更新失败: $e'));
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteShare(id);
      await load();
    } catch (e) {
      if (_isDisposed) return;
      _setStateIfAlive(state.copyWith(error: '删除失败: $e'));
    }
  }

  // 跳转到博客详情页
  void onShareItemTap(BuildContext context, ShareItem blogItem) {
    if (blogItem.blogType == 1) {
      context.push(Routes.shareImgDetailView, extra: blogItem);
    } else {
      context.push(Routes.shareVideoDetailView, extra: blogItem);
    }
  }

  // 跳转到图片预览页
  void onBlogImgItemTap(
      BuildContext context,
      ShareItem blogItem,
      int index,
      String heroTag,
      List<String> imageUrls,
      ) {
    PreviewImg previewImg = PreviewImg().copyWith(
      id: blogItem.id!.toInt(),
      url: blogItem.resources,
      index: index,
      heroTag: heroTag,
      allUris: imageUrls,
    );
    context.push(Routes.watchImgUrl, extra: previewImg);
  }

  // 点击头像事件
  void onUserAvatarTap(BuildContext context, ShareItem blogItem) {
    context.push(Routes.whatArticle, extra: blogItem);
  }

  // 关注
  void onCareTap(ShareItem blogItem) {
    // TODO: 实现关注功能
  }

  // 点赞
  void onZanTap(ShareItem blogItem) {
    // TODO: 实现点赞功能
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

  double getVideoItemHeightWithWidth(int colCount, double screenWidth) {
    double widthItem = screenWidth;
    if (colCount > 1) {
      widthItem = widthItem * 0.5;
    }
    return widthItem / (15 / 9) + 150;
  }
}

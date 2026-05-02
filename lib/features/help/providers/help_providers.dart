import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../components/imgpreview/preview_img.dart';
import '../../../router/app_routes.dart';
import '../../blog/data/models/blog_page_model.dart';
import '../data/models/help_page_model.dart';
import '../data/repos/help_repo.dart';
import '../data/models/help_model.dart';

part 'help_providers.freezed.dart';  
part 'help_providers.g.dart';

@freezed
sealed class HelpState with _$HelpState {
  const factory HelpState({
    // freezed 的 @Default 必须是 const
    @Default(const AsyncLoading()) AsyncValue<HelpPageModelData> helpPageModelData,
    @Default([]) List<HelpItem> allItems,
    @Default(1) int currentPage,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    String? error,
  }) = _HelpState;
}

@riverpod
class HelpNotifier extends _$HelpNotifier {
  late final IHelpRepo _repo;

  @override
  HelpState build() {
    _repo = ref.read(helpRepoProvider);
    Future.microtask(() => load());
    return const HelpState();
  }

  Future<void> load() async {
    state = state.copyWith(helpPageModelData: const AsyncLoading(), error: null);
    try {
      final items = await _repo.getHelpPageModelDataWithPage(1);
      state = state.copyWith(
        helpPageModelData: AsyncData(items),
        allItems: items.list ?? [],
        currentPage: 1,
        hasMore: (items.list?.length ?? 0) >= 10,
      );
    } catch (e, st) {
      state = state.copyWith(helpPageModelData: AsyncError(e, st), error: e.toString());
    }
  }

  Future<void> refresh() async {
    try {
      final items = await _repo.getHelpPageModelDataWithPage(1);
      state = state.copyWith(
        helpPageModelData: AsyncData(items),
        allItems: items.list ?? [],
        currentPage: 1,
        hasMore: (items.list?.length ?? 0) >= 10,
      );
    } catch (e, st) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.currentPage + 1;
      final items = await _repo.getHelpPageModelDataWithPage(nextPage);
      final newItems = items.list ?? [];
      state = state.copyWith(
        allItems: [...state.allItems, ...newItems],
        currentPage: nextPage,
        hasMore: newItems.length >= 10,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    final newItem = HelpModel(
      id: const Uuid().v4(),
      title: title,
      isDone: false,
    );
    try {
      await _repo.addHelp(newItem);
      await load();
    } catch (e) {
      state = state.copyWith(error: '添加失败: $e');
    }
  }

  Future<void> toggle(String id) async {
    final item = await _repo.getHelpById(id);
    if (item == null) return;
    final updated = item.copyWith(isDone: !item.isDone);
    try {
      await _repo.updateHelp(updated);
      await load();
    } catch (e) {
      state = state.copyWith(error: '更新失败: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteHelp(id);
      await load();
    } catch (e) {
      state = state.copyWith(error: '删除失败: $e');
    }
  }

  // 跳转到博客详情页
  void onHelpItemTap(BuildContext context, HelpItem blogItem) {
    if (blogItem.blogType == 1) {
      context.push(Routes.helpImgDetailView, extra: blogItem);
    } else {
      context.push(Routes.helpVideoDetailView, extra: blogItem);
    }
  }

  // 跳转到图片预览页
  void onBlogImgItemTap(
      BuildContext context,
      HelpItem blogItem,
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
  void onUserAvatarTap(BuildContext context, HelpItem blogItem) {
    context.push(Routes.whatArticle, extra: blogItem);
  }

  // 关注
  void onCareTap(HelpItem blogItem) {
    // TODO: 实现关注功能
  }

  // 点赞
  void onZanTap(HelpItem blogItem) {
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


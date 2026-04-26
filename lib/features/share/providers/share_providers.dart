import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    @Default(const AsyncLoading()) AsyncValue<SharePageModelData> sharePageModelData,
    String? error,
  }) = _ShareState;
}

@riverpod
class ShareNotifier extends _$ShareNotifier {
  late final IShareRepo _repo;

  @override
  ShareState build() {
    _repo = ref.read(shareRepoProvider);
    Future.microtask(() => load());
    return const ShareState();
  }

  Future<void> load() async {
    state = state.copyWith(sharePageModelData: const AsyncLoading(), error: null);
    try {
      final items = await _repo.getSharePageModel("1");
      state = state.copyWith(sharePageModelData: AsyncData(items));
    } catch (e, st) {
      state = state.copyWith(sharePageModelData: AsyncError(e, st), error: e.toString());
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
      state = state.copyWith(error: '添加失败: $e');
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
      state = state.copyWith(error: '更新失败: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteShare(id);
      await load();
    } catch (e) {
      state = state.copyWith(error: '删除失败: $e');
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


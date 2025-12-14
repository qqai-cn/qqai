import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../components/imgcomment/previewImg.dart';
import '../../../blog/data/blog_repo.dart';
import '../../../blog/domain/blog_page_model.dart';
import '../../../../router/app_routes.dart';
import '../../../blog/presentation/providers/blog_providers.dart';

part 'share_providers.freezed.dart';
part 'share_providers.g.dart';

// ShareController 状态（与 BlogController 类似）- 使用 Freezed
@freezed
sealed class ShareState with _$ShareState {
  const factory ShareState({
    BlogPageModel? blogPageModel,
    int? total,
    @Default([]) List<BlogItem> blogItems,
    @Default(false) bool isLoading,
    @Default('') String error,
    @Default(0.0) double scrollOffset,
  }) = _ShareState;
}

// ShareController Provider - 使用 Riverpod 3 代码生成（family）
@riverpod
class ShareNotifier extends _$ShareNotifier {
  @override
  ShareState build(int category) {
    final repo = ref.watch(blogRepoProvider);
    const state = ShareState();
    // 初始化后加载数据
    Future.microtask(() => loadBlogPageModel(repo));
    return state;
  }

  BlogRepo get blogPageRepo => ref.watch(blogRepoProvider);

  Future<void> loadBlogPageModel(BlogRepo repo) async {
    try {
      state = state.copyWith(isLoading: true, error: '');
      BlogPageModel res = await repo.getBlogPageModel(1);
      state = state.copyWith(
        blogPageModel: res,
        total: res.data?.total?.toInt(),
        blogItems: res.data?.list ?? [],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // 跳转到博客详情页
  void onBlogItemTap(BuildContext context, BlogItem blogItem) {
    if (blogItem.blogType == 1) {
      context.push(Routes.whatArticle, extra: blogItem);
    } else {
      context.push(Routes.watchVideo, extra: blogItem);
    }
  }

  // 跳转到图片预览页
  void onBlogImgItemTap(BuildContext context, BlogItem blogItem, int index, String heroTag) {
    PreviewImg previewImg = PreviewImg().copyWith(
      id: blogItem.id,
      url: blogItem.resources,
      index: index,
      heroTag: heroTag,
    );
    context.push(Routes.watchImgUrl, extra: previewImg);
  }

  // 点击头像事件
  void onUserAvatarTap(BuildContext context, BlogItem blogItem) {
    context.push(Routes.whatArticle, extra: blogItem);
  }

  // 关注
  void onCareTap(BlogItem blogItem) {
    // TODO: 实现关注功能
  }

  // 点赞
  void onZanTap(BlogItem blogItem) {
    // TODO: 实现点赞功能
  }

  void setScrollOffset(double curScrollOffset) {
    state = state.copyWith(scrollOffset: curScrollOffset);
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

// Provider 已通过代码生成自动创建为 shareNotifierProvider (family)


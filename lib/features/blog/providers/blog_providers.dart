import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../components/imgpreview/preview_img.dart';
import '../../../router/app_routes.dart';
import '../data/blog_repo.dart';
import '../domain/blog_page_model.dart';

part 'blog_providers.freezed.dart';
part 'blog_providers.g.dart';

// BlogRepo Provider - 使用 Riverpod 3 代码生成
@riverpod
BlogRepo blogRepo(Ref ref) {
  return BlogRepo();
}

// BlogController 状态 - 使用 Freezed
@freezed
sealed class BlogState with _$BlogState {
  const factory BlogState({
    BlogPageModel? blogPageModel,
    int? total,
    @Default([]) List<BlogItem> blogItems,
    @Default(false) bool isLoading,
    @Default('') String error,
    @Default(0.0) double scrollOffset,
  }) = _BlogState;
}

// BlogController Provider - 使用 Riverpod 3 代码生成（family）
@riverpod
class BlogNotifier extends _$BlogNotifier {
  @override
  Future<BlogState> build(int category) async {
    final repo = ref.read(blogRepoProvider);
    
    try {
      final res = await repo.getBlogPageModel(1);
      return BlogState(
        blogPageModel: res,
        total: res.data?.total?.toInt() ?? 0,
        blogItems: res.data?.list ?? [],
        isLoading: false,
        error: '',
        scrollOffset: 0.0,
      );
    } catch (e, stack) {
      // 打印错误，方便调试
      debugPrint('Blog load error: $e\n$stack');
      return BlogState(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // 刷新方法
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(category));
  }

  // 跳转到博客详情页
  void onBlogItemTap(BuildContext context, BlogItem blogItem) {
    if (blogItem.blogType == 1) {
      context.push(Routes.imageFlowPage, extra: blogItem);
    } else {
      context.push(Routes.videoFlowPage, extra: blogItem);
    }
  }

  // 跳转到图片预览页
  void onBlogImgItemTap(
      BuildContext context, BlogItem blogItem, int index, String heroTag, List<String> imageUrls) {
    PreviewImg previewImg = PreviewImg(
      id: blogItem.id?.toInt(),
      url: blogItem.resources,
      index: index,
      heroTag: heroTag,
      allUris: imageUrls
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
    // state = state.copyWith(scrollOffset: curScrollOffset);
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

  // 动态根据图片个数算item高度
  static double getImgItemHeight(
      int itemCount, double length, int colCount, double screenWidth) {
    length = length == 0 ? 100 : length;
    double widthItem = screenWidth;
    if (colCount > 1) {
      widthItem = widthItem * 0.5;
    }
    length =
        '长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。'.length.toDouble();
    length = length * 22;
    double lineCount = (length / widthItem).ceilToDouble();
    double wordHeight = (lineCount > 3 ? 3 : lineCount) * 30 + 102;
    // 没有图片的时候
    if (itemCount == 0) {
      return wordHeight;
    }
    // 静态方法中调用静态方法计算图片网格高度
    double imgGridHeight = _getImgGridHeightStatic(itemCount);
    return imgGridHeight + wordHeight;
  }

  static double _getImgGridHeightStatic(int itemCount) {
    if (itemCount == 1) {
      return 500;
    } else if (itemCount > 1 && itemCount <= 3) {
      return 300;
    } else {
      return 600;
    }
  }

  double getVideoItemHeight(int colCount) {
    // 使用屏幕宽度，需要从外部传入
    // 这里返回一个基础值，实际使用时应该传入屏幕宽度
    return 300.0; // 临时值，需要在调用时传入实际屏幕宽度
  }

  double getVideoItemHeightWithWidth(int colCount, double screenWidth) {
    double widthItem = screenWidth;
    if (colCount > 1) {
      widthItem = widthItem * 0.5;
    }
    return widthItem / (15 / 9) + 150;
  }
}

final commentPanelVisibleProvider = StateProvider<bool>((ref) => false);
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../components/imgpreview/preview_img.dart';
import '../../../router/app_routes.dart';
import '../data/models/blog_model.dart';
import '../data/models/blog_page_model.dart';
import '../data/repos/blog_repo.dart';
import '../data/models/blog_save_req_vo.dart';

part 'blog_providers.freezed.dart';
part 'blog_providers.g.dart';

@freezed
sealed class BlogState with _$BlogState {
  const factory BlogState({
    // freezed 的 @Default 必须是 const
    @Default(const AsyncLoading()) AsyncValue<BlogPageModelData> blogPageData,
    @Default([]) List<BlogItem> allItems,
    @Default(1) int currentPage,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    String? error,
  }) = _BlogState;
}

@riverpod
class BlogNotifier extends _$BlogNotifier {
  late final IBlogRepo _repo;

  @override
  BlogState build() {
    _repo = ref.read(blogRepoProvider);
    Future.microtask(() => load());
    return const BlogState();
  }


  Future<void> load() async {
    state = state.copyWith(blogPageData: const AsyncLoading(), error: null);
    try {
      final items = await _repo.getBlogPageModelDataWithPage(1);
      state = state.copyWith(
        blogPageData: AsyncData(items),
        allItems: items.list ?? [],
        currentPage: 1,
        hasMore: (items.list?.length ?? 0) >= 10,
      );
    } catch (e, st) {
      state = state.copyWith(
        blogPageData: AsyncError(e, st),
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    try {
      final items = await _repo.getBlogPageModelDataWithPage(1);
      state = state.copyWith(
        blogPageData: AsyncData(items),
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
      final items = await _repo.getBlogPageModelDataWithPage(nextPage);
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
    final newItem = BlogModel(
      id: const Uuid().v4(),
      title: title,
      isDone: false,
    );
    try {
      await _repo.addBlog(newItem);
      await load();
    } catch (e) {
      state = state.copyWith(error: '添加失败: $e');
    }
  }

  Future<void> toggle(String id) async {
    final item = await _repo.getBlogById(id);
    if (item == null) return;
    final updated = item.copyWith(isDone: !item.isDone);
    try {
      await _repo.updateBlog(updated);
      await load();
    } catch (e) {
      state = state.copyWith(error: '更新失败: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteBlog(id);
      await load();
    } catch (e) {
      state = state.copyWith(error: '删除失败: $e');
    }
  }

  // 跳转到博客详情页
  void onBlogItemTap(BuildContext context, BlogItem blogItem) {
    if (blogItem.blogType == 1) {
      context.push(Routes.blogImgDetailView, extra: blogItem);
    } else {
      context.push(Routes.blogVideoDetailView, extra: blogItem);
    }
  }

  // 跳转到图片预览页
  void onBlogImgItemTap(
    BuildContext context,
    BlogItem blogItem,
    int index,
    String heroTag,
    List<String> imageUrls,
  ) {
    PreviewImg previewImg = PreviewImg(
      id: blogItem.id?.toInt(),
      url: blogItem.resources,
      index: index,
      heroTag: heroTag,
      allUris: imageUrls,
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

  Future<void> createBlog(BlogSaveReqVO req) async {
    try {
      await _repo.createBlog(req);
    } catch (e) {
      state = state.copyWith(error: '发布失败: $e');
      rethrow;
    }
  }

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
    int itemCount,
    double length,
    int colCount,
    double screenWidth,
  ) {
    length = length == 0 ? 100 : length;
    double widthItem = screenWidth;
    if (colCount > 1) {
      widthItem = widthItem * 0.5;
    }
    length = '长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。'.length
        .toDouble();
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

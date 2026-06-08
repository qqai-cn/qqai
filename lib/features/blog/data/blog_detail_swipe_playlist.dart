import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/data/repos/blog_repo.dart';
import 'package:qqai/features/my/data/repos/profile_repo.dart';

/// 详情页当前生效的合集（优先侧栏选中，否则取博客首个合集）。
BlogItemCollection? effectiveBlogDetailCollection(
  BlogItem blog,
  BlogItemCollection? selected,
) {
  final collections = blog.collections ?? const <BlogItemCollection>[];
  if (collections.isEmpty) return null;
  final selectedId = selected?.id;
  if (selectedId != null) {
    for (final collection in collections) {
      if (collection.id == selectedId) return collection;
    }
  }
  return collections.first;
}

/// 详情页上下滑播放列表：有合集按合集顺序，否则按相关推荐（当前篇置顶）。
Future<List<BlogItem>> loadBlogDetailSwipePlaylist({
  required WidgetRef ref,
  required BlogItem currentBlog,
  BlogItemCollection? collection,
}) async {
  final blogType = currentBlog.blogType;
  final currentId = currentBlog.id;
  final collectionId = collection?.id;

  if (collectionId != null && collection != null) {
    final detail = await ref
        .read(profileRepoProvider)
        .getCollectionDetail(collectionId);
    return (detail.blogs ?? [])
        .where(
          (b) =>
              b.id != null && (blogType == null || b.blogType == blogType),
        )
        .map((b) => b.copyWith(collections: [collection]))
        .toList();
  }

  final page = await ref.read(blogRepoProvider).getBlogPageModelDataWithPage(
    1,
    pageSize: 20,
    blogType: blogType,
    categary: currentBlog.categary,
  );
  final related = (page.list ?? [])
      .where((b) => b.id != null && b.id != currentId)
      .toList();
  if (currentId == null) return related;
  return [currentBlog, ...related];
}

int blogDetailSwipeInitialIndex(List<BlogItem> playlist, BlogItem current) {
  final currentId = current.id;
  if (currentId == null) return 0;
  final index = playlist.indexWhere((b) => b.id == currentId);
  return index < 0 ? 0 : index;
}

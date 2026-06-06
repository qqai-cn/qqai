import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/blog_page_model.dart';
import '../data/repos/blog_repo.dart';
import '../views/blog_img_detail_view.dart';
import '../views/blog_video_detail_view.dart';

/// 通过分享链接中的 `?id=` 加载博客详情。
class BlogDetailByIdLoader extends ConsumerStatefulWidget {
  const BlogDetailByIdLoader({super.key, required this.blogId});

  final int blogId;

  @override
  ConsumerState<BlogDetailByIdLoader> createState() =>
      _BlogDetailByIdLoaderState();
}

class _BlogDetailByIdLoaderState extends ConsumerState<BlogDetailByIdLoader> {
  late Future<BlogItem?> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(blogRepoProvider).fetchBlogItemById(widget.blogId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BlogItem?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final blog = snapshot.data;
        if (blog == null) {
          return const Scaffold(
            body: Center(child: Text('内容不存在或不可访问，请返回重试')),
          );
        }
        if (blog.blogType == 2) {
          return BlogVideoDetailView(blogItem: blog);
        }
        return BlogImgDetailView(blogItem: blog);
      },
    );
  }
}

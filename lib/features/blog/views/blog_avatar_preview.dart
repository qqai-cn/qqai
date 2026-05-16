import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/imgpreview/preview_img.dart';
import 'package:qqai/router/app_routes.dart';

import '../data/models/blog_page_model.dart';

/// 博客作者头像 Hero 标签（与列表 category、blogId 唯一对应）。
String blogAvatarHeroTag(int category, BlogItem blog) =>
    'blogAvatar-$category-${blog.id ?? blog.userId ?? 0}';

/// 详情页侧栏头像 Hero 标签。
String blogAvatarDetailHeroTag(BlogItem blog) =>
    'blogAvatar-detail-${blog.id ?? blog.userId ?? 0}';

/// 头像大图预览（与博客图片同一套 [Routes.watchImgUrl] + Hero）。
void openBlogAvatarPreview(
  BuildContext context, {
  required BlogItem blog,
  required String heroTag,
  required String imageUrl,
}) {
  context.push(
    Routes.watchImgUrl,
    extra: PreviewImg(
      id: blog.id?.toInt(),
      url: imageUrl,
      index: 0,
      heroTag: heroTag,
      allUris: [imageUrl],
    ),
  );
}

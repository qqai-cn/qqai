import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'preview_img.dart';

class ImageDetailPage extends StatelessWidget {
  final PreviewImg preview;

  const ImageDetailPage({super.key, required this.preview});

  @override
  Widget build(BuildContext context) {
    final urls = preview.allUris;
    if (urls.isEmpty) {
      return const Scaffold(body: Center(child: Text('无图片')));
    }

    final initialIndex = preview.index?.clamp(0, urls.length - 1) ?? 0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          if (context.mounted) Navigator.pop(context); // 点击任意地方返回
        },
        child: PhotoViewGallery.builder(
          // 用 photo_view 包实现多图滑动
          itemCount: urls.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(urls[index]),
              heroAttributes: PhotoViewHeroAttributes(
                tag: '${preview.heroTag}',
              ),
              initialScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2.5,
            );
          },
          pageController: PageController(initialPage: initialIndex),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          scrollPhysics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }
}

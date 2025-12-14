import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'previewImg.dart';
import 'package:qqai/util/navigation_helper.dart';

class ImageDetailPage extends StatelessWidget {
  final dynamic imageItem;

  const ImageDetailPage({super.key, this.imageItem});

  @override
  Widget build(BuildContext context) {
    final PreviewImg? previewImg = imageItem as PreviewImg?;
    if (previewImg == null) {
      return const Scaffold(
        body: Center(child: Text('图片数据为空')),
      );
    }
    
    List<String> urls = previewImg.url!.split(",");
    String heroTag = previewImg.heroTag!;
    return Center(
      child: GestureDetector(
        onTap: () => NavigationHelper.back(context),
        child: Hero(
          tag: heroTag,
          // --- 关键：设置唯一 Tag ---
          child: Image.network(
            urls[previewImg.index!.toInt()],
            fit: BoxFit.cover,
            // height: 150.0,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, size: 50, color: Colors.red);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

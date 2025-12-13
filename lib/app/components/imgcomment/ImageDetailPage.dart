import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qqai/app/components/imgcomment/previewImg.dart';

class ImageDetailPage extends StatelessWidget {
  // 接收图片数据

  @override
  Widget build(BuildContext context) {
    final PreviewImg? imageItem = Get.arguments as PreviewImg?;
    List<String> urls = imageItem!.url!.split(",");
    String heroTag = imageItem.heroTag!;
    return Center(
      child: GestureDetector(
        onTap: Get.back,
        child: Hero(
          tag: heroTag,
          // --- 关键：设置唯一 Tag ---
          child: Image.network(
            urls[imageItem.index!.toInt()],
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

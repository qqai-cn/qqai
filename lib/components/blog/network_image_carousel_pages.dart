import 'package:flutter/material.dart';

/// 逗号分隔资源字段 → URL 列表。
List<String> parseCommaSeparatedUrls(String? raw) {
  return raw
          ?.split(',')
          .map((url) => url.trim())
          .where((url) => url.isNotEmpty)
          .toList() ??
      [];
}

/// 全屏轮播子页：圆角 [Image.network] + 加载/错误占位。
List<Widget> buildNetworkImageCarouselPages(List<String> imageUrls) {
  return imageUrls.map((url) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.error, color: Colors.red),
              ),
            );
          },
        ),
      ),
    );
  }).toList();
}

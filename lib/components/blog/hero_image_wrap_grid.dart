import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'image_tile_layout.dart';

/// Hero + 圆角宫格，点击回调带 index 与 tag。
class HeroImageWrapGrid extends StatelessWidget {
  final List<String> imageUrls;
  final String Function(int index) heroTagBuilder;
  final void Function(int index, String heroTag) onImageTap;

  const HeroImageWrapGrid({
    super.key,
    required this.imageUrls,
    required this.heroTagBuilder,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final parentWidth = constraints.maxWidth;
        final imageCount = imageUrls.length;
        final itemSize = tileExtentForWrapImageGrid(imageCount, parentWidth);
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(imageCount, (i) {
            final url = imageUrls[i];
            final heroTag = heroTagBuilder(i);
            return InkWell(
              onTap: () => onImageTap(i, heroTag),
              child: Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    width: itemSize,
                    height: itemSize,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red, size: 40),
                    fadeInDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/video_player/item_controls.dart';
import 'package:qqai/components/video_player/local_qqai_player.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';

class FabuMediaPreviewTile extends StatelessWidget {
  const FabuMediaPreviewTile({
    super.key,
    required this.file,
    required this.isVideo,
    required this.onRemove,
    this.videoPlayerController,
  });

  final XFile file;
  final bool isVideo;
  final VoidCallback onRemove;
  final LocalQqaiPlayerController? videoPlayerController;

  @override
  Widget build(BuildContext context) {
    final media = isVideo
        ? LocalQqaiPlayer(
            key: ValueKey(file.path),
            file: file,
            playerController: videoPlayerController,
            controls: const ItemControls(),
          )
        : kIsWeb
        ? Image.network(
            file.path,
            fit: BoxFit.cover,
            cacheWidth: 320,
            cacheHeight: 320,
            filterQuality: FilterQuality.low,
            errorBuilder: _buildImageError,
          )
        : Image.file(
            File(file.path),
            fit: BoxFit.cover,
            cacheWidth: 320,
            cacheHeight: 320,
            filterQuality: FilterQuality.low,
            errorBuilder: _buildImageError,
          );
    final preview = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(child: media),
          Positioned(
            right: 8,
            top: isVideo ? 48 : 8,
            child: IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.56),
                minimumSize: const Size(34, 34),
                fixedSize: const Size(34, 34),
              ),
              onPressed: onRemove,
              icon: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );

    if (isVideo) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.light
                      ? 0.08
                      : 0.35,
                ),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            child: LocalVideoAspectRatioBox(
              file: file,
              fallbackAspectRatio: 9 / 16,
              builder: (context, aspectRatio) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth;
                    final width = aspectRatio < 1 ? maxWidth * 0.5 : maxWidth;
                    return Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: width,
                        child: AspectRatio(
                          aspectRatio: aspectRatio,
                          child: preview,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
    }

    final imageSize = 112.w.clamp(96.0, 132.0).toDouble();
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: SizedBox(width: imageSize, height: imageSize, child: preview),
    );
  }

  Widget _buildImageError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      color: GoodsPageStyle.imageBg(context),
      alignment: Alignment.center,
      child: Icon(
        Icons.broken_image_outlined,
        color: AppActionColors.subtle(context),
        size: 30,
      ),
    );
  }
}

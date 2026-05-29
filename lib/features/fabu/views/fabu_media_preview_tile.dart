import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/video_player/item_controls.dart';
import 'package:qqai/components/video_player/local_qqai_player.dart';

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
                errorBuilder: _buildImageError,
              )
            : Image.file(
                File(file.path),
                fit: BoxFit.cover,
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
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 15 / 9,
              child: preview,
            ),
          ),
        ),
      );
    }

    final imageSize = 112.w.clamp(96.0, 132.0).toDouble();
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: SizedBox(
        width: imageSize,
        height: imageSize,
        child: preview,
      ),
    );
  }

  Widget _buildImageError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      color: const Color(0xFFF3F5F8),
      alignment: Alignment.center,
      child: const Icon(
        Icons.broken_image_outlined,
        color: Color(0xFF9CA3AF),
        size: 30,
      ),
    );
  }
}

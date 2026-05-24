import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class FabuMediaPreviewTile extends StatelessWidget {
  const FabuMediaPreviewTile({
    super.key,
    required this.file,
    required this.isVideo,
    required this.onRemove,
  });

  final XFile file;
  final bool isVideo;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final media = isVideo
        ? _FabuLocalVideoPreview(key: ValueKey(file.path), file: file)
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
            top: 8,
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

class _FabuLocalVideoPreview extends StatefulWidget {
  const _FabuLocalVideoPreview({super.key, required this.file});

  final XFile file;

  @override
  State<_FabuLocalVideoPreview> createState() => _FabuLocalVideoPreviewState();
}

class _FabuLocalVideoPreviewState extends State<_FabuLocalVideoPreview> {
  VideoPlayerController? _controller;
  Object? _initError;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(_FabuLocalVideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path) {
      _disposeController();
      _initError = null;
      _initController();
    }
  }

  Future<void> _initController() async {
    final controller = _createController(widget.file);
    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _initError = null;
      });
    } catch (e) {
      await controller.dispose();
      if (mounted) {
        setState(() => _initError = e);
      }
    }
  }

  VideoPlayerController _createController(XFile file) {
    final path = file.path;
    final uri = Uri.tryParse(path);
    if (uri != null && uri.hasScheme && uri.scheme != 'file') {
      return VideoPlayerController.networkUrl(uri);
    }
    if (kIsWeb) {
      return VideoPlayerController.networkUrl(uri ?? Uri.parse(path));
    }
    return VideoPlayerController.file(File(uri?.toFilePath() ?? path));
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  void _togglePlayback() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_initError != null) {
      return Container(
        color: const Color(0xFF1F2937),
        alignment: Alignment.center,
        child: const Icon(
          Icons.videocam_off_outlined,
          color: Colors.white54,
          size: 36,
        ),
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return Container(
        color: const Color(0xFF1F2937),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white70,
        ),
      );
    }

    return GestureDetector(
      onTap: _togglePlayback,
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
            if (!controller.value.isPlaying)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 36),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

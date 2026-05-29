import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// 聊天视频消息气泡：优先展示 [VideoMessage.metadata] 中的封面，点击后播放。
class QqaiChatVideoMessage extends StatefulWidget {
  const QqaiChatVideoMessage({
    super.key,
    required this.message,
    required this.index,
  });

  final VideoMessage message;
  final int index;

  @override
  State<QqaiChatVideoMessage> createState() => _QqaiChatVideoMessageState();
}

class _QqaiChatVideoMessageState extends State<QqaiChatVideoMessage> {
  VideoPlayerController? _controller;
  bool _playing = false;
  bool _initializing = false;

  String? get _coverUrl {
    final cover = widget.message.metadata?['coverUrl'];
    if (cover is String && cover.isNotEmpty) return cover;
    return null;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _startPlayback() async {
    if (_playing || _initializing) return;
    setState(() => _initializing = true);
    try {
      final source = widget.message.source;
      final controller = _controllerForSource(source);
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller?.dispose();
        _controller = controller;
        _playing = true;
        _initializing = false;
      });
      await controller.play();
    } catch (e) {
      debugPrint('chat video play error: $e');
      if (mounted) setState(() => _initializing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select(
      (ChatTheme t) => (
        surfaceContainerLow: t.colors.surfaceContainerLow,
        onSurface: t.colors.onSurface,
        primary: t.colors.primary,
      ),
    );
    final maxWidth = 280.0;
    final message = widget.message;
    final aspectRatio = message.width != null &&
            message.height != null &&
            message.width! > 0 &&
            message.height! > 0
        ? message.width! / message.height!
        : 16 / 9;

    Widget body;
    if (_playing && _controller != null && _controller!.value.isInitialized) {
      body = AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    } else {
      body = Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: aspectRatio,
            child: _coverUrl != null
                ? Image.network(
                    _coverUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(theme),
                  )
                : _placeholder(theme),
          ),
          if (_initializing)
            const CircularProgressIndicator(strokeWidth: 2)
          else
            Icon(Icons.play_circle_fill, size: 48, color: theme.onSurface),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        color: theme.surfaceContainerLow,
        child: GestureDetector(
          onTap: _playing ? null : _startPlayback,
          child: body,
        ),
      ),
    );
  }

  Widget _placeholder(({Color surfaceContainerLow, Color onSurface, Color primary}) theme) {
    return Container(
      color: theme.surfaceContainerLow,
      alignment: Alignment.center,
      child: Icon(Icons.videocam, size: 40, color: theme.onSurface.withValues(alpha: 0.5)),
    );
  }

  VideoPlayerController _controllerForSource(String source) {
    final uri = Uri.tryParse(source);
    if (uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https')) {
      return VideoPlayerController.networkUrl(uri);
    }
    if (!kIsWeb) {
      return VideoPlayerController.file(File(source));
    }
    return VideoPlayerController.networkUrl(Uri.parse(source));
  }
}

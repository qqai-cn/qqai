import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flyer_chat_file_message/flyer_chat_file_message.dart';

import 'chat_file_download.dart';

/// 可点击下载 / 打开的文件消息气泡。
class QqaiChatFileMessage extends StatefulWidget {
  const QqaiChatFileMessage({
    super.key,
    required this.message,
    required this.index,
  });

  final FileMessage message;
  final int index;

  @override
  State<QqaiChatFileMessage> createState() => _QqaiChatFileMessageState();
}

class _QqaiChatFileMessageState extends State<QqaiChatFileMessage> {
  bool _downloading = false;

  Future<void> _onTap() async {
    if (_downloading) return;
    setState(() => _downloading = true);
    try {
      await downloadChatFile(widget.message);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已下载：${chatFileDisplayName(widget.message)}')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('下载失败：$error')),
      );
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            FlyerChatFileMessage(
              message: widget.message,
              index: widget.index,
            ),
            if (_downloading)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

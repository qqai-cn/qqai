import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:qqai/components/chat/qqai_chat_text_message.dart';

import 'stream_state.dart';

/// Demo 用流式文本消息，纯 Text 渲染，不引入 KaTeX 字体。
class QqaiChatTextStreamMessage extends StatelessWidget {
  final TextStreamMessage message;
  final int index;
  final StreamState streamState;
  final EdgeInsetsGeometry? padding;
  final Color? receivedBackgroundColor;
  final TextStyle? receivedTextStyle;
  final bool showTime;
  final bool showStatus;
  final String loadingText;

  const QqaiChatTextStreamMessage({
    super.key,
    required this.message,
    required this.index,
    required this.streamState,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.receivedBackgroundColor,
    this.receivedTextStyle,
    this.showTime = true,
    this.showStatus = true,
    this.loadingText = 'Thinking',
  });

  @override
  Widget build(BuildContext context) {
    final text = switch (streamState) {
      StreamStateLoading() => null,
      StreamStateStreaming(:final accumulatedText) => accumulatedText,
      StreamStateCompleted(:final finalText) => finalText,
      StreamStateError(:final accumulatedText) => accumulatedText,
    };

    if (streamState is StreamStateLoading ||
        (text == null || text.isEmpty)) {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            Text(loadingText),
          ],
        ),
      );
    }

    final resolved = TextMessage(
      id: message.id,
      authorId: message.authorId,
      createdAt: message.createdAt,
      text: text,
    );

    return QqaiChatTextMessage(
      message: resolved,
      index: index,
      padding: padding,
      showTime: showTime,
      showStatus: showStatus,
      receivedBackgroundColor: receivedBackgroundColor,
      receivedTextStyle: receivedTextStyle,
      linkPreviewPosition: LinkPreviewPosition.none,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:provider/provider.dart';
import 'package:qqai/util/chat_message_time_format.dart';

/// 轻量文本消息气泡，用 [SelectableText] 替代 GptMarkdown，避免 KaTeX 字体进包。
class QqaiChatTextMessage extends StatelessWidget {
  final TextMessage message;
  final int index;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final BoxConstraints? constraints;
  final double? onlyEmojiFontSize;
  final Color? sentBackgroundColor;
  final Color? receivedBackgroundColor;
  final TextStyle? sentTextStyle;
  final TextStyle? receivedTextStyle;
  final TextStyle? timeStyle;
  final bool showTime;
  final bool showStatus;
  final TimeAndStatusPosition timeAndStatusPosition;
  final EdgeInsetsGeometry? timeAndStatusPositionInlineInsets;
  final LinkPreviewPosition linkPreviewPosition;
  final Widget? topWidget;

  const QqaiChatTextMessage({
    super.key,
    required this.message,
    required this.index,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.borderRadius,
    this.constraints,
    this.onlyEmojiFontSize = 48,
    this.sentBackgroundColor,
    this.receivedBackgroundColor,
    this.sentTextStyle,
    this.receivedTextStyle,
    this.timeStyle,
    this.showTime = true,
    this.showStatus = true,
    this.timeAndStatusPosition = TimeAndStatusPosition.end,
    this.timeAndStatusPositionInlineInsets = const EdgeInsets.only(bottom: 2),
    this.linkPreviewPosition = LinkPreviewPosition.bottom,
    this.topWidget,
  });

  bool get _isOnlyEmoji => message.metadata?['isOnlyEmoji'] == true;

  @override
  Widget build(BuildContext context) {
    final theme = context.select(
      (ChatTheme t) => (
        bodyMedium: t.typography.bodyMedium,
        labelSmall: t.typography.labelSmall,
        onPrimary: t.colors.onPrimary,
        onSurface: t.colors.onSurface,
        primary: t.colors.primary,
        shape: t.shape,
        surfaceContainer: t.colors.surfaceContainer,
      ),
    );
    final isSentByMe = context.read<UserID>() == message.authorId;
    final backgroundColor = isSentByMe
        ? (sentBackgroundColor ?? theme.primary)
        : (receivedBackgroundColor ?? theme.surfaceContainer);
    final paragraphStyle = isSentByMe
        ? (sentTextStyle ?? theme.bodyMedium.copyWith(color: theme.onPrimary))
        : (receivedTextStyle ??
            theme.bodyMedium.copyWith(color: theme.onSurface));
    final resolvedTimeStyle = isSentByMe
        ? (timeStyle ??
            theme.labelSmall.copyWith(
              color: _isOnlyEmoji ? theme.onSurface : theme.onPrimary,
            ))
        : (timeStyle ?? theme.labelSmall.copyWith(color: theme.onSurface));

    final timeAndStatus = showTime || (isSentByMe && showStatus)
        ? _TimeAndStatus(
            time: message.resolvedTime,
            status: message.resolvedStatus,
            showTime: showTime,
            showStatus: isSentByMe && showStatus,
            textStyle: resolvedTimeStyle,
          )
        : null;

    final textContent = SelectableText(
      message.text,
      style: _isOnlyEmoji
          ? paragraphStyle?.copyWith(fontSize: onlyEmojiFontSize)
          : paragraphStyle,
    );

    final linkPreviewWidget = linkPreviewPosition != LinkPreviewPosition.none
        ? context.read<Builders>().linkPreviewBuilder?.call(
            context,
            message,
            isSentByMe,
          )
        : null;

    return ClipRRect(
      borderRadius: borderRadius ?? theme.shape,
      child: Container(
        constraints: constraints,
        decoration: _isOnlyEmoji ? null : BoxDecoration(color: backgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: _isOnlyEmoji
                  ? EdgeInsets.symmetric(
                      horizontal: (padding?.horizontal ?? 0) / 2,
                      vertical: 0,
                    )
                  : padding,
              child: _buildContent(
                context: context,
                textContent: textContent,
                timeAndStatus: timeAndStatus,
                linkPreviewWidget: linkPreviewWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required Widget textContent,
    _TimeAndStatus? timeAndStatus,
    Widget? linkPreviewWidget,
  }) {
    final textDirection = Directionality.of(context);
    final effectiveLinkPreviewPosition = linkPreviewWidget != null
        ? linkPreviewPosition
        : LinkPreviewPosition.none;

    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (topWidget != null) topWidget!,
            if (effectiveLinkPreviewPosition == LinkPreviewPosition.top)
              linkPreviewWidget!,
            timeAndStatusPosition == TimeAndStatusPosition.inline
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(child: textContent),
                      const SizedBox(width: 4),
                      Padding(
                        padding:
                            timeAndStatusPositionInlineInsets ?? EdgeInsets.zero,
                        child: timeAndStatus,
                      ),
                    ],
                  )
                : textContent,
            if (effectiveLinkPreviewPosition == LinkPreviewPosition.bottom)
              linkPreviewWidget!,
            if (timeAndStatusPosition != TimeAndStatusPosition.inline)
              Opacity(opacity: 0, child: timeAndStatus),
          ],
        ),
        if (timeAndStatusPosition != TimeAndStatusPosition.inline &&
            timeAndStatus != null)
          Positioned.directional(
            textDirection: textDirection,
            end: timeAndStatusPosition == TimeAndStatusPosition.end ? 0 : null,
            start: timeAndStatusPosition == TimeAndStatusPosition.start
                ? 0
                : null,
            bottom: 0,
            child: timeAndStatus,
          ),
      ],
    );
  }
}

class _TimeAndStatus extends StatelessWidget {
  final DateTime? time;
  final MessageStatus? status;
  final bool showTime;
  final bool showStatus;
  final TextStyle? textStyle;

  const _TimeAndStatus({
    required this.time,
    this.status,
    this.showTime = true,
    this.showStatus = true,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 2,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showTime && time != null)
          Text(formatChatMessageTime(time!.toLocal()), style: textStyle),
        if (showStatus && status != null)
          if (status == MessageStatus.sending)
            SizedBox(
              width: 6,
              height: 6,
              child: CircularProgressIndicator(
                color: textStyle?.color,
                strokeWidth: 2,
              ),
            )
          else
            Icon(getIconForStatus(status!), color: textStyle?.color, size: 12),
      ],
    );
  }
}

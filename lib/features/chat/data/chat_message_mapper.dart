import 'package:flutter_chat_core/flutter_chat_core.dart';

import 'chat_message_extra.dart';
import 'models/chat_models.dart';

Message? mapChatMessageDtoToMessage(
  ChatMessageDto dto, {
  String? fallbackLocalId,
}) {
  final idStr =
      dto.id != null ? dto.id!.toString() : (fallbackLocalId ?? '');
  if (idStr.isEmpty) return null;
  final author = dto.senderId?.toString() ?? '0';
  final created = dto.createTimeParsed?.toUtc() ?? DateTime.now().toUtc();
  final sent = dto.createTimeParsed?.toUtc() ?? created;
  final extra = parseChatMessageExtra(dto.extra);

  switch (dto.type) {
    case 1:
      return TextMessage(
        id: idStr,
        authorId: author,
        createdAt: created,
        sentAt: sent,
        text: dto.content ?? '',
      );
    case 2:
      return ImageMessage(
        id: idStr,
        authorId: author,
        createdAt: created,
        sentAt: sent,
        source: dto.content ?? '',
      );
    case 3:
      return FileMessage(
        id: idStr,
        authorId: author,
        createdAt: created,
        sentAt: sent,
        source: dto.content ?? '',
        name: extra?['name'] as String? ?? '语音',
        size: (extra?['size'] as num?)?.toInt() ?? 0,
        mimeType: extra?['mimeType'] as String?,
        metadata: extra,
      );
    case 4:
      return FileMessage(
        id: idStr,
        authorId: author,
        createdAt: created,
        sentAt: sent,
        source: dto.content ?? '',
        name: extra?['name'] as String? ?? '附件',
        size: (extra?['size'] as num?)?.toInt() ?? 0,
        mimeType: extra?['mimeType'] as String?,
        metadata: extra,
      );
    case 5:
      return VideoMessage(
        id: idStr,
        authorId: author,
        createdAt: created,
        sentAt: sent,
        source: dto.content ?? '',
        width: (extra?['width'] as num?)?.toDouble(),
        height: (extra?['height'] as num?)?.toDouble(),
        size: (extra?['size'] as num?)?.toInt(),
        name: extra?['name'] as String?,
        metadata: extra,
      );
    default:
      return TextMessage(
        id: idStr,
        authorId: author,
        createdAt: created,
        sentAt: sent,
        text: dto.content ?? '[消息]',
      );
  }
}

import 'package:flutter_chat_core/flutter_chat_core.dart';

import '../../ai/data/models/ai_chat_models.dart';
import 'chat_message_extra.dart';
import 'models/chat_models.dart';

/// AI 助手在 flutter_chat_ui 中的固定 authorId。
const String kAiChatPeerUserId = 'ai';

Message? mapAiChatMessageDtoToMessage(
  AiChatMessageDto dto, {
  required String currentUserId,
}) {
  final idStr = dto.id?.toString();
  if (idStr == null || idStr.isEmpty) return null;
  final authorId = dto.isUser ? currentUserId : kAiChatPeerUserId;
  final created = DateTime.tryParse(dto.createTime ?? '')?.toUtc() ??
      DateTime.now().toUtc();
  if (dto.type == AiChatMessageDto.typeSystem) {
    return SystemMessage(
      id: idStr,
      authorId: 'system',
      createdAt: created,
      sentAt: created,
      text: dto.content ?? '',
    );
  }
  return TextMessage(
    id: idStr,
    authorId: authorId,
    createdAt: created,
    sentAt: created,
    text: dto.content ?? '',
  );
}

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

import 'package:flutter_chat_core/flutter_chat_core.dart';

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
    case 4:
      return FileMessage(
        id: idStr,
        authorId: author,
        createdAt: created,
        sentAt: sent,
        source: dto.content ?? '',
        name: '附件',
        size: 0,
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

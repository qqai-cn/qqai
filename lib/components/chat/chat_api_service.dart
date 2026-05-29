import 'package:flutter_chat_core/flutter_chat_core.dart';

import '../../features/chat/data/chat_message_extra.dart';
import '../../features/chat/data/repos/chat_repo.dart';

/// 将 [Message] 发到业务接口 `/app-api/infra/chat/message/send`。
class ChatApiService {
  ChatApiService({
    required this.repo,
    required this.conversationId,
  });

  final IChatRepo repo;
  final int conversationId;

  int _messageType(Message message) {
    if (message is TextMessage) return 1;
    if (message is ImageMessage) return 2;
    if (message is FileMessage) return 4;
    if (message is VideoMessage) return 5;
    return 1;
  }

  String? _content(Message message) {
    if (message is TextMessage) return message.text;
    if (message is ImageMessage) return message.source;
    if (message is FileMessage) return message.source;
    if (message is VideoMessage) return message.source;
    return null;
  }

  /// 返回供 UI 更新的字段：`id`（服务端）、`ts`（毫秒 UTC，来自 createTime）。
  Future<Map<String, dynamic>> send(Message message) async {
    final dto = await repo.sendMessage(
      conversationId: conversationId,
      type: _messageType(message),
      content: _content(message),
      extra: encodeMessageExtra(message),
    );
    final t = dto.createTimeParsed?.toUtc().millisecondsSinceEpoch ??
        DateTime.now().toUtc().millisecondsSinceEpoch;
    return {
      'id': dto.id?.toString() ?? message.id,
      'ts': t,
    };
  }

  Future<void> delete(Message message) async {
    // 后端未提供删除接口时占位
  }

  Future<void> flush() async {}

  Future<void> seen(MessageID messageId) async {}
}

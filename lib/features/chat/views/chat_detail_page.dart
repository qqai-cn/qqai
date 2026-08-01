import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/components/chat/chat_widget.dart';
import 'package:qqai/features/ai/providers/ai_assistants_provider.dart';
import 'package:qqai/features/chat/providers/chat_providers.dart';
import 'package:qqai/providers/auth_providers.dart';
import 'package:qqai/util/api_base_client.dart';

/// 竖屏全屏聊天页：AppBar 标题为单聊对方昵称、群聊群名或 AI 助手名。
class ChatDetailPage extends ConsumerWidget {
  const ChatDetailPage({
    super.key,
    required this.conversationId,
    this.isAi = false,
  });

  final int conversationId;
  final bool isAi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    final String title;
    if (isAi) {
      title = ref.watch(aiAssistantsProvider).maybeWhen(
            data: (list) {
              for (final a in list) {
                if (a.id == conversationId) {
                  final t = a.title?.trim();
                  if (t != null && t.isNotEmpty) return t;
                  break;
                }
              }
              return 'AI助手';
            },
            orElse: () => 'AI助手',
          );
    } else {
      title = ref.watch(chatConversationProvider(conversationId)).maybeWhen(
            data: (conversation) => conversation.displayTitle,
            orElse: () => '聊天',
          );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ChatWidget(
        key: ValueKey<String>('${isAi ? 'ai' : 'im'}-$conversationId'),
        currentUserId: auth.userId ?? '0',
        conversationId: conversationId,
        initialMessages: const [],
        dio: ApiBaseClient.dio,
        token: auth.token,
        enableSocket: !isAi,
        isAi: isAi,
      ),
    );
  }
}

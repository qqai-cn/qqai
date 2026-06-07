import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/components/chat/chat_widget.dart';
import 'package:qqai/features/chat/providers/chat_providers.dart';
import 'package:qqai/providers/auth_providers.dart';
import 'package:qqai/util/api_base_client.dart';

/// 竖屏全屏聊天页：AppBar 标题为单聊对方昵称或群聊群名。
class ChatDetailPage extends ConsumerWidget {
  const ChatDetailPage({super.key, required this.conversationId});

  final int conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final conversationAsync = ref.watch(
      chatConversationProvider(conversationId),
    );

    final title = conversationAsync.maybeWhen(
      data: (conversation) => conversation.displayTitle,
      orElse: () => '聊天',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ChatWidget(
        key: ValueKey<int>(conversationId),
        currentUserId: auth.userId ?? '0',
        conversationId: conversationId,
        initialMessages: const [],
        dio: ApiBaseClient.dio,
        token: auth.token,
        enableSocket: true,
      ),
    );
  }
}

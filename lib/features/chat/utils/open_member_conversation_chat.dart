import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/auth_providers.dart';
import '../../../router/app_routes.dart';
import '../data/models/chat_models.dart';
import '../data/repos/chat_repo.dart';
import '../providers/chat_providers.dart';

/// 打开消息列表并选中/进入与指定会员的单聊会话。
Future<void> openMemberConversationChat(
  BuildContext context,
  WidgetRef ref,
  int memberUserId, {
  int? sourceType,
}) async {
  if (!ref.read(authProvider).isAuthenticated) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('请先登录')),
    );
    context.push(Routes.login);
    return;
  }

  try {
    final conversation = await ref
        .read(chatRepoProvider)
        .getOrCreateSingleConversation(
          memberUserId,
          sourceType: sourceType,
        );
    final conversationId = conversation.id;
    if (conversationId == null) {
      throw Exception('无会话编号');
    }
    ref.invalidate(chatConversationsProvider);
    if (!context.mounted) return;
    context.go('${Routes.messagePage}?conversationId=$conversationId');
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('打开聊天失败：$e')),
    );
  }
}

import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/auth_providers.dart';
import '../../friends/providers/friend_providers.dart';
import '../data/models/chat_models.dart';
import '../data/repos/chat_repo.dart';

part 'chat_providers.g.dart';

/// 会话聊天记录版本号；清空记录后递增，供 [ChatWidget] 重新拉取历史。
final chatHistoryRevisionProvider = StateProvider.family<int, int>(
  (ref, conversationId) => 0,
);

/// 单个会话详情（竖屏聊天页 AppBar 标题等）。
@riverpod
Future<ChatConversationDto> chatConversation(Ref ref, int conversationId) async {
  return ref.watch(chatRepoProvider).getConversation(conversationId);
}

@riverpod
Future<List<ChatConversationDto>> chatConversations(Ref ref) async {
  return ref.watch(chatRepoProvider).listConversations();
}

@riverpod
Future<List<GroupInvitationPendingDto>> groupInvitationPendingIncoming(
  Ref ref,
) async {
  return ref.watch(chatRepoProvider).listPendingIncomingGroupInvitations();
}

@riverpod
Future<List<GroupInvitationPendingDto>> groupInvitationPendingOutgoing(
  Ref ref,
) async {
  return ref.watch(chatRepoProvider).listPendingOutgoingGroupInvitations();
}

/// 底部「消息」Tab 未读：会话未读 + 待处理好友申请 + 待处理群邀请。
@riverpod
int messageTabUnreadCount(Ref ref) {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return 0;

  final conversationUnread = ref.watch(chatConversationsProvider).maybeWhen(
    data: (conversations) => conversations.fold<int>(
      0,
      (sum, conversation) => sum + (conversation.unreadCount ?? 0),
    ),
    orElse: () => 0,
  );

  final pendingFriends = ref.watch(friendPendingIncomingProvider).maybeWhen(
    data: (list) => list.length,
    orElse: () => 0,
  );

  final pendingGroups =
      ref.watch(groupInvitationPendingIncomingProvider).maybeWhen(
        data: (list) => list.length,
        orElse: () => 0,
      );

  return conversationUnread + pendingFriends + pendingGroups;
}

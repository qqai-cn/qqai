import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

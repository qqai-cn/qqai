import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/auth_providers.dart';
import '../../ai/data/models/ai_chat_models.dart';
import '../../ai/providers/ai_assistants_provider.dart';
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

/// 消息 Tab 收件箱：IM 会话 + AI 助手（合成列表）。
/// 不用 autoDispose，避免切会话时短暂无监听导致反复销毁重建。
final messageInboxConversationsProvider =
    FutureProvider<List<ChatConversationDto>>((ref) async {
  final im = await ref.watch(chatConversationsProvider.future);
  List<AiChatConversationDto> assistants = const [];
  try {
    assistants = await ref.watch(aiAssistantsProvider.future);
  } catch (_) {}
  final aiItems = <ChatConversationDto>[];
  for (final a in assistants) {
    final id = a.id;
    if (id == null) continue;
    aiItems.add(
      ChatConversationDto.fromAiAssistant(
        id: id,
        title: (a.title?.trim().isNotEmpty == true) ? a.title!.trim() : 'AI助手',
        pinned: a.pinned,
        model: a.model,
        createTime: a.createTime,
      ),
    );
  }
  final merged = [...aiItems, ...im];
  merged.sort((a, b) {
    final ap = a.pinned == true ? 1 : 0;
    final bp = b.pinned == true ? 1 : 0;
    if (ap != bp) return bp - ap;
    final ad = a.isAi && a.name == kDefaultAiAssistantTitle ? 1 : 0;
    final bd = b.isAi && b.name == kDefaultAiAssistantTitle ? 1 : 0;
    if (ad != bd) return bd - ad;
    final at = DateTime.tryParse(a.lastMessageTime ?? a.updateTime ?? '')
            ?.millisecondsSinceEpoch ??
        0;
    final bt = DateTime.tryParse(b.lastMessageTime ?? b.updateTime ?? '')
            ?.millisecondsSinceEpoch ??
        0;
    return bt.compareTo(at);
  });
  return merged;
});

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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../models/chat_models.dart';

final chatRepoProvider = Provider<IChatRepo>((ref) => ChatRepo());

abstract class IChatRepo {
  Future<List<ChatConversationDto>> listConversations();

  Future<ChatConversationDto> getConversation(int id);

  Future<ChatConversationDto> getOrCreateSingleConversation(int otherUserId);

  Future<ChatConversationDto> createGroupConversation({
    String? name,
    required List<int> memberIds,
  });

  Future<ChatMessagePageData> getMessagePage({
    required int conversationId,
    required int pageNo,
    int pageSize = 50,
  });

  Future<ChatMessagePageData> searchMessages({
    required int conversationId,
    required String keyword,
    required int pageNo,
    int pageSize = 20,
  });

  Future<void> clearConversationHistory(int conversationId);

  Future<ChatMessageDto> sendMessage({
    required int conversationId,
    required int type,
    String? content,
    String? extra,
  });

  Future<void> updateConversationMuted({
    required int conversationId,
    required bool muted,
  });

  Future<void> updateConversationPinned({
    required int conversationId,
    required bool pinned,
  });

  Future<void> deleteConversation(int conversationId);

  Future<void> updateGroupConversation({
    required int conversationId,
    String? name,
    String? avatar,
  });

  Future<void> markConversationRead({
    required int conversationId,
    int? messageId,
  });

  Future<List<ChatGroupMemberDto>> listGroupMembers(int conversationId);

  Future<List<GroupInvitationPendingDto>> listPendingIncomingGroupInvitations();

  Future<List<GroupInvitationPendingDto>> listPendingOutgoingGroupInvitations();

  Future<bool> acceptGroupInvitation({required int invitationId});

  Future<bool> rejectGroupInvitation({required int invitationId});
}

void _throwIfBadEnvelope(Map<String, dynamic> root) {
  final code = root['code'];
  if (code != null && code != 0) {
    throw Exception(root['msg']?.toString() ?? '业务错误');
  }
}

class ChatRepo implements IChatRepo {
  @override
  Future<List<ChatConversationDto>> listConversations() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_CONVERSATION_LIST,
      RequestType.get,
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
    final data = root['data'];
    if (data is! List) return [];
    final conversations = data
        .map(
          (e) =>
              ChatConversationDto.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
    return Future.wait(conversations.map(_withSinglePeerProfile));
  }

  Future<ChatConversationDto> _withSinglePeerProfile(
    ChatConversationDto conversation,
  ) async {
    final peerUserId = conversation.peerUserId;
    if (conversation.type != 1 || peerUserId == null) {
      return conversation;
    }
    try {
      final response = await ApiBaseClient.safeApiCall(
        ApiConstant.profileUserPagePath(peerUserId),
        RequestType.get,
      );
      final root = Map<String, dynamic>.from(response.data as Map);
      _throwIfBadEnvelope(root);
      final data = root['data'];
      if (data is! Map) return conversation;
      final profile = Map<String, dynamic>.from(data);
      final nickname = profile['nickname']?.toString().trim();
      final avatar = profile['avatar']?.toString().trim();
      return conversation.copyWith(
        name: nickname != null && nickname.isNotEmpty
            ? nickname
            : '用户 $peerUserId',
        avatar: avatar != null && avatar.isNotEmpty ? avatar : null,
      );
    } catch (_) {
      return conversation.copyWith(name: '用户 $peerUserId');
    }
  }

  @override
  Future<ChatConversationDto> getConversation(int id) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_CONVERSATION_GET,
      RequestType.get,
      queryParameters: {'id': id},
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
    final data = root['data'] as Map<String, dynamic>?;
    if (data == null) throw Exception('无会话数据');
    final conversation = ChatConversationDto.fromJson(data);
    return _withSinglePeerProfile(conversation);
  }

  @override
  Future<ChatConversationDto> getOrCreateSingleConversation(
    int otherUserId,
  ) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_CONVERSATION_SINGLE,
      RequestType.post,
      queryParameters: {'otherUserId': otherUserId},
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
    final data = root['data'] as Map<String, dynamic>?;
    if (data == null) throw Exception('无会话数据');
    return ChatConversationDto.fromJson(data);
  }

  @override
  Future<ChatConversationDto> createGroupConversation({
    String? name,
    required List<int> memberIds,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_CONVERSATION_GROUP,
      RequestType.post,
      data: {
        if (name != null && name.isNotEmpty) 'name': name,
        'memberIds': memberIds,
      },
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
    final data = root['data'] as Map<String, dynamic>?;
    if (data == null) throw Exception('无会话数据');
    return ChatConversationDto.fromJson(data);
  }

  @override
  Future<ChatMessagePageData> getMessagePage({
    required int conversationId,
    required int pageNo,
    int pageSize = 50,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_MESSAGE_PAGE,
      RequestType.get,
      queryParameters: {
        'conversationId': conversationId,
        'pageNo': pageNo,
        'pageSize': pageSize,
      },
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
    final data = root['data'] as Map<String, dynamic>?;
    if (data == null) {
      return ChatMessagePageData(list: [], total: 0);
    }
    return ChatMessagePageData.fromJson(data);
  }

  @override
  Future<ChatMessagePageData> searchMessages({
    required int conversationId,
    required String keyword,
    required int pageNo,
    int pageSize = 20,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_MESSAGE_SEARCH,
      RequestType.get,
      queryParameters: {
        'conversationId': conversationId,
        'keyword': keyword,
        'pageNo': pageNo,
        'pageSize': pageSize,
      },
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
    final data = root['data'] as Map<String, dynamic>?;
    if (data == null) {
      return ChatMessagePageData(list: [], total: 0);
    }
    return ChatMessagePageData.fromJson(data);
  }

  @override
  Future<void> clearConversationHistory(int conversationId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_CONVERSATION_CLEAR_HISTORY,
      RequestType.delete,
      queryParameters: {'id': conversationId},
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
  }

  @override
  Future<ChatMessageDto> sendMessage({
    required int conversationId,
    required int type,
    String? content,
    String? extra,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_MESSAGE_SEND,
      RequestType.post,
      data: {
        'conversationId': conversationId,
        'type': type,
        if (content != null) 'content': content,
        if (extra != null) 'extra': extra,
      },
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
    final data = root['data'] as Map<String, dynamic>?;
    if (data == null) throw Exception('无消息数据');
    return ChatMessageDto.fromJson(data);
  }

  @override
  Future<void> updateConversationMuted({
    required int conversationId,
    required bool muted,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_CONVERSATION_MUTE,
      RequestType.put,
      queryParameters: {'id': conversationId, 'muted': muted},
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
  }

  @override
  Future<void> updateConversationPinned({
    required int conversationId,
    required bool pinned,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_CONVERSATION_PIN,
      RequestType.put,
      queryParameters: {'id': conversationId, 'pinned': pinned},
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
  }

  @override
  Future<void> deleteConversation(int conversationId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_CONVERSATION_DELETE,
      RequestType.delete,
      queryParameters: {'id': conversationId},
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
  }

  @override
  Future<void> updateGroupConversation({
    required int conversationId,
    String? name,
    String? avatar,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_CONVERSATION_GROUP_UPDATE,
      RequestType.put,
      data: {
        'id': conversationId,
        if (name != null) 'name': name,
        if (avatar != null) 'avatar': avatar,
      },
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
  }

  @override
  Future<void> markConversationRead({
    required int conversationId,
    int? messageId,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_CONVERSATION_READ,
      RequestType.put,
      queryParameters: {
        'id': conversationId,
        if (messageId != null) 'messageId': messageId,
      },
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
  }

  @override
  Future<List<GroupInvitationPendingDto>> listPendingIncomingGroupInvitations() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_GROUP_INVITATION_PENDING_INCOMING,
      RequestType.get,
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
    final data = root['data'];
    if (data is! List) return [];
    return data
        .map(
          (e) => GroupInvitationPendingDto.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  @override
  Future<List<GroupInvitationPendingDto>> listPendingOutgoingGroupInvitations() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_GROUP_INVITATION_PENDING_OUTGOING,
      RequestType.get,
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
    final data = root['data'];
    if (data is! List) return [];
    return data
        .map(
          (e) => GroupInvitationPendingDto.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  @override
  Future<bool> acceptGroupInvitation({required int invitationId}) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_GROUP_INVITATION_ACCEPT,
      RequestType.post,
      data: {'invitationId': invitationId},
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
    return root['data'] == true;
  }

  @override
  Future<bool> rejectGroupInvitation({required int invitationId}) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_GROUP_INVITATION_REJECT,
      RequestType.post,
      data: {'invitationId': invitationId},
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
    return root['data'] == true;
  }

  @override
  Future<List<ChatGroupMemberDto>> listGroupMembers(int conversationId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.CHAT_GROUP_MEMBER_LIST,
      RequestType.get,
      queryParameters: {'conversationId': conversationId},
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _throwIfBadEnvelope(root);
    final data = root['data'];
    if (data is! List) return [];
    return data
        .map(
          (e) => ChatGroupMemberDto.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../models/chat_models.dart';

final chatRepoProvider = Provider<IChatRepo>((ref) => ChatRepo());

abstract class IChatRepo {
  Future<List<ChatConversationDto>> listConversations();

  Future<ChatConversationDto> getConversation(int id);

  Future<ChatConversationDto> createGroupConversation({
    String? name,
    required List<int> memberIds,
  });

  Future<ChatMessagePageData> getMessagePage({
    required int conversationId,
    required int pageNo,
    int pageSize = 50,
  });

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

  Future<void> deleteConversation(int conversationId);

  Future<void> markConversationRead({
    required int conversationId,
    int? messageId,
  });
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
    return data
        .map((e) => ChatConversationDto.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
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
      queryParameters: {
        'id': conversationId,
        'muted': muted,
      },
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
}

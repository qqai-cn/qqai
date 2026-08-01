import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../models/ai_chat_models.dart';

final aiChatRepoProvider = Provider<IAiChatRepo>((ref) => AiChatRepo());

abstract class IAiChatRepo {
  Future<List<AiChatConversationDto>> listMyConversations();

  /// AI 助手好友列表（服务端会确保默认「千千AI助手」）
  Future<List<AiChatConversationDto>> listAssistants();

  Future<AiChatConversationDto?> getMyConversation(int id);

  Future<int> createMyConversation({int? roleId, int? modelId});

  Future<int> createAssistant({
    String? title,
    String? systemMessage,
    int? modelId,
  });

  Future<void> updateMyConversation({
    required int id,
    String? title,
    bool? pinned,
    int? modelId,
    String? systemMessage,
    double? temperature,
    int? maxTokens,
    int? maxContexts,
  });

  Future<void> deleteMyConversation(int id);

  Future<void> deleteUnpinnedConversations();

  Future<List<AiChatMessageDto>> listMessages(int conversationId);

  Future<void> deleteMessage(int id);

  Future<void> deleteMessagesByConversation(int conversationId);

  Future<List<AiModelSimpleDto>> listChatModels();

  /// SSE 流式发送。返回的 Stream 在结束或取消后 complete。
  Stream<AiChatSendChunk> sendMessageStream({
    required int conversationId,
    required String content,
    bool useContext = true,
    bool useSearch = false,
    CancelToken? cancelToken,
  });
}

void _throwIfBadEnvelope(Map<String, dynamic> root) {
  final code = root['code'];
  if (code != null && code != 0) {
    throw Exception(root['msg']?.toString() ?? '业务错误');
  }
}

Map<String, dynamic> _asMap(dynamic data) {
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  throw Exception('响应格式错误');
}

class AiChatRepo implements IAiChatRepo {
  @override
  Future<List<AiChatConversationDto>> listMyConversations() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.AI_CHAT_CONVERSATION_MY_LIST,
      RequestType.get,
    );
    final root = _asMap(response.data);
    _throwIfBadEnvelope(root);
    final data = root['data'];
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((e) => AiChatConversationDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<AiChatConversationDto>> listAssistants() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.AI_CHAT_CONVERSATION_ASSISTANTS,
      RequestType.get,
    );
    final root = _asMap(response.data);
    _throwIfBadEnvelope(root);
    final data = root['data'];
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((e) => AiChatConversationDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<AiChatConversationDto?> getMyConversation(int id) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.AI_CHAT_CONVERSATION_GET_MY,
      RequestType.get,
      queryParameters: {'id': id},
    );
    final root = _asMap(response.data);
    _throwIfBadEnvelope(root);
    final data = root['data'];
    if (data == null) return null;
    return AiChatConversationDto.fromJson(_asMap(data));
  }

  @override
  Future<int> createMyConversation({int? roleId, int? modelId}) async {
    final body = <String, dynamic>{};
    if (roleId != null) body['roleId'] = roleId;
    if (modelId != null) body['modelId'] = modelId;
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.AI_CHAT_CONVERSATION_CREATE_MY,
      RequestType.post,
      data: body,
    );
    final root = _asMap(response.data);
    _throwIfBadEnvelope(root);
    final id = root['data'];
    if (id is num) return id.toInt();
    throw Exception('创建对话失败');
  }

  @override
  Future<int> createAssistant({
    String? title,
    String? systemMessage,
    int? modelId,
  }) async {
    final body = <String, dynamic>{};
    if (title != null && title.trim().isNotEmpty) body['title'] = title.trim();
    if (systemMessage != null) body['systemMessage'] = systemMessage;
    if (modelId != null) body['modelId'] = modelId;
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.AI_CHAT_CONVERSATION_CREATE_ASSISTANT,
      RequestType.post,
      data: body,
    );
    final root = _asMap(response.data);
    _throwIfBadEnvelope(root);
    final id = root['data'];
    if (id is num) return id.toInt();
    throw Exception('添加 AI 助手失败');
  }

  @override
  Future<void> updateMyConversation({
    required int id,
    String? title,
    bool? pinned,
    int? modelId,
    String? systemMessage,
    double? temperature,
    int? maxTokens,
    int? maxContexts,
  }) async {
    final body = <String, dynamic>{'id': id};
    if (title != null) body['title'] = title;
    if (pinned != null) body['pinned'] = pinned;
    if (modelId != null) body['modelId'] = modelId;
    if (systemMessage != null) body['systemMessage'] = systemMessage;
    if (temperature != null) body['temperature'] = temperature;
    if (maxTokens != null) body['maxTokens'] = maxTokens;
    if (maxContexts != null) body['maxContexts'] = maxContexts;
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.AI_CHAT_CONVERSATION_UPDATE_MY,
      RequestType.put,
      data: body,
    );
    _throwIfBadEnvelope(_asMap(response.data));
  }

  @override
  Future<void> deleteMyConversation(int id) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.AI_CHAT_CONVERSATION_DELETE_MY,
      RequestType.delete,
      queryParameters: {'id': id},
    );
    _throwIfBadEnvelope(_asMap(response.data));
  }

  @override
  Future<void> deleteUnpinnedConversations() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.AI_CHAT_CONVERSATION_DELETE_UNPINNED,
      RequestType.delete,
    );
    _throwIfBadEnvelope(_asMap(response.data));
  }

  @override
  Future<List<AiChatMessageDto>> listMessages(int conversationId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.AI_CHAT_MESSAGE_LIST,
      RequestType.get,
      queryParameters: {'conversationId': conversationId},
    );
    final root = _asMap(response.data);
    _throwIfBadEnvelope(root);
    final data = root['data'];
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((e) => AiChatMessageDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> deleteMessage(int id) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.AI_CHAT_MESSAGE_DELETE,
      RequestType.delete,
      queryParameters: {'id': id},
    );
    _throwIfBadEnvelope(_asMap(response.data));
  }

  @override
  Future<void> deleteMessagesByConversation(int conversationId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.AI_CHAT_MESSAGE_DELETE_BY_CONVERSATION,
      RequestType.delete,
      queryParameters: {'conversationId': conversationId},
    );
    _throwIfBadEnvelope(_asMap(response.data));
  }

  @override
  Future<List<AiModelSimpleDto>> listChatModels() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.AI_MODEL_SIMPLE_LIST,
      RequestType.get,
      queryParameters: {'type': 1},
    );
    final root = _asMap(response.data);
    _throwIfBadEnvelope(root);
    final data = root['data'];
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((e) => AiModelSimpleDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Stream<AiChatSendChunk> sendMessageStream({
    required int conversationId,
    required String content,
    bool useContext = true,
    bool useSearch = false,
    CancelToken? cancelToken,
  }) async* {
    final response = await ApiBaseClient.dio.post<ResponseBody>(
      ApiConstant.AI_CHAT_MESSAGE_SEND_STREAM,
      data: {
        'conversationId': conversationId,
        'content': content,
        'useContext': useContext,
        'useSearch': useSearch,
      },
      options: Options(
        responseType: ResponseType.stream,
        headers: const {
          Headers.acceptHeader: 'text/event-stream',
          Headers.contentTypeHeader: Headers.jsonContentType,
        },
        receiveTimeout: const Duration(minutes: 10),
        sendTimeout: const Duration(seconds: 30),
      ),
      cancelToken: cancelToken,
    );

    final body = response.data;
    if (body == null) return;

    final buffer = StringBuffer();
    await for (final Uint8List chunk in body.stream) {
      buffer.write(utf8.decode(chunk, allowMalformed: true));
      final text = buffer.toString();
      final parts = text.split('\n');
      // 保留最后一段未完整行
      buffer
        ..clear()
        ..write(parts.isEmpty ? '' : parts.removeLast());

      for (final line in parts) {
        final trimmed = line.trimRight();
        if (trimmed.isEmpty || trimmed.startsWith(':')) continue;
        if (!trimmed.startsWith('data:')) continue;
        var payload = trimmed.substring(5);
        if (payload.startsWith(' ')) payload = payload.substring(1);
        if (payload.isEmpty || payload == '[DONE]') continue;
        try {
          final json = jsonDecode(payload);
          if (json is Map) {
            yield AiChatSendChunk.fromEnvelope(Map<String, dynamic>.from(json));
          }
        } catch (_) {
          // 忽略半包 / 非 JSON
        }
      }
    }

    final leftover = buffer.toString().trim();
    if (leftover.startsWith('data:')) {
      var payload = leftover.substring(5).trim();
      if (payload.isNotEmpty && payload != '[DONE]') {
        try {
          final json = jsonDecode(payload);
          if (json is Map) {
            yield AiChatSendChunk.fromEnvelope(Map<String, dynamic>.from(json));
          }
        } catch (_) {}
      }
    }
  }
}

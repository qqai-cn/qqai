import 'package:dio/dio.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:qqai/util/api_base_client.dart';

class ChatApiService {
  final String baseUrl;
  final String chatId;
  final Dio dio;

  ChatApiService({
    required this.baseUrl,
    required this.chatId,
    required this.dio,
  });

  Future<dynamic> send(Message message) async {
    try {
      final response = ApiBaseClient.safeApiCall(
        '$baseUrl/app-api/infra/chat/message/send',
        RequestType.post,
      );
      return response;
    } catch (e) {
      throw 'Failed to send message: $e';
    }
  }

  Future<void> delete(Message message) async {
    try {
      await dio.delete(
        '$baseUrl/chat/$chatId/message',
        data: {'id': message.id},
      );
    } catch (e) {
      throw 'Failed to delete message: $e';
    }
  }

  Future<void> flush() async {
    try {
      await dio.post('$baseUrl/chat/$chatId/message-flush');
    } catch (e) {
      throw 'Failed to flush messages: $e';
    }
  }

  Future<void> seen(MessageID messageId) async {
    try {
      await dio.post('$baseUrl/chat/$chatId/seen', data: {'msgId': messageId});
    } catch (e) {
      throw 'Failed to mark message as seen: $e';
    }
  }
}

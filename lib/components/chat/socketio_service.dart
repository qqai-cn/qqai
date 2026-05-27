import 'dart:async';
import 'dart:convert';

import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum WebSocketEventType { newMessage, deleteMessage, flush, error, unknown }

enum WebSocketStatus { disconnected, connecting, connected, reconnecting }

class WebSocketEvent {
  final WebSocketEventType type;
  final Message? message;
  final String? error;

  const WebSocketEvent({required this.type, this.message, this.error});
}

class SocketioService {
  final String host;
  final String chatId;
  final UserID authorId;
  final String? token;
  final _statusController = StreamController<WebSocketStatus>.broadcast();
  WebSocketStatus _status = WebSocketStatus.disconnected;

  SocketioService({
    required this.host,
    required this.chatId,
    required this.authorId,
    this.token,
  });

  Stream<WebSocketStatus> get status => _statusController.stream;

  WebSocketStatus get currentStatus => _status;

  void _updateStatus(WebSocketStatus newStatus) {
    _status = newStatus;
    _statusController.add(newStatus);
  }

  Stream<WebSocketEvent> connect() async* {
    try {
      var builder = IO.OptionBuilder()
          .setPath('/socket.io')
          .setTransports(['websocket']);
      if (token != null && token!.isNotEmpty) {
        builder = builder.setQuery({'token': token});
      }
      IO.Socket socket = IO.io(host, builder.build());

      socket.onConnect((_) {
        print('connect');
        _updateStatus(WebSocketStatus.connected);
        socket.emit('infra:send-msg', 'test');
      });
      socket.on('infra:new-msg', (data) => _parseWebSocketMessage(data));
      socket.onDisconnect((_) => print('disconnect'));
    } catch (e) {
      yield WebSocketEvent(
        type: WebSocketEventType.error,
        error: 'Connection error: $e',
      );
    }
  }

  WebSocketEvent _parseWebSocketMessage(dynamic message) {
    print(message);
    final Map<String, dynamic> json;
    try {
      json = jsonDecode(message);
    } catch (e) {
      throw FormatException('Invalid JSON format: $e');
    }

    if (json['msg'] != null) {
      final Message parsedMessage;
      try {
        parsedMessage = Message.fromJson(json['msg']);
      } catch (e) {
        throw FormatException('Invalid message format: $e');
      }

      if (json['op'] == 'new') {
        return WebSocketEvent(
          type: WebSocketEventType.newMessage,
          message: parsedMessage,
        );
      } else if (json['op'] == 'del') {
        return WebSocketEvent(
          type: WebSocketEventType.deleteMessage,
          message: parsedMessage,
        );
      }
    } else if (json['op'] == 'flush') {
      return const WebSocketEvent(type: WebSocketEventType.flush);
    }

    return const WebSocketEvent(type: WebSocketEventType.unknown);
  }

  void dispose() {
    _statusController.close();
  }
}

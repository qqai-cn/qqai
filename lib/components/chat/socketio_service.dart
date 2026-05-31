import 'dart:async';
import 'dart:convert';

import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:qqai/features/chat/data/chat_message_mapper.dart';
import 'package:qqai/features/chat/data/models/chat_models.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum WebSocketEventType {
  newMessage,
  deleteMessage,
  flush,
  error,
  rtcSignal,
  unknown,
}

enum WebSocketStatus { disconnected, connecting, connected, reconnecting }

class WebSocketEvent {
  final WebSocketEventType type;
  final Message? message;
  final String? error;
  final Map<String, dynamic>? rtcSignal;

  const WebSocketEvent({
    required this.type,
    this.message,
    this.error,
    this.rtcSignal,
  });
}

class SocketioService {
  final String host;
  final String chatId;
  final UserID authorId;
  final String? token;
  final _statusController = StreamController<WebSocketStatus>.broadcast();
  final _eventController = StreamController<WebSocketEvent>.broadcast();
  WebSocketStatus _status = WebSocketStatus.disconnected;
  io.Socket? _socket;

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

  Stream<WebSocketEvent> connect() {
    if (_socket == null) {
      _connectSocket();
    }
    return _eventController.stream;
  }

  void _connectSocket() {
    try {
      _updateStatus(WebSocketStatus.connecting);
      var builder = io.OptionBuilder().setPath('/socket.io').setTransports([
        'websocket',
      ]);
      if (token != null && token!.isNotEmpty) {
        builder = builder.setQuery({'token': token});
      }
      final socket = io.io(host, builder.build());
      _socket = socket;

      socket.onConnect((_) {
        _updateStatus(WebSocketStatus.connected);
      });
      socket.on('infra:new-msg', (data) {
        try {
          final event = _parseWebSocketMessage(data);
          if (event.type != WebSocketEventType.unknown) {
            _eventController.add(event);
          }
        } catch (e) {
          _eventController.add(
            WebSocketEvent(type: WebSocketEventType.error, error: e.toString()),
          );
        }
      });
      socket.on('infra:rtc-signal', (data) {
        final signal = _parseRtcSignal(data);
        if (signal != null) {
          _eventController.add(
            WebSocketEvent(
              type: WebSocketEventType.rtcSignal,
              rtcSignal: signal,
            ),
          );
        }
      });
      socket.onDisconnect((_) {
        _updateStatus(WebSocketStatus.disconnected);
      });
    } catch (e) {
      _eventController.add(
        WebSocketEvent(
          type: WebSocketEventType.error,
          error: 'Connection error: $e',
        ),
      );
    }
  }

  WebSocketEvent _parseWebSocketMessage(dynamic message) {
    final Map<String, dynamic> json;
    if (message is Map) {
      json = Map<String, dynamic>.from(message);
    } else if (message is String) {
      json = Map<String, dynamic>.from(jsonDecode(message) as Map);
    } else {
      return const WebSocketEvent(type: WebSocketEventType.unknown);
    }

    if (json.containsKey('type') && json.containsKey('conversationId')) {
      final conversationId = json['conversationId']?.toString();
      if (conversationId != chatId) {
        return const WebSocketEvent(type: WebSocketEventType.unknown);
      }
      final dto = ChatMessageDto.fromJson(json);
      final parsedMessage = mapChatMessageDtoToMessage(dto);
      if (parsedMessage == null) {
        return const WebSocketEvent(type: WebSocketEventType.unknown);
      }
      return WebSocketEvent(
        type: WebSocketEventType.newMessage,
        message: parsedMessage,
      );
    }

    if (json['msg'] != null) {
      final Message parsedMessage;
      try {
        parsedMessage = Message.fromJson(
          Map<String, dynamic>.from(json['msg'] as Map),
        );
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

  Map<String, dynamic>? _parseRtcSignal(dynamic message) {
    final Map<String, dynamic> json;
    if (message is Map) {
      json = Map<String, dynamic>.from(message);
    } else if (message is String) {
      json = Map<String, dynamic>.from(jsonDecode(message) as Map);
    } else {
      return null;
    }
    final conversationId = json['conversationId']?.toString();
    if (conversationId != chatId) {
      return null;
    }
    return json;
  }

  void dispose() {
    _socket?.dispose();
    _statusController.close();
    _eventController.close();
  }
}

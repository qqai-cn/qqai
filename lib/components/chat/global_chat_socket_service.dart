import 'dart:async';
import 'dart:convert';

import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/constant/api_constant.dart';
import 'package:qqai/features/chat/data/chat_message_mapper.dart';
import 'package:qqai/features/chat/data/models/chat_models.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum GlobalSocketStatus { disconnected, connecting, connected }

class GlobalChatMessageEvent {
  const GlobalChatMessageEvent({required this.dto, required this.message});

  final ChatMessageDto dto;
  final Message message;
}

class GlobalRtcSignalEvent {
  const GlobalRtcSignalEvent({
    required this.conversationId,
    required this.senderId,
    required this.callId,
    required this.signalType,
    required this.payload,
  });

  final int conversationId;
  final String senderId;
  final String callId;
  final String signalType;
  final Map<String, dynamic> payload;
}

final globalChatSocketServiceProvider = Provider<GlobalChatSocketService>((
  ref,
) {
  final service = GlobalChatSocketService();
  ref.onDispose(service.dispose);
  return service;
});

class GlobalChatSocketService {
  final _statusController = StreamController<GlobalSocketStatus>.broadcast();
  final _messageController =
      StreamController<GlobalChatMessageEvent>.broadcast();
  final _rtcController = StreamController<GlobalRtcSignalEvent>.broadcast();
  final List<Map<String, dynamic>> _pendingRtcSignals = [];

  io.Socket? _socket;
  String? _token;
  GlobalSocketStatus _status = GlobalSocketStatus.disconnected;

  Stream<GlobalSocketStatus> get statusStream => _statusController.stream;

  Stream<GlobalChatMessageEvent> get messageStream => _messageController.stream;

  Stream<GlobalRtcSignalEvent> get rtcSignalStream => _rtcController.stream;

  GlobalSocketStatus get currentStatus => _status;

  void connect({required String token}) {
    if (token.isEmpty) {
      disconnect();
      return;
    }
    if (_socket != null && _token == token) return;

    disconnect();
    _token = token;
    _updateStatus(GlobalSocketStatus.connecting);

    final socket = io.io(
      ApiConstant.SOCKET_IO_URL,
      io.OptionBuilder()
          .setPath('/socket.io')
          .setTransports(['websocket'])
          .setQuery({'token': token})
          .build(),
    );
    _socket = socket;

    socket.onConnect((_) {
      _updateStatus(GlobalSocketStatus.connected);
      _flushPendingRtcSignals();
    });
    socket.onDisconnect((_) => _updateStatus(GlobalSocketStatus.disconnected));
    socket.onConnectError(
      (_) => _updateStatus(GlobalSocketStatus.disconnected),
    );
    socket.onError((_) => _updateStatus(GlobalSocketStatus.disconnected));
    socket.on('infra:new-msg', _handleNewMessage);
    socket.on('infra:rtc-signal', _handleRtcSignal);
  }

  void emitRtcSignal({
    required int conversationId,
    required String callId,
    required String signalType,
    Map<String, dynamic> payload = const <String, dynamic>{},
  }) {
    final event = {
      'conversationId': conversationId,
      'callId': callId,
      'signalType': signalType,
      'payload': payload,
    };
    if (_status == GlobalSocketStatus.connected && _socket != null) {
      _socket?.emit('infra:rtc-signal', event);
      return;
    }
    _pendingRtcSignals.add(event);
  }

  void emitChatMessage({
    required int conversationId,
    required int type,
    String? content,
    String? extra,
  }) {
    final event = <String, dynamic>{
      'conversationId': conversationId,
      'type': type,
    };
    if (content != null) {
      event['content'] = content;
    }
    if (extra != null) {
      event['extra'] = extra;
    }
    if (_status == GlobalSocketStatus.connected && _socket != null) {
      _socket?.emit('infra:send-msg', event);
      return;
    }
    throw StateError('聊天连接未就绪');
  }

  void disconnect() {
    final socket = _socket;
    _socket = null;
    _token = null;
    _pendingRtcSignals.clear();
    socket?.dispose();
    _updateStatus(GlobalSocketStatus.disconnected);
  }

  void _flushPendingRtcSignals() {
    if (_pendingRtcSignals.isEmpty) return;
    final events = List<Map<String, dynamic>>.from(_pendingRtcSignals);
    _pendingRtcSignals.clear();
    for (final event in events) {
      _socket?.emit('infra:rtc-signal', event);
    }
  }

  void dispose() {
    disconnect();
    _statusController.close();
    _messageController.close();
    _rtcController.close();
  }

  void _handleNewMessage(dynamic data) {
    final json = _asMap(data);
    if (json == null) return;
    try {
      final dto = ChatMessageDto.fromJson(json);
      final message = mapChatMessageDtoToMessage(dto);
      if (message == null) return;
      _messageController.add(
        GlobalChatMessageEvent(dto: dto, message: message),
      );
    } catch (_) {
      // Ignore malformed realtime payloads; history reload still has the source of truth.
    }
  }

  void _handleRtcSignal(dynamic data) {
    final json = _asMap(data);
    if (json == null) return;
    final conversationId = (json['conversationId'] as num?)?.toInt();
    final senderId = json['senderId']?.toString();
    final callId = json['callId']?.toString();
    final signalType = json['signalType']?.toString();
    if (conversationId == null ||
        senderId == null ||
        senderId.isEmpty ||
        callId == null ||
        callId.isEmpty ||
        signalType == null ||
        signalType.isEmpty) {
      return;
    }
    _rtcController.add(
      GlobalRtcSignalEvent(
        conversationId: conversationId,
        senderId: senderId,
        callId: callId,
        signalType: signalType,
        payload: _payloadMap(json['payload']),
      ),
    );
  }

  Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String && data.isNotEmpty) {
      return Map<String, dynamic>.from(jsonDecode(data) as Map);
    }
    return null;
  }

  Map<String, dynamic> _payloadMap(dynamic payload) {
    if (payload is Map) return Map<String, dynamic>.from(payload);
    if (payload is String && payload.isNotEmpty) {
      return Map<String, dynamic>.from(jsonDecode(payload) as Map);
    }
    return <String, dynamic>{};
  }

  void _updateStatus(GlobalSocketStatus status) {
    if (_status == status) return;
    _status = status;
    _statusController.add(status);
  }
}

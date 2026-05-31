import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/chat/global_chat_socket_service.dart';
import 'package:qqai/providers/auth_providers.dart';
import 'package:qqai/router/app_routes.dart';

class GlobalChatRealtimeScope extends ConsumerStatefulWidget {
  const GlobalChatRealtimeScope({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<GlobalChatRealtimeScope> createState() =>
      _GlobalChatRealtimeScopeState();
}

class _GlobalChatRealtimeScopeState
    extends ConsumerState<GlobalChatRealtimeScope> {
  StreamSubscription<GlobalRtcSignalEvent>? _rtcSubscription;
  final Set<String> _pendingInviteCallIds = <String>{};
  String? _connectedToken;

  @override
  void initState() {
    super.initState();
    final socket = ref.read(globalChatSocketServiceProvider);
    _rtcSubscription = socket.rtcSignalStream.listen(_handleRtcSignal);
  }

  @override
  void dispose() {
    _rtcSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final token = auth.token;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final socket = ref.read(globalChatSocketServiceProvider);
      if (auth.isAuthenticated && token != null && token.isNotEmpty) {
        if (_connectedToken != token) {
          socket.connect(token: token);
          _connectedToken = token;
        }
      } else if (_connectedToken != null) {
        socket.disconnect();
        _connectedToken = null;
      }
    });
    return widget.child;
  }

  void _handleRtcSignal(GlobalRtcSignalEvent signal) {
    if (!mounted || signal.signalType != 'invite') return;
    if (!_pendingInviteCallIds.add(signal.callId)) return;
    unawaited(_showIncomingVideoCall(signal));
  }

  Future<void> _showIncomingVideoCall(GlobalRtcSignalEvent signal) async {
    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('视频通话邀请'),
        content: const Text('对方邀请你视频通话，是否接听？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('拒绝'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('接听'),
          ),
        ],
      ),
    );
    _pendingInviteCallIds.remove(signal.callId);
    if (!mounted) return;
    if (accepted == true) {
      context.push(
        '${Routes.chat}/${signal.conversationId}/video-call'
        '?callId=${signal.callId}&caller=false',
      );
    } else {
      ref
          .read(globalChatSocketServiceProvider)
          .emitRtcSignal(
            conversationId: signal.conversationId,
            callId: signal.callId,
            signalType: 'hangup',
          );
    }
  }
}

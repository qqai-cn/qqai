import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:qqai/components/chat/global_chat_socket_service.dart';

class ChatVideoCallPage extends ConsumerStatefulWidget {
  const ChatVideoCallPage({
    super.key,
    required this.conversationId,
    required this.currentUserId,
    this.token,
    this.callId,
    this.isCaller = true,
  });

  final int conversationId;
  final String currentUserId;
  final String? token;
  final String? callId;
  final bool isCaller;

  @override
  ConsumerState<ChatVideoCallPage> createState() => _ChatVideoCallPageState();
}

class _ChatVideoCallPageState extends ConsumerState<ChatVideoCallPage> {
  static const _turnHost = '47.94.236.184';
  static const _turnPort = 3478;
  static const _turnCredentialTtl = Duration(hours: 24);
  static const _turnStaticAuthSecret = String.fromEnvironment(
    'QQAI_TURN_STATIC_AUTH_SECRET',
  );

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  RTCPeerConnection? _peer;
  MediaStream? _localStream;
  StreamSubscription<GlobalRtcSignalEvent>? _rtcSubscription;
  late final String _callId;
  final List<RTCIceCandidate> _pendingCandidates = [];
  Timer? _durationTimer;
  Duration _duration = Duration.zero;
  bool _initializing = true;
  bool _connected = false;
  bool _micEnabled = true;
  bool _cameraEnabled = true;
  bool _callDisposed = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _callId =
        widget.callId ??
        '${widget.conversationId}-${widget.currentUserId}-${DateTime.now().millisecondsSinceEpoch}';
    _enterCallMode();
    _startCall();
  }

  Future<void> _enterCallMode() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _exitCallMode() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _startCall() async {
    try {
      await _localRenderer.initialize();
      await _remoteRenderer.initialize();

      final stream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': {
          'facingMode': 'user',
          'width': {'ideal': 1280},
          'height': {'ideal': 720},
          'frameRate': {'ideal': 30},
        },
      });

      _localStream = stream;
      _localRenderer.srcObject = stream;

      final config = _buildPeerConnectionConfig();
      final peer = await createPeerConnection(config);
      _peer = peer;

      peer.onIceCandidate = (candidate) {
        _sendSignal('candidate', {
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      };
      peer.onTrack = (event) {
        if (event.streams.isNotEmpty) {
          _remoteRenderer.srcObject = event.streams.first;
          if (mounted && !_connected) {
            setState(() => _connected = true);
            _startDurationTimer();
          }
        }
      };

      for (final track in stream.getTracks()) {
        await peer.addTrack(track, stream);
      }

      _connectSignalStream();

      if (mounted) {
        setState(() => _initializing = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _initializing = false;
          _error = '无法开启视频通话：$e';
        });
      }
    }
  }

  void _connectSignalStream() {
    final socket = ref.read(globalChatSocketServiceProvider);
    _rtcSubscription = socket.rtcSignalStream.listen(_handleRtcSignal);
    if (widget.isCaller) {
      _sendSignal('invite', {'media': 'video'});
    } else {
      _sendSignal('accept', {'media': 'video'});
    }
  }

  Future<void> _handleRtcSignal(GlobalRtcSignalEvent signal) async {
    if (signal.callId != _callId) return;
    if (signal.senderId == widget.currentUserId) return;
    try {
      switch (signal.signalType) {
        case 'accept':
          if (widget.isCaller) {
            await _createAndSendOffer();
          }
          break;
        case 'offer':
          await _receiveOffer(signal.payload);
          break;
        case 'answer':
          await _receiveAnswer(signal.payload);
          break;
        case 'candidate':
          await _receiveCandidate(signal.payload);
          break;
        case 'hangup':
          await _disposeCall();
          if (mounted) Navigator.of(context).pop();
          break;
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = '视频通话信令处理失败：$e');
      }
    }
  }

  Future<void> _createAndSendOffer() async {
    final peer = _peer;
    if (peer == null) return;
    final offer = await peer.createOffer();
    await peer.setLocalDescription(offer);
    _sendSignal('offer', {'type': offer.type, 'sdp': offer.sdp});
  }

  Future<void> _receiveOffer(Map<String, dynamic> payload) async {
    final peer = _peer;
    if (peer == null) return;
    await peer.setRemoteDescription(
      RTCSessionDescription(
        payload['sdp']?.toString(),
        payload['type']?.toString(),
      ),
    );
    await _flushPendingCandidates();
    final answer = await peer.createAnswer();
    await peer.setLocalDescription(answer);
    _sendSignal('answer', {'type': answer.type, 'sdp': answer.sdp});
  }

  Future<void> _receiveAnswer(Map<String, dynamic> payload) async {
    final peer = _peer;
    if (peer == null) return;
    await peer.setRemoteDescription(
      RTCSessionDescription(
        payload['sdp']?.toString(),
        payload['type']?.toString(),
      ),
    );
    await _flushPendingCandidates();
  }

  Future<void> _receiveCandidate(Map<String, dynamic> payload) async {
    final candidate = RTCIceCandidate(
      payload['candidate']?.toString(),
      payload['sdpMid']?.toString(),
      (payload['sdpMLineIndex'] as num?)?.toInt(),
    );
    final peer = _peer;
    if (peer == null) return;
    final remoteDescription = await peer.getRemoteDescription();
    if (remoteDescription == null) {
      _pendingCandidates.add(candidate);
      return;
    }
    await peer.addCandidate(candidate);
  }

  Future<void> _flushPendingCandidates() async {
    final peer = _peer;
    if (peer == null || _pendingCandidates.isEmpty) return;
    final candidates = List<RTCIceCandidate>.from(_pendingCandidates);
    _pendingCandidates.clear();
    for (final candidate in candidates) {
      await peer.addCandidate(candidate);
    }
  }

  void _sendSignal(String type, Map<String, dynamic> payload) {
    ref
        .read(globalChatSocketServiceProvider)
        .emitRtcSignal(
          conversationId: widget.conversationId,
          callId: _callId,
          signalType: type,
          payload: payload,
        );
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _duration += const Duration(seconds: 1));
      }
    });
  }

  Map<String, dynamic> _buildPeerConnectionConfig() {
    final iceServers = <Map<String, dynamic>>[
      {'urls': 'stun:$_turnHost:$_turnPort'},
    ];
    if (_turnStaticAuthSecret.isNotEmpty) {
      final credential = _createTurnCredential();
      iceServers.add({
        'urls': [
          'turn:$_turnHost:$_turnPort?transport=udp',
          'turn:$_turnHost:$_turnPort?transport=tcp',
        ],
        'username': credential.username,
        'credential': credential.password,
      });
    }
    return {'iceServers': iceServers, 'sdpSemantics': 'unified-plan'};
  }

  _TurnCredential _createTurnCredential() {
    final expiresAt =
        DateTime.now().toUtc().add(_turnCredentialTtl).millisecondsSinceEpoch ~/
        1000;
    final username = expiresAt.toString();
    final digest = Hmac(
      sha1,
      utf8.encode(_turnStaticAuthSecret),
    ).convert(utf8.encode(username));
    return _TurnCredential(
      username: username,
      password: base64Encode(digest.bytes),
    );
  }

  void _toggleMic() {
    final next = !_micEnabled;
    for (final track
        in _localStream?.getAudioTracks() ?? <MediaStreamTrack>[]) {
      track.enabled = next;
    }
    setState(() => _micEnabled = next);
  }

  void _toggleCamera() {
    final next = !_cameraEnabled;
    for (final track
        in _localStream?.getVideoTracks() ?? <MediaStreamTrack>[]) {
      track.enabled = next;
    }
    setState(() => _cameraEnabled = next);
  }

  Future<void> _switchCamera() async {
    final tracks = _localStream?.getVideoTracks() ?? <MediaStreamTrack>[];
    if (tracks.isEmpty) return;
    try {
      await Helper.switchCamera(tracks.first);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('切换摄像头失败：$e')));
    }
  }

  Future<void> _hangup() async {
    _sendSignal('hangup', {});
    await _disposeCall();
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _disposeCall() async {
    if (_callDisposed) return;
    _callDisposed = true;
    _durationTimer?.cancel();
    _durationTimer = null;
    final peer = _peer;
    final stream = _localStream;
    final rtcSubscription = _rtcSubscription;
    _peer = null;
    _rtcSubscription = null;
    _localRenderer.srcObject = null;
    _remoteRenderer.srcObject = null;
    _localStream = null;
    await rtcSubscription?.cancel();
    await peer?.close();
    for (final track in stream?.getTracks() ?? <MediaStreamTrack>[]) {
      await track.stop();
    }
  }

  @override
  void dispose() {
    unawaited(_disposeCall());
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    unawaited(_exitCallMode());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _hangup();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(child: _buildRemoteVideo()),
              Positioned(top: 16, right: 16, child: _buildLocalPreview()),
              Positioned(left: 24, right: 24, top: 24, child: _buildHeader()),
              Positioned(
                left: 0,
                right: 0,
                bottom: 28,
                child: _buildControls(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemoteVideo() {
    if (_error != null) {
      return _CallPlaceholder(
        icon: Icons.videocam_off_outlined,
        title: '视频通话未接通',
        subtitle: _error!,
      );
    }
    if (!_connected) {
      return const _CallPlaceholder(
        icon: Icons.person_outline,
        title: '正在等待对方接听',
        subtitle: '已开启摄像头和麦克风',
      );
    }
    return RTCVideoView(
      _remoteRenderer,
      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      mirror: true,
    );
  }

  Widget _buildLocalPreview() {
    return Container(
      width: 108,
      height: 156,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF202124),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: _cameraEnabled && _localRenderer.srcObject != null
          ? RTCVideoView(
              _localRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              mirror: true,
            )
          : const Icon(Icons.videocam_off_outlined, color: Colors.white70),
    );
  }

  Widget _buildHeader() {
    final status = _error != null
        ? '通话异常'
        : _connected
        ? _formatDuration(_duration)
        : _initializing
        ? '正在发起视频通话...'
        : '等待接听...';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '视频通话',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '会话 ${widget.conversationId} · $status',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CallControlButton(
          icon: _micEnabled ? Icons.mic_none : Icons.mic_off_outlined,
          label: _micEnabled ? '静音' : '取消静音',
          onPressed: _toggleMic,
        ),
        _CallControlButton(
          icon: Icons.call_end,
          label: '挂断',
          color: const Color(0xFFE94343),
          iconColor: Colors.white,
          onPressed: _hangup,
        ),
        _CallControlButton(
          icon: _cameraEnabled
              ? Icons.videocam_outlined
              : Icons.videocam_off_outlined,
          label: _cameraEnabled ? '关闭摄像头' : '打开摄像头',
          onPressed: _toggleCamera,
        ),
        _CallControlButton(
          icon: Icons.cameraswitch_outlined,
          label: '翻转',
          onPressed: _switchCamera,
        ),
      ],
    );
  }

  String _formatDuration(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = value.inHours;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}

class _TurnCredential {
  const _TurnCredential({required this.username, required this.password});

  final String username;
  final String password;
}

class _CallControlButton extends StatelessWidget {
  const _CallControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color ?? Colors.white.withValues(alpha: 0.16),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: 58,
              height: 58,
              child: Icon(icon, color: iconColor ?? Colors.white, size: 28),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 70,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _CallPlaceholder extends StatelessWidget {
  const _CallPlaceholder({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111315),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 72),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white60),
          ),
        ],
      ),
    );
  }
}

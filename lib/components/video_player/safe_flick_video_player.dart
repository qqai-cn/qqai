// Fork of flick_video_player's FlickVideoPlayer with mounted checks on async/frame
// callbacks. Upstream registers [context] in a post-frame callback without checking
// [mounted], which throws if the widget is disposed before the next frame (e.g.
// vertical PageView swipe).
//
// ignore_for_file: implementation_imports, depend_on_referenced_packages

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qqai/components/video_player/flick_web_support.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// API-compatible with [FlickVideoPlayer]; safe when disposed before first frame.
class SafeFlickVideoPlayer extends StatefulWidget {
  SafeFlickVideoPlayer({
    Key? key,
    required this.flickManager,
    this.flickVideoWithControls = const FlickVideoWithControls(
      controls: FlickPortraitControls(),
    ),
    this.flickVideoWithControlsFullscreen,
    this.systemUIOverlay = SystemUiOverlay.values,
    this.systemUIOverlayFullscreen = const [],
    this.preferredDeviceOrientation = const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
    this.preferredDeviceOrientationFullscreen = const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
    this.wakelockEnabled = true,
    this.wakelockEnabledFullscreen = true,
    FlickWebKeyHandler? webKeyDownHandler,
  })  : webKeyDownHandler = webKeyDownHandler ?? defaultFlickWebKeyHandler,
        super(key: key);

  final FlickManager flickManager;
  final Widget flickVideoWithControls;
  final Widget? flickVideoWithControlsFullscreen;
  final List<SystemUiOverlay> systemUIOverlay;
  final List<SystemUiOverlay> systemUIOverlayFullscreen;
  final List<DeviceOrientation> preferredDeviceOrientation;
  final List<DeviceOrientation> preferredDeviceOrientationFullscreen;
  final bool wakelockEnabled;
  final bool wakelockEnabledFullscreen;
  final FlickWebKeyHandler webKeyDownHandler;

  @override
  State<SafeFlickVideoPlayer> createState() => _SafeFlickVideoPlayerState();
}

class _SafeFlickVideoPlayerState extends State<SafeFlickVideoPlayer>
    with WidgetsBindingObserver {
  late FlickManager flickManager;
  bool _isFullscreen = false;
  OverlayEntry? _overlayEntry;
  double? _videoWidth;
  double? _videoHeight;
  bool _managerInitialized = false;
  final FocusNode _focusNode = FocusNode(skipTraversal: true);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    flickManager = widget.flickManager;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      flickManager.registerContext(context);
      _initializeFlickManager();
    });
  }

  void _initializeFlickManager() {
    if (_managerInitialized || !mounted) return;
    _managerInitialized = true;
    flickManager.flickControlManager!.addListener(listener);
    _setSystemUIOverlays();
    _setPreferredOrientation();

    if (widget.wakelockEnabled && !kIsWeb) {
      WakelockPlus.enable();
    }

    if (kIsWeb) {
      setupFlickWebDocumentListeners(
        onFullscreenChange: _webFullscreenListener,
        onKeyDown: _webKeyListener,
      );
    }
  }

  @override
  void dispose() {
    if (_managerInitialized) {
      flickManager.flickControlManager!.removeListener(listener);
    }
    if (widget.wakelockEnabled && !kIsWeb) {
      WakelockPlus.disable();
    }
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    if (_overlayEntry != null) {
      flickManager.flickControlManager!.exitFullscreen();
      return true;
    }
    return false;
  }

  void listener() {
    if (!mounted) return;
    if (flickManager.flickControlManager!.isFullscreen && !_isFullscreen) {
      _switchToFullscreen();
    } else if (_isFullscreen &&
        !flickManager.flickControlManager!.isFullscreen) {
      _exitFullscreen();
    }
  }

  void _switchToFullscreen() {
    if (!mounted) return;
    if (widget.wakelockEnabledFullscreen && !kIsWeb) {
      WakelockPlus.disable();
      WakelockPlus.enable();
    }

    _isFullscreen = true;
    _setPreferredOrientation();
    _setSystemUIOverlays();
    if (kIsWeb) {
      requestFlickWebFullscreen();
      _focusNode.requestFocus();
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) return;
        _videoHeight = MediaQuery.of(context).size.height;
        _videoWidth = MediaQuery.of(context).size.width;
        setState(() {});
      });
    } else {
      _overlayEntry = OverlayEntry(
        builder: (context) {
          return Scaffold(
            body: FlickManagerBuilder(
              flickManager: flickManager,
              child: widget.flickVideoWithControlsFullscreen ??
                  widget.flickVideoWithControls,
            ),
          );
        },
      );

      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _exitFullscreen() {
    if (!mounted) return;
    if (widget.wakelockEnabled && !kIsWeb) {
      WakelockPlus.disable();
      WakelockPlus.enable();
    }

    _isFullscreen = false;

    if (kIsWeb) {
      if (flickWebScreenIsFullscreen()) {
        exitFlickWebFullscreen();
      }
      _videoHeight = null;
      _videoWidth = null;
      setState(() {});
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    _setPreferredOrientation();
    _setSystemUIOverlays();
  }

  void _setPreferredOrientation() {
    if (!mounted) return;
    final aspectRatio =
        widget.flickManager.flickVideoManager!.videoPlayerValue!.aspectRatio;
    if (_isFullscreen && aspectRatio >= 1) {
      SystemChrome.setPreferredOrientations(
        widget.preferredDeviceOrientationFullscreen,
      );
    } else {
      SystemChrome.setPreferredOrientations(widget.preferredDeviceOrientation);
    }
  }

  void _setSystemUIOverlays() {
    if (!mounted) return;
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: widget.systemUIOverlayFullscreen,
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: widget.systemUIOverlay,
      );
    }
  }

  void _webFullscreenListener() {
    if (!mounted) return;
    final browserFullscreen = flickWebScreenIsFullscreen();
    if (browserFullscreen && !flickManager.flickControlManager!.isFullscreen) {
      flickManager.flickControlManager!.enterFullscreen();
    } else if (!browserFullscreen) {
      _syncExitWebFullscreen();
    }
  }

  /// Browser left native fullscreen (e.g. ESC); reset player UI to match.
  void _syncExitWebFullscreen() {
    if (flickManager.flickControlManager!.isFullscreen) {
      flickManager.flickControlManager!.exitFullscreen();
    } else if (_isFullscreen) {
      _isFullscreen = false;
      _videoHeight = null;
      _videoWidth = null;
      _setPreferredOrientation();
      _setSystemUIOverlays();
      setState(() {});
    }
  }

  KeyEventResult _handleEscapeKey() {
    if (!_isFullscreen && !flickManager.flickControlManager!.isFullscreen) {
      return KeyEventResult.ignored;
    }
    flickManager.flickControlManager!.exitFullscreen();
    return KeyEventResult.handled;
  }

  void _webKeyListener(Object event) {
    if (!mounted) return;
    widget.webKeyDownHandler(event, flickManager);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        if (event.logicalKey != LogicalKeyboardKey.escape) {
          return KeyEventResult.ignored;
        }
        return _handleEscapeKey();
      },
      child: SizedBox(
        width: _videoWidth,
        height: _videoHeight,
        child: FlickManagerBuilder(
          flickManager: flickManager,
          child: widget.flickVideoWithControls,
        ),
      ),
    );
  }
}

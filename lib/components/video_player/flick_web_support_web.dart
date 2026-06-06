import 'dart:js_interop';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flick_video_player/src/utils/web_key_bindings.dart';
import 'package:web/web.dart' as web;

typedef FlickWebKeyHandler = void Function(Object event, FlickManager manager);

FlickWebKeyHandler get defaultFlickWebKeyHandler => flickDefaultWebKeyDownHandler;

/// 发布页等表单场景：不响应空格播放，且在输入框聚焦时忽略全部快捷键。
FlickWebKeyHandler get flickWebKeyDownHandlerWithoutSpacePlay =>
    _flickWebKeyDownHandlerWithoutSpacePlay;

void _flickWebKeyDownHandlerWithoutSpacePlay(
  Object event,
  FlickManager flickManager,
) {
  if (event is! web.KeyboardEvent) return;
  if (_flickWebActiveElementIsEditable()) return;
  if (event.keyCode == 32) return;
  flickDefaultWebKeyDownHandler(event, flickManager);
}

bool _flickWebActiveElementIsEditable() {
  final active = web.document.activeElement;
  if (active == null || active == web.document.body) return false;
  if (active is! web.HTMLElement) return false;
  final tag = active.tagName.toUpperCase();
  if (tag == 'INPUT' || tag == 'TEXTAREA' || tag == 'SELECT') return true;
  return active.isContentEditable;
}

typedef FlickWebDocumentListenersDispose = void Function();

class FlickWebDocumentListenersHandle {
  const FlickWebDocumentListenersHandle({required this.dispose});

  final FlickWebDocumentListenersDispose dispose;
}

FlickWebDocumentListenersHandle setupFlickWebDocumentListeners({
  required void Function() onFullscreenChange,
  required void Function(Object event) onKeyDown,
}) {
  void handleFullscreenChange(web.Event _) => onFullscreenChange();
  void handleKeyDown(web.Event event) => onKeyDown(event);

  final fullscreenListener = handleFullscreenChange.toJS;
  final keydownListener = handleKeyDown.toJS;

  // Listen on document: ESC exits browser fullscreen here, not on documentElement.
  web.document.addEventListener('fullscreenchange', fullscreenListener);
  web.document.addEventListener('keydown', keydownListener);

  return FlickWebDocumentListenersHandle(
    dispose: () {
      web.document.removeEventListener('fullscreenchange', fullscreenListener);
      web.document.removeEventListener('keydown', keydownListener);
    },
  );
}

void requestFlickWebFullscreen() {
  web.document.documentElement?.requestFullscreen();
}

void exitFlickWebFullscreen() {
  web.document.exitFullscreen();
}

bool flickWebScreenIsFullscreen() {
  return web.document.fullscreenElement != null;
}

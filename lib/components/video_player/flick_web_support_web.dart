import 'dart:js_interop';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flick_video_player/src/utils/web_key_bindings.dart';
import 'package:web/web.dart' as web;

typedef FlickWebKeyHandler = void Function(Object event, FlickManager manager);

FlickWebKeyHandler get defaultFlickWebKeyHandler => flickDefaultWebKeyDownHandler;

void setupFlickWebDocumentListeners({
  required void Function() onFullscreenChange,
  required void Function(Object event) onKeyDown,
}) {
  void handleFullscreenChange(web.Event _) => onFullscreenChange();
  void handleKeyDown(web.Event event) => onKeyDown(event);

  // Listen on document: ESC exits browser fullscreen here, not on documentElement.
  web.document.addEventListener('fullscreenchange', handleFullscreenChange.toJS);
  web.document.addEventListener('keydown', handleKeyDown.toJS);
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

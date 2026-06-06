import 'dart:js_interop';

import 'package:web/web.dart' as web;

void setupFlickWebDocumentListeners({
  required void Function() onFullscreenChange,
  required void Function(Object event) onKeyDown,
}) {
  void handleFullscreenChange(web.Event _) => onFullscreenChange();
  void handleKeyDown(web.Event event) => onKeyDown(event);

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

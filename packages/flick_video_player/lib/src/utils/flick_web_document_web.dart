import 'package:web/web.dart' as web;

void setupFlickWebDocumentListeners({
  required void Function() onFullscreenChange,
  required void Function(Object event) onKeyDown,
}) {
  web.document.documentElement?.onFullscreenChange
      .listen((_) => onFullscreenChange());
  web.document.documentElement?.onKeyDown.listen((event) => onKeyDown(event));
}

void requestFlickWebFullscreen() {
  web.document.documentElement?.requestFullscreen();
}

void exitFlickWebFullscreen() {
  web.document.exitFullscreen();
}

bool flickWebScreenIsFullscreen() {
  final w = web.document.defaultView;
  return w != null && w.screenTop == 0 && w.screenY == 0;
}

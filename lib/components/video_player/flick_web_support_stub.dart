import 'package:flick_video_player/flick_video_player.dart';

typedef FlickWebKeyHandler = void Function(Object event, FlickManager manager);

class FlickWebDocumentListenersHandle {
  const FlickWebDocumentListenersHandle({required this.dispose});

  final void Function() dispose;
}

FlickWebKeyHandler get defaultFlickWebKeyHandler => (_, __) {};

FlickWebKeyHandler get flickWebKeyDownHandlerWithoutSpacePlay => (_, __) {};

FlickWebDocumentListenersHandle setupFlickWebDocumentListeners({
  required void Function() onFullscreenChange,
  required void Function(Object event) onKeyDown,
}) {
  return FlickWebDocumentListenersHandle(dispose: () {});
}

void requestFlickWebFullscreen() {}

void exitFlickWebFullscreen() {}

bool flickWebScreenIsFullscreen() => false;

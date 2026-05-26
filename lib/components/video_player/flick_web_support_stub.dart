import 'package:flick_video_player/flick_video_player.dart';

typedef FlickWebKeyHandler = void Function(Object event, FlickManager manager);

FlickWebKeyHandler get defaultFlickWebKeyHandler => (_, __) {};

void setupFlickWebDocumentListeners({
  required void Function() onFullscreenChange,
  required void Function(Object event) onKeyDown,
}) {}

void requestFlickWebFullscreen() {}

void exitFlickWebFullscreen() {}

bool flickWebScreenIsFullscreen() => false;

import 'package:flick_video_player/src/manager/flick_manager.dart';

typedef FlickWebKeyDownHandler = void Function(
  Object event,
  FlickManager flickManager,
);

void flickDefaultWebKeyDownHandler(
  Object event,
  FlickManager flickManager,
) {}

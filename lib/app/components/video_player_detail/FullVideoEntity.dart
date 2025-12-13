import 'package:video_player/video_player.dart';

/// controller : ""

class FullVideoEntity {
  FullVideoEntity({
    VideoPlayerController? controller,
    num? id,
    String? heroTag,
  }) {
    _controller = controller;
    _id = id;
    _heroTag = heroTag;
  }

  FullVideoEntity.fromJson(dynamic json) {
    _controller = json['controller'];
    _id = json['id'];
    _heroTag = json['heroTag'];
  }

  VideoPlayerController? _controller;
  num? _id;
  String? _heroTag;

  FullVideoEntity copyWith({
    VideoPlayerController? controller,
    num? id,
    String? heroTag,
  }) =>
      FullVideoEntity(
        controller: controller ?? _controller,
        id: id ?? _id,
        heroTag: heroTag ?? _heroTag,
      );

  VideoPlayerController? get controller => _controller;

  num? get id => _id;
  String? get heroTag => _heroTag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['controller'] = _controller;
    map['id'] = _id;
    map['heroTag'] = _heroTag;
    return map;
  }
}

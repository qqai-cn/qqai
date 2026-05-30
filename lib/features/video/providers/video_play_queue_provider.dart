import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../blog/data/models/blog_page_model.dart';
import '../../../components/blog/network_image_carousel_pages.dart';

part 'video_play_queue_provider.g.dart';

/// 影视 Tab 播放队列：用户通过「加入播放队列」追加的待播视频。
@riverpod
class VideoPlayQueue extends _$VideoPlayQueue {
  @override
  List<BlogItem> build() => const [];

  bool contains(int blogId) => state.any((e) => e.id == blogId);

  /// 追加到队列末尾；已在队列或不可播放则返回 false。
  bool add(BlogItem item) {
    final id = item.id;
    if (id == null) return false;
    if (firstPlayableVideoUrlFromResources(item.resources) == null) {
      return false;
    }
    if (contains(id)) return false;
    state = [...state, item];
    return true;
  }

  void remove(int blogId) {
    state = state.where((e) => e.id != blogId).toList();
  }

  void clear() {
    state = const [];
  }
}

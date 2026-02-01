import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/video_model.dart';

// Repo Provider（按 blog 的格式：Provider 放在 repo 文件里）
final videoRepoProvider = Provider<IVideoRepo>(
  (ref) => VideoRepo(),
);

abstract class IVideoRepo {
  Future<List<VideoModel>> getAllVideos();
  Future<VideoModel?> getVideoById(String id);
  Future<void> addVideo(VideoModel item);
  Future<void> updateVideo(VideoModel item);
  Future<void> deleteVideo(String id);
}

class VideoRepo implements IVideoRepo {
  final List<VideoModel> _items = [];

  @override
  Future<List<VideoModel>> getAllVideos() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<VideoModel?> getVideoById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addVideo(VideoModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> updateVideo(VideoModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> deleteVideo(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }
}

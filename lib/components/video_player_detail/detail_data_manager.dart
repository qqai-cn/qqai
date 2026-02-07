/// 视频列表数据管理（Chewie 迁移后简化为占位，如需 playlist 功能可自行实现）
class DetailDataManager {
  DetailDataManager({required this.urls});

  int currentPlaying = 0;
  final List<String> urls;

  String getNextVideo() {
    currentPlaying++;
    return urls[currentPlaying];
  }

  bool hasNextVideo() => currentPlaying != urls.length - 1;
  bool hasPreviousVideo() => currentPlaying != 0;
}

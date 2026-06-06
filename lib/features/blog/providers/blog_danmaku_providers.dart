import 'package:flutter_riverpod/legacy.dart';

final blogDanmakuRefreshProvider = StateProvider.family<int, int>(
  (ref, blogId) => 0,
);

final blogDanmakuCurrentPositionProvider = StateProvider.family<int, int>(
  (ref, blogId) => 0,
);

final blogDanmakuVisibleProvider = StateProvider.family<bool, int>(
  (ref, blogId) => true,
);

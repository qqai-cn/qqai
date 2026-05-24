import 'package:visibility_detector/visibility_detector.dart';

/// Web/列表布局未稳定时 [VisibilityInfo.size] 可能为负，直接读 [visibleFraction] 会断言失败。
bool isVisibilityMeasurable(VisibilityInfo info) {
  final size = info.size;
  return size.height > 0 && size.width > 0;
}

double safeVisibleFraction(VisibilityInfo info) {
  if (!isVisibilityMeasurable(info)) return 0;
  return info.visibleFraction;
}

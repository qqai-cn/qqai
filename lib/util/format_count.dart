/// Feed 操作栏：有数量只显示数字，否则显示 fallback（如「评论」「分享」）。
String feedActionCountLabel(int? count, String fallback) {
  final n = count;
  if (n != null && n > 0) {
    return formatCompactCount(n);
  }
  return fallback;
}

/// 将数量格式化为简短展示（如 1.2万）。
String formatCompactCount(int? count) {
  final n = count ?? 0;
  if (n >= 10000) {
    final v = n / 10000;
    final s = (v == v.floorToDouble())
        ? v.toInt().toString()
        : v.toStringAsFixed(1);
    return '$s万';
  }
  return '$n';
}

/// 博客附近列表距离（千米）展示，如 `500m`、`3.2km`、`12km`。
String formatBlogDistanceKm(double? km) {
  if (km == null || km.isNaN || km < 0) return '';
  if (km < 0.001) return '';
  if (km < 1) {
    final meters = (km * 1000).round();
    if (meters < 100) return '${meters}m';
    return '${km.toStringAsFixed(1)}km';
  }
  if (km < 10) {
    final rounded = (km * 10).round() / 10;
    if (rounded == rounded.roundToDouble()) {
      return '${rounded.toInt()}km';
    }
    return '${rounded.toStringAsFixed(1)}km';
  }
  return '${km.round()}km';
}

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

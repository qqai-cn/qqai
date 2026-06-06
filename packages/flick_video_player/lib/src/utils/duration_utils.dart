/// Web 端在元数据未就绪时 [Duration.inMilliseconds] 可能抛 NaN，统一安全读取。
int? safeDurationMilliseconds(Duration duration) {
  try {
    final ms = duration.inMilliseconds;
    if (!ms.isFinite || ms < 0) return null;
    return ms;
  } catch (_) {
    return null;
  }
}

/// 校验并裁剪 seek 目标，避免向 video_player_web 传入非法 Duration。
Duration? safeSeekDuration(Duration moment, {Duration? maxDuration}) {
  final ms = safeDurationMilliseconds(moment);
  if (ms == null) return null;

  if (maxDuration != null) {
    final maxMs = safeDurationMilliseconds(maxDuration);
    if (maxMs == null || maxMs <= 0) return null;
    final clamped = ms > maxMs ? maxMs : ms;
    return Duration(milliseconds: clamped);
  }

  return Duration(milliseconds: ms);
}

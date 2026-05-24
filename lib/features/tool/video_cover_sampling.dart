/// 超过此时长的视频，采样范围限制在前 [qqaiCoverMaxSampleDurationMs]。
const int qqaiCoverLongVideoThresholdMs = 600000;

/// 长视频封面采样的最大时间窗口（10 分钟）。
const int qqaiCoverMaxSampleDurationMs = 600000;

/// 无时长信息时的 fallback 时间点（毫秒）。
const int qqaiCoverFallbackTimeMs = 1000;

int frameCountForCoverStyle(int styleId) {
  return switch (styleId) {
    1 => 5,
    2 => 10,
    3 => 1,
    4 => 7,
    _ => 6,
  };
}

int effectiveCoverSampleDurationMs(int durationMs) {
  if (durationMs <= 0) return 0;
  if (durationMs <= qqaiCoverLongVideoThresholdMs) return durationMs;
  return qqaiCoverMaxSampleDurationMs;
}

/// 均匀采样；长视频只在前 [qqaiCoverMaxSampleDurationMs] 内取帧，限制 seek 距离。
List<int> computeCoverStyleTimePoints(int durationMs, int styleId) {
  final count = frameCountForCoverStyle(styleId);
  final sampleDuration = effectiveCoverSampleDurationMs(durationMs);
  if (sampleDuration <= 0) {
    return List.filled(count, qqaiCoverFallbackTimeMs);
  }

  final step = sampleDuration ~/ (count + 1);
  return List.generate(count, (i) => (step * (i + 1)).clamp(0, sampleDuration));
}

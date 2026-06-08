/// 超过此时长的视频，采样范围限制在前 [qqaiCoverMaxSampleDurationMs]。
const int qqaiCoverLongVideoThresholdMs = 600000;

/// 长视频封面采样的最大时间窗口（10 分钟）。
const int qqaiCoverMaxSampleDurationMs = 600000;

/// 无时长信息时的 fallback 时间点（毫秒）。
const int qqaiCoverFallbackTimeMs = 1000;

/// 发布/封面默认取帧：视频总时长的一半（毫秒）。
int defaultVideoCoverTimeMs(int durationMs) {
  if (durationMs <= 0) return qqaiCoverFallbackTimeMs;
  return (durationMs ~/ 2).clamp(0, durationMs - 1);
}

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

/// 均匀采样；主封面帧取总时长一半，其余帧在前段窗口内均匀分布。
List<int> computeCoverStyleTimePoints(int durationMs, int styleId) {
  final count = frameCountForCoverStyle(styleId);
  if (durationMs <= 0) {
    return List.filled(count, qqaiCoverFallbackTimeMs);
  }

  final defaultMs = defaultVideoCoverTimeMs(durationMs);
  if (count == 1) return [defaultMs];

  final sampleDuration = effectiveCoverSampleDurationMs(durationMs);
  final step = sampleDuration ~/ (count + 1);
  final points = List.generate(
    count,
    (i) => (step * (i + 1)).clamp(0, sampleDuration),
  );
  points[0] = defaultMs;
  return points;
}

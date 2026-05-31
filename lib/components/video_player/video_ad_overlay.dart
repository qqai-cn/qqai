import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:qqai/constant/api_constant.dart';
import 'package:qqai/util/api_base_client.dart';
import 'package:qqai/util/media_url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

/// 详情页右侧操作条区域宽度，跳过按钮默认右内边距。
const double kVideoAdDetailSkipRightInset = 72;

/// 视频插入广告遮罩：播放前触发一次，播放到配置时间点后可再次触发。
class VideoAdOverlay extends StatefulWidget {
  const VideoAdOverlay({
    super.key,
    required this.child,
    required this.videoController,
    required this.flickManager,
    this.enabled = true,
    this.placement = 'video',
    this.videoId,
    this.adTopInset = 12,
    this.adSkipRightInset = 12,
  });

  final Widget child;
  final VideoPlayerController videoController;
  final FlickManager flickManager;
  final bool enabled;
  final String placement;
  final int? videoId;
  final double adTopInset;
  final double adSkipRightInset;

  @override
  State<VideoAdOverlay> createState() => _VideoAdOverlayState();
}

class _VideoAdOverlayState extends State<VideoAdOverlay> {
  final Set<int> _shownCuePoints = <int>{};
  Timer? _timer;
  VideoAdConfig? _config;
  bool _configLoaded = false;
  bool _adVisible = false;
  bool _prerollShown = false;
  bool _resumeAfterAd = false;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    widget.videoController.addListener(_handleVideoChanged);
    unawaited(_loadAdConfig());
  }

  @override
  void didUpdateWidget(covariant VideoAdOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoController != widget.videoController) {
      oldWidget.videoController.removeListener(_handleVideoChanged);
      widget.videoController.addListener(_handleVideoChanged);
      _resetAds();
    }
    if (oldWidget.placement != widget.placement ||
        oldWidget.videoId != widget.videoId) {
      _resetAds();
      _configLoaded = false;
      _config = null;
      unawaited(_loadAdConfig());
    }
  }

  @override
  void dispose() {
    widget.videoController.removeListener(_handleVideoChanged);
    _timer?.cancel();
    super.dispose();
  }

  void _resetAds() {
    _timer?.cancel();
    _shownCuePoints.clear();
    _adVisible = false;
    _prerollShown = false;
    _resumeAfterAd = false;
    _secondsLeft = 0;
  }

  Future<void> _loadAdConfig() async {
    try {
      final response = await ApiBaseClient.safeApiCall(
        ApiConstant.VIDEO_AD_CURRENT,
        RequestType.get,
        queryParameters: {'placement': widget.placement},
      );
      final config = VideoAdConfig.fromEnvelope(response.data);
      if (!mounted) return;
      setState(() {
        _config = config;
        _configLoaded = true;
      });
      _handleVideoChanged();
    } catch (_) {
      if (!mounted) return;
      setState(() => _configLoaded = true);
    }
  }

  void _handleVideoChanged() {
    if (!mounted || !widget.enabled || !_configLoaded || _adVisible) return;

    final config = _config;
    if (config == null || !config.enabled) return;
    if (!config.shouldShowForVideo(widget.videoId)) return;

    final value = widget.videoController.value;
    if (!value.isInitialized || !value.isPlaying) return;

    if (!_prerollShown && config.showPreroll) {
      _prerollShown = true;
      _showAd(config);
      return;
    }
    _prerollShown = true;

    for (final cuePoint in config.midrollCuePoints) {
      final cueMs = cuePoint.inMilliseconds;
      if (_shownCuePoints.contains(cueMs)) continue;
      if (value.position >= cuePoint) {
        _shownCuePoints.add(cueMs);
        _showAd(config);
        return;
      }
    }
  }

  void _showAd(VideoAdConfig config) {
    _timer?.cancel();
    _resumeAfterAd = widget.videoController.value.isPlaying;
    widget.flickManager.flickControlManager?.pause();
    widget.videoController.pause();

    setState(() {
      _adVisible = true;
      _secondsLeft = config.durationSeconds.clamp(1, 999);
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        _finishAd();
        return;
      }
      setState(() => _secondsLeft -= 1);
    });
  }

  void _finishAd() {
    _timer?.cancel();
    if (!_adVisible) return;
    setState(() => _adVisible = false);
    if (_resumeAfterAd && mounted) {
      widget.flickManager.flickControlManager?.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (_adVisible)
          _AdSurface(
            secondsLeft: _secondsLeft,
            durationSeconds: _config?.durationSeconds ?? _secondsLeft,
            skipAfterSeconds: _config?.skipAfterSeconds ?? 0,
            config: _config,
            onSkip: _finishAd,
            topInset: widget.adTopInset,
            skipRightInset: widget.adSkipRightInset,
          ),
      ],
    );
  }
}

class _AdSurface extends StatelessWidget {
  const _AdSurface({
    required this.secondsLeft,
    required this.durationSeconds,
    required this.skipAfterSeconds,
    required this.config,
    required this.onSkip,
    required this.topInset,
    required this.skipRightInset,
  });

  final int secondsLeft;
  final int durationSeconds;
  final int skipAfterSeconds;
  final VideoAdConfig? config;
  final VoidCallback onSkip;
  final double topInset;
  final double skipRightInset;

  Future<void> _openActionUrl() async {
    final url = config?.actionUrl;
    if (url == null || url.isEmpty) return;
    final rawUrl = url.startsWith('http') ? url : '${ApiConstant.BASE_URL}$url';
    final uri = Uri.tryParse(rawUrl);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final ad = config;
    final imageUrl = resolveMediaUrl(ad?.imageUrl);
    final elapsedSeconds = (durationSeconds - secondsLeft).clamp(0, durationSeconds);
    final canSkip = skipAfterSeconds <= 0 || elapsedSeconds >= skipAfterSeconds;
    final skipWaitLeft =
        (skipAfterSeconds - elapsedSeconds).clamp(0, skipAfterSeconds);
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF101820),
                    Color(0xFF203A43),
                    Color(0xFF2C5364),
                  ],
                ),
              ),
            ),
            if (imageUrl != null && imageUrl.isNotEmpty)
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.18),
                      Colors.black.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                        ),
                      ),
                      child: const Text(
                        '广告',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      ad?.title ?? 'QQAI 视频广告',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ad?.subtitle ?? '精彩内容马上回来',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.76),
                        fontSize: 14,
                      ),
                    ),
                    if (ad?.hasAction == true) ...[
                      const SizedBox(height: 18),
                      FilledButton(
                        onPressed: _openActionUrl,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                        ),
                        child: const Text('查看详情'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Positioned(
              top: topInset,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  '$secondsLeft 秒后继续',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            Positioned(
              right: skipRightInset,
              bottom: 12,
              child: canSkip
                  ? TextButton(
                      onPressed: onSkip,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black.withValues(alpha: 0.42),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('跳过',style: TextStyle(fontSize: 13),),
                          SizedBox(width: 4),
                          Icon(Icons.skip_next_rounded, size: 20),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.42),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        '$skipWaitLeft 秒后可跳过',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontSize: 13,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoAdConfig {
  const VideoAdConfig({
    required this.enabled,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.actionUrl,
    required this.durationSeconds,
    required this.skipAfterSeconds,
    required this.cuePoints,
    required this.deliveryRatio,
  });

  final bool enabled;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final String? actionUrl;
  final int durationSeconds;
  final int skipAfterSeconds;
  final List<Duration> cuePoints;
  final int deliveryRatio;

  bool shouldShowForVideo(int? videoId) {
    final ratio = deliveryRatio.clamp(1, 100);
    if (ratio >= 100) return true;
    if (videoId == null) return false;
    return videoId.abs() % 100 < ratio;
  }

  bool get showPreroll =>
      cuePoints.isEmpty ||
      cuePoints.any((cuePoint) => cuePoint == Duration.zero);

  bool get hasAction => actionUrl != null && actionUrl!.isNotEmpty;

  List<Duration> get midrollCuePoints =>
      cuePoints.where((cuePoint) => cuePoint > Duration.zero).toList();

  static VideoAdConfig? fromEnvelope(dynamic raw) {
    if (raw is! Map<String, dynamic>) return null;
    final code = raw['code'];
    if (code != null && code != 0 && code != '0') return null;
    final data = raw['data'];
    if (data is! Map<String, dynamic>) return null;
    return VideoAdConfig.fromJson(data);
  }

  factory VideoAdConfig.fromJson(Map<String, dynamic> json) {
    return VideoAdConfig(
      enabled: json['enabled'] == true,
      title: json['title']?.toString() ?? 'QQAI 视频广告',
      subtitle: json['subtitle']?.toString() ?? '精彩内容马上回来',
      imageUrl: json['imageUrl']?.toString(),
      actionUrl: json['actionUrl']?.toString(),
      durationSeconds: _parseInt(json['durationSeconds'], fallback: 5),
      skipAfterSeconds: _parseInt(json['skipAfterSeconds'], fallback: 0),
      cuePoints: _parseCuePoints(json['cuePoints']),
      deliveryRatio: _parseInt(json['deliveryRatio'], fallback: 100),
    );
  }

  static int _parseInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static List<Duration> _parseCuePoints(dynamic value) {
    final raw = value?.toString().trim();
    if (raw == null || raw.isEmpty) {
      return const [Duration.zero];
    }
    final points = <Duration>[];
    for (final part in raw.split(',')) {
      final seconds = int.tryParse(part.trim());
      if (seconds == null || seconds < 0) continue;
      points.add(Duration(seconds: seconds));
    }
    return points.isEmpty ? const [Duration.zero] : points;
  }
}

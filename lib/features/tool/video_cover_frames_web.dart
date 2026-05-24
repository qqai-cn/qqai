import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:web/web.dart';

import 'video_cover_frame_result.dart';
import 'video_cover_sampling.dart';

/// Web 端复用同一个 `<video>` 顺序 seek，同时读取时长，避免重复加载 blob。
Future<CoverStyleFramesResult> extractCoverStyleFrames({
  required String videoPath,
  List<int>? timePointsMs,
  required int styleId,
  required int durationHintMs,
  required int maxWidth,
  required int batchSize,
  void Function(int index, img.Image frame)? onFrameExtracted,
}) async {
  final videoEl = HTMLVideoElement()
    ..preload = 'auto';

  // blob 本地视频不要设 crossOrigin，否则 canvas 可能截到空白帧。
  if (!videoPath.startsWith('blob:')) {
    videoEl.crossOrigin = 'anonymous';
  }
  videoEl.src = videoPath;

  try {
    await _waitVideoReady(videoEl);
    final durationMs = _readDurationMs(videoEl) ?? durationHintMs;
    final points =
        timePointsMs ?? computeCoverStyleTimePoints(durationMs, styleId);
    if (points.isEmpty) {
      return CoverStyleFramesResult(frames: const [], durationMs: durationMs);
    }

    final results = <img.Image?>[];

    for (var index = 0; index < points.length; index++) {
      final frame = await _captureFrame(
        videoEl: videoEl,
        timeMs: points[index],
        maxWidth: maxWidth,
      );
      results.add(frame);
      if (frame != null) {
        onFrameExtracted?.call(index, frame);
      }
    }

    return CoverStyleFramesResult(
      frames: results,
      durationMs: durationMs,
    );
  } on Object catch (e, s) {
    Error.throwWithStackTrace(
      PlatformException(
        code: 'WEB_COVER_FRAME_ERROR',
        message: e.toString(),
      ),
      s,
    );
  } finally {
    videoEl
      ..pause()
      ..removeAttribute('src')
      ..load();
  }
}

int? _readDurationMs(HTMLVideoElement videoEl) {
  final durationSec = videoEl.duration;
  if (!durationSec.isFinite || durationSec <= 0) return null;
  return (durationSec * 1000).round();
}

Future<void> _waitVideoReady(HTMLVideoElement videoEl) async {
  if (videoEl.readyState >= HTMLMediaElement.HAVE_CURRENT_DATA) return;

  final completer = Completer<void>();
  void onReady(Event _) {
    if (!completer.isCompleted) completer.complete();
  }

  void onError(Event _) {
    if (completer.isCompleted) return;
    final err = videoEl.error;
    completer.completeError(
      PlatformException(
        code: 'VIDEO_LOAD_ERROR',
        message: err?.message ?? 'Failed to load video for cover generation',
      ),
    );
  }

  final readyHandler = onReady.toJS;
  final errorHandler = onError.toJS;
  videoEl
    ..addEventListener('loadeddata', readyHandler)
    ..addEventListener('error', errorHandler);

  try {
    await completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw PlatformException(
        code: 'VIDEO_LOAD_TIMEOUT',
        message: 'Video metadata load timed out',
      ),
    );
  } finally {
    videoEl
      ..removeEventListener('loadeddata', readyHandler)
      ..removeEventListener('error', errorHandler);
  }
}

Future<img.Image?> _captureFrame({
  required HTMLVideoElement videoEl,
  required int timeMs,
  required int maxWidth,
}) async {
  if (videoEl.videoWidth <= 0 || videoEl.videoHeight <= 0) {
    return null;
  }

  final durationSec = videoEl.duration;
  final maxSec = durationSec.isFinite && durationSec > 0 ? durationSec : null;
  final targetSec = maxSec == null
      ? math.max(timeMs / 1000, 0)
      : math.min(math.max(timeMs / 1000, 0), math.max(maxSec - 0.05, 0));

  if ((videoEl.currentTime - targetSec).abs() > 0.05) {
    videoEl.currentTime = targetSec;
    await _waitVideoEvent(videoEl, 'seeked');
  }

  await _waitForPaintedFrame(videoEl);

  final canvas = HTMLCanvasElement();
  final ctx = canvas.getContext('2d');
  if (ctx == null) {
    throw PlatformException(
      code: 'CANVAS_CONTEXT_ERROR',
      message: 'Could not get 2d context',
    );
  }
  final c2d = ctx as CanvasRenderingContext2D;

  final mw = maxWidth;
  final aspectRatio = videoEl.videoWidth / videoEl.videoHeight;
  if (aspectRatio.isNaN || aspectRatio.isInfinite || aspectRatio <= 0) {
    return null;
  }
  final mh = (mw / aspectRatio).round();

  canvas
    ..width = mw
    ..height = mh;
  c2d.drawImage(videoEl, 0, 0, mw, mh);

  final dataUrl = canvas.toDataURL('image/jpeg', 0.85.toJS);
  final parts = dataUrl.split(',');
  if (parts.length < 2) return null;
  final bytes = base64Decode(parts[1]);
  return img.decodeImage(bytes);
}

/// seeked 后等待浏览器真正把帧画到 video 上，避免 canvas 截到白屏。
Future<void> _waitForPaintedFrame(HTMLVideoElement videoEl) async {
  if (videoEl.readyState < HTMLMediaElement.HAVE_CURRENT_DATA) {
    await _waitVideoEvent(videoEl, 'loadeddata');
  }
  await Future<void>.delayed(const Duration(milliseconds: 16));
}

Future<void> _waitVideoEvent(HTMLVideoElement videoEl, String eventName) {
  final completer = Completer<void>();
  void handler(Event _) {
    if (!completer.isCompleted) completer.complete();
  }

  final jsHandler = handler.toJS;
  videoEl.addEventListener(eventName, jsHandler);
  return completer.future.whenComplete(
    () => videoEl.removeEventListener(eventName, jsHandler),
  );
}

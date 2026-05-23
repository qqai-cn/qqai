import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:web/web.dart';

/// Web 端复用同一个 `<video>` 顺序 seek，避免每帧重新加载 blob 视频。
Future<List<img.Image?>> extractCoverStyleFrames({
  required String videoPath,
  required List<int> timePointsMs,
  required int maxWidth,
  required int batchSize,
}) async {
  if (timePointsMs.isEmpty) return const [];

  final videoEl = HTMLVideoElement()
    ..crossOrigin = 'anonymous'
    ..preload = 'auto'
    ..src = videoPath;

  try {
    await _waitVideoReady(videoEl);
    final results = <img.Image?>[];
    for (final timeMs in timePointsMs) {
      results.add(
        await _captureFrame(
          videoEl: videoEl,
          timeMs: timeMs,
          maxWidth: maxWidth,
        ),
      );
    }
    return results;
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

Future<void> _waitVideoReady(HTMLVideoElement videoEl) async {
  if (videoEl.readyState >= 1) return;

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
    ..addEventListener('loadedmetadata', readyHandler)
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
      ..removeEventListener('loadedmetadata', readyHandler)
      ..removeEventListener('error', errorHandler);
  }
}

Future<img.Image?> _captureFrame({
  required HTMLVideoElement videoEl,
  required int timeMs,
  required int maxWidth,
}) async {
  final durationSec = videoEl.duration;
  final maxSec = durationSec.isFinite && durationSec > 0 ? durationSec : null;
  final targetSec = maxSec == null
      ? math.max(timeMs / 1000, 0)
      : math.min(math.max(timeMs / 1000, 0), math.max(maxSec - 0.05, 0));

  if ((videoEl.currentTime - targetSec).abs() > 0.05) {
    videoEl.currentTime = targetSec;
    await _waitVideoEvent(videoEl, 'seeked');
  }

  final canvas = HTMLCanvasElement();
  final ctx = canvas.getContext('2d');
  if (ctx == null) {
    throw PlatformException(
      code: 'CANVAS_CONTEXT_ERROR',
      message: 'Could not get 2d context',
    );
  }
  final c2d = ctx as CanvasRenderingContext2D;

  var mw = maxWidth;
  var mh = 0;
  final aspectRatio = videoEl.videoWidth / videoEl.videoHeight;
  if (aspectRatio.isNaN || aspectRatio.isInfinite || aspectRatio <= 0) {
    return null;
  }
  mh = (mw / aspectRatio).round();

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

import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:math' as math;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get_thumbnail_video/src/image_format.dart';
import 'package:get_thumbnail_video/src/video_thumbnail_platform.dart';
import 'package:web/web.dart';

// An error code value to error name Map.
// See: https://developer.mozilla.org/en-US/docs/Web/API/MediaError/code
const Map<int, String> _kErrorValueToErrorName = <int, String>{
  1: 'MEDIA_ERR_ABORTED',
  2: 'MEDIA_ERR_NETWORK',
  3: 'MEDIA_ERR_DECODE',
  4: 'MEDIA_ERR_SRC_NOT_SUPPORTED',
};

// An error code value to description Map.
// See: https://developer.mozilla.org/en-US/docs/Web/API/MediaError/code
const Map<int, String> _kErrorValueToErrorDescription = <int, String>{
  1: 'The user canceled the fetching of the video.',
  2: 'A network error occurred while fetching the video, despite having previously been available.',
  3: 'An error occurred while trying to decode the video, despite having previously been determined to be usable.',
  4: 'The video has been found to be unsuitable (missing or in a format not supported by your browser).',
};

// The default error message, when the error is an empty string
// See: https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/error
const String _kDefaultErrorMessage =
    'No further diagnostic information can be determined or provided.';

/// A web implementation of the VideoThumbnailPlatform of the VideoThumbnail plugin.
class VideoThumbnailWeb extends VideoThumbnailPlatform {
  /// Constructs a VideoThumbnailWeb
  VideoThumbnailWeb();

  static void registerWith(Registrar registrar) {
    VideoThumbnailPlatform.instance = VideoThumbnailWeb();
  }

  @override
  Future<XFile> thumbnailFile({
    required String video,
    required Map<String, String>? headers,
    required String? thumbnailPath,
    required ImageFormat imageFormat,
    required int maxHeight,
    required int maxWidth,
    required int timeMs,
    required int quality,
  }) async {
    final blob = await _createThumbnail(
      videoSrc: video,
      headers: headers,
      imageFormat: imageFormat,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      timeMs: timeMs,
      quality: quality,
    );

    return XFile(URL.createObjectURL(blob), mimeType: blob.type);
  }

  @override
  Future<Uint8List> thumbnailData({
    required String video,
    required Map<String, String>? headers,
    required ImageFormat imageFormat,
    required int maxHeight,
    required int maxWidth,
    required int timeMs,
    required int quality,
  }) async {
    final blob = await _createThumbnail(
      videoSrc: video,
      headers: headers,
      imageFormat: imageFormat,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      timeMs: timeMs,
      quality: quality,
    );
    final path = URL.createObjectURL(blob);
    final file = XFile(path, mimeType: blob.type);
    final bytes = await file.readAsBytes();
    URL.revokeObjectURL(path);

    return bytes;
  }

  Blob _blobFromCanvasSync(
    HTMLCanvasElement canvas,
    ImageFormat imageFormat,
    int quality,
  ) {
    final mime = _imageFormatToCanvasFormat(imageFormat);
    final dataUrl = canvas.toDataURL(mime, (quality / 100).toJS);
    final parts = dataUrl.split(',');
    if (parts.length < 2) {
      throw PlatformException(
        code: 'CANVAS_EXPORT_ERROR',
        message: 'Canvas returned invalid data URL',
      );
    }
    final bytes = base64Decode(parts[1]);
    return Blob(
      [bytes.toJS].toJS,
      BlobPropertyBag(type: mime),
    );
  }

  Future<Blob> _createThumbnail({
    required String videoSrc,
    required Map<String, String>? headers,
    required ImageFormat imageFormat,
    required int maxHeight,
    required int maxWidth,
    required int timeMs,
    required int quality,
  }) async {
    final completer = Completer<Blob>();

    final videoEl = HTMLVideoElement();
    final timeSec = math.max(timeMs / 1000, 0);
    final fetchVideo = headers != null && headers.isNotEmpty;

    videoEl.onloadedmetadata = ((Event _) {
      videoEl.currentTime = timeSec;

      if (fetchVideo) {
        URL.revokeObjectURL(videoEl.src);
      }
    }).toJS;

    videoEl.onseeked = ((Event _) {
      if (completer.isCompleted) return;
      final canvas = HTMLCanvasElement();
      final ctx = canvas.getContext('2d');
      if (ctx == null) {
        completer.completeError(
          PlatformException(
            code: 'CANVAS_CONTEXT_ERROR',
            message: 'Could not get 2d context',
          ),
        );
        return;
      }
      final c2d = ctx as CanvasRenderingContext2D;

      var mw = maxWidth;
      var mh = maxHeight;

      if (mw == 0 && mh == 0) {
        canvas
          ..width = videoEl.videoWidth
          ..height = videoEl.videoHeight;
        c2d.drawImage(videoEl, 0, 0);
      } else {
        final aspectRatio = videoEl.videoWidth / videoEl.videoHeight;
        if (mw == 0) {
          mw = (mh * aspectRatio).round();
        } else if (mh == 0) {
          mh = (mw / aspectRatio).round();
        }

        final inputAspectRatio = mw / mh;
        if (aspectRatio > inputAspectRatio) {
          mh = (mw / aspectRatio).round();
        } else {
          mw = (mh * aspectRatio).round();
        }

        canvas
          ..width = mw
          ..height = mh;
        c2d.drawImage(videoEl, 0, 0, mw, mh);
      }

      try {
        final blob = _blobFromCanvasSync(canvas, imageFormat, quality);
        completer.complete(blob);
      } catch (e, s) {
        completer.completeError(
          PlatformException(
            code: 'CANVAS_EXPORT_ERROR',
            details: e,
            stacktrace: s.toString(),
          ),
          s,
        );
      }
    }).toJS;

    videoEl.onerror = ((Event _) {
      if (!completer.isCompleted) {
        final err = videoEl.error;
        if (err != null) {
          completer.completeError(
            PlatformException(
              code: _kErrorValueToErrorName[err.code]!,
              message: err.message != '' ? err.message : _kDefaultErrorMessage,
              details: _kErrorValueToErrorDescription[err.code],
            ),
          );
        } else {
          completer.completeError(
            PlatformException(
              code: 'VIDEO_ERROR',
              message: _kDefaultErrorMessage,
            ),
          );
        }
      }
    }).toJS;

    if (fetchVideo) {
      try {
        final blob = await _fetchVideoByHeaders(
          videoSrc: videoSrc,
          headers: headers,
        );

        videoEl.src = URL.createObjectURL(blob);
      } catch (e, s) {
        completer.completeError(e, s);
      }
    } else {
      videoEl
        ..crossOrigin = 'Anonymous'
        ..src = videoSrc;
    }

    return completer.future;
  }

  /// Fetching video by [headers].
  Future<Blob> _fetchVideoByHeaders({
    required String videoSrc,
    required Map<String, String> headers,
  }) async {
    final completer = Completer<Blob>();

    final xhr = XMLHttpRequest();
    xhr.open('GET', videoSrc, true);
    xhr.responseType = 'blob';
    headers.forEach((name, value) {
      xhr.setRequestHeader(name, value);
    });

    xhr.onload = ((Event _) {
      final resp = xhr.response;
      if (resp != null) {
        completer.complete(resp as Blob);
      } else {
        completer.completeError(
          PlatformException(
            code: 'VIDEO_FETCH_ERROR',
            message: 'Empty or invalid response',
          ),
        );
      }
    }).toJS;

    xhr.onerror = ((Event _) {
      completer.completeError(
        PlatformException(
          code: 'VIDEO_FETCH_ERROR',
          message: 'Status: ${xhr.statusText}',
        ),
      );
    }).toJS;

    xhr.send();

    return completer.future;
  }

  String _imageFormatToCanvasFormat(ImageFormat imageFormat) {
    switch (imageFormat) {
      case ImageFormat.JPEG:
        return 'image/jpeg';
      case ImageFormat.PNG:
        return 'image/png';
      case ImageFormat.WEBP:
        return 'image/webp';
    }
  }
}

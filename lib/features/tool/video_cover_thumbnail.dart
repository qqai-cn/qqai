import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';

class LocalThumbnailRequest {
  const LocalThumbnailRequest({
    required this.video,
    required this.thumbnailPath,
    required this.imageFormat,
    required this.maxHeight,
    required this.maxWidth,
    required this.timeMs,
    required this.quality,
    required this.attachHeaders,
    required this.fit,
  });

  final String video;
  final String? thumbnailPath;
  final ImageFormat imageFormat;
  final int maxHeight;
  final int maxWidth;
  final int timeMs;
  final int quality;
  final bool attachHeaders;
  final BoxFit fit;
}

class ThumbnailResult {
  const ThumbnailResult({
    required this.image,
    required this.dataSize,
    required this.height,
    required this.width,
  });

  final Image image;
  final int dataSize;
  final int height;
  final int width;
}

Future<ThumbnailResult> genThumbnail(LocalThumbnailRequest r, int count) async {
  Uint8List bytes;
  final completer = Completer<ThumbnailResult>();
  if (r.thumbnailPath != null) {
    final thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: r.video,
      headers:
          r.attachHeaders
              ? const {
                'USERHEADER1': 'user defined header1',
                'USERHEADER2': 'user defined header2',
              }
              : null,
      thumbnailPath: r.thumbnailPath,
      imageFormat: r.imageFormat,
      maxHeight: r.maxHeight,
      maxWidth: r.maxWidth,
      timeMs: r.timeMs,
      quality: r.quality,
    );

    debugPrint('thumbnail file is located: $thumbnailFile');

    bytes = await thumbnailFile.readAsBytes();
  } else {
    bytes = await VideoThumbnail.thumbnailData(
      video: r.video,
      headers:
          r.attachHeaders
              ? const {
                'USERHEADER1': 'user defined header1',
                'USERHEADER2': 'user defined header2',
              }
              : null,
      imageFormat: r.imageFormat,
      maxHeight: r.maxHeight,
      maxWidth: r.maxWidth,
      timeMs: r.timeMs,
      quality: r.quality,
    );
  }
  count++;
  if (count >= 15) {
    debugPrint('more count: $count return');
    return completer.future;
  }
  final imageDataSize = bytes.length;
  debugPrint('image size: $imageDataSize');

  final image = Image.memory(bytes, fit: r.fit);
  image.image
      .resolve(ImageConfiguration.empty)
      .addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          completer.complete(
            ThumbnailResult(
              image: image,
              dataSize: imageDataSize,
              height: info.image.height,
              width: info.image.width,
            ),
          );
        }, onError: completer.completeError),
      );
  return completer.future;
}

class GenThumbnailImage extends StatefulWidget {
  const GenThumbnailImage({super.key, required this.thumbnailRequest});

  final LocalThumbnailRequest thumbnailRequest;

  @override
  State<GenThumbnailImage> createState() => _GenThumbnailImageState();
}

class _GenThumbnailImageState extends State<GenThumbnailImage> {
  @override
  Widget build(BuildContext context) {
    late int count = 0;
    return FutureBuilder<ThumbnailResult>(
      future: genThumbnail(widget.thumbnailRequest, count),
      builder: (BuildContext context, AsyncSnapshot<ThumbnailResult> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final image = data.image;
          return SizedBox.expand(child: image);
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(8),
            color: Colors.red.withValues(alpha: 0.85),
            child: const Text(
              '生成失败',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return Center(
            child: Text(
              '加载中...',
              style: context.typo.body.copyWith(
                color: GoodsPageStyle.sub(context),
              ),
            ),
          );
        }
      },
    );
  }
}

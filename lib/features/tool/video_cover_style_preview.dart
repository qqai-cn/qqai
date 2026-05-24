import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:qqai/config/theme/app_typography.dart';

import 'video_cover_sampling.dart';
import 'video_cover_thumbnail.dart';
import 'video_cover_tool.dart';

/// 将 400×800 画布按 topCenter 裁入 400/500 外框，与发布页缩略图一致。
class VideoCoverFramedContent extends StatelessWidget {
  const VideoCoverFramedContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: qqaiVideoCoverCanvasWidth,
        height: qqaiVideoCoverCanvasHeight,
        child: child,
      ),
    );
  }
}

Size resolveVideoCoverPreviewSize({
  required double maxWidth,
  required double maxHeight,
}) {
  var width = maxWidth;
  var height = width / qqaiVideoCoverAspectRatio;
  if (height > maxHeight) {
    height = maxHeight;
    width = height * qqaiVideoCoverAspectRatio;
  }
  return Size(width, height);
}

Future<Uint8List?> captureVideoCoverStylePreview(GlobalKey repaintKey) async {
  final boundary = repaintKey.currentContext?.findRenderObject();
  if (boundary is! RenderRepaintBoundary) return null;
  final image = await boundary.toImage(pixelRatio: 2.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) return null;
  return byteData.buffer.asUint8List();
}

void populateCoverThumbnailImages({
  required int styleId,
  required int durationSeconds,
  required String videoPath,
  required Map<int, GenThumbnailImage> imgMap,
  ImageFormat imageFormat = ImageFormat.WEBP,
  bool attachHeaders = false,
}) {
  imgMap.clear();
  final durationMs = durationSeconds * 1000;
  final timePoints = computeCoverStyleTimePoints(durationMs, styleId);
  debugPrint('populateCoverThumbnailImages:$styleId,seconds:$durationSeconds');

  for (var i = 0; i < timePoints.length; i++) {
    final slot = i + 1;
    final fit = styleId == 1 && slot > 1 ? BoxFit.fitWidth : BoxFit.cover;
    imgMap[slot] = GenThumbnailImage(
      thumbnailRequest: LocalThumbnailRequest(
        video: videoPath,
        thumbnailPath: null,
        imageFormat: imageFormat,
        maxHeight: 0,
        maxWidth: 0,
        timeMs: timePoints[i],
        quality: 100,
        attachHeaders: attachHeaders,
        fit: fit,
      ),
    );
  }
}

Widget buildVideoCoverStyleView(
  int index,
  Map<int, GenThumbnailImage?> imgMap,
  BuildContext context,
) {
    if (index == 1) {
      return ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 0.625,
          child: Container(
            width: 400,
            height: 800,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // colors: [Colors.white, Color(0xfcfcfc)],
                colors: [Colors.white, Colors.grey.withValues(alpha: 0.5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Container(height: 16),
                Container(
                  height: 205,
                  width: 367,
                  color: Colors.blueAccent,
                  child:
                      imgMap[1] == null
                          ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此1',
                              style: context.typo.body.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          )
                          : imgMap[1],
                ),
                Container(
                  height: 4,
                  width: 367,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.black54, Colors.white],
                      // 中间浅，两边深
                      stops: [0.0, 0.5, 1.0],
                      // 渐变从中间扩散
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        // begin: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                        // end: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.transparent],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.195,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationX(3.14159),
                          // 180° 翻转
                          child: Container(
                            width: 367,
                            height: 205,
                            child: imgMap[1],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   height: 30,
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [Colors.grey, Colors.white], // 渐变颜色
                //       begin: Alignment.topCenter, // 渐变起点（顶部）
                //       end: Alignment.bottomCenter, // 渐变终点（底部）
                //     ),
                //   ),
                // ),
                Row(
                  children: [
                    SizedBox(width: 17),
                    Container(
                      //197,
                      height: 98.5,
                      //358
                      width: 179,
                      color:
                          imgMap[2] == null
                              ? Colors.blueAccent
                              : Colors.black,
                      child:
                          imgMap[2] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此2',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[2],
                    ),
                    SizedBox(width: 8),
                    Container(
                      //197,
                      height: 98.5,
                      //358
                      width: 179,
                      color:
                          imgMap[3] == null
                              ? Colors.blueAccent
                              : Colors.black,
                      child:
                          imgMap[3] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此3',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[3],
                    ),
                  ],
                ),
                Container(height: 8),
                Row(
                  children: [
                    Container(width: 17),
                    Container(
                      //197,
                      height: 98.5,
                      //358
                      width: 179,
                      color:
                          imgMap[4] == null
                              ? Colors.blueAccent
                              : Colors.black,
                      child:
                          imgMap[4] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此4',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[4],
                    ),
                    SizedBox(width: 8),
                    Container(
                      //197,
                      height: 98.5,
                      //358
                      width: 179,
                      color:
                          imgMap[5] == null
                              ? Colors.blueAccent
                              : Colors.black,
                      child:
                          imgMap[5] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此5',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[5],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else if (index == 2) {
      return ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 0.625,
          child: Container(
            width: 400,
            height: 800,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // colors: [Colors.white, Color(0xfcfcfc)],
                colors: [Colors.white, Colors.grey.withValues(alpha: 0.5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Container(height: 16),
                Container(
                  height: 205,
                  width: 367,
                  color: Colors.blueAccent,
                  child:
                      imgMap[1] == null
                          ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此1',
                              style: context.typo.body.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          )
                          : imgMap[1],
                ),
                Container(
                  height: 4,
                  width: 367,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.black54, Colors.white],
                      // 中间浅，两边深
                      stops: [0.0, 0.5, 1.0],
                      // 渐变从中间扩散
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        // begin: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                        // end: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.transparent],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.195,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationX(3.14159),
                          // 180° 翻转
                          child: Container(
                            width: 367,
                            height: 205,
                            child: imgMap[1],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: 16.5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[2] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此2',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[2],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[3] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此3',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[3],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[4] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此4',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[4],
                    ),
                  ],
                ),
                Container(height: 5),
                Row(
                  children: [
                    Container(width: 16.5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[5] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此5',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[5],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[6] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此6',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[6],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[7] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此7',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[7],
                    ),
                  ],
                ),
                Container(height: 5),
                Row(
                  children: [
                    Container(width: 16.5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[8] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此8',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[8],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[9] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此9',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[9],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[10] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此10',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[10],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else if (index == 3) {
      return ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 0.625,
          child: Container(
            width: 400,
            height: 800,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // colors: [Colors.white, Color(0xfcfcfc)],
                colors: [Colors.white, Colors.grey.withValues(alpha: 0.5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Container(height: 30),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // 阴影颜色
                        offset: Offset(3, 3), // 阴影偏移量，正值表示向右和向下
                        blurRadius: 10, // 阴影模糊半径
                        spreadRadius: 2, // 阴影扩散半径
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 441,
                      width: 211,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3), // 阴影颜色
                            // color: Colors.black, // 阴影颜色
                            offset: Offset(3, 3), // 阴影偏移量，正值表示向右和向下
                            blurRadius: 15, // 阴影模糊半径
                            spreadRadius: 2, // 阴影扩散半径
                          ),
                        ],
                      ),
                      child:
                          imgMap[1] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此1',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[1],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 0.625,
          child: Container(
            width: 400,
            height: 800,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // colors: [Colors.white, Color(0xfcfcfc)],
                colors: [Colors.white, Colors.grey.withValues(alpha: 0.5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Container(height: 40),
                Row(
                  children: [
                    SizedBox(width: 16.5),
                    Container(
                      height: 210,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[1] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此1',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[1],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 210,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[2] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此2',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[2],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 210,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[3] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此3',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[3],
                    ),
                  ],
                ),
                Container(height: 5),
                Row(
                  children: [
                    Container(width: 16.5),
                    Container(
                      height: 210,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[4] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此4',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[4],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 210,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[5] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此5',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[5],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 210,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          imgMap[6] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此6',
                                  style: context.typo.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : imgMap[6],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
}

class VideoCoverStylePreview extends StatefulWidget {
  const VideoCoverStylePreview({
    super.key,
    required this.videoPath,
    required this.styleId,
    required this.durationSeconds,
    required this.repaintKey,
  });

  final String videoPath;
  final int styleId;
  final int durationSeconds;
  final GlobalKey repaintKey;

  @override
  State<VideoCoverStylePreview> createState() => VideoCoverStylePreviewState();
}

class VideoCoverStylePreviewState extends State<VideoCoverStylePreview> {
  final Map<int, GenThumbnailImage> _imgMap = {};

  Map<int, GenThumbnailImage?> get imgMap => _imgMap;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) regenerate();
    });
  }

  void regenerate() {
    populateCoverThumbnailImages(
      styleId: widget.styleId,
      durationSeconds: widget.durationSeconds,
      videoPath: widget.videoPath,
      imgMap: _imgMap,
    );
    setState(() {});
  }

  Future<Uint8List?> capture() => captureVideoCoverStylePreview(widget.repaintKey);

  @override
  void didUpdateWidget(VideoCoverStylePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.styleId != widget.styleId ||
        oldWidget.videoPath != widget.videoPath ||
        oldWidget.durationSeconds != widget.durationSeconds) {
      regenerate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.repaintKey,
      child: buildVideoCoverStyleView(widget.styleId, _imgMap, context),
    );
  }
}

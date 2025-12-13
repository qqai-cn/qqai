import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qqai/app/pages/tool/widgets/custom_video_progress_bar.dart';
import 'package:video_player/video_player.dart';
import 'dart:html' as html;
import 'package:image/image.dart' as img;

import 'controllers/tool_controller.dart';

class ThumbnailRequest {
  const ThumbnailRequest({
    required this.video,
    required this.thumbnailPath,
    required this.imageFormat,
    required this.maxHeight,
    required this.maxWidth,
    required this.timeMs,
    required this.quality,
    required this.attachHeaders,
  });

  final String video;
  final String? thumbnailPath;
  final ImageFormat imageFormat;
  final int maxHeight;
  final int maxWidth;
  final int timeMs;
  final int quality;
  final bool attachHeaders;
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

Future<ThumbnailResult> genThumbnail(ThumbnailRequest r) async {
  Uint8List bytes;
  final completer = Completer<ThumbnailResult>();
  if (r.thumbnailPath != null) {
    final thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: r.video,
      headers: r.attachHeaders
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
      headers: r.attachHeaders
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

  final imageDataSize = bytes.length;
  debugPrint('image size: $imageDataSize');

  final image = Image.memory(
    bytes,
    fit: BoxFit.cover,
  );
  image.image.resolve(ImageConfiguration.empty).addListener(
        ImageStreamListener(
          (ImageInfo info, bool _) {
            completer.complete(
              ThumbnailResult(
                image: image,
                dataSize: imageDataSize,
                height: info.image.height,
                width: info.image.width,
              ),
            );
          },
          onError: completer.completeError,
        ),
      );
  return completer.future;
}

class GenThumbnailImage extends StatefulWidget {
  const GenThumbnailImage({
    Key? key,
    required this.thumbnailRequest,
  }) : super(key: key);
  final ThumbnailRequest thumbnailRequest;

  @override
  State<GenThumbnailImage> createState() => _GenThumbnailImageState();
}

class _GenThumbnailImageState extends State<GenThumbnailImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThumbnailResult>(
      future: genThumbnail(widget.thumbnailRequest),
      builder: (BuildContext context, AsyncSnapshot<ThumbnailResult> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final image = data.image;
          return Container(
            width: double.infinity, // 宽度铺满
            height: double.infinity,
            child: image,
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(8),
            color: Colors.red,
            child: Text('Error:\n${snapshot.error}\n\n${snapshot.stackTrace}'),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Generating the thumbnail for: ${widget.thumbnailRequest.video}...',
              ),
              const SizedBox(height: 10),
              const CircularProgressIndicator(),
            ],
          );
        }
      },
    );
  }
}

class ThumbnailPage extends StatefulWidget {
  const ThumbnailPage({Key? key}) : super(key: key);

  @override
  State<ThumbnailPage> createState() => _ThumbnailPage();
}

class _ThumbnailPage extends State<ThumbnailPage> {
  late ToolController toolController;
  GlobalKey _globalKey = GlobalKey(); // 用于获取截图
  final _editNode = FocusNode();
  final _video = TextEditingController(
    text:
        'https://cloud.video.taobao.com/play/u/153810888/p/2/e/6/t/1/266102583124.mp4',
    // '',
  );
  ImageFormat _format = ImageFormat.JPEG;
  bool _attachHeaders = false;

  String? _tempDir;
  late VideoPlayerController _controller;
  Duration? _duration;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      getTemporaryDirectory().then((d) => _tempDir = d.path);
    }
    _controller = VideoPlayerController.network(_video.text)
      ..initialize().then((_) {
        setState(() {
          int seconds = _controller.value.duration.inSeconds; // 获取秒数
          _duration = Duration(seconds: seconds); // 转换为Duration
        });
      });
    toolController = Get.put(ToolController());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('封面生成器'),
      ),
      body: GetBuilder<ToolController>(builder: (a) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 50,
            ),
            Center(
              child: Row(
                children: [
                  Spacer(),
                  Container(
                    width: 400,
                    // height: 500,
                    // color: Colors.amber,
                    decoration: BoxDecoration(
                      // color: Colors.grey,
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        _controller.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: 1.5,
                                child: VideoPlayer(_controller),
                              )
                            : Center(child: CircularProgressIndicator()),
                        CustomVideoProgressBar(
                          controller: _controller,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                              child: Icon(_controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                authCreate(toolController.curStyle);
                              },
                              child: Text('自动填充'),
                            ),
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: Text("横版封面一"),
                              onPressed: () {
                                toolController.setStyle(1);
                              },
                            ),
                            Spacer(),
                            ElevatedButton(
                              child: Text("横版封面二"),
                              onPressed: () {
                                toolController.setStyle(2);
                              },
                            ),
                            Spacer(),
                            ElevatedButton(
                              child: Text("竖版封面"),
                              onPressed: () {
                                toolController.setStyle(3);
                              },
                            ),
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("添加到："),
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        getRows(toolController.curStyle),
                      ],
                    ),
                  ),
                  Spacer(),
                  RepaintBoundary(
                    key: _globalKey,
                    child: getView(toolController.curStyle),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        );
      }),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () async {
              final video =
                  await ImagePicker().pickVideo(source: ImageSource.gallery);
              setState(() {
                _controller = VideoPlayerController.network(video!.path)
                  ..initialize().then((_) {
                    setState(() {
                      int seconds =
                          _controller.value.duration.inSeconds; // 获取秒数
                      _duration = Duration(seconds: seconds); // 转换为Duration
                    });
                  });
                _video.text = video.path ?? '';
              });
            },
            tooltip: '选择一个视频',
            child: const Icon(Icons.local_movies),
          ),
          FloatingActionButton(
            onPressed: () async {
              _captureAndDownload();
            },
            tooltip: '下载视频',
            child: const Icon(Icons.download),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  Future<int?> getVideoDuration(String videoPath,
      {bool isAsset = false}) async {
    final controller = isAsset
        ? VideoPlayerController.asset(videoPath)
        : VideoPlayerController.network(videoPath);
    try {
      await controller.initialize().timeout(Duration(seconds: 10),
          onTimeout: () {
        throw TimeoutException('视频加载超时');
      });
      return controller.value.duration.inSeconds;
    } catch (e) {
      print('获取视频时长失败: $e');
      return null;
    } finally {
      await controller.dispose();
    }
  }

  void authCreate(int index) {
    int seconds = _controller.value.duration.inMilliseconds; // 获取秒数

    if (index == 1) {
      int per = (seconds / 6).toInt();
      for (int i = 1; i <= 5; i++) {
        print(per * i);
        GenThumbnailImage tmp = GenThumbnailImage(
          thumbnailRequest: ThumbnailRequest(
            video: _video.text,
            thumbnailPath: null,
            imageFormat: _format,
            maxHeight: 0,
            maxWidth: 0,
            timeMs: per * i,
            quality: 100,
            attachHeaders: _attachHeaders,
          ),
        );
        toolController.setGenThumbnailImage(i, tmp);
      }
    } else if (index == 2) {
      int per = (seconds / 11).toInt();
      for (int i = 1; i <= 10; i++) {
        GenThumbnailImage tmp = GenThumbnailImage(
          thumbnailRequest: ThumbnailRequest(
            video: _video.text,
            thumbnailPath: null,
            imageFormat: _format,
            maxHeight: 0,
            maxWidth: 0,
            timeMs: per * i,
            quality: 100,
            attachHeaders: _attachHeaders,
          ),
        );
        toolController.setGenThumbnailImage(i, tmp);
      }
    } else {
      print((seconds / 2).toInt());
      GenThumbnailImage tmp = GenThumbnailImage(
        thumbnailRequest: ThumbnailRequest(
          video: _video.text,
          thumbnailPath: null,
          imageFormat: _format,
          maxHeight: 0,
          maxWidth: 0,
          timeMs: (seconds / 2).toInt(),
          quality: 100,
          attachHeaders: _attachHeaders,
        ),
      );
      toolController.setGenThumbnailImage(1, tmp);
    }
  }

  Widget getRows(int index) {
    if (index == 1) {
      return Wrap(
        children: [
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(1, tmp);
              },
              child: Text("1")),
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(2, tmp);
              },
              child: Text("2")),
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(3, tmp);
              },
              child: Text("3")),
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(4, tmp);
              },
              child: Text("4")),
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(5, tmp);
              },
              child: Text("5")),
        ],
      );
    } else if (index == 2) {
      return Wrap(
        children: [
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(1, tmp);
              },
              child: Text("1")),
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(2, tmp);
              },
              child: Text("2")),
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(3, tmp);
              },
              child: Text("3")),
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(4, tmp);
              },
              child: Text("4")),
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(5, tmp);
              },
              child: Text("5")),
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(6, tmp);
              },
              child: Text("6")),
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(7, tmp);
              },
              child: Text("7")),
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(8, tmp);
              },
              child: Text("8")),
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(9, tmp);
              },
              child: Text("9")),
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(10, tmp);
              },
              child: Text("10")),
        ],
      );
    } else {
      return Wrap(
        children: [
          ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: ThumbnailRequest(
                    video: _video.text,
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: _controller.value.position.inMilliseconds,
                    quality: 100,
                    attachHeaders: _attachHeaders,
                  ),
                );
                toolController.setGenThumbnailImage(1, tmp);
              },
              child: Text("1")),
        ],
      );
    }
  }

  Widget getView(int index) {
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
              colors: [Colors.white, Color(0xfcfcfc)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 16,
              ),
              Container(
                height: 205,
                width: 365,
                color: Colors.blueAccent,
                child: toolController.imgMap[1] == null
                    ? IconButton(
                        onPressed: () {},
                        icon: Text(
                          '添加到此1',
                          style: TextStyle(color: Colors.white),
                        ))
                    : toolController.imgMap[1],
              ),
              Container(
                height: 4,
                width: 365,
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
                          width: 365,
                          height: 205,
                          child: toolController.imgMap[1],
                        ),
                      ),
                    )),
                  )),
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
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    //197,
                    height: 98.5,
                    //358
                    width: 179,
                    color: Colors.blueAccent,
                    child: toolController.imgMap[2] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此2',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[2],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    //197,
                    height: 98.5,
                    //358
                    width: 179,
                    color: Colors.blueAccent,
                    child: toolController.imgMap[3] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此3',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[3],
                  ),
                ],
              ),
              Container(
                height: 8,
              ),
              Row(
                children: [
                  Container(
                    width: 15,
                  ),
                  Container(
                    //197,
                    height: 98.5,
                    //358
                    width: 179,
                    color: Colors.blueAccent,
                    child: toolController.imgMap[4] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此4',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[4],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    //197,
                    height: 98.5,
                    //358
                    width: 179,
                    color: Colors.blueAccent,
                    child: toolController.imgMap[5] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此5',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[5],
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
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
              colors: [Colors.white, Color(0xfcfcfc)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 16,
              ),
              Container(
                height: 205,
                width: 365,
                color: Colors.blueAccent,
                child: toolController.imgMap[1] == null
                    ? IconButton(
                        onPressed: () {},
                        icon: Text(
                          '添加到此1',
                          style: TextStyle(color: Colors.white),
                        ))
                    : toolController.imgMap[1],
              ),
              Container(
                height: 4,
                width: 365,
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
                          width: 365,
                          height: 205,
                          child: toolController.imgMap[1],
                        ),
                      ),
                    )),
                  )),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 67,
                    width: 119,
                    color: Colors.blueAccent,
                    child: toolController.imgMap[2] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此2',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[2],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 67,
                    width: 119,
                    color: Colors.blueAccent,
                    child: toolController.imgMap[3] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此3',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[3],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 67,
                    width: 119,
                    color: Colors.blueAccent,
                    child: toolController.imgMap[4] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此4',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[4],
                  ),
                ],
              ),
              Container(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    width: 15,
                  ),
                  Container(
                    height: 67,
                    width: 119,
                    color: Colors.blueAccent,
                    child: toolController.imgMap[5] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此5',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[5],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 67,
                    width: 119,
                    color: Colors.blueAccent,
                    child: toolController.imgMap[6] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此6',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[6],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 67,
                    width: 119,
                    color: Colors.blueAccent,
                    child: toolController.imgMap[7] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此7',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[7],
                  ),
                ],
              ),
              Container(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    width: 15,
                  ),
                  Container(
                    height: 67,
                    width: 119,
                    color: Colors.blueAccent,
                    child: toolController.imgMap[8] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此8',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[8],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 67,
                    width: 119,
                    color: Colors.blueAccent,
                    child: toolController.imgMap[9] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此9',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[9],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 67,
                    width: 119,
                    color: Colors.blueAccent,
                    child: toolController.imgMap[10] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此10',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[10],
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
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
              colors: [Colors.white, Color(0xfcfcfc)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // 阴影颜色
                    offset: Offset(3, 3), // 阴影偏移量，正值表示向右和向下
                    blurRadius: 10, // 阴影模糊半径
                    spreadRadius: 2, // 阴影扩散半径
                  ),
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 441,
                    width: 211,
                    decoration:
                        BoxDecoration(color: Colors.blueAccent, boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // 阴影颜色
                        // color: Colors.black, // 阴影颜色
                        offset: Offset(3, 3), // 阴影偏移量，正值表示向右和向下
                        blurRadius: 15, // 阴影模糊半径
                        spreadRadius: 2, // 阴影扩散半径
                      ),
                    ]),
                    child: toolController.imgMap[1] == null
                        ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此1',
                              style: TextStyle(color: Colors.white),
                            ))
                        : toolController.imgMap[1],
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }
  }

  Future<void> _captureAndDownload() async {
    try {
      // 1️⃣ 获取 RenderRepaintBoundary
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      img.Image? rawImage = img.decodeImage(pngBytes);
      // 质量90%
      Uint8List jpgBytes = img.encodeJpg(rawImage!, quality: 90);

      // 2️⃣ 触发 Web 下载
      final blob = html.Blob([jpgBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "screenshot.jpg")
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print("截图错误: $e");
    }
  }
}

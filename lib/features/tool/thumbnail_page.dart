import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'widgets/custom_video_progress_bar.dart';


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

class ToolController extends ChangeNotifier {
  final Map<int, GenThumbnailImage> imgMap = {};
  int curStyle = 1;
  VideoPlayerController? controller;
  String _videoText = '';

  Future<void> resetController(XFile video) async {
    await controller?.dispose();

    final uri = Uri.tryParse(video.path);
    final videoUri =
        (uri != null && uri.hasScheme) ? uri : Uri.file(video.path);

    final nextController = VideoPlayerController.networkUrl(videoUri);
    await nextController.initialize();

    _videoText = video.path;
    controller = nextController;
    notifyListeners();
  }

  Future<void> switchOpen() async {
    final current = controller;
    if (current == null || !current.value.isInitialized) return;
    if (current.value.isPlaying) {
      await current.pause();
    } else {
      await current.play();
    }
    notifyListeners();
  }

  void setStyle(int style) {
    curStyle = style;
    notifyListeners();
  }

  void setGenThumbnailImage(int index, GenThumbnailImage gen) {
    imgMap[index] = gen;
    notifyListeners();
  }

  void clearGenThumbnailImage() {
    imgMap.clear();
    notifyListeners();
  }

  String getVideoText() => _videoText;

  int getMilliseconds() => controller?.value.duration.inSeconds ?? 0;

  int getPositionMilliseconds() =>
      controller?.value.position.inMilliseconds ?? 0;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
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
  const GenThumbnailImage({Key? key, required this.thumbnailRequest})
    : super(key: key);
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
            color: Colors.red,
            child: Text('生成失败'),
            // child: Text('Error:\n${snapshot.error}\n\n${snapshot.stackTrace}')
          );
        } else {
          return Center(
            child: Text('加载中...', style: TextStyle(color: Colors.white)),
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

  ImageFormat _format = ImageFormat.WEBP;
  bool _attachHeaders = false;

  String? _tempDir;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      getTemporaryDirectory().then((d) => _tempDir = d.path);
    }

    toolController = ToolController();
  }

  @override
  void dispose() {
    toolController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video != null) {
      await toolController.resetController(video);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('封面生成器'),
        centerTitle: true,
        // centerTitle: false,
      ),
      body: AnimatedBuilder(
        animation: toolController,
        builder: (context, _) {
          final currentController = toolController.controller;
          final hasVideo =
              currentController != null &&
              currentController.value.isInitialized;
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        _launchURL(
                          'http://cloud.video.taobao.com/play/u/null/p/1/e/6/t/1/510926763195.mp4',
                        );
                      },
                      child: Text(
                        '使用教程',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline, // 添加下划线
                          decorationColor: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(height: 50),
                Center(
                  child: Row(
                    children: [
                      Spacer(),
                      Container(
                        width: 350,
                        // height: 500,
                        // color: Colors.amber,
                        decoration: BoxDecoration(
                          // color: Colors.grey,
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            hasVideo
                                ? AspectRatio(
                                  key: ValueKey(currentController),
                                  aspectRatio: 1.8,
                                  child: VideoPlayer(currentController),
                                )
                                : AspectRatio(
                                  aspectRatio: 1.8,
                                  child: InkWell(
                                    onTap: _pickVideo,
                                    child: Container(
                                      color: Colors.black12,
                                      alignment: Alignment.center,
                                      child: Text('请先选择视频（点击选择）'),
                                    ),
                                  ),
                                ),
                            if (hasVideo)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: _pickVideo,
                                  icon: Icon(Icons.video_library),
                                  label: Text('更换视频'),
                                ),
                              ),
                            if (hasVideo)
                              CustomVideoProgressBar(
                                controller: currentController,
                              ),
                            if (!hasVideo) SizedBox(height: 3),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed:
                                      hasVideo
                                          ? () {
                                            toolController.switchOpen();
                                          }
                                          : null,
                                  child: Icon(
                                    hasVideo &&
                                            currentController.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                ),
                                Spacer(),
                                ElevatedButton(
                                  onPressed:
                                      hasVideo
                                          ? () {
                                            authCreate(toolController.curStyle);
                                          }
                                          : null,
                                  child: Text('自动填充'),
                                ),
                              ],
                            ),
                            Container(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                ElevatedButton(
                                  child: Text(
                                    "横版封面1",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () {
                                    toolController.setStyle(1);
                                  },
                                ),
                                Spacer(),
                                ElevatedButton(
                                  child: Text(
                                    "横版封面2",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () {
                                    toolController.setStyle(2);
                                  },
                                ),
                                Spacer(),
                              ],
                            ),
                            Container(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                ElevatedButton(
                                  child: Text(
                                    "竖版封面1",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () {
                                    toolController.setStyle(3);
                                  },
                                ),
                                Spacer(),
                                ElevatedButton(
                                  child: Text(
                                    "竖版封面2",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () {
                                    toolController.setStyle(4);
                                  },
                                ),
                                Spacer(),
                              ],
                            ),
                            Container(height: 10),
                            Row(children: [Text("添加到：")]),
                            Container(height: 10),
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
                Container(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      heroTag: 'thumbnail-pick-video-fab',
                      onPressed: _pickVideo,
                      tooltip: '选择一个视频',
                      child: const Icon(Icons.local_movies),
                    ),
                    Container(width: 30),
                    FloatingActionButton(
                      heroTag: 'thumbnail-download-fab',
                      onPressed: () async {
                        _captureAndDownload();
                      },
                      tooltip: '下载视频',
                      child: const Icon(Icons.download),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   mainAxisSize: MainAxisSize.max,
      //   spacing: 5,
      //   children: <Widget>[
      //     FloatingActionButton(
      //       onPressed: () async {
      //         _controller.dispose();
      //         final video = await ImagePicker().pickVideo(
      //           source: ImageSource.gallery,
      //         );
      //         setState(() {
      //           _controller = VideoPlayerController.network(video!.path)
      //             ..initialize().then((_) {
      //               setState(() {
      //                 int seconds =
      //                     _controller.value.duration.inSeconds; // 获取秒数
      //                 _duration = Duration(seconds: seconds); // 转换为Duration
      //               });
      //             });
      //           _video.text = video.path ?? '';
      //         });
      //       },
      //       tooltip: '选择一个视频',
      //       child: const Icon(Icons.local_movies),
      //     ),
      //     FloatingActionButton(
      //       onPressed: () async {
      //         _captureAndDownload();
      //       },
      //       tooltip: '下载视频',
      //       child: const Icon(Icons.download),
      //     ),
      //     const SizedBox(width: 5),
      //   ],
      // ),
    );
  }

  Future<int?> getVideoDuration(
    String videoPath, {
    bool isAsset = false,
  }) async {
    final controller =
        isAsset
            ? VideoPlayerController.asset(videoPath)
            : VideoPlayerController.network(videoPath);
    try {
      await controller.initialize().timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('视频加载超时');
        },
      );
      return controller.value.duration.inSeconds;
    } catch (e) {
      print('获取视频时长失败: $e');
      return null;
    } finally {
      await controller.dispose();
    }
  }

  /**
   * 自动生成
   * @param null
   * @return
   * @author dcx
   * @date 2025/6/26 14:15
   **/
  void authCreate(int index) {
    int seconds = toolController.getMilliseconds(); // 获取秒数
    debugPrint("authCreate:$index,seconds:$seconds");
    toolController.clearGenThumbnailImage();
    if (index == 1) {
      int per = (seconds / 6).toInt();
      for (int i = 1; i <= 5; i++) {
        print(per * i);
        if (i == 1) {
          GenThumbnailImage tmp = GenThumbnailImage(
            thumbnailRequest: LocalThumbnailRequest(
              video: toolController.getVideoText(),
              thumbnailPath: null,
              imageFormat: _format,
              maxHeight: 0,
              maxWidth: 0,
              timeMs: per * i,
              quality: 100,
              attachHeaders: _attachHeaders,
              fit: BoxFit.cover,
            ),
          );
          toolController.setGenThumbnailImage(i, tmp);
        } else {
          GenThumbnailImage tmp = GenThumbnailImage(
            thumbnailRequest: LocalThumbnailRequest(
              video: toolController.getVideoText(),
              thumbnailPath: null,
              imageFormat: _format,
              maxHeight: 0,
              maxWidth: 0,
              timeMs: per * i,
              quality: 100,
              attachHeaders: _attachHeaders,
              fit: BoxFit.fitWidth,
            ),
          );
          toolController.setGenThumbnailImage(i, tmp);
        }
      }
    } else if (index == 2) {
      int per = (seconds / 11).toInt();
      for (int i = 1; i <= 10; i++) {
        print(per * i);
        GenThumbnailImage tmp = GenThumbnailImage(
          thumbnailRequest: LocalThumbnailRequest(
            video: toolController.getVideoText(),
            thumbnailPath: null,
            imageFormat: _format,
            maxHeight: 0,
            maxWidth: 0,
            timeMs: per * i,
            quality: 100,
            attachHeaders: _attachHeaders,
            fit: BoxFit.cover,
          ),
        );
        toolController.setGenThumbnailImage(i, tmp);
      }
    } else if (index == 3) {
      print((seconds / 2).toInt());
      GenThumbnailImage tmp = GenThumbnailImage(
        thumbnailRequest: LocalThumbnailRequest(
          video: toolController.getVideoText(),
          thumbnailPath: null,
          imageFormat: _format,
          maxHeight: 0,
          maxWidth: 0,
          timeMs: (seconds / 2).toInt(),
          quality: 100,
          attachHeaders: _attachHeaders,
          fit: BoxFit.cover,
        ),
      );
      toolController.setGenThumbnailImage(1, tmp);
    } else if (index == 4) {
      int per = (seconds / 8).toInt();
      for (int i = 1; i <= 7; i++) {
        print(per * i);
        GenThumbnailImage tmp = GenThumbnailImage(
          thumbnailRequest: LocalThumbnailRequest(
            video: toolController.getVideoText(),
            thumbnailPath: null,
            imageFormat: _format,
            maxHeight: 0,
            maxWidth: 0,
            timeMs: per * i,
            quality: 100,
            attachHeaders: _attachHeaders,
            fit: BoxFit.cover,
          ),
        );
        toolController.setGenThumbnailImage(i, tmp);
      }
    }
  }

  /**
   * 单个生成按钮
   * @param null
   * @return
   * @author dcx
   * @date 2025/6/26 14:17
   **/
  Widget getRows(int index) {
    if (index == 1) {
      return Wrap(
        children: [
          ElevatedButton(
            onPressed: () {
              GenThumbnailImage tmp = GenThumbnailImage(
                thumbnailRequest: LocalThumbnailRequest(
                  video: toolController.getVideoText(),
                  thumbnailPath: null,
                  imageFormat: _format,
                  maxHeight: 0,
                  maxWidth: 0,
                  timeMs: toolController.getPositionMilliseconds(),
                  quality: 100,
                  attachHeaders: _attachHeaders,
                  fit: BoxFit.cover,
                ),
              );
              toolController.setGenThumbnailImage(1, tmp);
            },
            child: Text("1"),
          ),
          for (int i = 2; i <= 5; i++)
            ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: LocalThumbnailRequest(
                    video: toolController.getVideoText(),
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: toolController.getPositionMilliseconds(),
                    quality: 100,
                    attachHeaders: _attachHeaders,
                    fit: BoxFit.fitWidth,
                  ),
                );
                toolController.setGenThumbnailImage(i, tmp);
              },
              child: Text("$i"),
            ),
        ],
      );
    } else if (index == 2) {
      return Wrap(
        children: [
          for (int i = 1; i <= 10; i++)
            ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: LocalThumbnailRequest(
                    video: toolController.getVideoText(),
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: toolController.getPositionMilliseconds(),
                    quality: 100,
                    attachHeaders: _attachHeaders,
                    fit: BoxFit.cover,
                  ),
                );
                toolController.setGenThumbnailImage(i, tmp);
              },
              child: Text("$i"),
            ),
        ],
      );
    } else if (index == 3) {
      return Wrap(
        children: [
          ElevatedButton(
            onPressed: () {
              GenThumbnailImage tmp = GenThumbnailImage(
                thumbnailRequest: LocalThumbnailRequest(
                  video: toolController.getVideoText(),
                  thumbnailPath: null,
                  imageFormat: _format,
                  maxHeight: 0,
                  maxWidth: 0,
                  timeMs: toolController.getPositionMilliseconds(),
                  quality: 100,
                  attachHeaders: _attachHeaders,
                  fit: BoxFit.cover,
                ),
              );
              toolController.setGenThumbnailImage(1, tmp);
            },
            child: Text("1"),
          ),
        ],
      );
    } else {
      return Wrap(
        children: [
          for (int i = 1; i <= 6; i++)
            ElevatedButton(
              onPressed: () {
                GenThumbnailImage tmp = GenThumbnailImage(
                  thumbnailRequest: LocalThumbnailRequest(
                    video: toolController.getVideoText(),
                    thumbnailPath: null,
                    imageFormat: _format,
                    maxHeight: 0,
                    maxWidth: 0,
                    timeMs: toolController.getPositionMilliseconds(),
                    quality: 100,
                    attachHeaders: _attachHeaders,
                    fit: BoxFit.cover,
                  ),
                );
                toolController.setGenThumbnailImage(i, tmp);
              },
              child: Text("$i"),
            ),
        ],
      );
    }
  }

  /// 生成图
  /// @param null
  /// @return
  /// @author dcx
  /// @date 2025/6/26 14:18
  ///
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
                      toolController.imgMap[1] == null
                          ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此1',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                          : toolController.imgMap[1],
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
                            child: toolController.imgMap[1],
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
                          toolController.imgMap[2] == null
                              ? Colors.blueAccent
                              : Colors.black,
                      child:
                          toolController.imgMap[2] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此2',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[2],
                    ),
                    SizedBox(width: 8),
                    Container(
                      //197,
                      height: 98.5,
                      //358
                      width: 179,
                      color:
                          toolController.imgMap[3] == null
                              ? Colors.blueAccent
                              : Colors.black,
                      child:
                          toolController.imgMap[3] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此3',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[3],
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
                          toolController.imgMap[4] == null
                              ? Colors.blueAccent
                              : Colors.black,
                      child:
                          toolController.imgMap[4] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此4',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[4],
                    ),
                    SizedBox(width: 8),
                    Container(
                      //197,
                      height: 98.5,
                      //358
                      width: 179,
                      color:
                          toolController.imgMap[5] == null
                              ? Colors.blueAccent
                              : Colors.black,
                      child:
                          toolController.imgMap[5] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此5',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[5],
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
                      toolController.imgMap[1] == null
                          ? IconButton(
                            onPressed: () {},
                            icon: Text(
                              '添加到此1',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                          : toolController.imgMap[1],
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
                            child: toolController.imgMap[1],
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
                          toolController.imgMap[2] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此2',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[2],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          toolController.imgMap[3] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此3',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[3],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          toolController.imgMap[4] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此4',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[4],
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
                          toolController.imgMap[5] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此5',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[5],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          toolController.imgMap[6] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此6',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[6],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          toolController.imgMap[7] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此7',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[7],
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
                          toolController.imgMap[8] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此8',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[8],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          toolController.imgMap[9] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此9',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[9],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 67,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          toolController.imgMap[10] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此10',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[10],
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
                          toolController.imgMap[1] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此1',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[1],
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
                          toolController.imgMap[1] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此1',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[1],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 210,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          toolController.imgMap[2] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此2',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[2],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 210,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          toolController.imgMap[3] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此3',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[3],
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
                          toolController.imgMap[4] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此4',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[4],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 210,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          toolController.imgMap[5] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此5',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[5],
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 210,
                      width: 119,
                      color: Colors.blueAccent,
                      child:
                          toolController.imgMap[6] == null
                              ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此6',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : toolController.imgMap[6],
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

  Future<void> _captureAndDownload() async {
    try {
      // 1️⃣ 获取 RenderRepaintBoundary
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      // ByteData? byteData = await image.toByteData(
      //   format: ui.ImageByteFormat.png,
      // );
      // Uint8List pngBytes = byteData!.buffer.asUint8List();
      //加载水印图片
      final ByteData data = await rootBundle.load("imgs/shuiyin.png");
      final Uint8List bytes = data.buffer.asUint8List();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      Uint8List watermarkedImage = await _addWatermarkToImage(
        image,
        frameInfo.image,
      );

      downloadAsWebp(watermarkedImage);

      // img.Image? rawImage = img.decodeImage(watermarkedImage);
      // // 质量90%
      // Uint8List jpgBytes = img.encodeJpg(rawImage!, quality: 70);
      //
      // // 2️⃣ 触发 Web 下载
      // final blob = html.Blob([jpgBytes]);
      // final url = html.Url.createObjectUrlFromBlob(blob);
      // final anchor =
      //     html.AnchorElement(href: url)
      //       ..setAttribute("download", "素材封面.jpg")
      //       ..click();
      // html.Url.revokeObjectUrl(url);
    } catch (e) {
      print("截图错误: $e");
    }
  }

  /// 在图片上添加水印图片
  Future<Uint8List> _addWatermarkToImage(
    ui.Image image,
    ui.Image watermark,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // 绘制原始截图
    Paint paint = Paint();
    canvas.drawImage(image, Offset.zero, paint);

    // 计算水印位置（右下角）
    double watermarkX = image.width - watermark.width - 20;
    double watermarkY = image.height - watermark.height - 20;

    // 绘制水印图片
    canvas.drawImage(watermark, Offset(watermarkX, watermarkY), Paint());

    // 生成新的图片
    final picture = recorder.endRecording();
    ui.Image watermarkedImage = await picture.toImage(
      image.width,
      image.height,
    );
    ByteData? byteData = await watermarkedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData!.buffer.asUint8List();
  }

  _launchURL(url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // 在浏览器中打开
    } else {
      throw '无法打开链接: $url';
    }
  }

  Future<void> downloadAsJpg(Uint8List watermarkedImage) async {
    img.Image? rawImage = img.decodeImage(watermarkedImage);
    // 质量90%
    Uint8List jpgBytes = img.encodeJpg(rawImage!, quality: 70);

    // 2️⃣ 触发 Web 下载
    final blob = html.Blob([jpgBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute("download", "素材封面.jpg")
          ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> downloadAsWebp(Uint8List pngBytes) async {
    // 创建一个 Blob 对象
    final blob = html.Blob([pngBytes], 'image/png');

    // 创建一个 URL 来表示这个 Blob 对象
    final url = html.Url.createObjectUrlFromBlob(blob);

    // 创建一个 Image 元素，并设置它的 src 属性
    final img = html.ImageElement()..src = url;

    // 等待图片加载完毕
    await img.onLoad.first;

    // 使用 Canvas 元素进行绘制和格式转换
    final canvas = html.CanvasElement(width: img.width, height: img.height);
    final ctx = canvas.context2D;
    ctx.drawImage(img, 0, 0);

    // 将 Canvas 内容以 WebP 格式导出
    final webpDataUrl = canvas.toDataUrl('image/webp', 0.8); // 第二个参数是质量选项

    // 分离 DataURL 并创建一个新的 Blob 对象
    final parts = webpDataUrl.split(',');
    final mime = parts[0].split(':')[1].split(';')[0];
    final byteString = parts[1];
    final buffer = Uint8List.fromList(base64Decode(byteString));
    final webpBlob = html.Blob([buffer], mime);

    // 创建一个下载链接并触发下载
    final a =
        html.AnchorElement(href: html.Url.createObjectUrl(webpBlob))
          ..setAttribute("download", "素材封面.webp")
          ..click();

    // 清理
    html.Url.revokeObjectUrl(url);
  }

  Future<void> downloadAsWebp1(Uint8List jpgBytes) async {
    // 1. 解码 JPG
    img.Image? decodedImage = img.decodeImage(jpgBytes);
    if (decodedImage == null) return;

    // 2. 创建 HTML ImageElement
    final image = html.ImageElement();
    final tempJpgBlob = html.Blob([jpgBytes], 'image/jpeg');
    final tempUrl = html.Url.createObjectUrlFromBlob(tempJpgBlob);
    image.src = tempUrl;

    // 3. 等待加载
    await image.onLoad.first;

    // 4. 绘制到 Canvas
    final canvas = html.CanvasElement(width: image.width, height: image.height);
    final ctx = canvas.context2D;
    ctx.drawImage(image, 0, 0);

    // 5. 导出为 WebP Data URL
    final webpDataUrl = canvas.toDataUrl('image/webp', 0.8);

    // 6. 转为 Blob 并下载
    final parts = webpDataUrl.split(',');
    final mimeType = parts[0].split(':')[1].split(';')[0];
    final base64 = parts[1];
    final buffer = base64Decode(base64);
    final webpBlob = html.Blob([buffer], mimeType);
    final webpUrl = html.Url.createObjectUrlFromBlob(webpBlob);

    final anchor =
        html.AnchorElement(href: webpUrl)
          ..setAttribute('download', '素材封面.webp')
          ..click();

    // 7. 清理
    html.Url.revokeObjectUrl(tempUrl);
    html.Url.revokeObjectUrl(webpUrl);
  }
}

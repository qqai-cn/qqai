import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qqai/app/pages/demo/video/reflection_widget.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DemoHome(),
    );
  }
}

class VideoFromat {
  VideoFromat({
    required this.quality,
    required this.sizeH,
    required this.sizeW,
    required this.timeMs,
  });

  final int quality;
  int sizeH;
  int sizeW;
  int timeMs;
}

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

class DemoHome extends StatefulWidget {
  const DemoHome({Key? key}) : super(key: key);

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  final _editNode = FocusNode();
  final _video = TextEditingController(
    text:
        'https://cloud.video.taobao.com/play/u/153810888/p/2/e/6/t/1/266102583124.mp4',
  );
  ImageFormat _format = ImageFormat.JPEG;
  bool _attachHeaders = false;
  bool showImg = false;
  Map<int, bool> showImgMap = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false
  };
  late GenThumbnailImage? _futureImage1;
  late GenThumbnailImage? _futureImage2;
  late GenThumbnailImage? _futureImage3;
  late GenThumbnailImage? _futureImage4;
  late GenThumbnailImage? _futureImage5;
  List<VideoFromat> vfs = [
    VideoFromat(quality: 100, sizeH: 0, sizeW: 0, timeMs: 0),
    VideoFromat(quality: 100, sizeH: 0, sizeW: 0, timeMs: 0),
    VideoFromat(quality: 100, sizeH: 0, sizeW: 0, timeMs: 0),
    VideoFromat(quality: 100, sizeH: 0, sizeW: 0, timeMs: 0),
    VideoFromat(quality: 100, sizeH: 0, sizeW: 0, timeMs: 0),
  ];
  Map<int, GenThumbnailImage> imgMap = {};

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
        title: const Text('缩略图插件示例'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 10, 2, 8),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                isDense: true,
                labelText: '视频 URI',
              ),
              maxLines: null,
              controller: _video,
              focusNode: _editNode,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onEditingComplete: _editNode.unfocus,
            ),
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
                      // 加载中
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true, // 允许拖动
                        colors: VideoProgressColors(
                          playedColor: Colors.red, // 已播放部分颜色
                          bufferedColor: Colors.grey, // 缓冲部分颜色
                          backgroundColor: Colors.black, // 背景颜色
                        ),
                      ),
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
                      Row(
                        children: [
                          Text("添加到："),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  imgMap[1] = GenThumbnailImage(
                                    thumbnailRequest: ThumbnailRequest(
                                      video: _video.text,
                                      thumbnailPath: null,
                                      imageFormat: _format,
                                      maxHeight: 0,
                                      maxWidth: 0,
                                      timeMs: _controller
                                          .value.position.inMilliseconds,
                                      quality: 100,
                                      attachHeaders: _attachHeaders,
                                    ),
                                  );
                                });
                              },
                              child: Text("1")),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  imgMap[2] = GenThumbnailImage(
                                    thumbnailRequest: ThumbnailRequest(
                                      video: _video.text,
                                      thumbnailPath: null,
                                      imageFormat: _format,
                                      maxHeight: 0,
                                      maxWidth: 0,
                                      timeMs: _controller
                                          .value.position.inMilliseconds,
                                      quality: 100,
                                      attachHeaders: _attachHeaders,
                                    ),
                                  );
                                });
                              },
                              child: Text("2")),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  imgMap[3] = GenThumbnailImage(
                                    thumbnailRequest: ThumbnailRequest(
                                      video: _video.text,
                                      thumbnailPath: null,
                                      imageFormat: _format,
                                      maxHeight: 0,
                                      maxWidth: 0,
                                      timeMs: _controller
                                          .value.position.inMilliseconds,
                                      quality: 100,
                                      attachHeaders: _attachHeaders,
                                    ),
                                  );
                                });
                              },
                              child: Text("3")),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  imgMap[4] = GenThumbnailImage(
                                    thumbnailRequest: ThumbnailRequest(
                                      video: _video.text,
                                      thumbnailPath: null,
                                      imageFormat: _format,
                                      maxHeight: 0,
                                      maxWidth: 0,
                                      timeMs: _controller
                                          .value.position.inMilliseconds,
                                      quality: 100,
                                      attachHeaders: _attachHeaders,
                                    ),
                                  );
                                });
                              },
                              child: Text("4")),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  imgMap[5] = GenThumbnailImage(
                                    thumbnailRequest: ThumbnailRequest(
                                      video: _video.text,
                                      thumbnailPath: null,
                                      imageFormat: _format,
                                      maxHeight: 0,
                                      maxWidth: 0,
                                      timeMs: _controller
                                          .value.position.inMilliseconds,
                                      quality: 100,
                                      attachHeaders: _attachHeaders,
                                    ),
                                  );
                                });
                              },
                              child: Text("5")),
                        ],
                      ),
                    ],
                  ),
                ),
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
                      Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.blueAccent,
                        child: imgMap[1] == null
                            ? IconButton(
                                onPressed: () {},
                                icon: Text(
                                  '添加到此1',
                                  style: TextStyle(color: Colors.white),
                                ))
                            : imgMap[1],
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
                              heightFactor: 0.2,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationX(3.14159),
                                // 180° 翻转
                                child: Container(
                                  width: 400,
                                  height: 300,
                                  child: imgMap[1],
                                ),
                              ),
                            )),
                          )),

                      // ClipRect(
                      //   child: Align(
                      //     alignment: Alignment.topCenter,
                      //     heightFactor: 0.2, // 只显示上半部分
                      //     child: Transform(
                      //       alignment: Alignment.center,
                      //       transform: Matrix4.rotationX(3.14159), // 180° 翻转
                      //       child: Opacity(
                      //         opacity: 0.8,
                      //         child: ShaderMask(
                      //           shaderCallback: (bounds) {
                      //             return LinearGradient(
                      //               // begin: Alignment.bottomCenter,
                      //               begin: Alignment.topCenter,
                      //               // end: Alignment.topCenter,
                      //               end: Alignment.bottomCenter,
                      //               colors: [Colors.black, Colors.transparent],
                      //             ).createShader(bounds);
                      //           },
                      //           blendMode: BlendMode.dstIn,
                      //           child: Container(
                      //             width: 400,
                      //             height: 300,
                      //             child: imgMap[1],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // Container(
                      //   height: 20,
                      //   child: ReflectionWidget(child: Container(child: imgMap[1],height: 250,),reflectionHeight: 10,interval:0),
                      // ),
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey, Colors.white], // 渐变颜色
                            begin: Alignment.topCenter, // 渐变起点（顶部）
                            end: Alignment.bottomCenter, // 渐变终点（底部）
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 125,
                            width: 185,
                            color: Colors.blueAccent,
                            child: imgMap[2] == null
                                ? IconButton(
                                    onPressed: () {},
                                    icon: Text(
                                      '添加到此2',
                                      style: TextStyle(color: Colors.white),
                                    ))
                                : imgMap[2],
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Container(
                            height: 125,
                            width: 185,
                            color: Colors.blueAccent,
                            child: imgMap[3] == null
                                ? IconButton(
                                    onPressed: () {},
                                    icon: Text(
                                      '添加到此3',
                                      style: TextStyle(color: Colors.white),
                                    ))
                                : imgMap[3],
                          ),
                        ],
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 125,
                            width: 185,
                            color: Colors.blueAccent,
                            child: imgMap[4] == null
                                ? IconButton(
                                    onPressed: () {},
                                    icon: Text(
                                      '添加到此4',
                                      style: TextStyle(color: Colors.white),
                                    ))
                                : imgMap[4],
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Container(
                            height: 125,
                            width: 185,
                            color: Colors.blueAccent,
                            child: imgMap[5] == null
                                ? IconButton(
                                    onPressed: () {},
                                    icon: Text(
                                      '添加到此5',
                                      style: TextStyle(color: Colors.white),
                                    ))
                                : imgMap[5],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () async {
              final video =
                  await ImagePicker().pickVideo(source: ImageSource.camera);
              setState(() {
                _video.text = video?.path ?? '';
              });
            },
            tooltip: '捕捉视频',
            child: const Icon(Icons.videocam),
          ),
          const SizedBox(
            width: 5,
          ),
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

          //     const SizedBox(
          //       width: 20,
          //     ),
          //     FloatingActionButton(
          //       tooltip: '生成图文件',
          //       onPressed: () async {
          //         setState(() {
          //           int count = 0;
          //           for (VideoFromat vf in vfs) {
          //             GenThumbnailImage tmp = GenThumbnailImage(
          //               thumbnailRequest: ThumbnailRequest(
          //                 video: _video.text,
          //                 thumbnailPath: null,
          //                 imageFormat: _format,
          //                 maxHeight: vf.sizeH,
          //                 maxWidth: vf.sizeW,
          //                 timeMs: vf.timeMs,
          //                 quality: vf.quality,
          //                 attachHeaders: _attachHeaders,
          //               ),
          //             );
          //             count++;
          //             imgMap[count] = tmp;
          //           }
          //         });
          //       },
          //       child: const Text('文件'),
          //     ),
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

  Widget _buildGridItem(int index, Color color) {
    List<Widget> wds = [];
    for (VideoFromat vf in vfs) {
      final settings = <Widget>[
        Slider(
          value: vf.timeMs.toDouble(),
          onChangeEnd: (v) => setState(() {
            GenThumbnailImage tmp = GenThumbnailImage(
              thumbnailRequest: ThumbnailRequest(
                video: _video.text,
                thumbnailPath: null,
                imageFormat: _format,
                maxHeight: vf.sizeH,
                maxWidth: vf.sizeW,
                timeMs: vf.timeMs * 1000,
                quality: vf.quality,
                attachHeaders: _attachHeaders,
              ),
            );
            imgMap[index] = tmp;
            showImgMap[index] = true;
          }),
          max: _duration?.inSeconds.toDouble() ?? 1,
          divisions: _duration != null ? _duration!.inSeconds : 1,
          label: '${vf.timeMs}s',
          onChanged: (double value) {
            setState(() {
              vf.timeMs = value.round();
              _editNode.unfocus();
            });
          },
        ),
        Center(
          child: (vf.timeMs == 0)
              ? const Text('视频秒数')
              : Text('视频第 ${vf.timeMs}(s) 秒'),
        ),
      ];
      Card card = Card(
        color: color,
        shadowColor: index == 1 ? Colors.red : null,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Center(
          child: Column(
            children: [
              for (var i in settings) Expanded(child: i),
            ],
          ),
        ),
      );
      wds.add(card);
    }
    return wds.elementAt(index - 1);
  }
}

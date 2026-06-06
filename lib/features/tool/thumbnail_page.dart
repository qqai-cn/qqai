import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/web_blob_helpers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'widgets/custom_video_progress_bar.dart';
import 'video_cover_style_preview.dart';
import 'video_cover_thumbnail.dart';

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

  void populateCover({
    required int styleId,
    required int durationSeconds,
    ImageFormat imageFormat = ImageFormat.WEBP,
    bool attachHeaders = false,
  }) {
    imgMap.clear();
    populateCoverThumbnailImages(
      styleId: styleId,
      durationSeconds: durationSeconds,
      videoPath: _videoText,
      imgMap: imgMap,
      imageFormat: imageFormat,
      attachHeaders: attachHeaders,
    );
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
                        style: context.typo.link.copyWith(
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
                          border: Border.all(
                            color: AppActionColors.borderSubtle(context),
                            width: 2,
                          ),
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
                                      color: AppActionColors.borderSubtle(
                                        context,
                                      ),
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
                                    style: context.typo.button.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                  onPressed: () {
                                    toolController.setStyle(1);
                                  },
                                ),
                                Spacer(),
                                ElevatedButton(
                                  child: Text(
                                    "横版封面2",
                                    style: context.typo.button.copyWith(
                                      fontSize: 15,
                                    ),
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
                                    style: context.typo.button.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                  onPressed: () {
                                    toolController.setStyle(3);
                                  },
                                ),
                                Spacer(),
                                ElevatedButton(
                                  child: Text(
                                    "竖版封面2",
                                    style: context.typo.button.copyWith(
                                      fontSize: 15,
                                    ),
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
    final seconds = toolController.getMilliseconds();
    debugPrint("authCreate:$index,seconds:$seconds");
    toolController.populateCover(
      styleId: index,
      durationSeconds: seconds,
      imageFormat: _format,
      attachHeaders: _attachHeaders,
    );
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
    return buildVideoCoverStyleView(
      index,
      toolController.imgMap,
      context,
    );
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
    final rawImage = img.decodeImage(watermarkedImage);
    if (rawImage == null) return;
    final jpgBytes = img.encodeJpg(rawImage, quality: 70);
    downloadUint8ListAsFile(
      jpgBytes,
      '素材封面.jpg',
      mimeType: 'image/jpeg',
    );
  }

  Future<void> downloadAsWebp(Uint8List pngBytes) async {
    final rawImage = img.decodeImage(pngBytes);
    if (rawImage == null) return;

    Uint8List? webpBytes;
    if (kIsWeb) {
      webpBytes = await encodeWebpViaBrowserCanvas(rawImage);
    } else {
      webpBytes = Uint8List.fromList(img.encodePng(rawImage));
    }
    if (webpBytes == null || webpBytes.isEmpty) return;

    downloadUint8ListAsFile(
      webpBytes,
      kIsWeb ? '素材封面.webp' : '素材封面.png',
      mimeType: kIsWeb ? 'image/webp' : 'image/png',
    );
  }
}

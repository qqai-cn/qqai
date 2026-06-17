import 'dart:async';
import 'dart:typed_data';
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
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/web_blob_helpers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'tool_cyber_theme.dart';
import 'widgets/custom_video_progress_bar.dart';
import 'video_cover_style_preview.dart';
import 'video_cover_thumbnail.dart';
import 'video_cover_tool.dart';

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

class _ThumbnailPage extends State<ThumbnailPage>
    with SingleTickerProviderStateMixin {
  static const double _narrowBreakpoint = 900;
  static const double _controlPanelMaxWidth = 400;

  late ToolController toolController;
  late final AnimationController _scanController;
  final GlobalKey _globalKey = GlobalKey(); // 用于获取截图

  ImageFormat _format = ImageFormat.WEBP;
  bool _attachHeaders = false;

  String? _tempDir;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    if (!kIsWeb) {
      getTemporaryDirectory().then((d) => _tempDir = d.path);
    }

    toolController = ToolController();
  }

  @override
  void dispose() {
    _scanController.dispose();
    toolController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video != null) {
      await toolController.resetController(video);
    }
  }

  Widget _buildTutorialLink(ToolCyberTheme theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          _launchURL(
            'http://cloud.video.taobao.com/play/u/null/p/1/e/6/t/1/510926763195.mp4',
          );
        },
        child: Text(
          '使用教程',
          style: context.typo.link.copyWith(
            color: theme.link,
            decoration: TextDecoration.underline,
            decorationColor: theme.link,
          ),
        ),
      ),
    );
  }

  Widget _buildStyleButtons({
    required ToolCyberTheme theme,
    required bool narrow,
  }) {
    Widget styleButton(String label, int styleId) {
      final selected = toolController.curStyle == styleId;
      return OutlinedButton(
        style: theme.outlinedButtonStyle(selected: selected),
        onPressed: () => toolController.setStyle(styleId),
        child: Text(
          label,
          style: context.typo.button.copyWith(fontSize: 14),
        ),
      );
    }

    final buttons = [
      styleButton('横版封面1', 1),
      styleButton('横版封面2', 2),
      styleButton('竖版封面1', 3),
      styleButton('竖版封面2', 4),
    ];

    if (narrow) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: buttons,
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: buttons[0]),
            const SizedBox(width: 8),
            Expanded(child: buttons[1]),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: buttons[2]),
            const SizedBox(width: 8),
            Expanded(child: buttons[3]),
          ],
        ),
      ],
    );
  }

  Widget _buildControlPanel({
    required ToolCyberTheme theme,
    required bool hasVideo,
    required VideoPlayerController? currentController,
    required bool narrow,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: _controlPanelMaxWidth),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(colors: theme.innerGradient),
        border: Border.all(color: theme.innerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: hasVideo
                ? AspectRatio(
                  key: ValueKey(currentController),
                  aspectRatio: 1.8,
                  child: VideoPlayer(currentController!),
                )
                : AspectRatio(
                  aspectRatio: 1.8,
                  child: InkWell(
                    onTap: _pickVideo,
                    child: Container(
                      color: theme.imagePlaceholder,
                      alignment: Alignment.center,
                      child: Text(
                        '请先选择视频（点击选择）',
                        style: context.typo.body.copyWith(color: theme.subtitle),
                      ),
                    ),
                  ),
                ),
          ),
          if (hasVideo)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _pickVideo,
                icon: Icon(Icons.video_library, color: theme.accentIcon),
                label: Text('更换视频', style: TextStyle(color: theme.link)),
              ),
            ),
          if (hasVideo)
            DefaultTextStyle(
              style: TextStyle(color: theme.body),
              child: Theme(
                data: Theme.of(context).copyWith(
                  sliderTheme: SliderThemeData(
                    activeTrackColor: theme.primaryButton,
                    inactiveTrackColor: theme.innerBorder,
                    thumbColor: theme.accent,
                  ),
                ),
                child: CustomVideoProgressBar(controller: currentController!),
              ),
            ),
          if (!hasVideo) const SizedBox(height: 3),
          Row(
            children: [
              FilledButton(
                style: theme.filledButtonStyle.copyWith(
                  minimumSize: const WidgetStatePropertyAll(Size(48, 48)),
                  padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                ),
                onPressed: hasVideo ? toolController.switchOpen : null,
                child: Icon(
                  hasVideo && currentController!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              ),
              const Spacer(),
              FilledButton(
                style: theme.filledButtonStyle,
                onPressed:
                    hasVideo
                        ? () => authCreate(toolController.curStyle)
                        : null,
                child: const Text('自动填充'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStyleButtons(theme: theme, narrow: narrow),
          const SizedBox(height: 12),
          Text(
            '添加到：',
            style: context.typo.label.copyWith(
              color: theme.label,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          getRows(toolController.curStyle, theme),
        ],
      ),
    );
  }

  Widget _buildCoverPreview(ToolCyberTheme theme, double maxWidth) {
    final previewSize = resolveVideoCoverPreviewSize(
      maxWidth: maxWidth,
      maxHeight: 640,
    );
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(colors: theme.innerGradient),
        border: Border.all(color: theme.innerBorder),
      ),
      child: Center(
        child: SizedBox(
          width: previewSize.width,
          height: previewSize.height,
          child: FittedBox(
            fit: BoxFit.contain,
            child: RepaintBoundary(
              key: _globalKey,
              child: getView(toolController.curStyle),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow(ToolCyberTheme theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        FilledButton.icon(
          onPressed: _pickVideo,
          icon: const Icon(Icons.local_movies),
          label: const Text('选择视频'),
          style: theme.filledButtonStyle,
        ),
        FilledButton.icon(
          onPressed: _captureAndDownload,
          icon: const Icon(Icons.download),
          label: const Text('下载封面'),
          style: theme.filledButtonStyle,
        ),
      ],
    );
  }

  Widget _buildScanOverlay(ToolCyberTheme theme) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AnimatedBuilder(
          animation: _scanController,
          builder: (context, child) {
            final t = _scanController.value;
            final y = -0.35 + 1.7 * t;
            return Align(
              alignment: Alignment(0, y),
              child: Container(
                height: 86,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: theme.scanGradient,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ToolCyberTheme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: const Text('封面生成器'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: theme.appBarFg,
        iconTheme: IconThemeData(color: theme.appBarIcon),
        systemOverlayStyle: theme.overlayStyle,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.gradientColors,
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: toolController,
            builder: (context, _) {
              final currentController = toolController.controller;
              final hasVideo =
                  currentController != null &&
                  currentController.value.isInitialized;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      children: [
                        _buildScanOverlay(theme),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: theme.cardBg,
                            border: Border.all(
                              color: theme.cardBorder,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.cardShadow,
                                blurRadius: 24,
                                spreadRadius: 1,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final isNarrow =
                                  constraints.maxWidth < _narrowBreakpoint;
                              final contentWidth = constraints.maxWidth;
                              final controlPanel = _buildControlPanel(
                                theme: theme,
                                hasVideo: hasVideo,
                                currentController: currentController,
                                narrow: isNarrow,
                              );
                              final previewMaxWidth = isNarrow
                                  ? contentWidth
                                  : (contentWidth -
                                          _controlPanelMaxWidth -
                                          24)
                                      .clamp(
                                        qqaiStyledCoverW.toDouble(),
                                        contentWidth / 2,
                                      );
                              final coverPreview = _buildCoverPreview(
                                theme,
                                previewMaxWidth,
                              );

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Video Cover Studio',
                                    style: context.typo.heroTitle.copyWith(
                                      color: theme.title,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '从视频截取帧，生成横竖版素材封面',
                                    style: context.typo.caption.copyWith(
                                      color: theme.subtitle,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildTutorialLink(theme),
                                  SizedBox(height: isNarrow ? 16 : 20),
                                  if (isNarrow) ...[
                                    controlPanel,
                                    const SizedBox(height: 20),
                                    coverPreview,
                                  ] else
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: _controlPanelMaxWidth,
                                          child: controlPanel,
                                        ),
                                        const SizedBox(width: 24),
                                        Expanded(child: coverPreview),
                                      ],
                                    ),
                                  const SizedBox(height: 24),
                                  _buildActionRow(theme),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
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
  Widget getRows(int index, ToolCyberTheme theme) {
    OutlinedButton slotButton(VoidCallback onPressed, String label) {
      return OutlinedButton(
        style: theme.slotButtonStyle,
        onPressed: onPressed,
        child: Text(label),
      );
    }

    void setSlot(int slot, BoxFit fit) {
      final tmp = GenThumbnailImage(
        thumbnailRequest: LocalThumbnailRequest(
          video: toolController.getVideoText(),
          thumbnailPath: null,
          imageFormat: _format,
          maxHeight: 0,
          maxWidth: 0,
          timeMs: toolController.getPositionMilliseconds(),
          quality: 100,
          attachHeaders: _attachHeaders,
          fit: fit,
        ),
      );
      toolController.setGenThumbnailImage(slot, tmp);
    }

    if (index == 1) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          slotButton(() => setSlot(1, BoxFit.cover), '1'),
          for (int i = 2; i <= 5; i++)
            slotButton(() => setSlot(i, BoxFit.fitWidth), '$i'),
        ],
      );
    } else if (index == 2) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (int i = 1; i <= 10; i++)
            slotButton(() => setSlot(i, BoxFit.cover), '$i'),
        ],
      );
    } else if (index == 3) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          slotButton(() => setSlot(1, BoxFit.cover), '1'),
        ],
      );
    } else {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (int i = 1; i <= 6; i++)
            slotButton(() => setSlot(i, BoxFit.cover), '$i'),
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

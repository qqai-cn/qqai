import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';

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
  await WidgetsBinding.instance.endOfFrame;
  final boundary = repaintKey.currentContext?.findRenderObject();
  if (boundary is! RenderRepaintBoundary) return null;
  final image = await boundary.toImage(pixelRatio: 2.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) return null;
  return byteData.buffer.asUint8List();
}

Future<Uint8List?> captureVideoCoverStylePreviewWhenReady(
  GlobalKey repaintKey, {
  int maxAttempts = 10,
}) async {
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    await WidgetsBinding.instance.endOfFrame;
    final bytes = await captureVideoCoverStylePreview(repaintKey);
    if (bytes != null && bytes.isNotEmpty) {
      return bytes;
    }
    await Future<void>.delayed(Duration(milliseconds: 50 + attempt * 40));
  }
  return null;
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
    imgMap[i + 1] = GenThumbnailImage(
      thumbnailRequest: LocalThumbnailRequest(
        video: videoPath,
        thumbnailPath: null,
        imageFormat: imageFormat,
        maxHeight: 0,
        maxWidth: 0,
        timeMs: timePoints[i],
        quality: 100,
        attachHeaders: attachHeaders,
        fit: BoxFit.cover,
      ),
    );
  }
}

Widget _coverStyleFrame({required Widget child}) {
  return ClipRect(
    child: Align(
      alignment: Alignment.topCenter,
      heightFactor: 0.625,
      child: SizedBox(
        width: qqaiStyledCoverW.toDouble(),
        height: qqaiVideoCoverCanvasHeight,
        child: ColoredBox(
          color: Colors.white,
          child: child,
        ),
      ),
    ),
  );
}

Widget _coverThumbSlot(
  GenThumbnailImage? image,
  BuildContext context,
  String label,
) {
  if (image != null) return image;
  return ColoredBox(
    color: GoodsPageStyle.imageBg(context),
    child: Center(
      child: Text(
        '添加到此$label',
        style: context.typo.body.copyWith(
          color: GoodsPageStyle.sub(context),
        ),
      ),
    ),
  );
}

Widget _coverSeparatorBar() {
  return const DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white, Colors.black54, Colors.white],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
  );
}

Widget _coverReflection(GenThumbnailImage? mainImage) {
  return Opacity(
    opacity: 0.5,
    child: ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
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
            child: SizedBox(
              width: qqaiStyledCoverW.toDouble(),
              height: qqaiCoverMainH.toDouble(),
              child: mainImage,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _coverHeroSection(
  Map<int, GenThumbnailImage?> imgMap,
  BuildContext context,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: qqaiStyledCoverW.toDouble(),
        height: qqaiCoverMainH.toDouble(),
        child: _coverThumbSlot(imgMap[1], context, '1'),
      ),
      SizedBox(
        width: qqaiStyledCoverW.toDouble(),
        height: qqaiCoverSepH.toDouble(),
        child: _coverSeparatorBar(),
      ),
      SizedBox(
        width: qqaiStyledCoverW.toDouble(),
        height: qqaiCoverReflH.toDouble(),
        child: _coverReflection(imgMap[1]),
      ),
    ],
  );
}

Widget _coverThreeColRow({
  required List<GenThumbnailImage?> images,
  required List<String> labels,
  required double rowHeight,
  required BuildContext context,
}) {
  return SizedBox(
    height: rowHeight,
    child: Row(
      children: [
        for (var col = 0; col < 3; col++) ...[
          if (col > 0) SizedBox(width: qqaiCoverGap.toDouble()),
          SizedBox(
            width: qqaiCoverThreeColWidths[col].toDouble(),
            child: _coverThumbSlot(images[col], context, labels[col]),
          ),
        ],
      ],
    ),
  );
}

Widget _coverTwoColRow({
  required GenThumbnailImage? left,
  required GenThumbnailImage? right,
  required String leftLabel,
  required String rightLabel,
  required double rowHeight,
  required BuildContext context,
}) {
  return SizedBox(
    height: rowHeight,
    child: Row(
      children: [
        Expanded(child: _coverThumbSlot(left, context, leftLabel)),
        SizedBox(width: qqaiCoverGap.toDouble()),
        Expanded(child: _coverThumbSlot(right, context, rightLabel)),
      ],
    ),
  );
}

Widget buildVideoCoverStyleView(
  int index,
  Map<int, GenThumbnailImage?> imgMap,
  BuildContext context,
) {
  switch (index) {
    case 1:
      return _coverStyleFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _coverHeroSection(imgMap, context),
            _coverTwoColRow(
              left: imgMap[2],
              right: imgMap[3],
              leftLabel: '2',
              rightLabel: '3',
              rowHeight: qqaiCoverStyle1Row1H.toDouble(),
              context: context,
            ),
            SizedBox(height: qqaiCoverGap.toDouble()),
            _coverTwoColRow(
              left: imgMap[4],
              right: imgMap[5],
              leftLabel: '4',
              rightLabel: '5',
              rowHeight: qqaiCoverStyle1Row2H().toDouble(),
              context: context,
            ),
          ],
        ),
      );
    case 2:
      return _coverStyleFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _coverHeroSection(imgMap, context),
            for (var row = 0; row < 3; row++) ...[
              if (row > 0) SizedBox(height: qqaiCoverGap.toDouble()),
              _coverThreeColRow(
                images: [
                  imgMap[row * 3 + 2],
                  imgMap[row * 3 + 3],
                  imgMap[row * 3 + 4],
                ],
                labels: [
                  '${row * 3 + 2}',
                  '${row * 3 + 3}',
                  '${row * 3 + 4}',
                ],
                rowHeight: qqaiCoverStyle2RowH.toDouble(),
                context: context,
              ),
            ],
          ],
        ),
      );
    case 3:
      return _coverStyleFrame(
        child: SizedBox(
          width: qqaiStyledCoverW.toDouble(),
          height: qqaiStyledCoverH.toDouble(),
          child: _coverThumbSlot(imgMap[1], context, '1'),
        ),
      );
    default:
      return _coverStyleFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _coverThreeColRow(
              images: [imgMap[1], imgMap[2], imgMap[3]],
              labels: const ['1', '2', '3'],
              rowHeight: qqaiCoverStyle4RowH.toDouble(),
              context: context,
            ),
            SizedBox(height: qqaiCoverGap.toDouble()),
            _coverThreeColRow(
              images: [imgMap[4], imgMap[5], imgMap[6]],
              labels: const ['4', '5', '6'],
              rowHeight: qqaiCoverStyle4RowH.toDouble(),
              context: context,
            ),
          ],
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
    this.repaintKey,
  });

  final String videoPath;
  final int styleId;
  final int durationSeconds;
  final GlobalKey? repaintKey;

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

  Future<Uint8List?> capture() {
    final key = widget.repaintKey;
    if (key == null) return Future.value(null);
    return captureVideoCoverStylePreview(key);
  }

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
    final view = buildVideoCoverStyleView(widget.styleId, _imgMap, context);
    final key = widget.repaintKey;
    if (key == null) return view;
    return RepaintBoundary(key: key, child: view);
  }
}

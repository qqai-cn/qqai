import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

///
/// 创建一个倒影显示在[child]下面
///
class ReflectionWidget extends SingleChildRenderObjectWidget {
  final double interval;
  final double reflectionHeight;
  const ReflectionWidget(
      {Key? key,
        required Widget child,
        this.interval = 3,
        this.reflectionHeight = 40})
      : super(key: key, child: child);

  @override
  ReversImageRenderObject createRenderObject(BuildContext context) {
    return ReversImageRenderObject(interval);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant ReversImageRenderObject renderObject) {
    renderObject
      ..interval = interval
      ..reflectionHeight = reflectionHeight;
  }
}

class ReversImageRenderObject extends RenderProxyBox {
  //倒影间距
  double interval;
  //倒影高度
  double reflectionHeight = 10;

  ReversImageRenderObject(this.interval);
  Size innerSize = Size.zero;
  @override
  void performLayout() {
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      innerSize = child!.size;
      size = Size(
          innerSize.width, innerSize.height + reflectionHeight + interval + 2);
    } else {
      size = computeSizeForNoChild(constraints);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    drawReversImage(context, offset);
  }

  Paint mPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  Paint mPaint2 = Paint()..style = PaintingStyle.fill;

  void drawReversImage(PaintingContext context, Offset offset1) {
    Canvas canvas = context.canvas;
    canvas.save();
    canvas.translate(offset1.dx, offset1.dy);
    //翻转图像的矩阵y = -y+height*2+interval
    Matrix4 matrix4 = Matrix4.identity()
      ..setEntry(1, 1, -1)
      ..setEntry(1, 3, innerSize.height * 2 + interval);
    canvas.transform(matrix4.storage);
    //绘制裁剪区域
    Path path = Path()
      ..moveTo(0, innerSize.height - reflectionHeight)
      ..lineTo(0, innerSize.height)
      ..lineTo(innerSize.width, innerSize.height)
      ..lineTo(innerSize.width, innerSize.height - reflectionHeight)
      ..close();
    //裁剪画板
    canvas.clipPath(path, doAntiAlias: false);
    //绘制倒影child
    context.paintChild(child!, Offset.zero);
    canvas.restore();
    //恢复画板，并且把画板平移到倒影的左上角
    canvas.save();
    canvas.translate(offset1.dx, offset1.dy + interval + innerSize.height);
    //绘制白色渐变
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(size.width / 2, reflectionHeight / 2),
            width: size.width + 2,
            height: reflectionHeight + 2),
        mPaint
          ..strokeCap = StrokeCap.butt
          ..style = PaintingStyle.fill
          ..shader = ui.Gradient.linear(
            Offset.zero,
            Offset(0, reflectionHeight),
            [
              Colors.white.withOpacity(.2),
              Colors.white.withOpacity(.5),
              Colors.white
            ],
            [0, .4, .8],
          ));
    canvas.restore();
  }
}
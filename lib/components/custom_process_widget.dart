import 'package:flutter/material.dart';

class CustomeProcess extends StatelessWidget {
  final double min;
  final double max;
  final double start;
  final double end;
  final double height;

  CustomeProcess(this.min, this.max, this.start, this.end, this.height);

  @override
  Widget build(BuildContext context) {
    print('CustomeProcess $min,$max,$start,$end');
    return Stack(
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(3.0), //3像素圆角
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            double parentWidth = constraints.maxWidth;
            return Padding(
              padding: EdgeInsets.only(left: getLeftPad(parentWidth)),
              child: Container(
                height: height,
                width: getWidth(parentWidth),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0), //3像素圆角
                  gradient: LinearGradient(colors: [
                    Colors.green,
                    Colors.orange,
                  ], stops: [
                    0.0,
                    1.0
                  ]),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  //100/60*40
  double getLeftPad(double parentWidth) {
    double processWidth = parentWidth/(max - min)  * (start - min);
    return processWidth;
  }

  //100/60*40
  double getWidth(double parentWidth) {
    double processWidth = parentWidth/(max - min)  * (end - start);
    return processWidth;
  }
}

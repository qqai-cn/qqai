import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 自定义按钮
class MyFlatButton extends StatelessWidget {
  final VoidCallback onPress;
  final String img;
  final double imgSize;
  final String text;
  final double textSize;
  final Color color;
  final Color textColor;
  final bool circularImage;

  const MyFlatButton({
    Key? key,
    required this.onPress,
    required this.img,
    required this.text,
    this.color = Colors.white,
    required this.textColor,
    this.textSize = 10,
    this.imgSize = 30,
    this.circularImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      img,
      width: imgSize,
      height: imgSize,
      fit: BoxFit.cover,
    );
    if (circularImage) {
      image = ClipOval(
        child: SizedBox(width: imgSize, height: imgSize, child: image),
      );
    }
    return TextButton(
      onPressed: onPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          image,
          Text(
            text,
            style: context.typo.body.copyWith(color: textColor, fontSize: textSize),
          ),
        ],
      ),
    );
  }
}

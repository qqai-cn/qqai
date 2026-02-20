import 'package:flutter/material.dart';

/// 自定义按钮
class MyFlatButton extends StatelessWidget {
  final VoidCallback onPress;
  final String img;
  final double imgSize;
  final String text;
  final double textSize;
  final Color color;
  final Color textColor;

  const MyFlatButton({
    Key? key,
    required this.onPress,
    required this.img,
    required this.text,
    this.color = Colors.white,
    required this.textColor,
    this.textSize = 10,
    this.imgSize = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(img, width: imgSize, height: imgSize),
          Text(
            text,
            style: TextStyle(color: textColor, fontSize: textSize),
          ),
        ],
      ),
    );
  }
}

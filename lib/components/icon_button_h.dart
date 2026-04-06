import 'package:flutter/material.dart';

import '../features/douyin/theme/douyin_theme.dart';

/// 自定义按钮
class IconButtonH extends StatelessWidget {
  final VoidCallback onPress;
  final IconData icon;
  final double imgSize;
  final String text;
  final double textSize;
  final Color color;
  final Color textColor;

  const IconButtonH({
    Key? key,
    required this.onPress,
    required this.icon,
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
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: DouyinTheme.chip,
              shape: BoxShape.circle,
              border: Border.all(color: DouyinTheme.line),
            ),
            child: Icon(icon, color: DouyinTheme.text, size: 20),
          ),
          Text(
            text,
            style: TextStyle(color: textColor, fontSize: textSize),
          ),
        ],
      ),
    );
  }
}

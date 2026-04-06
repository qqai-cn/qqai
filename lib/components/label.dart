import 'package:flutter/material.dart';
import 'package:qqai/config/theme/my_fonts.dart';

/// 文本标签：仅 [content] 必填；[color] 默认跟主题，[onTap] 默认可不点。
class Label extends StatelessWidget {
  const Label({
    super.key,
    required this.content,
    this.color,
    this.backgroundColor,
    this.onTap,
  });

  final String content;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface;

    final textChild = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: DefaultTextStyle.merge(
        style: TextStyle(fontSize: MyFonts.labelSize, color: effectiveColor),
        child: Text(content),
      ),
    );

    if (onTap == null) {
      return Container(color: backgroundColor, child: textChild);
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(color: backgroundColor, child: textChild),
      ),
    );
  }
}

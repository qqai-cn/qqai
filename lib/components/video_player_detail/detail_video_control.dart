import 'package:flutter/material.dart';

/// Chewie 使用内置控件，此文件保留以便兼容引用；可删除未使用的引用
class DetailVideoControl extends StatelessWidget {
  const DetailVideoControl({
    super.key,
    this.iconSize = 20,
    this.fontSize = 12,
  });

  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

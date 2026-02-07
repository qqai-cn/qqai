import 'package:flutter/material.dart';

/// Chewie 使用内置控件，此文件保留以便兼容引用
class PublicVideoControl extends StatelessWidget {
  const PublicVideoControl({
    super.key,
    this.iconSize = 20,
    this.fontSize = 14,
  });

  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

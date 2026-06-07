import 'package:flutter/material.dart';

/// 留区域的默认底色（灰黑）。
const Color kLetterboxBackdropColor = Color(0xFF1F1F28);

enum LetterboxBackdropMode {
  /// 实时/静态内容高斯模糊延伸。
  blur,

  /// 纯色灰黑底，性能更好、兼容性更稳。
  solid,
}

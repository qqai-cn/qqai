export 'package:flick_video_player/flick_video_player.dart'
    show LetterboxBackdropMode, kLetterboxBackdropColor;

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// 静态封面：Web 上 [ImageFiltered] 对网络图有效，可开模糊。
LetterboxBackdropMode resolveCoverLetterboxBackdropMode() {
  return LetterboxBackdropMode.blur;
}

/// 实时视频：Web 的 [video_player] 仅 HtmlElementView（DOM video 标签），
/// 无法走 Texture 双图层，ImageFilter 也作用不到 Platform View 上。
LetterboxBackdropMode resolveVideoLetterboxBackdropMode() {
  if (kIsWeb) return LetterboxBackdropMode.solid;
  return LetterboxBackdropMode.blur;
}

/// @Deprecated 请改用 [resolveCoverLetterboxBackdropMode] 或 [resolveVideoLetterboxBackdropMode]。
LetterboxBackdropMode resolveLetterboxBackdropMode() =>
    resolveVideoLetterboxBackdropMode();

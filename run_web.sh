#!/bin/bash
# 使用本地资源运行 Web，不从 gstatic.com CDN 拉取 canvaskit.js（避免 Failed to fetch）
# 新版 Flutter 使用 --no-web-resources-cdn 将 CanvasKit 等资源打进构建产物。
set -e
cd "$(dirname "$0")"
exec flutter run -d chrome --no-web-resources-cdn "$@"

flutter pub run build_runner build --delete-conflicting-outputs

# 发布（单独执行）:
flutter build web --release --no-web-resources-cdn

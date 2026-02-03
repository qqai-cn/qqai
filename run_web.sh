#!/bin/bash
# 使用本地资源运行 Web，不从 gstatic.com CDN 拉取 canvaskit.js（避免 Failed to fetch）
# 注意：新版 Flutter 已移除 --web-renderer，改用 --no-web-resources-cdn 将资源打包到应用内
flutter run -d chrome --no-web-resources-cdn
flutter build web --release --wasm
#!/usr/bin/env bash
# Wasm 发布包（含 dart2js 回退）+ 本地 CanvasKit，便于 PWA 安装与离线资源目录完整。
# 部署需 HTTPS；可安装性由 web/manifest.json + 浏览器策略决定。
# Flutter 默认的 flutter_service_worker.js 当前为迁移用（激活后自卸载），
# 若需要离线首屏缓存，需自行接入 Workbox 等并注册自定义 SW。
set -euo pipefail
cd "$(dirname "$0")"

exec flutter build web --release --wasm --no-web-resources-cdn -O4 "$@"

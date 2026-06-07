#!/usr/bin/env bash
# dart2js 发布：去掉 index.html 中 main.dart.wasm / skwasm 预加载（仅 wasm 构建需要）。
set -euo pipefail

INDEX="${1:-web/index.html}"

perl -i -0pe '
  s#\n?\s*<!-- Wasm 首屏关键路径：.*?crossorigin>\s*##s;
  s#\n?\s*<!-- web-renderer:skwasm-preload -->.*?<!-- /web-renderer:skwasm-preload -->\n?##s;
' "$INDEX"

echo "index: 已移除 wasm/skwasm preload（dart2js 构建）"

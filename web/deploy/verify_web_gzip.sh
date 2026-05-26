#!/usr/bin/env bash
# 部署后校验 wasm 是否以 gzip/br 下发（未压缩时体积过大）
set -euo pipefail

BASE="${1:-https://qqai.cn}"

check_wasm() {
  local path="$1"
  local max_bytes="$2"
  local url="$BASE/$path"

  echo ""
  echo "检查: $url"
  local headers
  headers=$(curl -fsSI -H "Accept-Encoding: gzip, deflate, br" "$url")

  echo "$headers" | grep -iE '^(HTTP/|content-encoding|content-length|vary|content-type):' || true

  local len enc
  len=$(echo "$headers" | awk -F': ' 'tolower($1)=="content-length" {gsub(/\r/,"",$2); print $2; exit}')
  enc=$(echo "$headers" | awk -F': ' 'tolower($1)=="content-encoding" {gsub(/\r/,"",$2); print $2; exit}')

  if [[ -z "$len" ]]; then
    echo "FAIL: 无法读取 $path 的 content-length" >&2
    return 1
  fi

  if [[ "$len" -gt "$max_bytes" ]]; then
    echo "FAIL: $path 仍为 ${len} 字节（未压缩，阈值 ${max_bytes}）。" >&2
    return 1
  fi

  if [[ "${enc,,}" != "gzip" && "${enc,,}" != "br" ]]; then
    echo "WARN: $path 体积已缩小但无 content-encoding（enc=${enc:-无}）"
  else
    echo "OK: $path content-encoding=${enc} content-length=${len}"
  fi
}

failed=0
check_wasm "main.dart.wasm" 4000000 || failed=1
check_wasm "canvaskit/skwasm.wasm" 2500000 || failed=1

if [[ "$failed" -ne 0 ]]; then
  echo ""
  echo "处理：" >&2
  echo "  1) 本地: ./build_web_wasm.sh" >&2
  echo "  2) 确认 build/web/*.wasm.gz 与 canvaskit/skwasm.wasm.gz 存在" >&2
  echo "  3) rsync -av build/web/ 服务器:/var/www/qqai/web/  （须包含 .gz）" >&2
  echo "  4) 服务器: nginx -t && nginx -s reload" >&2
  exit 1
fi

echo ""
echo "首屏 wasm 传输量（gzip 后约）：main ~2.4MB + skwasm ~1.5MB ≈ 4MB"

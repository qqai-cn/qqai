#!/usr/bin/env bash
# 为 build/web 下的 wasm/js/mjs 预生成 .gz / .br，配合 nginx gzip_static / brotli_static。
set -euo pipefail

WEB_DIR="${1:-build/web}"

if [[ ! -d "$WEB_DIR" ]]; then
  echo "目录不存在: $WEB_DIR" >&2
  exit 1
fi

compress_file() {
  local f="$1"
  gzip -kf -9 "$f"
  if command -v brotli >/dev/null 2>&1; then
    brotli -kf -q 11 "$f"
  fi
}

echo "压缩 $WEB_DIR 中的 wasm / js / mjs / ttf / otf ..."
while IFS= read -r -d '' f; do
  compress_file "$f"
done < <(find "$WEB_DIR" \( -name '*.wasm' -o -name '*.js' -o -name '*.mjs' -o -name '*.ttf' -o -name '*.otf' \) -type f -print0)

if [[ -f "$WEB_DIR/main.dart.wasm" ]]; then
  if [[ ! -f "$WEB_DIR/main.dart.wasm.gz" ]]; then
    echo "FAIL: main.dart.wasm 存在但 main.dart.wasm.gz 未生成" >&2
    exit 1
  fi
  for f in "$WEB_DIR/main.dart.wasm" "$WEB_DIR/canvaskit/skwasm.wasm"; do
    [[ -f "$f" ]] || continue
    raw=$(wc -c < "$f" | tr -d ' ')
    gz=$(wc -c < "${f}.gz" | tr -d ' ')
    pct=$(awk "BEGIN {printf \"%.0f\", (1-${gz}/${raw})*100}")
    echo "$(basename "$f"): ${raw} bytes -> gzip ${gz} bytes (${pct}% 减小)"
  done
fi

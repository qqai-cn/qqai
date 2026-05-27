#!/usr/bin/env bash
# 将 web/ 下 bootstrap 与 index 切到 local（本站 /canvaskit/）或 cdn（gstatic）模式。
# 通常由 build_web_wasm.sh / run_web.sh 调用；勿单独长期改 index.html 后忘记还原。
set -euo pipefail

MODE="${1:-}"
case "$MODE" in
  local|cdn) ;;
  *)
    echo "用法: $0 <local|cdn>" >&2
    exit 1
    ;;
esac

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WEB_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

BOOT_SRC="$WEB_DIR/bootstrap/flutter_bootstrap.${MODE}.js"
INDEX="$WEB_DIR/index.html"

if [[ ! -f "$BOOT_SRC" ]]; then
  echo "缺少 $BOOT_SRC" >&2
  exit 1
fi

cp "$BOOT_SRC" "$WEB_DIR/flutter_bootstrap.js"

MARK_BEGIN='<!-- web-renderer:skwasm-preload -->'

FRAG="$WEB_DIR/bootstrap/index_skwasm_preload.fragment.html"

if [[ "$MODE" == "cdn" ]]; then
  if grep -q "$MARK_BEGIN" "$INDEX"; then
    perl -i -0pe 's#\n?\s*<!-- web-renderer:skwasm-preload -->.*?<!-- /web-renderer:skwasm-preload -->\n?##s' "$INDEX"
  fi
else
  if ! grep -q "$MARK_BEGIN" "$INDEX"; then
    if [[ ! -f "$FRAG" ]]; then
      echo "缺少 $FRAG，无法恢复 local preload" >&2
      exit 1
    fi
  tmp="$(mktemp)"
  awk -v frag="$FRAG" '
      /rel="preload" href="main\.dart\.wasm"/ && !done {
        print
        while ((getline line < frag) > 0) print line
        close(frag)
        done = 1
        next
      }
      { print }
    ' "$INDEX" > "$tmp"
    mv "$tmp" "$INDEX"
  fi
fi

echo "web renderer mode: $MODE (bootstrap <- $(basename "$BOOT_SRC"))"

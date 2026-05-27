#!/bin/bash
# 本地调试 Web（默认 local，不依赖 gstatic）
#
#   ./run_web.sh           # local：--no-web-resources-cdn + 本站 canvaskit
#   ./run_web.sh cdn       # 从 gstatic 拉 skwasm
set -e
cd "$(dirname "$0")"

MODE="${WEB_RENDERER_MODE:-local}"
if [[ "${1:-}" == "local" || "${1:-}" == "cdn" ]]; then
  MODE="$1"
  shift
fi

INDEX_BAK="$(mktemp)"
BOOTSTRAP_BAK="$(mktemp)"
cp web/index.html "$INDEX_BAK"
cp web/flutter_bootstrap.js "$BOOTSTRAP_BAK"
cleanup() {
  cp "$INDEX_BAK" web/index.html
  cp "$BOOTSTRAP_BAK" web/flutter_bootstrap.js
  rm -f "$INDEX_BAK" "$BOOTSTRAP_BAK"
}
trap cleanup EXIT INT TERM

bash web/scripts/apply_web_renderer_mode.sh "$MODE"

ARGS=(flutter run -d chrome)
if [[ "$MODE" == "local" ]]; then
  ARGS+=(--no-web-resources-cdn)
fi

echo "==> run_web mode=$MODE"
exec "${ARGS[@]}" "$@"

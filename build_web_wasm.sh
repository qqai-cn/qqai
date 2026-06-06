#!/usr/bin/env bash
# Wasm 发布包（含 dart2js 回退）。
#
# 用法：
#   ./build_web_wasm.sh              # 默认 local：本站 /canvaskit/ + --no-web-resources-cdn
#   ./build_web_wasm.sh cdn          # gstatic 拉 skwasm，部署包更小
#   WEB_RENDERER_MODE=cdn ./build_web_wasm.sh
#   ./build_web_wasm.sh local -- --dart-define=FOO=bar   # 额外参数写在 -- 之后
#
# 产物标记：build/web/.web-renderer-mode（local|cdn）
set -euo pipefail
cd "$(dirname "$0")"
# shellcheck source=scripts/qqai_dart_defines.sh
source "$(dirname "$0")/scripts/qqai_dart_defines.sh"

MODE="${WEB_RENDERER_MODE:-local}"
EXTRA_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    local|cdn)
      MODE="$1"
      shift
      ;;
    --)
      shift
      EXTRA_ARGS=("$@")
      break
      ;;
    *)
      EXTRA_ARGS+=("$1")
      shift
      ;;
  esac
done

case "$MODE" in
  local|cdn) ;;
  *)
    echo "用法: $0 [local|cdn] [-- flutter build 额外参数]" >&2
    exit 1
    ;;
esac

bash scripts/sync_web_icons.sh

INDEX_BAK="$(mktemp)"
BOOTSTRAP_BAK="$(mktemp)"
cp web/index.html "$INDEX_BAK"
cp web/flutter_bootstrap.js "$BOOTSTRAP_BAK"
cleanup() {
  cp "$INDEX_BAK" web/index.html
  cp "$BOOTSTRAP_BAK" web/flutter_bootstrap.js
  rm -f "$INDEX_BAK" "$BOOTSTRAP_BAK"
}
trap cleanup EXIT

bash web/scripts/apply_web_renderer_mode.sh "$MODE"

BUILD_ARGS=(build web --release --wasm -O4)
if [[ "$MODE" == "local" ]]; then
  # 把 canvaskit/skwasm 打进 build/web/canvaskit/，由本站提供
  BUILD_ARGS+=(--no-web-resources-cdn)
fi

if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
  echo "==> flutter ${BUILD_ARGS[*]} ${QQAI_DART_DEFINES[*]} ${EXTRA_ARGS[*]}"
  flutter "${BUILD_ARGS[@]}" "${QQAI_DART_DEFINES[@]}" "${EXTRA_ARGS[@]}"
else
  echo "==> flutter ${BUILD_ARGS[*]} ${QQAI_DART_DEFINES[*]}"
  flutter "${BUILD_ARGS[@]}" "${QQAI_DART_DEFINES[@]}"
fi

echo "$MODE" > build/web/.web-renderer-mode

if [[ -x web/compress_web_assets.sh ]]; then
  WEB_RENDERER_MODE="$MODE" web/compress_web_assets.sh
fi

echo ""
echo "完成: renderer=${MODE}, 标记 build/web/.web-renderer-mode"
if [[ "$MODE" == "local" ]]; then
  echo "  skwasm: https://<你的域名>/canvaskit/skwasm.wasm"
  echo "  部署: ./web/deploy/deploy_web.sh"
else
  echo "  skwasm: https://www.gstatic.com/flutter-canvaskit/<engineRevision>/skwasm.wasm"
  echo "  部署: 无需上传 build/web/canvaskit/；./web/deploy/deploy_web.sh"
fi

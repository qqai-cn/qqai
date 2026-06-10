#!/usr/bin/env bash
# dart2js 发布包（不用 --wasm，线上默认走此脚本，避免 WASM resize 栈溢出）。
#
# 用法：
#   ./build_web.sh              # 默认 local：本站 /canvaskit/ + --no-web-resources-cdn
#   ./build_web.sh cdn          # canvaskit 走 gstatic，部署包更小
#   WEB_RENDERER_MODE=cdn ./build_web.sh
#   ./build_web.sh local -- --dart-define=FOO=bar
#
# 产物：build/web/main.dart.js（无 main.dart.wasm）、build/web.zip（供 deploy.exp）
# 标记：build/web/.web-renderer-mode（local|cdn）、.web-build-target=js
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
bash web/scripts/strip_wasm_index_preloads.sh web/index.html

BUILD_ARGS=(build web --release)
if [[ "$MODE" == "local" ]]; then
  BUILD_ARGS+=(--no-web-resources-cdn)
fi

if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
  echo "==> flutter ${BUILD_ARGS[*]} ${QQAI_DART_DEFINES[*]} ${EXTRA_ARGS[*]}"
  flutter "${BUILD_ARGS[@]}" "${QQAI_DART_DEFINES[@]}" "${EXTRA_ARGS[@]}"
else
  echo "==> flutter ${BUILD_ARGS[*]} ${QQAI_DART_DEFINES[*]}"
  flutter "${BUILD_ARGS[@]}" "${QQAI_DART_DEFINES[@]}"
fi

# dart2js 构建后删除残留的 wasm/mjs，避免 zip 误带上旧产物
rm -f build/web/main.dart.wasm build/web/main.dart.wasm.* build/web/main.dart.mjs*

echo "$MODE" > build/web/.web-renderer-mode
echo "js" > build/web/.web-build-target

bash web/compress_web_assets.sh

echo "==> 打包 build/web.zip"
rm -f build/web.zip
(
  cd build
  zip -r web.zip web -x "*.DS_Store"
)

echo ""
echo "完成: target=js, renderer=${MODE}, 标记 build/web/.web-build-target"
echo "  zip: build/web.zip"
if [[ "$MODE" == "local" ]]; then
  echo "  canvaskit: https://<你的域名>/canvaskit/"
  echo "  部署: ./web/deploy/deploy_web.sh 或 expect deploy.exp"
else
  echo "  canvaskit: https://www.gstatic.com/flutter-canvaskit/<engineRevision>/"
  echo "  部署: expect deploy.exp（无需上传 build/web/canvaskit/）"
fi

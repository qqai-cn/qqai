#!/usr/bin/env bash
# 上传 build/web 到服务器（含 main.dart.wasm.gz），并校验线上 gzip 是否生效
#
# 环境变量：
#   WEB_DEPLOY_TARGET  例如 root@qqai.cn:/var/www/qqai/web/
#   WEB_DEPLOY_URL     校验用，默认 https://qqai.cn
#
# 用法：
#   export WEB_DEPLOY_TARGET='root@your-server:/var/www/qqai/web/'
#   ./web/deploy/deploy_web.sh
# 构建模式见 build/web/.web-renderer-mode（local 需 canvaskit/，cdn 不需要）
set -euo pipefail
cd "$(dirname "$0")/../.."

TARGET="${WEB_DEPLOY_TARGET:-}"
BASE_URL="${WEB_DEPLOY_URL:-https://qqai.cn}"
MODE="${WEB_RENDERER_MODE:-}"
BUILD_TARGET=""
if [[ -z "$MODE" && -f build/web/.web-renderer-mode ]]; then
  MODE="$(tr -d '[:space:]' < build/web/.web-renderer-mode)"
fi
if [[ -f build/web/.web-build-target ]]; then
  BUILD_TARGET="$(tr -d '[:space:]' < build/web/.web-build-target)"
fi
MODE="${MODE:-local}"

if [[ "$BUILD_TARGET" == "js" ]]; then
  if [[ ! -f build/web/main.dart.js.gz ]]; then
    echo "缺少 build/web/main.dart.js.gz，先执行: ./build_web.sh [local|cdn]" >&2
    exit 1
  fi
elif [[ ! -f build/web/main.dart.wasm.gz ]]; then
  echo "缺少 build/web/main.dart.wasm.gz，先执行: ./build_web_wasm.sh [local|cdn]" >&2
  exit 1
fi
if [[ "$BUILD_TARGET" != "js" && "$MODE" == "local" && ! -f build/web/canvaskit/skwasm.wasm.gz ]]; then
  echo "缺少 build/web/canvaskit/skwasm.wasm.gz，先执行: ./build_web_wasm.sh local" >&2
  exit 1
fi

echo "部署模式: target=${BUILD_TARGET:-wasm} renderer=$MODE"
echo "本地校验："
if [[ "$BUILD_TARGET" == "js" ]]; then
  ls -lh build/web/main.dart.js build/web/main.dart.js.gz
else
  ls -lh build/web/main.dart.wasm build/web/main.dart.wasm.gz
  if [[ "$MODE" == "local" ]]; then
    ls -lh build/web/canvaskit/skwasm.wasm build/web/canvaskit/skwasm.wasm.gz
  fi
fi

if [[ -z "$TARGET" ]]; then
  echo ""
  echo "未设置 WEB_DEPLOY_TARGET，跳过 rsync。请手动上传 build/web/（必须包含 .gz）："
  echo "  rsync -av --delete build/web/ user@server:/var/www/qqai/web/"
  echo "然后在服务器: nginx -t && nginx -s reload"
  echo "最后: bash web/deploy/verify_web_gzip.sh $BASE_URL"
  exit 0
fi

if [[ "$TARGET" != */ ]]; then
  TARGET="${TARGET}/"
fi

echo ""
echo "上传到 $TARGET ..."
rsync -av --delete build/web/ "$TARGET"

echo ""
echo "请在服务器执行: nginx -t && nginx -s reload"
echo "远程确认: ls -lh ${TARGET}main.dart.wasm*"
echo ""
bash web/deploy/verify_web_gzip.sh "$BASE_URL" "$MODE"

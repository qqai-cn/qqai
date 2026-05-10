#!/bin/bash
# 仅让 CanvasKit（canvaskit.js / canvaskit.wasm 等）从自定义 CDN 加载；
# 主站仍在当前域名，不使用 --static-assets-url。
#
# 步骤：
#   1) 先打一次带本地的包，得到与引擎版本一致的 canvaskit 目录：
#        flutter build web --release --no-web-resources-cdn
#   2) 将 build/web/canvaskit/ 整目录上传到你的 CDN，记下可访问的 URL 前缀，例如：
#        https://cdn.example.com/flutter/qqai-20250411/canvaskit/
#   3) 执行 ./build_web_cdn.sh（默认 CDN 前缀见脚本内；可用 CANVASKIT_CDN_URL 覆盖）
#
# CANVASKIT_CDN_URL 必须以 / 结尾。升级 Flutter 后需重新同步 canvaskit 目录。
#
# 依赖包字体（如 flutter_math_fork 的 KaTeX *.ttf）：Flutter 只会从 AssetManager 拉 /assets/packages/...，
# 不能单独给某一个包配 CDN。做法：把 build/web 整包同步到 CDN，在 index.html 里于 flutter_bootstrap 之前设置
#   window.__qqaiAssetBase = 'https://你的CDN/与 build/web 根对齐的路径/';
# 详见 web/flutter_bootstrap.js 注释。（可选：web/fonts_cdn.css 仅作浏览器 @font-face，不能替代引擎的 asset 请求。）
set -euo pipefail
cd "$(dirname "$0")"

# 默认与七牛静态资源同域；本地或其它环境可 export CANVASKIT_CDN_URL=... 覆盖
CANVASKIT_CDN_URL="${CANVASKIT_CDN_URL:-https://qiniu.qqai.cn/canvaskit/}"

if [[ "${CANVASKIT_CDN_URL: -1}" != "/" ]]; then
  echo "CANVASKIT_CDN_URL 必须以 / 结尾，当前: $CANVASKIT_CDN_URL" >&2
  exit 1
fi

flutter build web --release --wasm \
  --no-web-resources-cdn \
  --dart-define=FLUTTER_WEB_CANVASKIT_URL="$CANVASKIT_CDN_URL"

echo "完成。部署时可不将 build/web/canvaskit/ 上传到业务机（仅保留在 CDN），以减小源站体积。"

flutter build web --release --wasm \
  --no-web-resources-cdn
{{flutter_js}}
{{flutter_build_config}}

// 默认 cdn：skwasm 走 gstatic。local 模式由 build_web_wasm.sh / run_web.sh
// 调用 apply_web_renderer_mode.sh 临时替换为 bootstrap/flutter_bootstrap.local.js
_flutter.loader.load();

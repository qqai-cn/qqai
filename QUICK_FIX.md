# 快速修复 Freezed 编译错误

## 🔧 立即执行的步骤

这是典型的代码生成缓存问题。请按以下顺序执行：

### 步骤 1：清理并重新生成

```bash
cd /Users/dcx/work/flutter/qqai

# 1. 清理 Flutter
flutter clean

# 2. 重新获取依赖
flutter pub get

# 3. 清理 build_runner
 dart run build_runner clean

# 4. 重新生成所有代码
 dart run build_runner build --delete-conflicting-outputs
```

### 步骤 2：重启 IDE

**VS Code:**
1. 按 `Cmd+Shift+P` (Mac) 或 `Ctrl+Shift+P` (Windows/Linux)
2. 输入 "Dart: Restart Analysis Server"
3. 选择并执行

**Android Studio:**
1. File → Invalidate Caches / Restart
2. 选择 "Invalidate and Restart"

### 步骤 3：验证

```bash
# 检查生成的文件（应该返回 21）
find lib/providers -name "*.freezed.dart" | wc -l

# 检查实现类是否存在
grep "^class _AuthState" lib/providers/auth_providers.freezed.dart
```

### 步骤 4：如果仍然有问题

```bash
# 删除所有生成的文件
find lib -name "*.freezed.dart" -delete
find lib -name "*.g.dart" -delete

# 重新生成
flutter pub run build_runner build --delete-conflicting-outputs

# 重启 IDE
```

## ✅ 验证成功

运行以下命令应该**没有错误**：

```bash
flutter analyze lib/providers/
```

## 📝 说明

- ✅ 所有 `.freezed.dart` 文件已正确生成
- ✅ 所有 `_StateName` 实现类已存在
- ✅ `part` 语句正确
- ⚠️ 这是分析器缓存问题，需要重启 IDE/分析服务器

## 🚀 完成后

运行 `flutter run` 应该可以正常启动了！

flutter build web --release

---

## Web：Failed to fetch canvaskit.js (gstatic.com)

若在 Chrome 运行/热重启时报错：`Failed to fetch dynamically imported module: https://www.gstatic.com/flutter-canvaskit/.../canvaskit.js`，是因为默认从 **gstatic CDN** 拉取 CanvasKit；网络不可达时会失败。

**做法：使用本地资源，不依赖 CDN**

- **运行**：`flutter run -d chrome --no-web-resources-cdn`  
  或执行项目根目录脚本：`./run_web.sh`
- **打包**：`flutter build web --no-web-resources-cdn`

`--no-web-resources-cdn` 会把 CanvasKit 等资源打包进应用，由同一域名提供，不再请求 gstatic。

（新版 Flutter 已移除 `--web-renderer` 和 HTML 渲染器，只能通过关闭 CDN 避免外网拉取。）
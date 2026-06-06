---
name: qqai-ui
description: >-
  Guides UI work in the qqai Flutter app: prefer shared components in
  lib/components/, support light/dark themes, and adapt layouts for narrow vs
  wide screens. Use when adding or changing pages, widgets, layouts, styling,
  AppBar, dialogs, lists, or any visual UI in qqai/.
---

# QQAI Flutter UI 开发规范

目标子项目：`qqai/`（Flutter C 端 App）。

## 核心原则

1. **优先复用公共组件** — 写 UI 前先搜 `lib/components/`，能复用就不在页面里堆内联 Widget。
2. **必须兼容白天/夜间模式** — 颜色与文字走主题体系，禁止写死黑白前景色。
3. **必须考虑窄屏/宽屏** — 布局随宽度切换，避免超宽屏拉满或窄屏溢出。

---

## 1. 公共组件优先

### 开发顺序

```
- [ ] 在 lib/components/ 及子目录搜索是否已有同类组件
- [ ] 有 → 直接 import 使用或小幅扩展参数
- [ ] 无但可复用（≥2 处会用）→ 新增到 lib/components/（或对应子目录）
- [ ] 仅单页专用 → 放 features/<feature>/widgets/，但仍遵守主题与响应式规范
```

### 常用公共组件目录

| 路径 | 用途 |
|------|------|
| `lib/components/` | 通用按钮、搜索条、网格、Tab、头像、网络图等 |
| `lib/components/blog/` | 动态流、评论、侧栏操作、媒体详情壳 |
| `lib/components/chat/` | 聊天消息、输入区、连接状态 |
| `lib/components/video_player/` | 播放器、控制条、分享 |
| `lib/config/theme/` | 全局主题色、字体、操作色 |

优先查阅的组件示例：

- 操作按钮：`app_action_outline_button.dart`、`follow_button.dart`、`icon_button_h.dart`
- 搜索：`in_page_search_bar.dart`
- 图片：`qq_network_image.dart`、`default_asset_image.dart`
- 导航壳：`AnimatedBottomBar.dart`、`AnimatedLeftBar.dart`
- 网格：`responsive_masonry_grid.dart`、`my_grid_view.dart`
- 状态：`custom_loading_overlay.dart`、`api_error_widget.dart`、`custom_snackbar.dart`

新增公共组件时：命名清晰、参数化、文档注释说明适用场景；颜色/字号走下文主题规范。

---

## 2. 白天 / 夜间模式

主题由 `MyTheme.getThemeData` + `appThemeModeProvider` 驱动（`lib/main.dart`）。

### 颜色 — 按优先级选用

1. **`Theme.of(context).colorScheme`** — 背景、表面、主色、onSurface 等（首选）
2. **`AppActionColors`**（`lib/config/theme/app_action_colors.dart`）— 操作按钮、次要/强调/边框文字
3. **`LightThemeColors` / `DarkThemeColors`** — 需与全局调色板一致时
4. **业务主题类** — 如 `JdGoodsTheme`、`GoodsPageStyle`，仅在该业务域内使用

```dart
// ✅ 正确
final fg = AppActionColors.foreground(context);
final bg = Theme.of(context).scaffoldBackgroundColor;
final isDark = Theme.of(context).brightness == Brightness.dark;

// ❌ 避免
Text('标题', style: TextStyle(color: Colors.black));
Container(color: Colors.white);
```

### 文字样式

统一用 **`context.typo`**（`lib/config/theme/app_typography.dart`），不要散落硬编码 `TextStyle`：

```dart
Text('标题', style: context.typo.sectionTitle);
Text('正文', style: context.typo.body.copyWith(color: AppActionColors.muted(context)));
```

### 字号缩放

项目使用 `flutter_screenutil`（设计稿 `390×844`）。优先：

- `16.spSoft()` — 日常正文，减弱屏宽对字号的影响
- `16.spClamp()` — 需要严格上下限时
- `LayoutBuilder` 内窄容器用 `spInParent` / `spInParentBox`

详见 `lib/util/adaptive_sp.dart`。

### 状态栏

宽屏分栏或自定义 AppBar 时，按主题设置 `SystemUiOverlayStyle`（参考 `search_page.dart`）。

---

## 3. 窄屏 / 宽屏适配

### 断点参考（与现有代码保持一致）

| 场景 | 判断方式 | 典型行为 |
|------|----------|----------|
| 主壳导航 | `1.sw > 800` | 宽屏左侧栏 + 无底栏；窄屏底栏 |
| 聊天双栏 | `1.sw > Constant.CHAT_TWO_VIEW_WIDTH`（700） | 宽屏列表+详情并排 |
| 广场分栏 | `Constant.SQUARE_SPLIT_WIDTH`（750） | 宽屏左右分栏 |
| 通用三档 | `Responsive`（`lib/util/responsive.dart`） | mobile <850、tablet 850–1100、desktop ≥1100 |
| 搜索页 | `width >= 1200` | 落地页与结果分栏 |

新增页面时：**先确认所属场景**，复用相同断点；不要凭空发明新阈值，除非有明确设计理由并在 `Constant` 或页面顶部常量中声明。

### 布局手段

1. **`LayoutBuilder`** — 页面级根据 `constraints.maxWidth` 切换单列/双列/分栏
2. **`Responsive` widget** — 整页 mobile/tablet/desktop 三套子树
3. **`1.sw` / `.w` / `.h`** — ScreenUtil 逻辑宽，与主壳 `800` 等判断一致
4. **内容最大宽度** — 窄屏单列居中限宽（如搜索页 `600`），避免超宽屏一行拉满

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final wide = constraints.maxWidth >= 1200;
    return wide ? _buildSplitLayout() : _buildNarrowLayout();
  },
);
```

宽屏常见模式：侧栏 + 内容区、`Row` 分栏、`drawer` 改为常驻侧栏（见 `home_page.dart`、`index_page.dart`）。

---

## 4. 完成前自检

```
- [ ] 已搜索并优先使用 lib/components/ 中的公共组件
- [ ] 新组件若可复用，已放入 components 而非埋在单页
- [ ] 浅色与深色下文字、背景、边框、图标均清晰可读
- [ ] 未使用 Colors.black/white 等写死前景/背景（语义色如 liked 除外）
- [ ] 文字使用 context.typo；字号使用 .spSoft / .spClamp 等
- [ ] 窄屏（≈390 逻辑宽）与宽屏（>800 或业务断点）布局均验证
- [ ] 无横向溢出、底栏与侧栏切换正确
```

本地验证：

```bash
cd qqai && flutter analyze
# 手动：切换主题 + 调整浏览器/模拟器宽度查看布局
```

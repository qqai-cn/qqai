import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 在 ScreenUtil 缩放后再限制字号范围，避免极小屏上文字几乎看不见。
///
/// - **`16.sp`**：完全按 `screenWidth / designWidth` 线性缩放，屏宽一变字就明显变。
/// - **`16.spSoft()`**：在「设计稿数字」与「完整 `.sp`」之间混合，**减弱宽度影响**（大屏不会涨太猛、小屏不会缩太狠）。
/// - **`16.spClamp()`**：在 `.sp` 后再 clamp 上下限。
/// - **`16.spInParentBox(w, h)`**：按父级**宽高框**相对参考框等比缩放（几何平均）。
/// - **`16.spByAspectRatio(w, h)`**：按父级**宽高比**相对参考比微调。
extension AdaptiveSp on num {
  double spClamp({double minSp = 11, double maxSp = 40}) {
    return toDouble().sp.clamp(minSp, maxSp);
  }

  /// 削弱屏宽对字号的拉动：`设计稿数值` 与 `完整 .sp` 按 [blend] 插值。
  ///
  /// - [blend] = **1** → 与 `.sp` 一致；= **0** → 固定为设计稿上的逻辑字号（几乎不随屏宽变）。
  /// - 常用 **0.5～0.65**：比纯 `.sp` 稳得多。
  double spSoft({double blend = 0.58, double minSp = 10, double maxSp = 40}) {
    final d = toDouble();
    final scaled = d.sp;
    final mixed = d + (scaled - d) * blend.clamp(0.0, 1.0);
    return mixed.clamp(minSp, maxSp);
  }

  /// 先按 ScreenUtil 做 `.sp`，再按**父级逻辑宽度**相对 [refWidth] 成比例。
  ///
  /// 父级更窄（如双列卡片）时字更小；接近 [refWidth] 时与 `设计稿字号.sp` 一致。
  /// [parentWidth] 一般传 `LayoutBuilder` 的 `constraints.maxWidth`。
  double spInParent(
    double parentWidth, {
    double refWidth = 360,
    double minSp = 9,
    double maxSp = 40,
  }) {
    final base = toDouble().sp;
    final f = (parentWidth / refWidth).clamp(0.78, 1.12);
    return (base * f).clamp(minSp, maxSp);
  }

  /// 按**父级宽高框**与参考框做**等比**缩放（宽高几何平均，等价于按面积比开根号）。
  ///
  /// - [parentWidth] / [parentHeight]：一般为 [LayoutBuilder] 的 `constraints.maxWidth` / `maxHeight`。
  /// - [refWidth] / [refHeight]：设计稿里该区域的参考宽高；与父级一致时缩放系数为 1。
  /// - 先取设计稿字号 [toDouble().sp]，再乘 `√((pw/refW)×(ph/refH))`。
  double spInParentBox(
    double parentWidth,
    double parentHeight, {
    double refWidth = 360,
    double refHeight = 200,
    double minSp = 9,
    double maxSp = 40,
  }) {
    final base = toDouble().sp;
    if (parentWidth <= 0 || parentHeight <= 0 || refWidth <= 0 || refHeight <= 0) {
      return base.clamp(minSp, maxSp);
    }
    final sx = parentWidth / refWidth;
    final sy = parentHeight / refHeight;
    final scale = math.sqrt(sx * sy);
    return (base * scale).clamp(minSp, maxSp);
  }

  /// 按**父级宽高比** `width/height` 相对 [refAspect] 微调字号（更温和，适合只关心「扁/长」）。
  ///
  /// 缩放为 `√(aspectRatio / refAspect)` 并夹在 [scaleMin]～[scaleMax]，避免比例差太大时字过极端。
  double spByAspectRatio(
    double parentWidth,
    double parentHeight, {
    double refAspect = 1.0,
    double scaleMin = 0.88,
    double scaleMax = 1.12,
    double minSp = 9,
    double maxSp = 40,
  }) {
    final base = toDouble().sp;
    if (parentHeight <= 0 || refAspect <= 0) return base.clamp(minSp, maxSp);
    final aspect = parentWidth / parentHeight;
    final raw = math.sqrt(aspect / refAspect);
    final scale = raw.clamp(scaleMin, scaleMax);
    return (base * scale).clamp(minSp, maxSp);
  }
}

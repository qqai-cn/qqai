import 'package:flutter/material.dart';

import '../util/adaptive_sp.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 在 [Text] 外包一层，按**父组件**的宽高比用 [num.spByAspectRatio] 动态改字号。
///
/// [designSp] 为设计稿上的字号数字（内部会先 `.sp` 再按宽高比缩放）。不传时取
/// [text.style?.fontSize]，再否则取主题默认字号。
///
/// 建议在 [text] 里只写颜色、字重等；**不要在 [TextStyle.fontSize] 里再写 `xx.sp`**，以免重复缩放。
class ParentAspectText extends StatelessWidget {
  const ParentAspectText({
    super.key,
    required this.text,
    this.designSp,
    this.refAspect = 1.0,
    this.scaleMin = 0.88,
    this.scaleMax = 1.12,
    this.minSp = 9,
    this.maxSp = 40,
  });

  final Text text;

  /// 设计稿字号（如 `14`）；为 null 时用 [Text] 上已有 `fontSize` 或主题默认。
  final double? designSp;

  final double refAspect;
  final double scaleMin;
  final double scaleMax;
  final double minSp;
  final double maxSp;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final themeBody =
            Theme.of(context).textTheme.bodyMedium ?? context.typo.body.copyWith();
        final merged = DefaultTextStyle.of(context).style
            .merge(themeBody)
            .merge(text.style ?? context.typo.body.copyWith());
        final d = designSp ?? merged.fontSize ?? 14;
        final fontSize = d.spByAspectRatio(
          constraints.maxWidth,
          constraints.maxHeight,
          refAspect: refAspect,
          scaleMin: scaleMin,
          scaleMax: scaleMax,
          minSp: minSp,
          maxSp: maxSp,
        );
        final style = merged.copyWith(fontSize: fontSize);

        return Text(
          text.data ?? '',
          style: style,
          strutStyle: text.strutStyle,
          textAlign: text.textAlign,
          textDirection: text.textDirection,
          locale: text.locale,
          softWrap: text.softWrap,
          overflow: text.overflow,
          textScaler: text.textScaler,
          maxLines: text.maxLines,
          semanticsLabel: text.semanticsLabel,
          textWidthBasis: text.textWidthBasis,
          textHeightBehavior: text.textHeightBehavior,
          selectionColor: text.selectionColor,
        );
      },
    );
  }
}

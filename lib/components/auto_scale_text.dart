import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 外层传入 [Text]，在窄宽度下将合并后的字号乘以 [shrinkFactor]。
///
/// [Text] 上的 `style`、`maxLines`、`overflow` 等都会保留；字号由 [DefaultTextStyle.merge] 统一缩放。
class AutoScaleText extends StatelessWidget {
  const AutoScaleText(
    this.text, {
    super.key,
    this.shrinkFactor = 0.5,
    this.threshold = 280,
  });

  /// 由调用方配置好的 [Text]（文案、样式、行数等）。
  final Text text;

  /// 窄的时候缩小比例
  final double shrinkFactor;

  /// 多宽算「窄」（如 2 列时 item 宽度）
  final double threshold;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentWidth = constraints.maxWidth;
        final isNarrow = parentWidth < threshold;

        final parentStyle = DefaultTextStyle.of(context).style;
        final mergedBase = parentStyle
            .merge(text.style);
        final fontSize = mergedBase.fontSize ?? 16;
        final scaledSize = isNarrow ? fontSize * shrinkFactor : fontSize;

        return DefaultTextStyle.merge(
          style: mergedBase.copyWith(fontSize: scaledSize),
          child: text,
        );
      },
    );
  }
}

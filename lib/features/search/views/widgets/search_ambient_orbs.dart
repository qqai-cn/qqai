import 'package:flutter/material.dart';

import '../../theme/search_ai_theme.dart';

/// 搜索页氛围光晕（仅装饰，不接收手势）。
class SearchAmbientOrbs extends StatelessWidget {
  const SearchAmbientOrbs({
    super.key,
    this.landingOnly = false,
  });

  /// 落地侧：只保留左下柔光，避免盖住结果 Tab。
  final bool landingOnly;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          if (!landingOnly)
            Positioned(
              top: -60,
              left: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ai.orbCyanGradient,
                ),
              ),
            ),
          Positioned(
            bottom: 60,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: ai.orbRedGradient,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/app_config_providers.dart';

/// 宽屏左侧导航底部：夜间 / 浅色模式 Switch（位于备案号之上）。
class WideSidebarThemeToggle extends ConsumerWidget {
  const WideSidebarThemeToggle({
    super.key,
    required this.isExtended,
  });

  final bool isExtended;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = ref.watch(appThemeModeProvider);
    final isDarkMode = !isLight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      child: Align(
        alignment: isExtended ? Alignment.centerLeft : Alignment.center,
        child: Tooltip(
          message: isLight ? '切换到夜间' : '切换到浅色',
          child: Switch(
            value: isDarkMode,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (wantDark) {
              if (wantDark == isLight) {
                ref.read(appThemeModeProvider.notifier).toggle();
              }
            },
          ),
        ),
      ),
    );
  }
}

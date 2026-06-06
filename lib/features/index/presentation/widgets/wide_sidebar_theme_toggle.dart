import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/app_config_providers.dart';
import '../../../../providers/app_theme_preference.dart';

/// 宽屏左侧导航底部：夜间 / 浅色模式 Switch（位于备案号之上）。
class WideSidebarThemeToggle extends ConsumerWidget {
  const WideSidebarThemeToggle({
    super.key,
    required this.isExtended,
  });

  final bool isExtended;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preference = ref.watch(appThemeModeProvider);
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final isLight = appThemeIsLight(preference, platformBrightness);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
      child: Align(
        alignment: isExtended ? Alignment.centerLeft : Alignment.center,
        child: Tooltip(
          message: isLight ? '切换到夜间' : '切换到浅色',
          child: Transform.scale(
            scale: 0.72,
            alignment: isExtended ? Alignment.centerLeft : Alignment.center,
            child: Switch(
              value: !isLight,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (wantDark) {
                final currentlyLight = appThemeIsLight(
                  preference,
                  platformBrightness,
                );
                if (wantDark == currentlyLight) {
                  ref
                      .read(appThemeModeProvider.notifier)
                      .toggleForPlatform(platformBrightness);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/config/theme/shell_nav_colors.dart';

import '../../../../providers/auth_providers.dart';
import '../../../my/providers/my_page_profile.dart';
import 'app_bar_user_avatar.dart';

/// 宽屏左侧导航顶部「个人中心」入口（位于「首页」之上）。
class WideSidebarProfileEntry extends ConsumerWidget {
  const WideSidebarProfileEntry({
    super.key,
    required this.isExtended,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  final bool isExtended;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final profileAsync = ref.watch(myPageProfileProvider);
    final displayName = auth.isAuthenticated
        ? (profileAsync.maybeWhen(
              data: (page) {
                final name = page.nickname?.trim();
                if (name != null && name.isNotEmpty) return name;
                return null;
              },
              orElse: () => null,
            ) ??
            auth.username?.trim() ??
            '用户')
        : '未登录';

    return Builder(
      builder: (ctx) => Tooltip(
        message: '个人中心',
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () => Scaffold.of(ctx).openDrawer(),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 15,
              top: 10,
              left: 10,
              right: 10,
            ),
            child: Row(
              children: [
                const AppBarUserAvatar(size: 36),
                const SizedBox(width: 2),
                Visibility(
                  visible: isExtended,
                  child: AnimatedSize(
                    duration: animationDuration,
                    curve: Curves.easeInOut,
                    child: AutoSizeText(
                      displayName,
                      maxLines: 1,
                      style: context.typo.body.copyWith(
                        color: ShellNavColors.label(
                          context,
                          isSelected: false,
                          lightAccent: Colors.teal,
                        ),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/components/blog/detail_avatar.dart';
import 'package:qqai/components/shiny_avatar_ring.dart';

import '../../../../providers/auth_providers.dart';
import '../../../my/providers/my_page_profile.dart';

/// AppBar / Drawer 入口：已登录时展示 [myPageProfileProvider] 头像。
class AppBarUserAvatar extends ConsumerWidget {
  const AppBarUserAvatar({
    super.key,
    this.size = 28,
    this.shinyRing = true,
  });

  final double size;
  final bool shinyRing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final avatar = !auth.isAuthenticated
        ? buildDefaultUserAvatar(size)
        : _loggedInAvatar(ref, context);

    if (!shinyRing) return avatar;

    return ShinyAvatarRing(
      size: size,
      child: SizedBox(
        width: size,
        height: size,
        child: avatar,
      ),
    );
  }

  Widget _loggedInAvatar(WidgetRef ref, BuildContext context) {
    final profileAsync = ref.watch(myPageProfileProvider);
    final avatarUrl = profileAsync.maybeWhen(
      data: (page) => page.avatar,
      orElse: () => null,
    );
    return buildDetailAvatar(
      avatarUrl: avatarUrl,
      size: size,
      context: context,
    );
  }
}

/// AppBar actions 里的头像按钮。
class AppBarUserAvatarButton extends ConsumerWidget {
  const AppBarUserAvatarButton({
    super.key,
    required this.onPressed,
    this.tooltip = '个人中心',
    this.size = 35,
  });

  final VoidCallback onPressed;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: size + 12,
        minHeight: size + 12,
      ),
      icon: AppBarUserAvatar(size: size),
    );
  }
}

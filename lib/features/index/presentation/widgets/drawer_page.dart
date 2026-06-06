import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/blog/detail_avatar.dart';
import 'package:qqai/components/shiny_avatar_ring.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/format_count.dart';

import '../../../../providers/app_config_providers.dart';
import '../../../../providers/auth_providers.dart';
import '../../../../router/app_routes.dart';
import '../../../my/providers/my_page_profile.dart';

/// Drawer 头部用户头像尺寸（[DrawerHeader] 内容区约 136px 高）。
const double _drawerAvatarSize = 80;
const double _drawerAvatarRingWidth = 3.5;

Widget _drawerHeaderAvatar({
  required BuildContext context,
  required String? avatarUrl,
}) {
  return ShinyAvatarRing(
    size: _drawerAvatarSize,
    ringWidth: _drawerAvatarRingWidth,
    child: SizedBox(
      width: _drawerAvatarSize,
      height: _drawerAvatarSize,
      child: buildDetailAvatar(
        avatarUrl: avatarUrl,
        size: _drawerAvatarSize,
        context: context,
      ),
    ),
  );
}

class DrawerPage extends ConsumerWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          auth.isAuthenticated
              ? const _DrawerLoggedInHeader()
              : _DrawerGuestHeader(
                  onLogin: () {
                    Navigator.of(context).pop();
                    context.push(Routes.login);
                  },
                ),
          ..._drawerMenuTiles(context, ref),
        ],
      ),
    );
  }
}

class _DrawerGuestHeader extends StatelessWidget {
  const _DrawerGuestHeader({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.blue),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _drawerHeaderAvatar(context: context, avatarUrl: null),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '未登录',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.typo.sectionTitle.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '登录后查看头像、关注与粉丝',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.typo.caption.copyWith(
                          color: Colors.white70,
                          fontSize: 11,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 36,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                padding: EdgeInsets.zero,
              ),
              onPressed: onLogin,
              child: const Text('登录'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerLoggedInHeader extends ConsumerWidget {
  const _DrawerLoggedInHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final profileAsync = ref.watch(myPageProfileProvider);

    final nickname = profileAsync.maybeWhen(
      data: (page) {
        final name = page.nickname?.trim();
        if (name != null && name.isNotEmpty) return name;
        return null;
      },
      orElse: () => null,
    );
    final displayName = nickname ?? auth.username?.trim() ?? '用户';

    final followingLabel = profileAsync.maybeWhen(
      data: (page) => formatCompactCount(page.followingCount),
      orElse: () => '--',
    );
    final followerLabel = profileAsync.maybeWhen(
      data: (page) => formatCompactCount(page.followerCount),
      orElse: () => '--',
    );

    final avatarUrl = profileAsync.maybeWhen(
      data: (page) => page.avatar,
      orElse: () => null,
    );
    final qqId =
        profileAsync.maybeWhen(data: (page) => page.id, orElse: () => null) ??
        int.tryParse(auth.userId ?? '');

    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.blue),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _drawerHeaderAvatar(context: context, avatarUrl: avatarUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.sectionTitle.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                if (qqId != null)
                  Text(
                    '千千号 $qqId',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.caption.copyWith(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                if (qqId != null) const SizedBox(height: 4),
                if (profileAsync.isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white70,
                    ),
                  )
                else
                  Text(
                    '关注 $followingLabel  粉丝 $followerLabel',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.caption.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _drawerMenuTiles(BuildContext context, WidgetRef ref) {
  const imgPath = 'imgs/';
  final auth = ref.watch(authProvider);

  return [
    ListTile(
      leading: SvgPicture.asset(
        '${imgPath}care.svg',
        width: 35,
        height: 35,
        fit: BoxFit.fill,
      ),
      title: const Text('关注'),
      onTap: () {
        Navigator.of(context).pop();
        context.push(Routes.care);
      },
    ),
    ListTile(
      leading: SvgPicture.asset(
        '${imgPath}collect.svg',
        width: 35,
        height: 35,
        fit: BoxFit.fill,
      ),
      title: const Text('收藏'),
      onTap: () {
        Navigator.of(context).pop();
        context.push(Routes.collect);
      },
    ),
    ListTile(
      leading: SvgPicture.asset(
        '${imgPath}zuji.svg',
        width: 35,
        height: 35,
        fit: BoxFit.fill,
      ),
      title: const Text('足迹'),
      onTap: () {
        Navigator.of(context).pop();
        context.push(Routes.footprint);
      },
    ),
    Container(height: 1, color: AppActionColors.borderSubtle(context)),
    ListTile(
      leading: SvgPicture.asset(
        '${imgPath}fuli.svg',
        width: 35,
        height: 35,
        fit: BoxFit.fill,
      ),
      title: const Text('会员中心'),
      onTap: () {
        Navigator.of(context).pop();
        context.push(Routes.memberCenter);
      },
    ),
    ListTile(
      leading: Icon(
        Icons.location_on_outlined,
        size: 35,
        color: AppActionColors.strong(context),
      ),
      title: const Text('我的地址'),
      onTap: () {
        Navigator.of(context).pop();
        context.push(Routes.douyinMyAddresses);
      },
    ),
    ListTile(
      leading: SvgPicture.asset(
        '${imgPath}order.svg',
        width: 35,
        height: 35,
        fit: BoxFit.fill,
      ),
      title: const Text('订单'),
      onTap: () {
        Navigator.of(context).pop();
        context.push(Routes.douyinMyOrders);
      },
    ),
    ListTile(
      leading: SvgPicture.asset(
        '${imgPath}gouwuche.svg',
        width: 35,
        height: 35,
        fit: BoxFit.fill,
      ),
      title: const Text('购物车'),
      onTap: () {
        Navigator.of(context).pop();
        context.push(Routes.cartPageUrl);
      },
    ),
    Container(height: 1, color: AppActionColors.borderSubtle(context)),
    ListTile(
      leading: SvgPicture.asset(
        '${imgPath}set.svg',
        width: 35,
        height: 35,
        fit: BoxFit.fill,
      ),
      title: const Text('设置'),
      onTap: () {
        Navigator.of(context).pop();
      },
    ),
    SwitchListTile(
      secondary: SvgPicture.asset(
        '${imgPath}night.svg',
        width: 35,
        height: 35,
        fit: BoxFit.fill,
      ),
      title: const Text('夜间模式'),
      subtitle: Text(
        ref.watch(appThemeModeProvider) ? '当前：浅色' : '当前：深色',
        style: context.typo.caption,
      ),
      value: !ref.watch(appThemeModeProvider),
      onChanged: (wantDark) {
        final isLight = ref.read(appThemeModeProvider);
        if (wantDark == isLight) {
          ref.read(appThemeModeProvider.notifier).toggle();
        }
      },
    ),
    ListTile(
      leading: SvgPicture.asset(
        '${imgPath}fankui.svg',
        width: 35,
        height: 35,
        fit: BoxFit.fill,
      ),
      title: const Text('问题反馈'),
      onTap: () {
        Navigator.of(context).pop();
        context.push(Routes.feedback);
      },
    ),
    ListTile(
      leading: SvgPicture.asset(
        '${imgPath}version.svg',
        width: 35,
        height: 35,
        fit: BoxFit.fill,
      ),
      title: const Text('版本'),
      onTap: () {
        Navigator.of(context).pop();
      },
    ),
    if (auth.isAuthenticated)
      ListTile(
        leading: SvgPicture.asset(
          '${imgPath}exist.svg',
          width: 35,
          height: 35,
          fit: BoxFit.fill,
        ),
        title: const Text('退出登陆'),
        onTap: () async {
          Navigator.of(context).pop();
          await ref.read(authProvider.notifier).logout();
          if (!context.mounted) return;
          context.go(Routes.login);
        },
      ),
  ];
}

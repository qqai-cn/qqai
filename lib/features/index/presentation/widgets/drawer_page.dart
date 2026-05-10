import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../../providers/app_config_providers.dart';
import '../../../../providers/auth_providers.dart';
import '../../../../router/app_routes.dart';

class DrawerPage extends ConsumerStatefulWidget {
  const DrawerPage({super.key});

  @override
  ConsumerState<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends ConsumerState<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return myDrawer();
  }

  Drawer myDrawer() {
    String imgPath = 'imgs/';
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('imgs/user_default.png'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '新飞飞',
                    style: context.typo.sectionTitle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    '关注 122  粉丝 999',
                    style: context.typo.caption.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  )
                ],
              )),
          ListTile(
            leading: SvgPicture.asset(
              imgPath + 'care.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: Text('关注'),
            onTap: () {
              Navigator.of(context).pop();
              context.push(Routes.care);
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              imgPath + 'collect.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: Text('收藏'),
            onTap: () {
              Navigator.of(context).pop();
              context.push(Routes.collect);
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              imgPath + 'zuji.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: Text('足迹'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              imgPath + 'caogao.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: Text('草稿箱'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              imgPath + 'creator.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: Text('创作中心'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          Container(
            height: 1,
            color: Colors.black12,
          ),
          ListTile(
            leading: SvgPicture.asset(
              imgPath + 'fuli.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: Text('福利中心'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              imgPath + 'order.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: Text('订单'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              imgPath + 'gouwuche.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: Text('购物车'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          Container(
            height: 1,
            color: Colors.black12,
          ),
          ListTile(
            leading: SvgPicture.asset(
              imgPath + 'fankui.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: Text('意见反馈'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              imgPath + 'set.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: Text('设置'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          SwitchListTile(
            secondary: SvgPicture.asset(
              imgPath + 'night.svg',
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
              imgPath + 'version.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: Text('版本'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              imgPath + 'exist.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: Text('退出登陆'),
            onTap: () async {
              Navigator.of(context).pop();
              await ref.read(authProvider.notifier).logout();
              if (!mounted) return;
              context.go(Routes.login);
            },
          ),
        ],
      ),
    );
  }
}

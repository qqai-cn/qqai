import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../router/app_routes.dart';
import '../../providers/home_providers.dart';

class DrawerWidthPage extends ConsumerStatefulWidget {
  DrawerWidthPage({super.key});

  @override
  ConsumerState<DrawerWidthPage> createState() {
    return _DrawerWidthPage();
  }
}

class _DrawerWidthPage extends ConsumerState<DrawerWidthPage> {
  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    return myDrawer(homeState);
  }

  Drawer myDrawer(HomeState homeState) {
    String imgPath = 'imgs/';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            leading: SvgPicture.asset(
              imgPath + 'care.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: homeState.isExtended ? Text('关注') : null,
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
            title: homeState.isExtended ? Text('收藏') : null,
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
            title: homeState.isExtended ? Text('足迹') : null,
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
          Container(height: 1, color: Colors.black12),
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
          Container(height: 1, color: Colors.black12),
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
          ListTile(
            leading: SvgPicture.asset(
              imgPath + 'night.svg',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            title: Text('夜间模式'),
            onTap: () {
              Navigator.of(context).pop();
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
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

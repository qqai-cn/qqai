import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/app_routes.dart';

import 'package:qqai/config/theme/app_action_colors.dart';

import '../../../../components/mybutton.dart';

class PublicSheets extends StatelessWidget {
  const PublicSheets({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = AppActionColors.muted(context);
    return Center(
      child: SizedBox(
        width: 1.sw,
        height: 350.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyFlatButton(
              text: '发布动态',
              img: 'imgs/dongtai.png',
              textColor: muted,
              onPress: () => {
                Navigator.of(context).pop(),
                context.push(Routes.publishDynamicPageUrl),
              },
            ),
            MyFlatButton(
              text: '发布短视频',
              img: 'imgs/fabu-shorts.png',
              textColor: muted,
              onPress: () => {
                Navigator.of(context).pop(),
                context.push(Routes.publishShortVideoPageUrl),
              },
            ),
            MyFlatButton(
              text: '发布视频',
              img: 'imgs/fabu-video.png',
              textColor: muted,
              onPress: () => {
                Navigator.of(context).pop(),
                context.push(Routes.publishVideoPageUrl),
              },
            ),
            MyFlatButton(
              text: '发布求助',
              img: 'imgs/send_friend.png',
              textColor: muted,
              onPress: () => {
                Navigator.of(context).pop(),
                context.push(Routes.publishHelpPageUrl),
              },
            ),
          ],
        ),
      ),
    );
  }
}

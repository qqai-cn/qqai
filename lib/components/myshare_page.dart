import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_action_colors.dart';

import 'mybutton.dart';

class MySharePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MySharePage();
  }
}

class _MySharePage extends State<MySharePage> {
  int _selected = -1;
  List<String> imgs = [];

  @override
  void initState() {
    super.initState();
    imgs.addAll([
      "imgs/user_default.png",
      "imgs/me.png",
      "imgs/user_default.png",
      "imgs/user_default.png",
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final muted = AppActionColors.muted(context);
    return TextButton.icon(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent)),
      onPressed: () => {
        showModalBottomSheet(
            constraints: BoxConstraints(maxHeight: 350.h),
            context: context,
            builder: (BuildContext build) {
              return Center(
                  child: SizedBox(
                width: 1.sw,
                height: 350.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyFlatButton(
                      text: '微信好友',
                      img: 'imgs/wechat.png',
                      textColor: muted,
                      onPress: () => {
                        setState(() {
                          _selected = _selected == 0 ? -1 : 0;
                        })
                      },
                    ),
                    MyFlatButton(
                      text: 'qq好友',
                      img: 'imgs/qq.png',
                      textColor: muted,
                      onPress: () => {
                        setState(() {
                          _selected = _selected == 1 ? -1 : 1;
                        })
                      },
                    ),
                    MyFlatButton(
                      text: '好友',
                      img: 'imgs/send_friend.png',
                      textColor: muted,
                      onPress: () => {
                        setState(() {
                          _selected = _selected == 2 ? -1 : 2;
                        })
                      },
                    ),
                    MyFlatButton(
                      text: '复制链接',
                      img: 'imgs/link.png',
                      textColor: muted,
                      onPress: () => {},
                    ),
                  ],
                ),
              ));
            })
      },
      icon: Icon(
        Icons.share,
        color: AppActionColors.foreground(context),
      ),
      label: Text(
        '分享',
      ),
    );
  }
}

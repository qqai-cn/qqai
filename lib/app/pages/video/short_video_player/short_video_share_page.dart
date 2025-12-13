import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/mybutton.dart';


class ShortVideoSharePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShortVideoSharePage();
  }
}

class _ShortVideoSharePage extends State<ShortVideoSharePage> {
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
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: InkWell(
          child: SvgPicture.asset(
              width: (180.w > 80 ? 80 : 180.w) / 2, 'imgs/forward.svg'),
          onTap: () {
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
                          textColor: Colors.black54,
                          onPress: () => {
                            setState(() {
                              _selected = _selected == 0 ? -1 : 0;
                            })
                          },
                        ),
                        MyFlatButton(
                          text: 'qq好友',
                          img: 'imgs/qq.png',
                          textColor: Colors.black54,
                          onPress: () => {
                            setState(() {
                              _selected = _selected == 1 ? -1 : 1;
                            })
                          },
                        ),
                        MyFlatButton(
                          text: '好友',
                          img: 'imgs/send_friend.png',
                          textColor: Colors.black54,
                          onPress: () => {
                            setState(() {
                              _selected = _selected == 2 ? -1 : 2;
                            })
                          },
                        ),
                        MyFlatButton(
                          text: '复制链接',
                          img: 'imgs/link.png',
                          textColor: Colors.black54,
                          onPress: () => {},
                        ),
                      ],
                    ),
                  ));
                });
          },
        ));
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qqai/constant/constant.dart';

import '../../../routes/app_pages.dart';

class SquareItemView extends StatelessWidget {
  double imgHover = 60;
  bool _care = false;
  String SPLIT_O = Constant.SPLIT_O;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.homeAppbarItemPageUrl);
      },
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                width: 1.sw,
                child: CachedNetworkImage(
                  imageUrl: 'https://file.qqai.cn/qqai/2025/09/square.webp',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  // 图片加载完成后淡入显示（提升体验）
                  fadeInDuration: Duration(milliseconds: 300),
                ),
              ),
            ),
            Container(
              height: 2,
            ),
            Container(
              height: 80,
              child: Row(
                children: <Widget>[
                  InkWell(
                    onHover: (a) {},
                    onTap: () => {},
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'imgs/img_default.png',
                          width: imgHover,
                          height: imgHover,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          '长风破浪长风破浪长风222,破浪长风破浪长风破浪长风破浪',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onHover: (a) {},
                              onTap: () => {},
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    // textScaleFactor: 1.5,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                ' ◉ 1212 次观看  ◉ 2天前',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                  // Spacer(),
                  Column(
                    children: [
                      Spacer(),
                      PopupMenuButton(
                        tooltip: "",
                        icon: Icon(
                          Icons.more_horiz,
                          color: Colors.black54,
                        ),
                        onSelected: (va) {
                          print(va);
                        },
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: '0',
                              child: Text(
                                '收藏',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: '1',
                              child: Text(
                                '举报',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: '2',
                              child: Text(
                                '不感兴趣',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: '3',
                              child: Text(
                                '加入播放队列',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int getCount(int count) {
    if (count <= 3) {
      return count;
    } else {
      return 3;
    }
  }

  double getRatio(int count) {
    if (count == 1) {
      return 5 / 3;
    } else if (count == 2) {
      return 1;
    } else if (count >= 3) {
      return 1;
    } else {
      return 1;
    }
  }
}

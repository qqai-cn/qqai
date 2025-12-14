import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../../components/level_icon.dart';
import '../../../../components/myshare_page.dart';
import '../../../../components/video_player_detail/myvideo_play.dart';
import '../../domain/blog_page_model.dart';

import '../../../../../constant/color_constant.dart';
import '../../../../../constant/constant.dart';

class BlogVideoItemView extends StatelessWidget {
  final BlogItem blogItem;
  final int categary;

  //头像
  final VoidCallback? onAvatarTap;

  //点击卡片
  final VoidCallback? onCardTap;

  //赞
  final VoidCallback? onZanTap;

  //关注
  final VoidCallback? onCareTap;

  final String split_o = Constant.SPLIT_O;

  BlogVideoItemView(
      {super.key,
      required this.blogItem,
      this.onAvatarTap,
      this.onCardTap,
      this.onZanTap,
      this.onCareTap,
      required this.categary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'imgs/img_default.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: AutoSizeText(
                          '${blogItem.creatorName}',
                          style: TextStyle(fontSize: 20),
                          minFontSize: 10,
                          maxLines: 1,
                        ),
                      ),
                      LevelIcon(lv: Random().nextInt(7)),
                    ],
                  ),
                  Text(
                    '关注 32 KW $split_o️ 活跃 333 KW',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  style: blogItem.care == 1
                      ? ElevatedButton.styleFrom(
                          minimumSize: const Size(20, 35),
                          padding: EdgeInsets.only(left: 10, right: 10),
                        )
                      : ElevatedButton.styleFrom(
                          minimumSize: const Size(20, 35),
                          padding: EdgeInsets.only(left: 13, right: 13),
                          backgroundColor: ColorConstant.ThemeGreen,
                        ),
                  child: blogItem.care == 1
                      ? Text(
                          "已关注",
                          style: const TextStyle(
                              fontSize: 13, color: ColorConstant.ThemeGreen),
                        )
                      : Text(
                          "关注",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white),
                        ),
                  onPressed: onCareTap,
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: SelectableText(
              blogItem.content!,
              maxLines: 1,
              style: TextStyle(fontSize: 20, overflow: TextOverflow.ellipsis),
            ),
          ),
          Container(
            height: 2,
            color: Colors.white,
          ),
          Expanded(
            flex: 9,
            child: AspectRatio(
              aspectRatio: 15 / 9,
              child: MyVideo(
                blogItem: blogItem,
                color: Colors.black,
                categary: categary,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              TextButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.transparent)),
                onPressed: onZanTap,
                icon: blogItem.zan == 1
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(Icons.favorite_border),
                label: Text(blogItem.zan == 1 ? '取消' : '喜欢'),
              ),
              TextButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.transparent)),
                onPressed: onCardTap,
                icon: Icon(Icons.comment),
                label: Text('评论'),
              ),
              MySharePage(),
              Spacer(),
              PopupMenuButton(
                tooltip: "",
                icon: Icon(
                  Icons.more_vert,
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
          ),
        ],
      ),
    );
  }
}

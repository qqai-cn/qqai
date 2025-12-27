import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/constant/constant.dart';

import '../../../../../constant/color_constant.dart';
import '../../../../components/level_icon.dart';
import '../../../../components/myshare_page.dart';
import '../../../../components/video_player_detail/myvideo_play.dart';
import '../../../../router/app_routes.dart';

//互助-视频
class HelpVideoItem extends StatefulWidget {
  HelpVideoItem({this.id = 0});

  final int id;

  @override
  State<StatefulWidget> createState() {
    return _HelpVideoItem();
  }
}

class _HelpVideoItem extends State<HelpVideoItem> {
  late String name;
  bool _care = false;
  bool _zan = false;
  String split_o = Constant.SPLIT_O;

  //网络请求,获取详情
  @override
  void initState() {
    super.initState();
    name = '视频作者';
  }

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
                          name,
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
                  style: _care
                      ? ElevatedButton.styleFrom(
                          minimumSize: const Size(20, 35),
                          padding: EdgeInsets.only(left: 10, right: 10),
                        )
                      : ElevatedButton.styleFrom(
                          minimumSize: const Size(20, 35),
                          padding: EdgeInsets.only(left: 13, right: 13),
                          backgroundColor: ColorConstant.ThemeGreen,
                        ),
                  child: _care
                      ? Text(
                          "已关注",
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        )
                      : Text(
                          "关注",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white),
                        ),
                  onPressed: () {
                    setState(() {
                      _care = !_care;
                    });
                  },
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: SelectableText(
              '一寸光阴一寸金，寸金难买寸光阴。',
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
              child: Container()
              // MyVideo(
              //   url:
              //       'https://cloud.video.taobao.com//play/u/153810888/p/2/e/6/t/1/395124651263.mp4',
              //   color: Colors.black,
              // ),
            ),
          ),
          Container(
              height: 50,
              // color: Colors.grey[300],
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 50, right: 50, top: 15),
                    child: Container(
                      height: 10,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.black26,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        value: 0.3,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '已助 120人 ｜ 目标 12000人',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              )),
          Row(
            children: <Widget>[
              TextButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent)),
                onPressed: () => {
                  setState(() {
                    _zan = !_zan;
                  })
                },
                icon: _zan
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(Icons.favorite_border),
                label: Text(_zan ? '取消' : '喜欢'),
              ),
              TextButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent)),
                onPressed: () => {context.push(Routes.watchVideo)},
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
                      child: Text('收藏'),
                    ),
                    PopupMenuItem<String>(
                      value: '1',
                      child: Text('举报'),
                    ),
                    PopupMenuItem<String>(
                      value: '2',
                      child: Text('不感兴趣'),
                    ),
                    PopupMenuItem<String>(
                      value: '3',
                      child: Text('加入播放队列'),
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

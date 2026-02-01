import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/features/blog/views/video_item_player/video_item_player.dart';

import '../../../../../constant/color_constant.dart';
import '../../../../../constant/constant.dart';
import '../../../../components/level_icon.dart';
import '../../../../components/myshare_page.dart';
import '../data/models/blog_page_model.dart';
import '../providers/blog_providers.dart';

class BlogVideoItemView extends ConsumerStatefulWidget {
  final BlogItem blogItem;
  final int category;

  BlogVideoItemView(this.category, this.blogItem);

  @override
  ConsumerState<BlogVideoItemView> createState() {
    return _BlogVideoItemViewState();
  }
}

class _BlogVideoItemViewState extends ConsumerState<BlogVideoItemView> {
  String text = '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。';
  final String split_o = Constant.SPLIT_O;

  @override
  Widget build(BuildContext context) {
    final blogState = ref.watch(blogProvider);
    final blogNotifier = ref.read(blogProvider.notifier);
    final isWideScreen = 1.sw > 900;
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
                          '${widget.blogItem.creatorName}',
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
                  style: widget.blogItem.care == 1
                      ? ElevatedButton.styleFrom(
                          minimumSize: const Size(20, 35),
                          padding: EdgeInsets.only(left: 10, right: 10),
                        )
                      : ElevatedButton.styleFrom(
                          minimumSize: const Size(20, 35),
                          padding: EdgeInsets.only(left: 13, right: 13),
                          backgroundColor: ColorConstant.ThemeGreen,
                        ),
                  onPressed: () {
                    blogNotifier.onCareTap(widget.blogItem);
                  },
                  child: widget.blogItem.care == 1
                      ? Text(
                          "已关注",
                          style: const TextStyle(
                            fontSize: 13,
                            color: ColorConstant.ThemeGreen,
                          ),
                        )
                      : Text(
                          "关注",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: SelectableText(
              widget.blogItem.content!,
              maxLines: 1,
              style: TextStyle(fontSize: 20, overflow: TextOverflow.ellipsis),
            ),
          ),
          Container(height: 2, color: Colors.white),
          Expanded(
            flex: 9,
            child: AspectRatio(
              aspectRatio: 15 / 9,
              child: VideoItemPlayer(
                url: widget.blogItem.resources!,
                imgUrl: 'https://file.qqai.cn/qqai/2025/09/1.webp',
              ),
            ),
          ),

          Row(
            children: <Widget>[
              TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  blogNotifier.onZanTap(widget.blogItem);
                },
                icon: widget.blogItem.zan == 1
                    ? Icon(Icons.favorite, color: Colors.red)
                    : Icon(Icons.favorite_border),
                label: Text(widget.blogItem.zan == 1 ? '取消' : '喜欢'),
              ),
              TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  if (isWideScreen) {
                    blogNotifier.onBlogItemTap(context, widget.blogItem);
                  } else {
                    showModalBottomSheet(
                      constraints: BoxConstraints(maxHeight: 0.6.sh),
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext build) {
                        return ListView(
                          children: [
                            getRow(1),
                            getRow(1),
                            getRow(1),
                            getRow(1),
                          ],
                        );
                      },
                    );
                  }
                },
                icon: Icon(Icons.comment),
                label: Text('评论'),
              ),
              MySharePage(),
              Spacer(),
              PopupMenuButton(
                tooltip: "",
                icon: Icon(Icons.more_vert, color: Colors.black54),
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

  Widget getRow(int i) {
    return ListTile(
      hoverColor: Colors.white,
      focusColor: Colors.white,
      titleAlignment: ListTileTitleAlignment.titleHeight,
      leading: Image.asset(
        'imgs/defbak.png',
        width: Constant.HEAD_IMG_SEZE.w,
        height: Constant.HEAD_IMG_SEZE.w,
        fit: BoxFit.fill,
      ),
      title: Container(
        // padding: EdgeInsets.only(top: 10),
        decoration: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(child: Text('新飞飞')),
                LevelIcon(lv: 5),
                Spacer(),
                Image.asset('imgs/zan.png', width: 50, height: 30),
                Text('212'),
                PopupMenuButton(
                  tooltip: "",
                  icon: Icon(Icons.more_vert, color: Colors.black54),
                  onSelected: (va) {
                    print(va);
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(value: '0', child: Text('收藏')),
                      PopupMenuItem<String>(value: '1', child: Text('举报')),
                    ];
                  },
                ),
              ],
            ),
            SelectableText(text),
            SizedBox(height: 5),
            Text(
              '2022-12-11 10：12',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}

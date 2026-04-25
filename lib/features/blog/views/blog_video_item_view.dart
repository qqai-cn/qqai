import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/blog/views/video_item_player/video_item_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
    final blogNotifier = ref.read(blogProvider.notifier);
    final isWideScreen = 1.sw > 900;
    final titleStyle = context.typo.cardTitle.copyWith(
      fontWeight: FontWeight.bold,
    );
    final metaStyle = context.typo.caption;
    final bodyStyle = context.typo.body;
    const String coverUrl = 'https://file.qqai.cn/qqai/2025/09/1.webp';
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
                          widget.blogItem.creatorName ?? '未知用户',
                          style: titleStyle,
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      LevelIcon(lv: Random().nextInt(7)),
                    ],
                  ),
                  Text(
                    '关注 32 KW $split_o️ 活跃 333 KW',
                    textAlign: TextAlign.left,
                    style: metaStyle,
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
                          style: context.typo.button.copyWith(
                            color: ColorConstant.ThemeGreen,
                          ),
                        )
                      : Text(
                          "关注",
                          style: context.typo.button,
                        ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              widget.blogItem.content!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: bodyStyle.copyWith(fontSize: (bodyStyle.fontSize ?? 16)),
            ),
          ),
          Container(height: 2, color: Colors.white),
          Expanded(
            flex: 9,
            child: AspectRatio(
              aspectRatio: 15 / 9,
              child: _LazyVideoPlaceholder(
                key: Key('blog_video_${widget.blogItem.id}'),
                url: widget.blogItem.resources!,
                imgUrl: coverUrl,
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
                        style: context.typo.body.copyWith(color: Colors.black54),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '1',
                      child: Text(
                        '举报',
                        style: context.typo.body.copyWith(color: Colors.black54),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '2',
                      child: Text(
                        '不感兴趣',
                        style: context.typo.body.copyWith(color: Colors.black54),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '3',
                      child: Text(
                        '加入播放队列',
                        style: context.typo.body.copyWith(color: Colors.black54),
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
            Text(text),
            SizedBox(height: 5),
            Text(
              '2022-12-11 10：12',
              style: context.typo.caption.copyWith(fontSize: 15),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}

/// 仅当可见时加载视频播放器，否则只显示封面，减轻列表滑动卡顿。
class _LazyVideoPlaceholder extends StatefulWidget {
  final String url;
  final String imgUrl;

  const _LazyVideoPlaceholder({
    super.key,
    required this.url,
    required this.imgUrl,
  });

  @override
  State<_LazyVideoPlaceholder> createState() => _LazyVideoPlaceholderState();
}

class _LazyVideoPlaceholderState extends State<_LazyVideoPlaceholder> {
  double _visibleFraction = 0;

  static const double _visibleThreshold = 0.25;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('lazy_video_${widget.url.hashCode}'),
      onVisibilityChanged: (info) {
        if (mounted && info.visibleFraction != _visibleFraction) {
          setState(() => _visibleFraction = info.visibleFraction);
        }
      },
      child: _visibleFraction >= _visibleThreshold
          ? VideoItemPlayer(url: widget.url, imgUrl: widget.imgUrl)
          : _VideoThumbnail(imgUrl: widget.imgUrl),
    );
  }
}

class _VideoThumbnail extends StatelessWidget {
  final String imgUrl;

  const _VideoThumbnail({required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: imgUrl,
          fit: BoxFit.cover,
        ),
        Icon(Icons.play_circle_fill, size: 56, color: Colors.white70),
      ],
    );
  }
}

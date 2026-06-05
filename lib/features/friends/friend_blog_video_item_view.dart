import 'package:flutter/material.dart';
import 'package:qqai/components/default_asset_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/blog/video_thumbnail.dart';
import 'package:qqai/components/video_player/video_aspect_ratio.dart';
import 'package:qqai/features/blog/views/video_item_player/video_item_player.dart';
import 'package:qqai/util/visibility_safe.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../constant/constant.dart';
import '../../../../components/level_icon.dart';
import '../../../../components/myshare_page.dart';
import '../../../../components/blog/network_image_carousel_pages.dart';
import '../blog/data/models/blog_page_model.dart';
import '../blog/data/home_blog_tab.dart';
import '../blog/providers/blog_providers.dart';
import 'package:qqai/config/theme/app_typography.dart';

class FriendBlogVideoItemView extends ConsumerStatefulWidget {
  final BlogItem blogItem;
  final int category;

  FriendBlogVideoItemView(this.category, this.blogItem);

  @override
  ConsumerState<FriendBlogVideoItemView> createState() {
    return _BlogVideoItemViewState();
  }
}

class _BlogVideoItemViewState extends ConsumerState<FriendBlogVideoItemView> {
  String text = '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。';
  final String split_o = Constant.SPLIT_O;

  @override
  Widget build(BuildContext context) {
    final blogNotifier = ref.read(blogProvider(HomeBlogTab.recommend).notifier);
    final isWideScreen = 1.sw > 900;
    final bodyStyle = context.typo.body;
    final coverUrl = resolveBlogCoverUrl(widget.blogItem);
    final videoUrl =
        firstPlayableVideoUrlFromResources(widget.blogItem.resources) ?? '';
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
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
            child: _LazyVideoPlaceholder(
              key: Key('blog_video_${widget.blogItem.id}'),
              url: videoUrl,
              imgUrl: coverUrl,
              videoId: widget.blogItem.id,
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
                        style: context.typo.body.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '1',
                      child: Text(
                        '举报',
                        style: context.typo.body.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '2',
                      child: Text(
                        '不感兴趣',
                        style: context.typo.body.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '3',
                      child: Text(
                        '加入播放队列',
                        style: context.typo.body.copyWith(
                          color: Colors.black54,
                        ),
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
      leading: DefaultAssetImage(
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

class _LazyVideoPlaceholder extends StatefulWidget {
  final String url;
  final String imgUrl;
  final int? videoId;

  const _LazyVideoPlaceholder({
    super.key,
    required this.url,
    required this.imgUrl,
    this.videoId,
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
        final visibleFraction = safeVisibleFraction(info);
        if (mounted && visibleFraction != _visibleFraction) {
          setState(() => _visibleFraction = visibleFraction);
        }
      },
      child: VideoAspectRatioBox(
        videoUrl: widget.url,
        builder: (context, aspectRatio) {
          return _visibleFraction >= _visibleThreshold
              ? VideoItemPlayer(
                  url: widget.url,
                  imgUrl: widget.imgUrl,
                  videoId: widget.videoId,
                  fallbackAspectRatio: aspectRatio,
                )
              : VideoThumbnail(imgUrl: widget.imgUrl, aspectRatio: aspectRatio);
        },
      ),
    );
  }
}

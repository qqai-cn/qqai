import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/help/data/models/help_page_model.dart';

import '../../../../../constant/color_constant.dart';
import '../../../../../constant/constant.dart';
import '../../../../components/level_icon.dart';
import '../../../../components/myshare_page.dart';
import '../data/models/share_page_model.dart';
import '../providers/share_providers.dart';

class ShareImgItemView extends ConsumerStatefulWidget {
  final ShareItem shareItem;
  final int category;

  ShareImgItemView(this.category, this.shareItem);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HelpImgItemViewState();
  }
}

class _HelpImgItemViewState extends ConsumerState<ShareImgItemView> {
  late List<String> _imageUrls;
  String text = '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。';

  @override
  void initState() {
    super.initState();
    _imageUrls =
        widget.shareItem.resources
            ?.split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    final shareNotifier = ref.read(shareProvider.notifier);
    final isWideScreen = 1.sw > 900;
    final titleStyle = context.typo.cardTitle.copyWith(
      fontWeight: FontWeight.bold,
    );
    final metaStyle = context.typo.caption;
    final bodyStyle = context.typo.body;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Image.asset(
                  'imgs/img_default.png',
                  width: Constant.HEAD_IMG_SEZE,
                  height: Constant.HEAD_IMG_SEZE,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: AutoSizeText(
                          widget.shareItem.creatorName ?? '未知用户',
                          style: titleStyle,
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      LevelIcon(lv: Random().nextInt(7)),
                    ],
                  ),
                  Container(height: 2, color: Colors.white),
                  Text(
                    '关注 32 KW ◉️ 活跃 333 KW',
                    textAlign: TextAlign.left,
                    style: metaStyle,
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  style: widget.shareItem.care == 1
                      ? ElevatedButton.styleFrom(
                          minimumSize: const Size(20, 35),
                          padding: EdgeInsets.only(left: 10, right: 10),
                        )
                      : ElevatedButton.styleFrom(
                          minimumSize: const Size(20, 35),
                          padding: EdgeInsets.only(left: 13, right: 13),
                          backgroundColor: ColorConstant.ThemeGreen,
                        ),
                  child: Text(
                    widget.shareItem.care == 1 ? '已关注' : '关注',
                    style: context.typo.button.copyWith(
                      color: widget.shareItem.care == 1
                          ? ColorConstant.ThemeGreen
                          : Colors.white,
                    ),
                  ),
                  onPressed: () {
                    shareNotifier.onCareTap(widget.shareItem);
                  },
                ),
              ),
            ],
          ),
          SelectableText(
            widget.shareItem.content!,
            scrollPhysics: NeverScrollableScrollPhysics(),
            maxLines: 3,
            minLines: 1,
            style: bodyStyle.copyWith(
              fontSize: (bodyStyle.fontSize ?? 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double parentWidth = constraints.maxWidth;
              final imageCount = _imageUrls.length;

              if (imageCount == 0) return const SizedBox.shrink();

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(imageCount, (i) {
                  final url = _imageUrls[i];
                  final heroTag =
                      'lookBlogImg-${widget.category}-${widget.shareItem.id}-$i';
                  return InkWell(
                    onTap: () {
                      shareNotifier.onBlogImgItemTap(
                        context,
                        widget.shareItem,
                        i,
                        heroTag,
                      );
                    },
                    child: Hero(
                      tag: heroTag,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          width: getImgGridHeight(imageCount, parentWidth),
                          height: getImgGridHeight(imageCount, parentWidth),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 40,
                          ),
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
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
                    '求助 20000元 ｜ 目标 2000000元',
                    style: context.typo.caption,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  shareNotifier.onZanTap(widget.shareItem);
                },
                icon: widget.shareItem.zan == 1
                    ? Icon(Icons.favorite, color: Colors.red)
                    : Icon(Icons.favorite_border),
                label: Text(widget.shareItem.zan == 1 ? '取消' : '喜欢'),
              ),
              TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  if (isWideScreen) {
                    // 宽屏：切换右侧面板
                    shareNotifier.onHelpItemTap(context, widget.shareItem);
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
                tooltip: '',
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
                  ];
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  double getImgGridHeight(int itemCount, double parentWidth) {
    if (itemCount == 1) {
      return 300;
    } else if (itemCount == 3 || itemCount == 5 || itemCount == 6) {
      return (parentWidth - 30) / 3;
    } else {
      return parentWidth / 3;
    }
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
              style: context.typo.caption.copyWith(fontSize: 15),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
      onTap: () {
        setState(() {});
      },
    );
  }
}

int getCount(int count) {
  if (count <= 3) {
    return count;
  } else {
    return 3;
  }
}

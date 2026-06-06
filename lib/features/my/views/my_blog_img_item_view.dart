import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/default_asset_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../constant/constant.dart';
import '../../../../components/level_icon.dart';
import '../../../../components/myshare_page.dart';
import '../../blog/data/blog_route_extra.dart';
import '../../blog/data/models/blog_page_model.dart';
import '../../blog/data/home_blog_tab.dart';
import '../../blog/providers/blog_providers.dart';
import 'package:qqai/components/blog/feed_video_more_menu.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';

class MyBlogImgItemView extends ConsumerStatefulWidget {
  final BlogItem blogItem;
  final int category;
  final String? heroScope;

  MyBlogImgItemView(this.category, this.blogItem, {this.heroScope});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MyBlogImgItemViewState();
  }
}

class _MyBlogImgItemViewState extends ConsumerState<MyBlogImgItemView> {
  late final List<String> _imageUrls;
  String text = '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。';

  @override
  void initState() {
    super.initState();
    _imageUrls =
        widget.blogItem.resources
            ?.split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    final blogNotifier = ref.read(blogProvider(HomeBlogTab.recommend).notifier);
    final isWideScreen = 1.sw > 900;
    final bodyStyle = context.typo.body;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SelectableText(
            widget.blogItem.content ?? '',
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
                  final heroTag = blogImageDetailHeroTag(
                    widget.category,
                    widget.blogItem,
                    index: i,
                    scope: widget.heroScope,
                  );
                  return InkWell(
                    onTap: () {
                      blogNotifier.onBlogImgItemTap(
                        context,
                        widget.blogItem,
                        i,
                        heroTag,
                        _imageUrls,
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
          Row(
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  ref
                      .read(blogProvider(HomeBlogTab.recommend).notifier)
                      .onZanTap(widget.blogItem);
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
                    // 宽屏：切换右侧面板
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
                tooltip: '',
                icon: Icon(
                  Icons.more_vert,
                  color: AppActionColors.foreground(context),
                ),
                onSelected: (va) {
                  print(va);
                },
                itemBuilder: (BuildContext context) =>
                    feedBlogMoreMenuEntries(context, collected: false),
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
      hoverColor: Theme.of(context).colorScheme.surface,
      focusColor: Theme.of(context).colorScheme.surface,
      titleAlignment: ListTileTitleAlignment.titleHeight,
      leading: DefaultAssetImage(
        width: Constant.HEAD_IMG_SEZE.w,
        height: Constant.HEAD_IMG_SEZE.w,
        fit: BoxFit.fill,
      ),
      title: Container(
        // padding: EdgeInsets.only(top: 10),
        decoration: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppActionColors.borderSubtle(context)),
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
                  icon: Icon(
                    Icons.more_vert,
                    color: AppActionColors.foreground(context),
                  ),
                  onSelected: (va) {
                    print(va);
                  },
                  itemBuilder: (BuildContext context) =>
                      feedBlogMoreMenuEntries(context, collected: false),
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

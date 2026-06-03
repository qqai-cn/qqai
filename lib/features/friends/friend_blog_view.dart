import 'package:flutter/material.dart';
import 'package:qqai/components/default_asset_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/my_fonts.dart';

import '../../../components/level_icon.dart';
import '../../../components/responsive_masonry_grid.dart';
import '../../../constant/constant.dart';
import '../blog/data/home_blog_tab.dart';
import '../blog/providers/blog_providers.dart';
import 'friend_blog_img_item_view.dart';
import 'friend_blog_video_item_view.dart';
import 'package:qqai/config/theme/app_typography.dart';

class FriendBlogView extends ConsumerStatefulWidget {
  final int tabIndex;
  final int currentIndex; // 当前选中的 Tab index

  const FriendBlogView({required this.tabIndex, required this.currentIndex});

  @override
  ConsumerState<FriendBlogView> createState() => _TabPageState();
}

class _TabPageState extends ConsumerState<FriendBlogView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final int category = 8;
  String text = '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。';
  final String split_o = Constant.SPLIT_O;

  @override
  Widget build(BuildContext context) {
    final blogState = ref.watch(blogProvider(HomeBlogTab.recommend));
    final blogNotifier = ref.read(blogProvider(HomeBlogTab.recommend).notifier);

    if (widget.tabIndex != widget.currentIndex) {
      return SizedBox.shrink();
    }
    final isWideScreen = 1.sw > 900;
    // 避免 NestedScrollView 吸顶头部遮挡列表顶部
    const double kPinnedHeaderHeight = kToolbarHeight; // AppBar + TabBar 约 102

    return blogState.blogPageData.when(
      data: (data) => Padding(
        padding: const EdgeInsets.only(top: kPinnedHeaderHeight),
        child: ResponsiveMasonryGrid(
          itemCount: data.list!.length,
          minColumnWidth: 400,
          itemBuilder: (context, index) {
            final blogItem = data.list![index];
            final isWide = 1.sw > 800;
            final itemHeight = blogNotifier.getVideoItemHeightWithWidth(
              isWide ? 2 : 1,
              1.sw,
            );
            return RepaintBoundary(
              child: blogItem.blogType == 1
                  ? Card(child: FriendBlogImgItemView(category, blogItem))
                  : Card(
                      child: SizedBox(
                        height: itemHeight,
                        child: FriendBlogVideoItemView(category, blogItem),
                      ),
                    ),
            );
          },
        ),
      ),
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '加载失败: $err',
              style: context.typo.body.copyWith(color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () =>
                  ref.read(blogProvider(HomeBlogTab.recommend).notifier).load(),
              child: Text(
                '重试',
                style: context.typo.button.copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  double getVideoItemHeightWithWidth(int colCount, double screenWidth) {
    double widthItem = screenWidth;
    if (colCount > 1) {
      widthItem = widthItem * 0.5;
    }
    return widthItem / (15 / 9) + 150;
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
      onTap: () {
        if (mounted) setState(() {});
      },
    );
  }
}

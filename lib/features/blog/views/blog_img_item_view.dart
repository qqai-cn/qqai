import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_typography.dart';

import 'package:qqai/components/blog/comment_preview_sheet.dart';
import 'package:qqai/components/blog/creator_header_row.dart';
import 'package:qqai/components/blog/feed_action_bar.dart';
import 'package:qqai/components/blog/hero_image_wrap_grid.dart';

import '../../../../../constant/constant.dart';
import '../data/models/blog_page_model.dart';
import '../providers/blog_providers.dart';

class BlogImgItemView extends ConsumerStatefulWidget {
  final BlogItem blogItem;
  final int category;

  BlogImgItemView(this.category, this.blogItem);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BlogImgItemViewState();
  }
}

class _BlogImgItemViewState extends ConsumerState<BlogImgItemView> {
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
    final blogNotifier = ref.read(blogProvider.notifier);
    final isWideScreen = 1.sw > 900;
    final bodyStyle = context.typo.body;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CreatorHeaderRow(
              creatorName: widget.blogItem.creatorName ?? '未知用户',
              care: widget.blogItem.care ?? 0,
              metaText: '关注 32 KW ◉️ 活跃 333 KW',
              avatarSize: Constant.HEAD_IMG_SEZE,
              onCareTap: () => blogNotifier.onCareTap(widget.blogItem),
            ),
            SelectableText(
              widget.blogItem.content!,
              scrollPhysics: NeverScrollableScrollPhysics(),
              maxLines: 3,
              minLines: 1,
              style: bodyStyle.copyWith(
                fontSize: (bodyStyle.fontSize ?? 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 10),
            HeroImageWrapGrid(
              imageUrls: _imageUrls,
              heroTagBuilder: (i) =>
                  'lookBlogImg-${widget.category}-${widget.blogItem.id}-$i',
              onImageTap: (i, heroTag) {
                blogNotifier.onBlogImgItemTap(
                  context,
                  widget.blogItem,
                  i,
                  heroTag,
                  _imageUrls,
                );
              },
            ),
            FeedActionBar(
              liked: widget.blogItem.zan == 1,
              onLike: () =>
                  ref.read(blogProvider.notifier).onZanTap(widget.blogItem),
              onComment: () {
                if (isWideScreen) {
                  blogNotifier.onBlogItemTap(context, widget.blogItem);
                } else {
                  showCommentPreviewSheet(context, text);
                }
              },
              menuBuilder: (context) {
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
      ),
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

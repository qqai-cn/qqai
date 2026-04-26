import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/blog/comment_preview_sheet.dart';
import 'package:qqai/components/blog/creator_header_row.dart';
import 'package:qqai/components/blog/feed_action_bar.dart';
import 'package:qqai/components/blog/visibility_video_slot.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../../../constant/constant.dart';
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
    final bodyStyle = context.typo.body;
    const String coverUrl = 'https://file.qqai.cn/qqai/2025/09/1.webp';
    return Card(
      child: SizedBox(
        height: blogNotifier.getVideoItemHeightWithWidth(
          1.sw <= 800 ? 1 : 2,
          1.sw,
        ),
        child: Padding(
          padding: EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CreatorHeaderRow(
                creatorName: widget.blogItem.creatorName ?? '未知用户',
                care: widget.blogItem.care ?? 0,
                metaText: '关注 32 KW $split_o️ 活跃 333 KW',
                onCareTap: () => blogNotifier.onCareTap(widget.blogItem),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  widget.blogItem.content!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: bodyStyle.copyWith(
                    fontSize: (bodyStyle.fontSize ?? 16),
                  ),
                ),
              ),
              Container(height: 2, color: Colors.white),
              Expanded(
                flex: 9,
                child: AspectRatio(
                  aspectRatio: 15 / 9,
                  child: VisibilityVideoSlot(
                    key: Key('blog_video_${widget.blogItem.id}'),
                    url: widget.blogItem.resources!,
                    imgUrl: coverUrl,
                  ),
                ),
              ),
              FeedActionBar(
                liked: widget.blogItem.zan == 1,
                onLike: () => blogNotifier.onZanTap(widget.blogItem),
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
        ),
      ),
    );
  }
}

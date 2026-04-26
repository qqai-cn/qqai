import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/blog/comment_preview_sheet.dart';
import 'package:qqai/components/blog/creator_header_row.dart';
import 'package:qqai/components/blog/feed_action_bar.dart';
import 'package:qqai/components/blog/hero_image_wrap_grid.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../../../constant/constant.dart';
import '../data/models/share_page_model.dart';
import '../providers/share_providers.dart';

class ShareImgItemView extends ConsumerStatefulWidget {
  final ShareItem shareItem;
  final int category;

  ShareImgItemView(this.category, this.shareItem);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ShareImgItemViewState();
  }
}

class _ShareImgItemViewState extends ConsumerState<ShareImgItemView> {
  late final List<String> _imageUrls;
  String text = '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。';

  @override
  void initState() {
    super.initState();
    _imageUrls = parseCommaSeparatedUrls(widget.shareItem.resources);
  }

  @override
  Widget build(BuildContext context) {
    final shareNotifier = ref.read(shareProvider.notifier);
    final isWideScreen = 1.sw > 900;
    final bodyStyle = context.typo.body;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CreatorHeaderRow(
            creatorName: widget.shareItem.creatorName ?? '未知用户',
            care: widget.shareItem.care ?? 0,
            metaText: '关注 32 KW ◉️ 活跃 333 KW',
            avatarSize: Constant.HEAD_IMG_SEZE,
            onCareTap: () => shareNotifier.onCareTap(widget.shareItem),
          ),
          SelectableText(
            widget.shareItem.content!,
            scrollPhysics: const NeverScrollableScrollPhysics(),
            maxLines: 3,
            minLines: 1,
            style: bodyStyle.copyWith(
              fontSize: (bodyStyle.fontSize ?? 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),
          HeroImageWrapGrid(
            imageUrls: _imageUrls,
            heroTagBuilder: (i) =>
                'shareBlogImg-${widget.category}-${widget.shareItem.id}-$i',
            onImageTap: (i, heroTag) {
              shareNotifier.onBlogImgItemTap(
                context,
                widget.shareItem,
                i,
                heroTag,
                _imageUrls,
              );
            },
          ),
          SizedBox(
            height: 50,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 15),
                  child: SizedBox(
                    height: 10,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.black26,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.green,
                      ),
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
          FeedActionBar(
            liked: widget.shareItem.zan == 1,
            onLike: () =>
                ref.read(shareProvider.notifier).onZanTap(widget.shareItem),
            onComment: () {
              if (isWideScreen) {
                shareNotifier.onShareItemTap(context, widget.shareItem);
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
    );
  }
}

int getCount(int count) {
  if (count <= 3) {
    return count;
  }
  return 3;
}

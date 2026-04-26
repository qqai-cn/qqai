import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/blog/comment_preview_sheet.dart';
import 'package:qqai/components/blog/creator_header_row.dart';
import 'package:qqai/components/blog/feed_action_bar.dart';
import 'package:qqai/components/blog/feed_video_more_menu.dart';
import 'package:qqai/components/video_player_detail/myvideo_play.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../../../constant/constant.dart';
import '../data/models/share_page_model.dart';
import '../providers/share_providers.dart';

class ShareVideoItemView extends ConsumerStatefulWidget {
  final ShareItem helpItem;
  final int category;

  ShareVideoItemView(this.category, this.helpItem);

  @override
  ConsumerState<ShareVideoItemView> createState() => _ShareVideoItemViewState();
}

class _ShareVideoItemViewState extends ConsumerState<ShareVideoItemView> {
  String text = '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。';
  final String split_o = Constant.SPLIT_O;

  @override
  Widget build(BuildContext context) {
    final shareNotifier = ref.read(shareProvider.notifier);
    final isWideScreen = 1.sw > 900;
    final bodyStyle = context.typo.body;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CreatorHeaderRow(
            creatorName: widget.helpItem.creatorName ?? '未知用户',
            care: widget.helpItem.care ?? 0,
            metaText: '关注 32 KW $split_o️ 活跃 333 KW',
            onCareTap: () => shareNotifier.onCareTap(widget.helpItem),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: SelectableText(
              widget.helpItem.content!,
              maxLines: 1,
              style: bodyStyle.copyWith(
                fontSize: (bodyStyle.fontSize ?? 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(height: 2, color: Colors.white),
          Expanded(
            flex: 9,
            child: AspectRatio(
              aspectRatio: 15 / 9,
              child: MyVideo(
                id: widget.helpItem.id!,
                url: widget.helpItem.resources!,
                color: Colors.black,
                categary: widget.category,
              ),
            ),
          ),
          FeedActionBar(
            liked: widget.helpItem.zan == 1,
            onLike: () => shareNotifier.onZanTap(widget.helpItem),
            onComment: () {
              if (isWideScreen) {
                shareNotifier.onShareItemTap(context, widget.helpItem);
              } else {
                showCommentPreviewSheet(context, text);
              }
            },
            menuBuilder: feedVideoMoreMenuEntries,
          ),
        ],
      ),
    );
  }
}

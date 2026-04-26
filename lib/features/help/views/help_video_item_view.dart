import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/blog/comment_preview_sheet.dart';
import 'package:qqai/components/blog/creator_header_row.dart';
import 'package:qqai/components/blog/feed_action_bar.dart';
import 'package:qqai/components/blog/feed_video_more_menu.dart';
import 'package:qqai/components/blog/visibility_video_slot.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/help/data/models/help_page_model.dart';
import 'package:qqai/features/help/providers/help_providers.dart';

import '../../../../../constant/constant.dart';

class HelpVideoItemView extends ConsumerStatefulWidget {
  final HelpItem helpItem;
  final int category;

  HelpVideoItemView(this.category, this.helpItem);

  @override
  ConsumerState<HelpVideoItemView> createState() => _HelpVideoItemViewState();
}

class _HelpVideoItemViewState extends ConsumerState<HelpVideoItemView> {
  String text = '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。';
  final String split_o = Constant.SPLIT_O;

  @override
  Widget build(BuildContext context) {
    final helpNotifier = ref.read(helpProvider.notifier);
    final isWideScreen = 1.sw > 900;
    final bodyStyle = context.typo.body;
    const String coverUrl = 'https://file.qqai.cn/qqai/2025/09/1.webp';
    return Card(
      child: SizedBox(
        height: helpNotifier.getVideoItemHeightWithWidth(
          1.sw <= 800 ? 1 : 2,
          1.sw,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CreatorHeaderRow(
                creatorName: widget.helpItem.creatorName ?? '未知用户',
                care: widget.helpItem.care ?? 0,
                metaText: '关注 32 KW $split_o️ 活跃 333 KW',
                onCareTap: () => helpNotifier.onCareTap(widget.helpItem),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  widget.helpItem.content!,
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
                    key: Key('help_video_${widget.helpItem.id}'),
                    url: widget.helpItem.resources!,
                    imgUrl: coverUrl,
                  ),
                ),
              ),
              FeedActionBar(
                liked: widget.helpItem.zan == 1,
                onLike: () => helpNotifier.onZanTap(widget.helpItem),
                onComment: () {
                  if (isWideScreen) {
                    helpNotifier.onHelpItemTap(context, widget.helpItem);
                  } else {
                    showCommentPreviewSheet(context, text);
                  }
                },
                menuBuilder: feedVideoMoreMenuEntries,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

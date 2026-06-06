import 'package:flutter/material.dart';
import 'package:qqai/components/myshare_page.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/blog/views/blog_share_button.dart';
import 'package:qqai/util/format_count.dart';

/// 点赞、评论、分享、更多菜单。
class FeedActionBar extends StatelessWidget {
  final bool liked;
  final int? likeCount;
  final int? commentCount;
  final int? shareCount;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback? onShare;
  final List<PopupMenuEntry<String>> Function(BuildContext context) menuBuilder;
  final Widget? shareButton;
  final Widget? afterShare;
  final void Function(String value)? onMenuSelected;

  const FeedActionBar({
    super.key,
    required this.liked,
    required this.onLike,
    required this.onComment,
    required this.menuBuilder,
    this.likeCount,
    this.commentCount,
    this.shareCount,
    this.onShare,
    this.shareButton,
    this.afterShare,
    this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    final actionColor = AppActionColors.foreground(context);
    return Row(
      children: <Widget>[
        TextButton.icon(
          onPressed: onLike,
          icon: liked
              ? const Icon(Icons.favorite, color: AppActionColors.liked)
              : Icon(Icons.favorite_border, color: actionColor),
          label: Text(_likeLabel()),
        ),
        TextButton.icon(
          onPressed: onComment,
          icon: Icon(Icons.comment, color: actionColor),
          label: Text(_commentLabel()),
        ),
        if (onShare != null)
          TextButton.icon(
            onPressed: () =>
                showBlogShareSheet(context, onShareChannelTap: onShare),
            icon: Icon(Icons.share, color: actionColor),
            label: Text(_shareLabel()),
          )
        else
          shareButton ?? MySharePage(),
        ?afterShare,
        const Spacer(),
        PopupMenuButton<String>(
          tooltip: '',
          icon: Icon(Icons.more_vert, color: actionColor),
          onSelected: onMenuSelected,
          itemBuilder: menuBuilder,
        ),
      ],
    );
  }

  String _likeLabel() {
    final n = likeCount;
    if (n != null && n > 0) {
      return formatCompactCount(n);
    }
    return liked ? '取消' : '喜欢';
  }

  String _commentLabel() => feedActionCountLabel(commentCount, '评论');

  String _shareLabel() => feedActionCountLabel(shareCount, '分享');
}

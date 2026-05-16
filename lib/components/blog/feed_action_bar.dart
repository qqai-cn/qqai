import 'package:flutter/material.dart';
import 'package:qqai/components/myshare_page.dart';
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
    this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        TextButton.icon(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
          ),
          onPressed: onLike,
          icon: liked
              ? const Icon(Icons.favorite, color: Colors.red)
              : const Icon(Icons.favorite_border),
          label: Text(_likeLabel()),
        ),
        TextButton.icon(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
          ),
          onPressed: onComment,
          icon: const Icon(Icons.comment),
          label: Text(_commentLabel()),
        ),
        if (onShare != null)
          TextButton.icon(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
            ),
            onPressed: () => showBlogShareSheet(
              context,
              onShareChannelTap: onShare,
            ),
            icon: const Icon(Icons.share),
            label: Text(_shareLabel()),
          )
        else
          shareButton ?? MySharePage(),
        const Spacer(),
        PopupMenuButton<String>(
          tooltip: '',
          icon: const Icon(Icons.more_vert, color: Colors.black54),
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

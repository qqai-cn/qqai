import 'package:flutter/material.dart';
import 'package:qqai/components/myshare_page.dart';

class BlogActionBar extends StatelessWidget {
  final bool liked;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final List<PopupMenuEntry<String>> Function(BuildContext context) menuBuilder;

  const BlogActionBar({
    super.key,
    required this.liked,
    required this.onLike,
    required this.onComment,
    required this.menuBuilder,
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
          label: Text(liked ? '取消' : '喜欢'),
        ),
        TextButton.icon(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
          ),
          onPressed: onComment,
          icon: const Icon(Icons.comment),
          label: const Text('评论'),
        ),
        MySharePage(),
        const Spacer(),
        PopupMenuButton<String>(
          tooltip: '',
          icon: const Icon(Icons.more_vert, color: Colors.black54),
          onSelected: (value) {},
          itemBuilder: menuBuilder,
        ),
      ],
    );
  }
}

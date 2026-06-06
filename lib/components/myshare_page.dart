import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/views/blog_share_button.dart';

class MySharePage extends StatelessWidget {
  final BlogItem? blog;
  final VoidCallback? onShareChannelTap;

  const MySharePage({
    super.key,
    this.blog,
    this.onShareChannelTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
      ),
      onPressed: () => showBlogShareSheet(
        context,
        blog: blog,
        onShareChannelTap: onShareChannelTap,
      ),
      icon: Icon(
        Icons.share,
        color: AppActionColors.foreground(context),
      ),
      label: const Text('分享'),
    );
  }
}

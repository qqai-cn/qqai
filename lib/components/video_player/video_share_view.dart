import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/blog/data/models/blog_page_model.dart';
import '../../features/blog/views/blog_share_button.dart';

class VideoShareView extends StatelessWidget {
  final BlogItem? blog;
  final VoidCallback? onShareChannelTap;

  const VideoShareView({
    super.key,
    this.blog,
    this.onShareChannelTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = (180.w > 80 ? 80 : 180.w) / 2;
    return BlogShareButton(
      blog: blog,
      onShareChannelTap: onShareChannelTap,
      iconWidth: w,
      iconColor: Colors.white,
    );
  }
}

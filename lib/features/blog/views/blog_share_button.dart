import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/mybutton.dart';
import '../data/models/blog_page_model.dart';

/// 分享入口：打开渠道面板，[onShareChannelTap] 在用户选择渠道后调用（用于上报分享次数）。
class BlogShareButton extends StatelessWidget {
  final BlogItem? blog;
  final VoidCallback? onShareChannelTap;
  final double? iconWidth;
  final Color? iconColor;
  final bool showCount;
  final String countLabel;
  final TextStyle? countStyle;

  const BlogShareButton({
    super.key,
    this.blog,
    this.onShareChannelTap,
    this.iconWidth,
    this.iconColor,
    this.showCount = false,
    this.countLabel = '0',
    this.countStyle,
  });

  @override
  Widget build(BuildContext context) {
    final w = iconWidth ?? ((180.w > 80 ? 80 : 180.w) / 2);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => showBlogShareSheet(
            context,
            onShareChannelTap: onShareChannelTap,
          ),
          child: SvgPicture.asset(
            'imgs/forward.svg',
            width: w,
            colorFilter: iconColor != null
                ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                : null,
          ),
        ),
        if (showCount)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              countLabel,
              style: countStyle,
            ),
          ),
      ],
    );
  }
}

/// 分享渠道底部弹层；选择渠道后触发 [onShareChannelTap]（用于上报分享次数）。
void showBlogShareSheet(
  BuildContext context, {
  VoidCallback? onShareChannelTap,
}) {
  showModalBottomSheet<void>(
    constraints: BoxConstraints(maxHeight: 350.h),
    context: context,
    builder: (ctx) {
      void onChannel() {
        Navigator.pop(ctx);
        onShareChannelTap?.call();
      }

      return Center(
        child: SizedBox(
          width: 1.sw,
          height: 350.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyFlatButton(
                text: '微信好友',
                img: 'imgs/wechat.png',
                textColor: Colors.black54,
                onPress: onChannel,
              ),
              MyFlatButton(
                text: 'qq好友',
                img: 'imgs/qq.png',
                textColor: Colors.black54,
                onPress: onChannel,
              ),
              MyFlatButton(
                text: '好友',
                img: 'imgs/send_friend.png',
                textColor: Colors.black54,
                onPress: onChannel,
              ),
              MyFlatButton(
                text: '复制链接',
                img: 'imgs/link.png',
                textColor: Colors.black54,
                onPress: onChannel,
              ),
            ],
          ),
        ),
      );
    },
  );
}

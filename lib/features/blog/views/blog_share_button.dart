import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/share/share_to_friend_sheet.dart';
import 'package:qqai/util/content_share_service.dart';

import '../../../components/mybutton.dart';
import '../data/models/blog_page_model.dart';

/// 分享入口：打开渠道面板，[onShareChannelTap] 在用户选择渠道后调用（用于上报分享次数）。
class BlogShareButton extends StatelessWidget {
  final BlogItem? blog;
  final VoidCallback? onShareChannelTap;
  final double? iconWidth;
  final Color? iconColor;
  final double? tapTargetSize;
  final bool showCount;
  final String countLabel;
  final TextStyle? countStyle;

  const BlogShareButton({
    super.key,
    this.blog,
    this.onShareChannelTap,
    this.iconWidth,
    this.iconColor,
    this.tapTargetSize,
    this.showCount = false,
    this.countLabel = '0',
    this.countStyle,
  });

  @override
  Widget build(BuildContext context) {
    final w = iconWidth ?? ((180.w > 80 ? 80 : 180.w) / 2);
    final target = tapTargetSize ?? w;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => showBlogShareSheet(
            context,
            blog: blog,
            onShareChannelTap: onShareChannelTap,
          ),
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: target,
            height: target,
            child: Center(
              child: SvgPicture.asset(
                'imgs/forward.svg',
                width: w,
                colorFilter: iconColor != null
                    ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                    : null,
              ),
            ),
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
  BlogItem? blog,
  VoidCallback? onShareChannelTap,
}) {
  showModalBottomSheet<void>(
    context: context,
    builder: (ctx) {
      final muted = AppActionColors.muted(ctx);
      final payload = blog == null ? null : buildBlogSharePayload(blog);

      Future<void> onChannel(Future<bool> Function() action) async {
        if (payload == null) {
          if (ctx.mounted) {
            ScaffoldMessenger.maybeOf(ctx)
              ?..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('无法分享：缺少内容信息'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }
          return;
        }
        Navigator.pop(ctx);
        final ok = await action();
        if (ok) {
          onShareChannelTap?.call();
        }
      }

      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MyFlatButton(
                text: '微信好友',
                img: 'imgs/wechat.png',
                textColor: muted,
                onPress: () => onChannel(
                  () => shareToWechatFriend(context, payload!),
                ),
              ),
              MyFlatButton(
                text: 'qq好友',
                img: 'imgs/qq.png',
                textColor: muted,
                onPress: () => onChannel(
                  () => shareToQqFriend(context, payload!),
                ),
              ),
              MyFlatButton(
                text: '好友',
                img: 'imgs/qqai_site_icon.png',
                circularImage: true,
                textColor: muted,
                onPress: () => onChannel(() async {
                  final container = ProviderScope.containerOf(context);
                  return showShareToFriendSheet(
                    context,
                    container,
                    payload!,
                  );
                }),
              ),
              MyFlatButton(
                text: '复制链接',
                img: 'imgs/link.png',
                textColor: muted,
                onPress: () => onChannel(
                  () => copyShareLink(context, payload!),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

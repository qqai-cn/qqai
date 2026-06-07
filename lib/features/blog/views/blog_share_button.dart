import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/share/share_to_friend_sheet.dart';
import 'package:qqai/providers/auth_providers.dart';
import 'package:qqai/util/content_share_service.dart';

import '../../../components/mybutton.dart';
import '../data/blog_list_patch.dart';
import '../data/models/blog_page_model.dart';
import '../data/repos/blog_repo.dart';

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
  final FutureOr<void> Function(BlogItem blog)? onBlogDeleted;

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
    this.onBlogDeleted,
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
            onBlogDeleted: onBlogDeleted,
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
            child: Text(countLabel, style: countStyle),
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
  FutureOr<void> Function(BlogItem blog)? onBlogDeleted,
}) {
  showModalBottomSheet<void>(
    context: context,
    builder: (ctx) {
      final muted = AppActionColors.muted(ctx);
      final payload = blog == null ? null : buildBlogSharePayload(blog);
      final container = ProviderScope.containerOf(context);
      final currentUserId = container.read(authProvider).userId;
      final showDelete = blog != null && isOwnBlogPost(blog, currentUserId);

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

      Future<void> onDelete() async {
        final target = blog;
        final id = target?.id;
        if (target == null || id == null) {
          _showShareSnackBar(context, '无法删除：缺少内容信息');
          return;
        }
        final confirmed =
            await showDialog<bool>(
              context: ctx,
              builder: (dialogContext) => AlertDialog(
                title: const Text('删除作品'),
                content: const Text('删除后不可恢复，合集中的集数会自动调整。确定删除吗？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: const Text('删除'),
                  ),
                ],
              ),
            ) ??
            false;
        if (!confirmed) return;
        if (ctx.mounted) {
          Navigator.pop(ctx);
        }
        try {
          await container.read(blogRepoProvider).deleteMyBlog(id);
          await onBlogDeleted?.call(target);
          if (context.mounted) {
            _showShareSnackBar(context, '已删除');
          }
        } catch (e) {
          if (context.mounted) {
            _showShareSnackBar(context, e.toString());
          }
        }
      }

      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyFlatButton(
                    text: '微信好友',
                    img: 'imgs/wechat.png',
                    textColor: muted,
                    onPress: () =>
                        onChannel(() => shareToWechatFriend(context, payload!)),
                  ),
                  MyFlatButton(
                    text: 'qq好友',
                    img: 'imgs/qq.png',
                    textColor: muted,
                    onPress: () =>
                        onChannel(() => shareToQqFriend(context, payload!)),
                  ),
                  MyFlatButton(
                    text: '好友',
                    img: 'imgs/qqai_site_icon.png',
                    circularImage: true,
                    textColor: muted,
                    onPress: () => onChannel(() async {
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
                    onPress: () =>
                        onChannel(() => copyShareLink(context, payload!)),
                  ),
                ],
              ),
              if (showDelete) ...[
                Divider(height: 20.h),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text('删除', style: TextStyle(color: Colors.red)),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

void _showShareSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
}

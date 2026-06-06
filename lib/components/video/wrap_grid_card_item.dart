import 'package:flutter/material.dart';
import 'package:qqai/components/blog/blog_follow_button.dart';
import 'package:qqai/components/blog/feed_video_more_menu.dart';
import 'package:qqai/components/default_asset_image.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 网格卡片底部信息行：头像 + 标题/作者/元信息 + 关注 + 更多。
class WrapGridCardItem extends StatelessWidget {
  const WrapGridCardItem({
    super.key,
    required this.title,
    required this.creatorName,
    required this.metaText,
    required this.followed,
    required this.onFollowTap,
    this.onCreatorTap,
    this.onAvatarTap,
    this.avatar,
    this.itemHeight = 92,
    this.avatarSize = 60,
    this.moreIcon = Icons.more_horiz,
    this.menuEntries,
    this.onMenuSelected,
  });

  final String title;
  final String creatorName;
  final String metaText;
  final bool followed;
  final VoidCallback onFollowTap;
  final VoidCallback? onCreatorTap;
  final VoidCallback? onAvatarTap;
  final Widget? avatar;
  final double itemHeight;
  final double avatarSize;
  final IconData moreIcon;
  final List<PopupMenuEntry<String>> Function(BuildContext context)?
  menuEntries;
  final void Function(String value)? onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final titleStyle = context.typo.cardTitle;
    final creatorStyle = context.typo.cardSubtitle.copyWith(
      color: Colors.grey,
      fontSize: titleStyle.fontSize,
    );
    final metaStyle = context.typo.caption;

    return SizedBox(
      height: itemHeight,
      child: Row(
        children: <Widget>[
          InkWell(
            onHover: (_) {},
            onTap: onAvatarTap ?? () {},
            child: Column(
              children: <Widget>[
                avatar ??
                    DefaultPlaceholderImage(
                      width: avatarSize,
                      height: avatarSize,
                    ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle,
                ),
                Row(
                  children: [
                    InkWell(
                      onHover: (_) {},
                      onTap: onCreatorTap ?? () {},
                      child: Row(
                        children: <Widget>[
                          Text(
                            creatorName,
                            textAlign: TextAlign.left,
                            style: creatorStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        metaText,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: metaStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: BlogFollowButton(
                  followed: followed,
                  onTap: onFollowTap,
                ),
              ),
              PopupMenuButton<String>(
                tooltip: '',
                icon: Icon(moreIcon, color: Colors.black54),
                onSelected: onMenuSelected,
                itemBuilder: menuEntries ?? feedVideoMoreMenuEntries,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

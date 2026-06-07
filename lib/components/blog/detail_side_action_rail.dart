import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qqai/components/blog/detail_avatar.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/views/blog_share_button.dart';

/// 详情页右侧竖向操作条：头像/关注、点赞、评论、收藏（五角星）、分享。
///
/// 尺寸对齐抖音视频详情页右侧操作栏。
class DetailSideActionRail extends StatelessWidget {
  static const double avatarSize = 48;
  static const double followButtonSize = 18;
  static const double actionIconSize = 34;
  static const double actionGroupSpacing = 18;
  static const double iconLabelGap = 2;
  static const double tapTargetSize = 44;

  final String? avatarUrl;
  final bool showFollowButton;
  final bool isFollowing;
  final VoidCallback? onAvatarTap;
  final Object? avatarHeroTag;
  final VoidCallback? onFollowTap;
  final VoidCallback? onLikeTap;
  final bool liked;
  final String likeCountLabel;
  final VoidCallback onCommentTap;
  final String commentCountLabel;
  final VoidCallback? onCollectTap;
  final bool collected;
  final String collectCountLabel;
  final String shareCountLabel;
  final VoidCallback? onShareTap;
  final FutureOr<void> Function(BlogItem blog)? onBlogDeleted;
  final BlogItem? shareBlog;
  final double bottomOffset;

  const DetailSideActionRail({
    super.key,
    this.bottomOffset = 0,
    this.avatarUrl,
    this.showFollowButton = true,
    this.isFollowing = false,
    this.onAvatarTap,
    this.avatarHeroTag,
    this.onFollowTap,
    this.onLikeTap,
    this.liked = false,
    this.likeCountLabel = '0',
    required this.onCommentTap,
    this.commentCountLabel = '0',
    this.onCollectTap,
    this.collected = false,
    this.collectCountLabel = '0',
    this.shareCountLabel = '0',
    this.onShareTap,
    this.onBlogDeleted,
    this.shareBlog,
  });

  Widget _buildActionItem({
    required VoidCallback onTap,
    required Widget icon,
    required String label,
    required TextStyle labelStyle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: tapTargetSize,
            height: tapTargetSize,
            child: Center(child: icon),
          ),
        ),
        SizedBox(height: iconLabelGap),
        Text(label, style: labelStyle),
      ],
    );
  }

  Widget _buildAvatarWithHero(BuildContext context) {
    final url = avatarUrl;
    var avatar = buildDetailAvatar(
      avatarUrl: url,
      size: avatarSize,
      context: context,
    );
    if (avatarHeroTag != null &&
        onAvatarTap != null &&
        url != null &&
        url.isNotEmpty) {
      avatar = Hero(tag: avatarHeroTag!, child: avatar);
    }
    return avatar;
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.typo.caption.copyWith(
      color: Colors.white,
      fontSize: 12,
      height: 1.1,
      fontWeight: FontWeight.w500,
    );
    return Positioned(
      right: 8,
      bottom: bottomOffset,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: avatarSize,
            height: avatarSize + 6,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: InkWell(
                      onTap: onAvatarTap,
                      customBorder: const CircleBorder(),
                      child: _buildAvatarWithHero(context),
                    ),
                  ),
                ),
                if (showFollowButton && !isFollowing)
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: followButtonSize,
                      height: followButtonSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFE2C55),
                      ),
                      child: InkWell(
                        onTap: onFollowTap ?? () {},
                        customBorder: const CircleBorder(),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: actionGroupSpacing),
          _buildActionItem(
            onTap: onLikeTap ?? () {},
            label: likeCountLabel,
            labelStyle: labelStyle,
            icon: Icon(
              Icons.favorite,
              size: actionIconSize,
              color: liked ? const Color(0xFFFE2C55) : Colors.white,
            ),
          ),
          SizedBox(height: actionGroupSpacing),
          _buildActionItem(
            onTap: onCommentTap,
            label: commentCountLabel,
            labelStyle: labelStyle,
            icon: const Icon(
              Icons.mode_comment,
              size: actionIconSize,
              color: Colors.white,
            ),
          ),
          SizedBox(height: actionGroupSpacing),
          _buildActionItem(
            onTap: onCollectTap ?? () {},
            label: collectCountLabel,
            labelStyle: labelStyle,
            icon: Icon(
              Icons.star,
              size: actionIconSize,
              color: collected ? Colors.amber : Colors.white,
            ),
          ),
          SizedBox(height: actionGroupSpacing),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlogShareButton(
                blog: shareBlog,
                onShareChannelTap: onShareTap,
                onBlogDeleted: onBlogDeleted,
                iconWidth: actionIconSize,
                iconColor: Colors.white,
                tapTargetSize: tapTargetSize,
              ),
              SizedBox(height: iconLabelGap),
              Text(shareCountLabel, style: labelStyle),
            ],
          ),
        ],
      ),
    );
  }
}

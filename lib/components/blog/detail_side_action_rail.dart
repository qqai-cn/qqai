import 'package:flutter/material.dart';
import 'package:qqai/components/blog/detail_avatar.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/views/blog_share_button.dart';

/// 详情页右侧竖向操作条：头像/关注、点赞、评论、收藏、分享。
class DetailSideActionRail extends StatelessWidget {
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
    this.shareBlog,
  });

  Widget _buildAvatarWithHero(BuildContext context) {
    final url = avatarUrl;
    var avatar = buildDetailAvatar(
      avatarUrl: url,
      size: 50,
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
    final caption = context.typo.caption.copyWith(color: Colors.white);
    return Positioned(
      right: 10,
      bottom: bottomOffset,
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 60,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: InkWell(
                        onTap: onAvatarTap,
                        child: _buildAvatarWithHero(context),
                      ),
                    ),
                  ),
                ),
                if (showFollowButton && !isFollowing)
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: 40,
                      child: Center(
                        child: Container(
                          width: 25,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: InkWell(
                            onTap: onFollowTap ?? () {},
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          IconButton(
            iconSize: 40,
            onPressed: onLikeTap ?? () {},
            icon: Icon(
              liked ? Icons.favorite : Icons.favorite_border,
              color: liked ? Colors.red : Colors.white,
            ),
          ),
          Text(likeCountLabel, style: caption),
          const SizedBox(height: 5),
          IconButton(
            iconSize: 40,
            onPressed: onCommentTap,
            color: Colors.white,
            icon: const Icon(Icons.comment),
          ),
          Text(commentCountLabel, style: caption),
          const SizedBox(height: 5),
          IconButton(
            iconSize: 40,
            onPressed: onCollectTap ?? () {},
            color: collected ? Colors.amber : Colors.white,
            icon: Icon(collected ? Icons.star : Icons.star_border),
          ),
          Text(collectCountLabel, style: caption),
          const SizedBox(height: 5),
          BlogShareButton(
            blog: shareBlog,
            onShareChannelTap: onShareTap,
            iconWidth: 40,
            iconColor: Colors.white,
          ),
          Text(shareCountLabel, style: caption),
        ],
      ),
    );
  }
}

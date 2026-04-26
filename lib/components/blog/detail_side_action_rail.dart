import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/video/views/video_share_view.dart';

/// 详情页右侧竖向操作条：头像/关注、点赞、评论、收藏、分享。
class DetailSideActionRail extends StatelessWidget {
  final VoidCallback? onAvatarTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onLikeTap;
  final bool liked;
  final String likeCountLabel;
  final VoidCallback onCommentTap;
  final String commentCountLabel;
  final VoidCallback? onCollectTap;
  final String collectCountLabel;
  final String shareCountLabel;

  const DetailSideActionRail({
    super.key,
    this.onAvatarTap,
    this.onFollowTap,
    this.onLikeTap,
    this.liked = true,
    this.likeCountLabel = '10kw',
    required this.onCommentTap,
    this.commentCountLabel = '110kw',
    this.onCollectTap,
    this.collectCountLabel = '20kw',
    this.shareCountLabel = '2kw',
  });

  @override
  Widget build(BuildContext context) {
    final caption = context.typo.caption.copyWith(color: Colors.white);
    return Positioned(
      right: 10,
      bottom: 50,
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
                        onTap: onAvatarTap ?? () {},
                        child: ClipOval(
                          child: Image.asset('imgs/defbak.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: 50,
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
          const SizedBox(height: 10),
          IconButton(
            iconSize: 50,
            onPressed: onLikeTap ?? () {},
            icon: Icon(
              liked ? Icons.favorite : Icons.favorite_border,
              color: liked ? Colors.red : Colors.white,
            ),
          ),
          Text(likeCountLabel, style: caption),
          const SizedBox(height: 10),
          IconButton(
            iconSize: 50,
            onPressed: onCommentTap,
            color: Colors.white,
            icon: const Icon(Icons.comment),
          ),
          Text(commentCountLabel, style: caption),
          const SizedBox(height: 10),
          IconButton(
            iconSize: 50,
            onPressed: onCollectTap ?? () {},
            color: Colors.white,
            icon: const Icon(Icons.star),
          ),
          Text(collectCountLabel, style: caption),
          const SizedBox(height: 10),
          VideoShareView(),
          Text(shareCountLabel, style: caption),
        ],
      ),
    );
  }
}

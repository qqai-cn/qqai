import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_routes.dart';
import '../../../util/conversation_list_time_format.dart';
import '../../../util/format_count.dart';
import '../../../util/media_url.dart';
import '../data/models/square_model.dart';
import '../providers/square_providers.dart';

Widget _squareOwnerAvatar(String? avatarUrl, double size) {
  const fallback = 'imgs/img_default.png';
  if (avatarUrl == null) {
    return Image.asset(fallback, width: size, height: size, fit: BoxFit.cover);
  }
  return CachedNetworkImage(
    imageUrl: avatarUrl,
    width: size,
    height: size,
    fit: BoxFit.cover,
    errorWidget: (_, _, _) =>
        Image.asset(fallback, width: size, height: size, fit: BoxFit.cover),
  );
}

/// 封面铺满给定矩形（裁剪居中，不留白边）。
class _SquareCover extends StatelessWidget {
  const _SquareCover({required this.imageUrl, this.cacheWidth});

  final String imageUrl;
  final int? cacheWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFFE0E0E0)),
        Image(
          image: CachedNetworkImageProvider(imageUrl, maxWidth: cacheWidth),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          gaplessPlayback: true,
          filterQuality: FilterQuality.medium,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) return child;
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (_, _, _) => ColoredBox(
            color: Colors.grey.shade300,
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SquareItemView extends ConsumerWidget {
  const SquareItemView({super.key, required this.square});

  final SquareItem square;

  static const double _imageHeightFraction = 0.68;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverUrl =
        resolveMediaUrl(square.squareImg) ??
        'https://file.qqai.cn/qqai/2025/09/square.webp';
    final avatarUrl = resolveMediaUrl(square.userAvatar);
    final title = (square.squareName?.trim().isNotEmpty ?? false)
        ? square.squareName!.trim()
        : '广场';
    final squareDesc = (square.squareDesc?.trim().isNotEmpty ?? false)
        ? square.squareDesc!.trim()
        : '描述';
    final heatText = '${formatCompactCount(square.blogCount?.toInt())} 作品';
    final timeText = formatConversationListTime(square.createTime);
    final squareId = square.id;
    final dpr = MediaQuery.devicePixelRatioOf(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFECEEF2)),
      ),
      child: InkWell(
        onTap: squareId == null
            ? null
            : () => context.push(Routes.squareBlogView, extra: squareId),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tileW = constraints.maxWidth;
            final tileH = constraints.maxHeight;
            final narrowTile = tileW < 260;
            final imageH = tileH.isFinite && tileH > 0
                ? tileH * _imageHeightFraction
                : tileW * 2; // 无高度约束时的兜底
            final textH = tileH.isFinite && tileH > 0 ? tileH - imageH : tileW;
            final cacheWidth = (tileW * dpr).round().clamp(96, 1200);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: imageH,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _SquareCover(imageUrl: coverUrl, cacheWidth: cacheWidth),
                      Positioned(
                        left: 12,
                        bottom: 12,
                        child: _SquareStatPill(text: heatText),
                      ),
                      if (timeText.isNotEmpty)
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: _SquareStatPill(
                            text: timeText,
                            icon: Icons.schedule,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: textH.clamp(0, double.infinity),
                  width: double.infinity,
                  child: _SquareCardInfo(
                    title: title,
                    desc: squareDesc,
                    followed: square.followedByMe == true,
                    avatarSize: (textH * 0.5).clamp(
                      34.0,
                      narrowTile ? 42.0 : 46.0,
                    ),
                    avatar: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: _squareOwnerAvatar(
                        avatarUrl,
                        (textH * 0.5).clamp(34.0, narrowTile ? 42.0 : 46.0),
                      ),
                    ),
                    onFollowTap: squareId == null
                        ? () {}
                        : () => ref
                              .read(squareProvider.notifier)
                              .toggleFollow(square),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SquareCardInfo extends StatelessWidget {
  const _SquareCardInfo({
    required this.title,
    required this.desc,
    required this.followed,
    required this.avatar,
    required this.avatarSize,
    required this.onFollowTap,
  });

  final String title;
  final String desc;
  final bool followed;
  final Widget avatar;
  final double avatarSize;
  final VoidCallback onFollowTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 300;
        final resolvedAvatarSize = compact ? 34.0 : avatarSize;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            compact ? 10 : 12,
            6,
            compact ? 10 : 12,
            6,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!compact) ...[
                SizedBox(
                  width: resolvedAvatarSize,
                  height: resolvedAvatarSize,
                  child: avatar,
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF202124),
                        fontSize: 15,
                        height: 1.12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                        height: 1.12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: Size(compact ? 48 : 64, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
                  backgroundColor: followed
                      ? const Color(0xFFF3F4F6)
                      : const Color(0xFF3578E5),
                  foregroundColor: followed
                      ? const Color(0xFF6B7280)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                onPressed: onFollowTap,
                child: Text(
                  compact && followed ? '已关' : (followed ? '已关注' : '关注'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SquareStatPill extends StatelessWidget {
  const _SquareStatPill({required this.text, this.icon = Icons.auto_awesome});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

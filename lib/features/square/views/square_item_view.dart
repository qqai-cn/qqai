import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../components/video/wrap_grid_card_item.dart';
import '../../../router/app_routes.dart';
import '../../../util/conversation_list_time_format.dart';
import '../../../util/format_count.dart';
import '../../../util/media_url.dart';
import '../data/models/square_model.dart';

Widget _squareOwnerAvatar(String? avatarUrl, double size) {
  const fallback = 'imgs/img_default.png';
  if (avatarUrl == null) {
    return Image.asset(
      fallback,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
  return CachedNetworkImage(
    imageUrl: avatarUrl,
    width: size,
    height: size,
    fit: BoxFit.cover,
    errorWidget: (_, _, _) => Image.asset(
      fallback,
      width: size,
      height: size,
      fit: BoxFit.cover,
    ),
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
          image: CachedNetworkImageProvider(
            imageUrl,
            maxWidth: cacheWidth,
          ),
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

class SquareItemView extends StatelessWidget {
  const SquareItemView({super.key, required this.square});

  final SquareItem square;

  static const double _imageHeightFraction = 2 / 3;

  @override
  Widget build(BuildContext context) {
    final coverUrl = resolveMediaUrl(square.squareImg) ??
        'https://file.qqai.cn/qqai/2025/09/square.webp';
    final avatarUrl = resolveMediaUrl(square.userAvatar);
    final title = (square.squareName?.trim().isNotEmpty ?? false)
        ? square.squareName!.trim()
        : '广场';
    final squareDesc = (square.squareDesc?.trim().isNotEmpty ?? false)
        ? square.squareDesc!.trim()
        : '描述';
    final heatText =
        '${formatCompactCount(square.blogCount?.toInt())} 作品';
    final timeText = formatConversationListTime(square.createTime);
    final squareId = square.id;
    final dpr = MediaQuery.devicePixelRatioOf(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
            final textH = tileH.isFinite && tileH > 0
                ? tileH - imageH
                : tileW;
            final cacheWidth = (tileW * dpr).round().clamp(96, 1200);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: imageH,
                  width: double.infinity,
                  child: _SquareCover(
                    imageUrl: coverUrl,
                    cacheWidth: cacheWidth,
                  ),
                ),
                SizedBox(
                  height: textH.clamp(0, double.infinity),
                  width: double.infinity,
                  child: WrapGridCardItem(
                    title: squareDesc,
                    creatorName: title,
                    metaText: timeText.isEmpty
                        ? ' ◉ $heatText'
                        : ' ◉ $heatText  ◉ $timeText',
                    followed: true,
                    onFollowTap: () {},
                    onMenuSelected: (value) => debugPrint(value),
                    itemHeight: textH,
                    avatarSize:
                        (textH * 0.72).clamp(32.0, narrowTile ? 48.0 : 60.0),
                    avatar: _squareOwnerAvatar(
                      avatarUrl,
                      (textH * 0.72).clamp(32.0, narrowTile ? 48.0 : 60.0),
                    ),
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

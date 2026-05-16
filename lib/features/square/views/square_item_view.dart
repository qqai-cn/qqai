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

class SquareItemView extends StatelessWidget {
  const SquareItemView({super.key, required this.square});

  final SquareItem square;

  @override
  Widget build(BuildContext context) {
    final coverUrl = resolveMediaUrl(square.squareImg) ??
        'https://file.qqai.cn/qqai/2025/09/square.webp';
    final avatarUrl = resolveMediaUrl(square.userAvatar);
    final title = (square.squareName?.trim().isNotEmpty ?? false)
        ? square.squareName!.trim()
        : '广场';
    final heatText =
        '${formatCompactCount(square.blogCount?.toInt())} 作品';
    final timeText = formatConversationListTime(square.createTime);
    final squareId = square.id;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: squareId == null
            ? null
            : () => context.push(Routes.squareBlogView, extra: squareId),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final narrowTile = constraints.maxWidth < 260;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: coverUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      alignment: Alignment.center,
                      placeholder: (_, _) => const ColoredBox(
                        color: Color(0xFFE0E0E0),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (_, _, _) => ColoredBox(
                        color: Colors.grey.shade300,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                WrapGridCardItem(
                  title: title,
                  creatorName: title,
                  metaText: timeText.isEmpty
                      ? ' ◉ $heatText'
                      : ' ◉ $heatText  ◉ $timeText',
                  followed: true,
                  onFollowTap: () {},
                  onMenuSelected: (value) => debugPrint(value),
                  itemHeight: narrowTile ? 80 : 92,
                  avatarSize: narrowTile ? 44 : 60,
                  avatar: _squareOwnerAvatar(
                    avatarUrl,
                    narrowTile ? 44 : 60,
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

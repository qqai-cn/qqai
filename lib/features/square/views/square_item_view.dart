import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../components/video/wrap_grid_card_item.dart';
import '../../../router/app_routes.dart';

class SquareItemView extends StatelessWidget {
  const SquareItemView({
    super.key,
    this.imageUrl = 'https://file.qqai.cn/qqai/2025/09/square.webp',
    this.avatarAsset = 'imgs/img_default.png',
    this.title = '长风破浪长风破浪长风222,破浪长风破浪长风破浪长风破浪',
    this.creatorName = '新飞飞',
    this.heatText = '1212 热度',
    this.timeText = '2天前',
  });

  final String imageUrl;
  final String avatarAsset;
  final String title;
  final String creatorName;
  final String heatText;
  final String timeText;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.push(Routes.squareBlogView);
        },
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
                      imageUrl: imageUrl,
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
                  creatorName: creatorName,
                  metaText: ' ◉ $heatText  ◉ $timeText',
                  followed: false,
                  onFollowTap: () {},
                  onMenuSelected: (value) => debugPrint(value),
                  itemHeight: narrowTile ? 80 : 92,
                  avatarSize: narrowTile ? 44 : 60,
                  avatar: Image.asset(
                    avatarAsset,
                    width: narrowTile ? 44 : 60,
                    height: narrowTile ? 44 : 60,
                    fit: BoxFit.cover,
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

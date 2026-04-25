import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/my_fonts.dart';

import '../../../router/app_routes.dart';
import 'package:qqai/config/theme/app_typography.dart';

class SquareItemView extends StatelessWidget {
  const SquareItemView({
    super.key,
    this.imageUrl = 'https://file.qqai.cn/qqai/2025/09/square.webp',
    this.avatarAsset = 'imgs/img_default.png',
    this.title = '长风破浪长风破浪长风222,破浪长风破浪长风破浪长风破浪',
    this.heatText = '1212 热度',
    this.timeText = '2天前',
  });

  final String imageUrl;
  final String avatarAsset;
  final String title;
  final String heatText;
  final String timeText;

  @override
  Widget build(BuildContext context) {
    const double avatarSize = 60;
    const SizedBox gapH2 = SizedBox(height: 2);
    const SizedBox gapH4 = SizedBox(height: 4);
    const SizedBox gapW8 = SizedBox(width: 8);
    final TextStyle titleStyle = context.typo.cardTitle;
    final TextStyle metaStyle = context.typo.caption;

    return InkWell(
      onTap: () {
        context.push(Routes.squareBlogView);
      },
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: CachedNetworkImage(
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl: imageUrl,
                placeholder:
                    (context, url) => const ColoredBox(
                      color: Color(0xFFF3F4F6),
                      child: Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => const ColoredBox(
                      color: Color(0xFFF3F4F6),
                      child: Center(child: Icon(Icons.broken_image_outlined)),
                    ),
                fadeInDuration: const Duration(milliseconds: 300),
              ),
            ),
            gapH2,
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    avatarAsset,
                    width: avatarSize,
                    height: avatarSize,
                  ),
                  gapW8,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle,
                          ),
                        ),
                        gapH4,
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '◉ $heatText  ◉ $timeText',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: metaStyle,
                              ),
                            ),
                            PopupMenuButton<String>(
                              tooltip: "",
                              icon: const Icon(
                                Icons.more_horiz,
                                color: Colors.black54,
                              ),
                              onSelected: (va) {
                                print(va);
                              },
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: '0',
                                    child: Text(
                                      '收藏',
                                      style: context.typo.body.copyWith(color: Colors.black54),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: '1',
                                    child: Text(
                                      '举报',
                                      style: context.typo.body.copyWith(color: Colors.black54),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: '2',
                                    child: Text(
                                      '不感兴趣',
                                      style: context.typo.body.copyWith(color: Colors.black54),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: '3',
                                    child: Text(
                                      '加入播放队列',
                                      style: context.typo.body.copyWith(color: Colors.black54),
                                    ),
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

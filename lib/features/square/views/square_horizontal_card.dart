import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';

import '../../../components/horizontal_deal_layout.dart';
import '../../../router/app_routes.dart';
import '../../../util/format_count.dart';
import '../../../util/media_url.dart';
import '../data/models/square_model.dart';

/// 广场条目横向推荐卡片（团购带货同款左图右文布局）。
class SquareHorizontalCard extends ConsumerWidget {
  const SquareHorizontalCard({
    super.key,
    required this.square,
    /// 列表场景可指定封面边长；网格场景留空以随单元格自适应。
    this.imageExtent,
  });

  final SquareItem square;
  final double? imageExtent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverUrl =
        resolveMediaUrl(square.squareImg) ??
        'https://file.qqai.cn/qqai/2025/09/square.webp';
    final title = (square.squareName?.trim().isNotEmpty ?? false)
        ? square.squareName!.trim()
        : '广场';
    final works = formatCompactCount(square.blogCount?.toInt());
    final heat = formatCompactCount(square.followCount?.toInt());
    final squareId = square.id;

    return HorizontalDealCard(
      tag: '$works 作品',
      title: title,
      priceText: '热度 $heat',
      imageExtent: imageExtent,
      style: HorizontalDealCardStyle.square(
        context: context,
        cardBg: AppActionColors.surface,
        sub: AppActionColors.subtle,
        border: GoodsPageStyle.border,
        strong: AppActionColors.strong,
      ),
      onTap: squareId == null
          ? null
          : () => context.push(Routes.squareBlogView, extra: squareId),
      image: CachedNetworkImage(
        imageUrl: coverUrl,
        cacheKey: mediaCacheKey(coverUrl),
        fit: BoxFit.cover,
        errorWidget: (_, _, _) => ColoredBox(
          color: GoodsPageStyle.imageBg(context),
          child: Icon(
            Icons.grid_view_rounded,
            color: AppActionColors.subtle(context),
          ),
        ),
      ),
    );
  }
}

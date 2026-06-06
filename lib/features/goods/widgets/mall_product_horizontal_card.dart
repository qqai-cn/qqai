import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';

import '../../../components/horizontal_deal_layout.dart';
import '../../../util/media_url.dart';
import '../data/models/mall_product_model.dart';

class MallProductHorizontalCard extends StatelessWidget {
  const MallProductHorizontalCard({
    super.key,
    required this.item,
    this.onTap,
    this.imageExtent,
  });

  final MallProduct item;
  final VoidCallback? onTap;
  final double? imageExtent;

  @override
  Widget build(BuildContext context) {
    final coverUrl = resolveMediaUrl(item.coverUrl);
    final name = item.name?.trim().isNotEmpty == true
        ? item.name!.trim()
        : '商品';
    final sales = item.salesCount ?? 0;

    return HorizontalDealCard(
      tag: sales > 0 ? '$sales 已售' : '精选',
      title: name,
      priceText: '¥${item.priceYuan.toStringAsFixed(2)}',
      imageExtent: imageExtent,
      style: HorizontalDealCardStyle.goods(
        context: context,
        cardBg: GoodsPageStyle.cardBg,
        sub: GoodsPageStyle.sub,
        border: GoodsPageStyle.border,
      ),
      onTap: onTap,
      image: coverUrl == null
          ? const _GoodsImageFallback()
          : CachedNetworkImage(
              imageUrl: coverUrl,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => const _GoodsImageFallback(),
            ),
    );
  }
}

class _GoodsImageFallback extends StatelessWidget {
  const _GoodsImageFallback();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: GoodsPageStyle.imageBg(context),
      child: Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          color: GoodsPageStyle.sub(context),
          size: 36,
        ),
      ),
    );
  }
}

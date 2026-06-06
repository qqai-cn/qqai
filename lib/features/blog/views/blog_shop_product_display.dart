import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/media_url.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models/blog_page_model.dart';

String formatBlogShopProductPrice(int? cents) {
  if (cents == null) return '';
  final yuan = cents / 100;
  if (cents % 100 == 0) return '¥${yuan.toStringAsFixed(0)}';
  return '¥${yuan.toStringAsFixed(2)}';
}

Future<void> openBlogShopProduct(
  BuildContext context,
  BlogItemShopProduct product,
) async {
  final id = product.id;
  if (id != null && id > 0) {
    context.push('${Routes.goodsDetailPageUrl}/$id');
    return;
  }
  final url = product.externalUrl?.trim();
  if (url != null && url.isNotEmpty) {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
  }
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('暂无商品详情')),
  );
}

void showBlogShopProductsSheet(
  BuildContext context, {
  required List<BlogItemShopProduct> products,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      final bottom = MediaQuery.paddingOf(ctx).bottom;
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('团购商品', style: context.typo.sectionTitle),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return BlogShopProductListTile(
                      product: product,
                      onTap: () {
                        Navigator.pop(ctx);
                        openBlogShopProduct(context, product);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// 详情页左下角横向商品条（视频/图文共用）。
class BlogShopProductStrip extends StatelessWidget {
  const BlogShopProductStrip({
    super.key,
    required this.products,
    this.maxHeight = 40,
  });

  final List<BlogItemShopProduct> products;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: maxHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final product = products[index];
          return BlogShopProductChip(
            product: product,
            onTap: () => openBlogShopProduct(context, product),
          );
        },
      ),
    );
  }
}

class BlogShopProductChip extends StatelessWidget {
  const BlogShopProductChip({
    super.key,
    required this.product,
    required this.onTap,
    this.maxLabelWidth = 140,
  });

  final BlogItemShopProduct product;
  final VoidCallback onTap;
  final double maxLabelWidth;

  @override
  Widget build(BuildContext context) {
    final name = product.name?.trim();
    final priceText = formatBlogShopProductPrice(product.price);
    return Material(
      color: Colors.white.withValues(alpha: 0.26),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxLabelWidth),
                child: Text(
                  name?.isNotEmpty == true ? name! : '商品',
                  style: context.typo.bodyStrong.copyWith(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (priceText.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(
                  priceText,
                  style: context.typo.bodyStrong.copyWith(
                    color: const Color(0xFFFFD633),
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class BlogShopProductListTile extends StatelessWidget {
  const BlogShopProductListTile({
    super.key,
    required this.product,
    required this.onTap,
  });

  final BlogItemShopProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final coverUrl = resolveMediaUrl(product.coverUrl);
    final priceText = formatBlogShopProductPrice(product.price);
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: coverUrl == null
                      ? ColoredBox(
                          color: Theme.of(context).colorScheme.surface,
                          child: const Icon(Icons.shopping_bag_outlined),
                        )
                      : Image.network(
                          coverUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => ColoredBox(
                            color: Theme.of(context).colorScheme.surface,
                            child: const Icon(Icons.shopping_bag_outlined),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name?.trim().isNotEmpty == true
                          ? product.name!.trim()
                          : '商品',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.typo.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (priceText.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        priceText,
                        style: context.typo.body.copyWith(
                          color: const Color(0xFFFE2C55),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

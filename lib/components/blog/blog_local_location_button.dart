import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/blog/data/blog_list_patch.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/util/amap_launcher.dart';

/// 首页「本地」Tab：媒体下方的距离 + 地址可点击按钮。
class BlogLocalLocationButton extends StatelessWidget {
  const BlogLocalLocationButton({super.key, required this.item});

  final BlogItem item;

  @override
  Widget build(BuildContext context) {
    final label = blogLocalLocationButtonText(item);
    if (label.isEmpty) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: const Color(0xFF6B7280),
        ),
        onPressed: () => _openLocation(context),
        icon: const Icon(Icons.location_on_outlined, size: 16),
        label: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.typo.caption.copyWith(color: const Color(0xFF6B7280)),
        ),
      ),
    );
  }

  Future<void> _openLocation(BuildContext context) async {
    final ok = await openAmapLocation(
      latitude: item.latitude,
      longitude: item.longitude,
      name: item.address,
      keyword: item.address,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法打开高德地图')),
      );
    }
  }
}

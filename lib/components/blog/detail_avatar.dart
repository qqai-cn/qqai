import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/default_asset_image.dart';
import 'package:qqai/util/media_url.dart';

/// 详情页头像（网络图 + 默认图），与列表 [CreatorHeaderRow] 一致解析 URL。
Widget buildDetailAvatar({
  required String? avatarUrl,
  double size = 50,
  BuildContext? context,
}) {
  final url = resolveMediaUrl(avatarUrl);
  if (url == null) {
    return buildDefaultUserAvatar(size);
  }

  final dpr = context != null ? MediaQuery.devicePixelRatioOf(context) : 2.0;
  final memPx = (size * dpr).round().clamp(48, 256);

  return ClipOval(
    child: CachedNetworkImage(
      key: ValueKey(url),
      imageUrl: url,
      cacheKey: url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      memCacheWidth: memPx,
      memCacheHeight: memPx,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (_, _) => buildDefaultUserAvatar(size),
      errorWidget: (_, _, _) => buildDefaultUserAvatar(size),
    ),
  );
}

/// 本地默认用户头像（圆形，与列表 item 一致）。
Widget buildDefaultUserAvatar(double size) {
  return ClipOval(
    child: DefaultAssetImage(width: size, height: size, fit: BoxFit.cover),
  );
}

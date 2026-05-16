import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qqai/util/media_url.dart';

/// 详情页头像（网络图 + 默认图），与列表 [CreatorHeaderRow] 一致解析 URL。
Widget buildDetailAvatar({
  required String? avatarUrl,
  double size = 50,
  BuildContext? context,
}) {
  final url = resolveMediaUrl(avatarUrl);
  if (url == null) {
    return _defaultAvatar(size);
  }

  final dpr = context != null
      ? MediaQuery.devicePixelRatioOf(context)
      : 2.0;
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
      placeholder: (_, _) => _defaultAvatar(size),
      errorWidget: (_, _, _) => _defaultAvatar(size),
    ),
  );
}

Widget _defaultAvatar(double size) {
  return Image.asset(
    'imgs/img_default.png',
    width: size,
    height: size,
    fit: BoxFit.cover,
  );
}

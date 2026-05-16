import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 详情侧栏头像（网络图 + 默认图）。
Widget buildDetailAvatar({required String? avatarUrl, double size = 50}) {
  return ClipOval(
    child: avatarUrl != null && avatarUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: avatarUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorWidget: (_, _, _) => _defaultAvatar(size),
          )
        : _defaultAvatar(size),
  );
}

Widget _defaultAvatar(double size) {
  return Image.asset(
    'imgs/defbak.png',
    width: size,
    height: size,
    fit: BoxFit.cover,
  );
}

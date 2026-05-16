import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/level_icon.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/constant/color_constant.dart';
import 'package:qqai/util/media_url.dart';

/// 头像、昵称、等级、关注按钮与一行 meta 文案。
class CreatorHeaderRow extends StatelessWidget {
  final String creatorName;
  final int care;
  final VoidCallback onCareTap;
  final String metaText;
  final double avatarSize;
  final String? avatarUrl;
  /// 作者等级，0 表示不展示等级图标。
  final int creatorLevel;
  /// 自己的作品等场景不展示关注按钮。
  final bool showCareButton;
  final VoidCallback? onAvatarTap;
  final Object? avatarHeroTag;

  const CreatorHeaderRow({
    super.key,
    required this.creatorName,
    required this.care,
    required this.onCareTap,
    required this.metaText,
    this.avatarSize = 40,
    this.avatarUrl,
    this.creatorLevel = 0,
    this.showCareButton = true,
    this.onAvatarTap,
    this.avatarHeroTag,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = context.typo.cardTitle.copyWith(
      fontWeight: FontWeight.bold,
    );
    final metaStyle = context.typo.caption;
    return Row(
      children: <Widget>[
        InkWell(
          onTap: onAvatarTap,
          child: _buildAvatar(context),
        ),
        SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: AutoSizeText(
                    creatorName,
                    style: titleStyle,
                    minFontSize: 10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                LevelIcon(lv: creatorLevel),
              ],
            ),
            Text(
              metaText,
              textAlign: TextAlign.left,
              style: metaStyle,
            ),
          ],
        ),
        const Spacer(),
        if (showCareButton)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: care == 1
                  ? ElevatedButton.styleFrom(
                      minimumSize: const Size(20, 35),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                    )
                  : ElevatedButton.styleFrom(
                      minimumSize: const Size(20, 35),
                      padding: const EdgeInsets.only(left: 13, right: 13),
                      backgroundColor: ColorConstant.ThemeGreen,
                    ),
              onPressed: onCareTap,
              child: care == 1
                  ? Text(
                      '已关注',
                      style: context.typo.button.copyWith(
                        color: ColorConstant.ThemeGreen,
                      ),
                    )
                  : Text('关注', style: context.typo.button),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final url = resolveMediaUrl(avatarUrl);
    Widget avatar;
    if (url != null) {
      final dpr = MediaQuery.devicePixelRatioOf(context);
      final memPx = (avatarSize * dpr).round().clamp(48, 256);
      avatar = ClipRRect(
        borderRadius: BorderRadius.circular(avatarSize / 2),
        child: CachedNetworkImage(
          key: ValueKey(url),
          imageUrl: url,
          cacheKey: url,
          width: avatarSize,
          height: avatarSize,
          fit: BoxFit.cover,
          memCacheWidth: memPx,
          memCacheHeight: memPx,
          fadeInDuration: const Duration(milliseconds: 150),
          placeholder: (_, _) => _defaultAvatar(),
          errorWidget: (_, _, _) => _defaultAvatar(),
        ),
      );
    } else {
      avatar = _defaultAvatar();
    }
    if (avatarHeroTag != null && onAvatarTap != null && url != null) {
      return Hero(tag: avatarHeroTag!, child: avatar);
    }
    return avatar;
  }

  Widget _defaultAvatar() {
    return Image.asset(
      'imgs/img_default.png',
      width: avatarSize,
      height: avatarSize,
    );
  }
}

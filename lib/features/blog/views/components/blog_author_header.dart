import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../../../constant/color_constant.dart';
import '../../../../components/level_icon.dart';

class BlogAuthorHeader extends StatelessWidget {
  final String creatorName;
  final int care;
  final VoidCallback onCareTap;
  final String metaText;
  final double avatarSize;

  const BlogAuthorHeader({
    super.key,
    required this.creatorName,
    required this.care,
    required this.onCareTap,
    required this.metaText,
    this.avatarSize = 60,
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
          onTap: () {},
          child: Image.asset(
            'imgs/img_default.png',
            width: avatarSize,
            height: avatarSize,
          ),
        ),
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
                LevelIcon(lv: Random().nextInt(7)),
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
}

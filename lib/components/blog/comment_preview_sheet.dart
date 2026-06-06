import 'package:flutter/material.dart';
import 'package:qqai/components/default_asset_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/level_icon.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/constant/constant.dart';

void showCommentPreviewSheet(BuildContext context, String text) {
  showModalBottomSheet(
    constraints: BoxConstraints(maxHeight: 0.6.sh),
    context: context,
    isScrollControlled: true,
    builder: (BuildContext build) {
      return ListView(
        children: [
          CommentPreviewRow(text: text),
          CommentPreviewRow(text: text),
          CommentPreviewRow(text: text),
          CommentPreviewRow(text: text),
        ],
      );
    },
  );
}

class CommentPreviewRow extends StatelessWidget {
  final String text;

  const CommentPreviewRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      hoverColor: Colors.white,
      focusColor: Colors.white,
      titleAlignment: ListTileTitleAlignment.titleHeight,
      leading: DefaultAssetImage(
        width: Constant.HEAD_IMG_SEZE.w,
        height: Constant.HEAD_IMG_SEZE.w,
        fit: BoxFit.fill,
      ),
      title: Container(
        decoration: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppActionColors.borderSubtle(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const InkWell(child: Text('新飞飞')),
                LevelIcon(lv: 5),
                const Spacer(),
                Image.asset('imgs/zan.png', width: 50, height: 30),
                const Text('212'),
                PopupMenuButton<String>(
                  tooltip: '',
                  icon: Icon(Icons.more_vert, color: AppActionColors.menuItemForeground(context)),
                  onSelected: (va) {},
                  itemBuilder: (BuildContext context) {
                    return const <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(value: '0', child: Text('收藏')),
                      PopupMenuItem<String>(value: '1', child: Text('举报')),
                    ];
                  },
                ),
              ],
            ),
            SelectableText(text),
            const SizedBox(height: 5),
            Text(
              '2022-12-11 10：12',
              style: context.typo.caption.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}

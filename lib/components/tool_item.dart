import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../features/data/models/tool_item_bean.dart';
import 'package:qqai/config/theme/app_typography.dart';


class ToolItem extends StatelessWidget {
  final ToolItemBean toolItemBean;

  const ToolItem(this.toolItemBean, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        surfaceTintColor: Colors.white,
        child: Column(
          mainAxisAlignment: .center,
          children: [
            ListTile(
              leading: SvgPicture.asset(
                toolItemBean.imageUrl,
                fit: BoxFit.cover,
                height: 60,
                width: 50,
              ),
              title: Text(toolItemBean.title,
                  style: context.typo.body.copyWith(fontWeight: FontWeight.bold)),
              subtitle: Text(toolItemBean.subTitle,
                  style: context.typo.sectionTitle.copyWith(color: Colors.green)),
            ),
            ListTile(
              title:
                  Text(style: context.typo.caption.copyWith(color: Colors.grey), toolItemBean.desc),
            ),
          ],
        ));
  }
}

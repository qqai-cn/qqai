import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/models/tool_item_bean.dart';


class ToolItem extends StatelessWidget {
  final ToolItemBean toolItemBean;

  const ToolItem(this.toolItemBean, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        surfaceTintColor: Colors.white,
        child: Column(
          children: [
            ListTile(
              leading: SvgPicture.asset(
                toolItemBean.imageUrl,
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
              title: Text(toolItemBean.title,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(toolItemBean.subTitle,
                  style: TextStyle(color: Colors.green)),
            ),
            ListTile(
              title:
                  Text(style: TextStyle(color: Colors.grey), toolItemBean.desc),
            ),
          ],
        ));
  }
}

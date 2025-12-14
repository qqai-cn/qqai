import 'package:flutter/material.dart';

import 'myvideo_img_item.dart';

//视频-长视频页面
class MyVideoLongItem extends StatelessWidget {
  final List<String> _items = [
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
      padding: EdgeInsets.all(0),
      child: GridView.builder(
          // controller: ScrollController(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 500.0,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              childAspectRatio: 3 / 2),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return MyVideoImgItem(
              id: index,
            );
          }),
    ));
  }
}

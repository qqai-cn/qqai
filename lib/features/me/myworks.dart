import 'package:flutter/material.dart';

import 'mywork_item2.dart';

//我的小组
class MyWorks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyWorks();
  }
}

class _MyWorks extends State<MyWorks> {
  final List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _items.addAll([
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Padding(
        padding: EdgeInsets.all(1),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 431.0,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio:3/2),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return MyVideoImgItemV2();
            }),
      ),
    );
  }
}

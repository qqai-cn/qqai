import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'help_img_item.dart';
import 'help_video_item.dart';

//互助页面
class HelpItemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HelpItemPage();
  }
}

class _HelpItemPage extends State<HelpItemPage> {
  final List<String> _items = [];
  int colCount = 2;
  bool ifHelpOrShare = false;

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
//    double width = MediaQuery.of(context).size.width;
//    int count = getColCount(width);

    setState(() {
      colCount = getColCount(MediaQuery.of(context).size.width);
    });
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          // ignore: missing_required_param
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              return false;
            },
            child: MasonryGridView.count(
              itemCount: _items.length,
              crossAxisCount: colCount,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              itemBuilder: (BuildContext context, int index) {
                if (index % 2 == 0) {
                  return Material(
                    child: Container(
                      height:
                          getImgItemHeight(index > 6 ? 6 : index, index * 100),
                      child: HelpImgItem(
                        id: index > 6 ? 6 : index,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  );
                } else {
                  return Material(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      height: getVideoItemHeight(),
                      child: HelpVideoItem(),
                    ),
                  );
                }
              },
            ),
          )),
    );
  }

  int getColCount(double len) {
    // print(len);
    if (len < 1000) {
      return 1;
      // } else if (len >= 1000 && len < 1450) {
      //   // } else if (len >= 1000 && len < 1430) {
      //   return 2;
      //   // } else if (len >= 1430 && len < 2300) {
      // } else if (len >= 1450 && len < 2000) {
      //   return 3;
      // } else {
    } else {
      return 2;
    }
  }

  //动态根据图片个数算item高度
  double getImgItemHeight(int itemCount, double length) {
    length = length == 0 ? 100 : length;
    double widthItem = 1.sw;
    double hsHeight = 50;
    if (colCount > 1) {
      widthItem = 0.5.sw;
    }
    length =
        '长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。'.length.toDouble();
    length = length * 22;
    double lineCount = (length / widthItem).ceilToDouble();
    double wordHeight = (lineCount > 3 ? 3 : lineCount) * 30 + 102;
    //没有图片的时候
    if (itemCount == 0) {
      return wordHeight + hsHeight;
    }
    //图片超过3个的时候，高度固定
    if (itemCount > 3) {
      return (2 / 3) * widthItem + wordHeight + hsHeight;
    }
    return widthItem / itemCount + wordHeight + hsHeight;
  }

  double getVideoItemHeight() {
    double widthItem = 1.sw;
    double hsHeight = 50;

    if (colCount > 1) {
      widthItem = 0.5.sw;
    }
    return widthItem / (15 / 9) + 150 + hsHeight;
  }

  int getImgItemCount() {
    return Random().nextInt(3) + 1;
  }
}

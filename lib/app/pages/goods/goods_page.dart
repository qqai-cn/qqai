import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../routes/app_pages.dart';

class GoodsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GoodsPage();
  }
}

class _GoodsPage extends State<GoodsPage> {
  List _waterFallList = [];
  final List<String> swigeUrls = [];
  final List<Widget> _pageViews = [];

  @override
  void initState() {
    super.initState();
    var randomNum = new Random();
    for (var i = 0; i < 40; i++) {
      _waterFallList.add(250 + 150 * randomNum.nextDouble());
    }
    swigeUrls.addAll([
      'imgs/defbak.png',
      'imgs/defbak1.png',
      'imgs/user_default.png',
    ]);
    for (var value in swigeUrls) {
      _pageViews.add(
        Container(
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    value,
                  ),
                ))),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var count = (1.sw / 250).ceil();
    return SingleChildScrollView(
      child: Container(
        color: Colors.red,
        padding: EdgeInsets.all(5),
        child: MasonryGridView.count(
          // 展示几列
          crossAxisCount: count > 3 ? 3 : count,
          // 元素总个数
          itemCount: _waterFallList.length,
          // 单个子元素
          itemBuilder: (BuildContext context, int index) => InkWell(
            child: waterCard(_waterFallList[index]),
            onTap: () {
              Get.toNamed(Routes.whatArticle);
            },
          ),
          // 纵向元素间距
          mainAxisSpacing: 5,
          // 横向元素间距
          crossAxisSpacing: 5,
          //本身不滚动，让外面的singlescrollview来滚动
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true, //收缩，让元素宽度自适应
        ),
      ),
    );
  }

  Widget waterCard(double item) {
    var randomNum = new Random();
    var one = randomNum.nextBool();
    return Container(
      height: item,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          // height: item * 2 / 3,
          child: _pageViews[0],
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 5),
          child: Text(
            '蓝月亮洗衣液',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.normal),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: 10.w, top: 5),
            child: RichText(
              text: TextSpan(
                  text: '¥',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                  ),
                  children: [
                    TextSpan(
                        text: '18.88',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text: ' 到手价 ',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.normal),
                              children: [
                                TextSpan(
                                    text: '¥38.8',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal)),
                              ])
                        ])
                  ]),
            )),
        one
            ? Padding(
                padding: EdgeInsets.only(left: 10.w, top: 5),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(2)),
                    child: Text(
                      '跨店每满300减40',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.red),
                    )),
              )
            : Padding(
                padding: EdgeInsets.only(left: 10.w, top: 5),
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFFFBC02D), width: 1),
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(
                          '包邮',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFFFBC02D)),
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFFFBC02D), width: 1),
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(
                          '30天保价',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFFFBC02D)),
                        )),
                  ],
                ),
              ),
        SizedBox(
          height: 5,
        ),
      ]),
    );
  }
}

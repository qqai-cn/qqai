import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/constant.dart';
import '../../routes/app_pages.dart';

class MyTeamsItem extends StatefulWidget {
  MyTeamsItem({this.id = 0});

  final int id;

  @override
  State<StatefulWidget> createState() {
    return _MyTeamsItem();
  }
}

class _MyTeamsItem extends State<MyTeamsItem> {
  late String name;
  late Color click;
  final List<String> _items = [];
  String split_o = Constant.SPLIT_O;
  final List<String> _pageViews = [];
  late int _curPageView = 0;
  late PageController _pageController;

  //网络请求,获取详情
  @override
  void initState() {
    super.initState();
    name = "丽泽天地";
    _items.addAll([
      '1',
      '1',
      '1',
      '1',
    ]);

    _pageViews.addAll([
      'imgs/defbak.png',
      'imgs/defbak1.png',
      'imgs/user_default.png',
    ]);
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'imgs/img_default.png',
          width: 60,
          height: 60,
        ),
        title: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      name,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Image.asset(
                      'imgs/img_default.png',
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),
                Container(
                  height: 2,
                  color: Colors.white,
                ),
                Text(
                  '关注 32 KW $split_o 评分 5.0分',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.input),
              iconSize: 20,
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: InkWell(
        onHover: (a) {},
        onTap: () {
          Get.toNamed(Routes.goodsPageUrl);
        },
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    // height: 0.2.sh,
                    child: _buildPageView(),
                  ),
                  _buildIndicator(),
                ],
              ),
            ),
            Container(
              height: 10.w,
            ),
            Expanded(
              flex: 1,
              child: Text(
                '主要卖一些10元商品：铅笔，橡皮，玩具车，玩家足球，玩偶等，品类多多',
                maxLines: 4,
                style: TextStyle(fontSize: 17, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView() {
    var length = _pageViews.length;
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _curPageView = index;
        });
      },
      itemCount: length,
      itemBuilder: (context, index) {
        return Image.asset(
          _pageViews[index],
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 10,
      child: Row(
        children: _pageViews.map((s) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: ClipOval(
              child: Container(
                width: 8,
                height: 8,
                color: _pageViews.indexOf(s) == _curPageView
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  int getCount(int count) {
    if (count <= 3) {
      return count;
    } else {
      return 3;
    }
  }
}

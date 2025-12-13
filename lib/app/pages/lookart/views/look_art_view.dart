import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qqai/app/pages/lookart/controllers/look_art_controller.dart';
import 'package:qqai/constant/color_constant.dart';

import '../../../components/comment_second_item.dart';
import '../../../components/level_icon.dart';
import 'look_art_right.dart';

class LookartView extends GetView<LookArtController> {
  @override
  Widget build(BuildContext context) {
    controller.resetWindow();
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            spacing: 3,
            children: [
              Semantics(
                label: '',
                excludeSemantics: true,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  tooltip: '',
                ),
              ),
              CircleAvatar(
                radius: 15, // 圆形半径
                backgroundImage: NetworkImage(
                  'https://file.qqai.cn/qqai/2025/09/avator.webp',
                ),
                // 可选：当图片未加载时显示的文字（如用户首字母）
                // child: Text('U'),
              ),
              Text('飞飞')
            ],
          ),
          actionsPadding: EdgeInsets.only(right: 10),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(20, 35),
                  padding: EdgeInsets.only(left: 10, right: 10),
                ),
                onPressed: () {},
                child: Text('已关注')),
            IconButton(onPressed: () {}, icon: buildForwardIcon())
          ],
          // leading:,
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(child: _getLeft()),
              if (controller.hiddenRight.value)
                SizedBox(
                  width: 20,
                ),
              if (controller.hiddenRight.value)
                Container(
                  width: 350,
                  height: double.infinity,
                  child: LookArtRight(),
                ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: controller.ifInputing.value
            ? SizedBox(
                width: controller.hiddenRight.value ? 1.sw - 400 : 1.sw - 30,
                height: 100,
                child: TextField(
                  maxLines: 100,
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: '评论',
                    suffixIcon: Column(
                      children: [
                        TextButton(
                            onPressed: () => {controller.setIfInputing(true)},
                            child: Text('发表')),
                        TextButton(
                            onPressed: () => {controller.setIfInputing(false)},
                            child: Text('取消')),
                      ],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFDCDFE6)),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF409EFF)),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  onChanged: (a) {},
                ),
              )
            : FloatingActionButton(
                backgroundColor: ColorConstant.ThemeGreen,
                onPressed: () => {controller.setIfInputing(true)},
                child: Text(
                  '评论',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      );
    });
  }

  Widget _getLeft() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if (index == 0)
                return SelectableText.rich(
                    style: TextStyle(fontSize: 15),
                    TextSpan(text: controller.text.value));
              return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'imgs/defbak.png',
                    fit: BoxFit.fill,
                  ));
            },
            childCount: 5,
          )),
          SliverAppBar(
            pinned: false,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                TextButton(
                  onPressed: () => {controller.changeSelectRange()},
                  child: Text('全部回复',
                      style: TextStyle(
                          color: controller.allComment.value
                              ? Colors.blue
                              : Colors.grey)),
                ),
                TextButton(
                  onPressed: () => {controller.changeSelectRange()},
                  child: Text('只看楼主',
                      style: TextStyle(
                          color: !controller.allComment.value
                              ? Colors.blue
                              : Colors.grey)),
                ),
                Spacer(),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: Text(
                      '排序',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: controller.items
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    value: controller.getSelectItemIndex(),
                    onChanged: (value) {
                      print(value);
                      // controller.setSelectItemIndex(value);
                    },
                  ),
                ),
              ],
            ),
            // scrolledUnderElevation: 50,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                height: 10,
                // child: Row(),
              ),
            ),
          ),
        ];
      },
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return getRow(index);
        },
        itemCount: 3,
      ),
    );
  }

  Widget getRow(int i) {
    return Container(
        color: Colors.white,
        child: ListTile(
          titleAlignment: ListTileTitleAlignment.titleHeight,
          contentPadding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1),
          leading: SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              radius: 20, // 圆形半径
              backgroundImage: NetworkImage(
                'https://file.qqai.cn/qqai/2025/09/avator.webp',
              ),
              // 可选：当图片未加载时显示的文字（如用户首字母）
              // child: Text('U'),
            ),
          ),
          title: Container(
            // padding: EdgeInsets.only(top: 10),
            decoration: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.black12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                        child: Text(
                      '新飞飞',
                      style: TextStyle(fontSize: 17),
                    )),
                    LevelIcon(
                      lv: 5,
                    ),
                    Spacer(),
                    Image.asset(
                      'imgs/zan.png',
                      width: 50,
                      height: 30,
                    ),
                    Text('212'),
                    PopupMenuButton(
                      tooltip: "",
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.black54,
                      ),
                      onSelected: (va) {
                        print(va);
                      },
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: '0',
                            child: Text(
                              '收藏',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: '1',
                            child: Text(
                              '举报',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
                SelectableText(controller.text.value),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '第$i楼  2022-12-11 10：12',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  // color: Constant.SELECT_COLOR,
                  // color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText.rich(TextSpan(children: [
                        TextSpan(
                            text: '新飞飞1',
                            style: TextStyle(color: Colors.grey, height: 1.8),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('新飞飞1');
                              }),
                        TextSpan(
                            text: '：' + controller.text.value,
                            style: TextStyle(height: 1.8))
                      ])),
                      SelectableText.rich(TextSpan(children: [
                        TextSpan(
                            text: '新飞飞1：',
                            style: TextStyle(color: Colors.grey, height: 1.8),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('新飞飞1');
                              }),
                        TextSpan(
                            text: '：' + controller.text.value,
                            style: TextStyle(height: 1.8))
                      ])),
                      SelectableText.rich(TextSpan(children: [
                        TextSpan(
                            text: '新飞飞1：',
                            style: TextStyle(color: Colors.grey, height: 1.8),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('新飞飞1');
                              }),
                        TextSpan(
                            text: '：' + controller.text.value,
                            style: TextStyle(height: 1.8))
                      ])),
                      SelectableText.rich(TextSpan(children: [
                        TextSpan(
                            text: '新飞飞1：',
                            style: TextStyle(color: Colors.grey, height: 1.8),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('新飞飞1');
                              }),
                        TextSpan(
                            text: '：' + controller.text.value,
                            style: TextStyle(height: 1.8))
                      ])),
                      CommengSecondItem(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // onTap: () {
          //   setState(() {});
          // },
        ));
  }

  Widget buildForwardIcon() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(pi),
      child: Icon(Icons.reply_outlined, color: Colors.green),
    );
  }
}

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';

import '../../../../constant/color_constant.dart';


class GoodsFilterPageV2 extends StatefulWidget {
  const GoodsFilterPageV2({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GoodsFilterPageV2();
  }
}

class _GoodsFilterPageV2 extends State<GoodsFilterPageV2> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  //左侧列表测试用例，后续使用可以自定义任何List
  final List _left = const [
    '排序',
    '服务/折扣',
    '价格',
    '风格',
    '颜色',
  ];

  final List sortList = [
    '综合',
    '信用',
    '销量',
    '价格从高到低',
    '价格从低到高',
  ];

  final List serviceList = [
    'skuu物流',
    '百亿补贴',
    '包邮',
    '同城速配',
    '分期免息',
    '以旧换新',
    '仅看有货',
  ];

  Map<int, List> sel = Map();

  //右侧GridView中的项目数量，后续使用可以使用项目中的list数量，这里仅作为测试
  final List ll = [1, 2, 3, 4, 5];

  List<SideMenuItem> items = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < sortList.length; i++) {
      sel[i] = [];
    }
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
        child: Padding(
            padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
            child: Column(
              children: [
                SizedBox(
                  child: Text(
                    '全部筛选',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 5,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: SideMenu(
                          // Page controller to manage a PageView
                          controller: sideMenu,
                          onDisplayModeChanged: (mode) {
                            print(mode);
                          },
                          // List of SideMenuItem to show them on SideMenu
                          items: [
                            for (int index = 0; index < _left.length; index++)
                              SideMenuItem(
                                title: _left[index],
                                onTap: (index, _) {
                                  sideMenu.changePage(index);
                                },
                                badgeContent: sel.containsKey(index) &&
                                        sel[index]!.isNotEmpty
                                    ? Text(
                                        sel[index]!.length.toString(),
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : null,
                                icon: Icon(
                                  Icons.filter_alt,
                                ),
                              ),
                          ],
                          collapseWidth: 100,
                          style: SideMenuStyle(selectedColor: Colors.black12),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: PageView(
                          controller: pageController,
                          children: [
                            Container(
                              color: Colors.black12,
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 10,
                                    ),
                                    Wrap(
                                      spacing: 8.0, // 主轴(水平)方向间距
                                      runSpacing: 4.0, // 纵轴（垂直）方向间距
                                      alignment: WrapAlignment.start, //沿主轴方向居中
                                      children: <Widget>[
                                        for (var value in sortList)
                                          ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      ColorConstant.lightBlue),
                                              onPressed: () {
                                                setState(() {
                                                  if (sel[0]!.contains(value)) {
                                                    sel[0]!.remove(value);
                                                  } else {
                                                    sel[0]!.add(value);
                                                  }
                                                });
                                              },
                                              icon: sel[0]!.contains(value)
                                                  ? Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                    )
                                                  : Icon(
                                                      Icons.add_circle,
                                                      color: Colors.blue,
                                                    ),
                                              label: Text(value))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.black12,
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 10,
                                    ),
                                    Wrap(
                                      spacing: 8.0, // 主轴(水平)方向间距
                                      runSpacing: 4.0, // 纵轴（垂直）方向间距
                                      alignment: WrapAlignment.start, //沿主轴方向居中
                                      children: <Widget>[
                                        for (var value in serviceList)
                                          ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      ColorConstant.lightBlue),
                                              onPressed: () {
                                                setState(() {
                                                  if (sel[1]!.contains(value)) {
                                                    sel[1]!.remove(value);
                                                  } else {
                                                    sel[1]!.add(value);
                                                  }
                                                });
                                              },
                                              icon: sel[1]!.contains(value)
                                                  ? Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                    )
                                                  : Icon(
                                                      Icons.add_circle,
                                                      color: Colors.blue,
                                                    ),
                                              label: Text(value))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.black12,
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            prefixText: '¥',
                                            labelText: '最低价',
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text('一'),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                        width: 100,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            prefixText: '¥',
                                            labelText: '最高价',
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Text('Settings'),
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Text('Settings'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                for (int i = 0; i < sortList.length; i++) {
                                  sel[i] = [];
                                }
                              });
                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                  '重置',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20))),
                              // color: Colors.red,
                            )),
                      ),
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          child: Center(
                            child: Text(
                              '完成',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          // color: Colors.red,
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

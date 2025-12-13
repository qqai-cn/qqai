import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../constant/color_constant.dart';
import '../../../data/models/huati_entity.dart';

class FilterPage extends StatefulWidget {
  Map<int, String> commonNamesSel = {};

  FilterPage(this.commonNamesSel, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _FilterPage();
  }
}

class _FilterPage extends State<FilterPage> {
  // List<String> commonNames = [];
  Map<int, String> commonNameMap = {};

  @override
  void initState() {
    loadHuatiData();
    print('$commonNameMap');
    super.initState();
  }

  void loadHuatiData() async {
    await rootBundle.loadString('mock/huati.json').then((value) {
      List list = json.decode(value);
      list.forEach((v) {
        HuatiEntity huatiEntity = HuatiEntity.fromJson(v);
        commonNameMap[huatiEntity.code] = huatiEntity.name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(
              child: Text(
                '标签筛选',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 10,
            ),
            Wrap(
              spacing: 8.0, // 主轴(水平)方向间距
              runSpacing: 4.0, // 纵轴（垂直）方向间距
              alignment: WrapAlignment.start, //沿主轴方向居中
              children: <Widget>[
                for (int value in commonNameMap.keys)
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.lightBlue),
                      onPressed: () {
                        setState(() {
                          if (widget.commonNamesSel.containsKey(value)) {
                            widget.commonNamesSel.remove(value);
                          } else {
                            widget.commonNamesSel.addAll({value:commonNameMap[value]!});
                          }
                        });
                      },
                      icon: widget.commonNamesSel.containsKey(value)
                          ? Icon(Icons.offline_pin)
                          : Icon(
                              Icons.add_circle,
                              color: Colors.green,
                            ),
                      label: Text(commonNameMap[value]!))
              ],
            ),
            Spacer(),
            Container(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            widget.commonNamesSel.clear();
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
                          Navigator.pop(context, widget.commonNamesSel);
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
        ),
      ),
    );
  }
}

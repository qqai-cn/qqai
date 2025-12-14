import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/constant/api_constant.dart';
import 'package:qqai/constant/color_constant.dart';

import '../data/models/idCard_bean_entity.dart';

class IdToolPage extends StatefulWidget {
  IdToolPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IdToolPage();
  }
}

class _IdToolPage extends State<IdToolPage> {
  final searchController = TextEditingController();
  late TextEditingController _controller;
  List<ListTile> list = [];
  String id = '';
  String address = '';
  String birthday = '';
  String shengxiao = '';
  String age = '';
  String ababdan = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("身份证号码"),
      ),
      body: Center(
        child: Container(
          width: 400,
          height: 0.5.sh,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                  ),
                  Expanded(
                      child: TextField(
                          controller: _controller,
                          style: TextStyle(fontSize: 20),
                          keyboardType: TextInputType.number,
                          maxLength: 18,
                          decoration: InputDecoration(
                            labelText: "请输入身份证号码",
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _controller.clear();
                              },
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ))),
                  Container(
                    width: 10,
                  ),
                  ElevatedButton(
                    child: Text(
                      "验证",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.ThemeGreen,
                        padding: EdgeInsets.only(left: 10, right: 10)),
                    onPressed: () async {
                      final dio = Dio();
                      var url = ApiConstant.API_ID;
                      var text = _controller.text;
                      if (text.isEmpty || text.length != 18) {
                        const snackBar = SnackBar(
                          content: Text('请输入正确的身份证号码!'),
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }
                      Response response =
                          await dio.post(url, data: {"id": text});
                      IdCardBeanEntity idBeanEntity =
                          IdCardBeanEntity.fromJson(response.data);
                      if (idBeanEntity.data == null) {
                        const snackBar = SnackBar(
                          content: Text('查询失败!'),
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }
                      IdCardBeanData? idBeanData = idBeanEntity.data;
                      var ageTmp = idBeanData?.age;
                      var sex = idBeanData?.sex == 1 ? '男' : '女';
                      bool? abandoned = idBeanData?.abandoned;
                      setState(() {
                        id = text;
                        address = idBeanData!.address!;
                        birthday = idBeanData.birthday!;
                        shengxiao = idBeanData.chineseZodiac!;
                        age = '$sex $ageTmp周岁';
                        ababdan = abandoned! ? '是' : '否';
                      });
                    },
                  ),
                ],
              ),
              Container(
                height: 20,
              ),
              Table(
                border: TableBorder.all(
                  color: Colors.green,
                ),
                // defaultColumnWidth:FlexColumnWidth(2),
                columnWidths: {
                  0: FlexColumnWidth(0.4),
                  // 1: FlexColumnWidth(270),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    TableCell(
                        child: Container(
                      color: Colors.black12,
                      child: Text(
                        '证件号码',
                        textAlign: TextAlign.center,
                      ),
                    )),
                    TableCell(
                        child: Text(
                      '$id',
                      textAlign: TextAlign.center,
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Container(
                            color: Colors.black12,
                            child: Text(
                              '正常使用',
                              textAlign: TextAlign.center,
                            ))),
                    TableCell(
                        child: Text(
                      '$ababdan',
                      textAlign: TextAlign.center,
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Container(
                            color: Colors.black12,
                            child: Text(
                              '发 证 地',
                              textAlign: TextAlign.center,
                            ))),
                    TableCell(
                        child: Text(
                      '$address',
                      textAlign: TextAlign.center,
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Container(
                            color: Colors.black12,
                            child: Text(
                              '出生日期',
                              textAlign: TextAlign.center,
                            ))),
                    TableCell(
                        child: Text(
                      '$birthday',
                      textAlign: TextAlign.center,
                    ))
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Container(
                            color: Colors.black12,
                            child: Text(
                              '生肖',
                              textAlign: TextAlign.center,
                            ))),
                    TableCell(
                        child: Text(
                      '$shengxiao',
                      textAlign: TextAlign.center,
                    ))
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Container(
                            color: Colors.black12,
                            child: Text(
                              '性别年龄',
                              textAlign: TextAlign.center,
                            ))),
                    TableCell(
                        child: Text(
                      '$age',
                      textAlign: TextAlign.center,
                    ))
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

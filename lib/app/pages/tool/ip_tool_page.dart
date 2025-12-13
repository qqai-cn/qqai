import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/app/data/models/ip_bean_entity.dart';
import 'package:qqai/constant/color_constant.dart';

class IpToolPage extends StatefulWidget {
  IpToolPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IpToolPage();
  }
}

class _IpToolPage extends State<IpToolPage> {
  final searchController = TextEditingController();
  late TextEditingController _controller;
  List<ListTile> list = [];
  String ip = '';
  String country = '';
  String region = '';
  String province = '';
  String city = '';
  String isp = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    initData();
  }

  initData() async {
    final dio = Dio();
    var url = 'https://qqai.cn/api/ip';
    var text = 'local';
    Response response = await dio.post(url, data: {"ip": text});
    IpBeanEntity ipBeanEntity = IpBeanEntity.fromJson(response.data);
    IpBeanData? ipBeanData = ipBeanEntity.data;
    setState(() {
      ip = ipBeanData!.ip!;
      country = ipBeanData.country!;
      region = ipBeanData.region ?? '';
      province = ipBeanData.province!;
      city = ipBeanData.city!;
      isp = ipBeanData.isp!;
      _controller.text = ip;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ip查询"),
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
                            labelText: "请输入ip",
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
                      "查询",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.ThemeGreen,
                        padding: EdgeInsets.only(left: 10, right: 10)),
                    onPressed: () async {
                      final dio = Dio();
                      var url = 'https://qqai.cn/api/ip';
                      var text = _controller.text;
                      if (text.isEmpty) {
                        const snackBar = SnackBar(
                          content: Text('请输入正确的ip!'),
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }
                      Response response =
                          await dio.post(url, data: {"ip": text});
                      IpBeanEntity ipBeanEntity =
                          IpBeanEntity.fromJson(response.data);
                      if (ipBeanEntity.data == null) {
                        const snackBar = SnackBar(
                          content: Text('查询失败!'),
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }
                      IpBeanData? ipBeanData = ipBeanEntity.data;
                      setState(() {
                        ip = text;
                        country = ipBeanData!.country!;
                        region = ipBeanData.region ?? '';
                        province = ipBeanData.province!;
                        city = ipBeanData.city!;
                        isp = ipBeanData.isp!;
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
                        'ip',
                        textAlign: TextAlign.center,
                      ),
                    )),
                    TableCell(
                        child: Text(
                      '$ip',
                      textAlign: TextAlign.center,
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Container(
                            color: Colors.black12,
                            child: Text(
                              '国家',
                              textAlign: TextAlign.center,
                            ))),
                    TableCell(
                        child: Text(
                      '$country',
                      textAlign: TextAlign.center,
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Container(
                            color: Colors.black12,
                            child: Text(
                              '大区',
                              textAlign: TextAlign.center,
                            ))),
                    TableCell(
                        child: Text(
                      '$region',
                      textAlign: TextAlign.center,
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Container(
                            color: Colors.black12,
                            child: Text(
                              '省份',
                              textAlign: TextAlign.center,
                            ))),
                    TableCell(
                        child: Text(
                      '$province',
                      textAlign: TextAlign.center,
                    ))
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Container(
                            color: Colors.black12,
                            child: Text(
                              '城市',
                              textAlign: TextAlign.center,
                            ))),
                    TableCell(
                        child: Text(
                      '$city',
                      textAlign: TextAlign.center,
                    ))
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Container(
                            color: Colors.black12,
                            child: Text(
                              '运营商',
                              textAlign: TextAlign.center,
                            ))),
                    TableCell(
                        child: Text(
                      '$isp',
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

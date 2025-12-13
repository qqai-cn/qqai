import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../constant/color_constant.dart';


class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _QrCodePage();
  }
}

class _QrCodePage extends State<QrCodePage> {
  final searchController = TextEditingController();
  String text ='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("二维码工具"),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 0.3.sh,
                child: TextField(
                  maxLines: 50,
                  controller: searchController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: '转换的内容粘贴在这里',
                    border: InputBorder.none,
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
              ),
              Container(
                height: 20,
              ),
              ElevatedButton(
                child: Text(
                  "生成二维码",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.ThemeGreen,
                    padding: EdgeInsets.only(left: 10, right: 10)),
                onPressed: () {
                  setState(() {
                    text =
                        searchController.value.text;
                  });
                },
              ),
              if(text != '')
              QrImageView(
                data: text,
                size: 320,
                gapless: false,
              )
            ],
          ),
        )
      )
    );

  }

}

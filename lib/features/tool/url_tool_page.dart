import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/constant/color_constant.dart';

class UrlToolPage extends StatefulWidget {
  UrlToolPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UrlToolPage();
  }
}

class _UrlToolPage extends State<UrlToolPage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("URL编码/解码"),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              height: 0.4.sh,
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
            Row(
              children: [
                Spacer(),
                ElevatedButton(
                  child: Text(
                    "UrlEncode编码",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.ThemeGreen,
                      padding: EdgeInsets.only(left: 10, right: 10)),
                  onPressed: () {
                    searchController.text =
                        Uri.encodeFull(searchController.value.text);
                  },
                ),
                Container(
                  width: 10,
                ),
                ElevatedButton(
                  child: Text(
                    "UrlDecode解码",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.ThemeGreen,
                      padding: EdgeInsets.only(left: 10, right: 10)),
                  onPressed: () {
                    setState(() {
                      searchController.text =
                          Uri.decodeFull(searchController.value.text);
                    });
                  },
                ),
                Container(
                  width: 10,
                ),
                ElevatedButton(
                  child: Text(
                    "清空内容",
                    style: TextStyle(
                      color: ColorConstant.ThemeGreen,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      searchController.clear();
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

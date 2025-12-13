import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../constant/color_constant.dart';
import '../../components/tool_item.dart';
import '../../data/models/tool_item_bean.dart';
import '../../routes/app_pages.dart';

class ToolPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ToolPage();
  }
}

class _ToolPage extends State<ToolPage> {
  List<ToolItemBean> showToolItemBeans = [];
  List<ToolItemBean> allToolItemBeans = [];

  int colCount = 2;
  double aspectRatio = 2;

  @override
  void initState() {
    super.initState();

    allToolItemBeans.add(ToolItemBean(
        imageUrl: "imgs/rili.svg",
        title: "日历",
        subTitle: "查询工具",
        desc: "时间日历，八字，时事新闻",
        indexLetter: "rili",
        clickUrl: Routes.calendarToolPageUrl));
    allToolItemBeans.add(ToolItemBean(
        imageUrl: "imgs/rili.svg",
        title: "天气",
        subTitle: "天气预报",
        desc: "天气预报",
        indexLetter: "tianqi",
        clickUrl: Routes.weatherPageUrl));

    allToolItemBeans.add(ToolItemBean(
        imageUrl: "imgs/ai.svg",
        title: "AI小助手",
        subTitle: "谷歌Gemini AI",
        desc: "文本回答",
        indexLetter: "ai",
        clickUrl: Routes.aiPageUrl));

    allToolItemBeans.add(ToolItemBean(
        imageUrl: "imgs/date.svg",
        title: "时间转换",
        subTitle: "文本工具",
        desc: "时间和时间戳的互相转换",
        indexLetter: "shijian",
        clickUrl: Routes.dateToolPageUrl));
    allToolItemBeans.add(ToolItemBean(
        imageUrl: "imgs/URL_args.svg",
        title: "URL编码/解码",
        subTitle: "文本工具",
        desc: "URL编码/解码互相转换",
        indexLetter: "url",
        clickUrl: Routes.urlToolPageUrl));
    allToolItemBeans.add(ToolItemBean(
        imageUrl: "imgs/ip.svg",
        title: "IP查询",
        subTitle: "查询工具",
        desc: "IP查询，定位",
        indexLetter: "ip",
        clickUrl: Routes.ipToolPageUrl));
    allToolItemBeans.add(ToolItemBean(
        imageUrl: "imgs/idcard.svg",
        title: "身份证查询",
        subTitle: "查询工具",
        desc: "身份证信息查询",
        indexLetter: "id",
        clickUrl: Routes.idToolPageUrl));
    allToolItemBeans.add(ToolItemBean(
        imageUrl: "imgs/erweima.svg",
        title: "二维码工具",
        subTitle: "文本工具",
        desc: "二维码工具",
        indexLetter: "erweima",
        clickUrl: Routes.qrCodePageUrl));
    allToolItemBeans.add(ToolItemBean(
        imageUrl: "imgs/jietu.svg",
        title: "视频工具",
        subTitle: "视频工具",
        desc: "视频截取图片",
        indexLetter: "video",
        clickUrl: Routes.thumbnailPageUrl));
    showToolItemBeans = allToolItemBeans;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      colCount = (1.sw / 300).truncate();
      aspectRatio = (1.sw / colCount / 50).toDouble();
    });

    return Scaffold(
        appBar: AppBar(
            backgroundColor: ColorConstant.lightBlue,
            title: Container(
                width: 0.8.sw,
                height: 40,
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.w),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "快速搜索",
                      prefixIcon: Icon(Icons.search)),
                  onChanged: (t) {
                    if (t.isNotEmpty) {
                      setState(() {
                        showToolItemBeans = filter(allToolItemBeans, t);
                      });
                    } else {
                      setState(() {
                        showToolItemBeans = allToolItemBeans;
                      });
                    }
                  },
                ))),
        backgroundColor: Colors.black12,
        // backgroundColor: ColorConstant.lightBlue,
        body: MasonryGridView.count(
          crossAxisCount: colCount,
          mainAxisSpacing: 1.w,
          crossAxisSpacing: 1.w,
          itemCount: showToolItemBeans.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: Container(
                height: 120,
                child: ToolItem(showToolItemBeans[index]),
              ),
              // onHover: (a) {},
              onTap: () {
                Get.toNamed(showToolItemBeans[index].clickUrl);
              },
            );
          },
        ));
  }

  int getColCount() {
    double len = MediaQuery.of(context).size.width;
    int count = (len / 300).truncate();
    return count;
  }

  List<ToolItemBean> filter(List<ToolItemBean> items, String name) {
    List<ToolItemBean> fil = [];
    for (var value in items) {
      if (value.indexLetter.contains(name)) {
        fil.add(value);
      }
    }
    return fil;
  }
}

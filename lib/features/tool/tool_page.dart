import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';

import '../../components/in_page_search_bar.dart';
import '../../components/tool_item.dart';
import '../../router/app_routes.dart';
import '../data/models/tool_item_bean.dart';

class ToolPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ToolPage();
  }
}

class _ToolPage extends State<ToolPage> {
  List<ToolItemBean> showToolItemBeans = [];
  List<ToolItemBean> allToolItemBeans = [];

  @override
  void initState() {
    super.initState();

    allToolItemBeans.add(
      ToolItemBean(
        imageUrl: "imgs/rili.svg",
        title: "日历",
        subTitle: "查询工具",
        desc: "时间日历，八字，时事新闻",
        indexLetter: "rili",
        clickUrl: Routes.calendarToolPageUrl,
      ),
    );
    allToolItemBeans.add(
      ToolItemBean(
        imageUrl: "imgs/rili.svg",
        title: "天气",
        subTitle: "天气预报",
        desc: "天气预报",
        indexLetter: "tianqi",
        clickUrl: Routes.weatherPageUrl,
      ),
    );

    allToolItemBeans.add(
      ToolItemBean(
        imageUrl: "imgs/ai.svg",
        title: "AI小助手",
        subTitle: "谷歌Gemini AI",
        desc: "文本回答",
        indexLetter: "ai",
        clickUrl: Routes.aiPageUrl,
      ),
    );

    allToolItemBeans.add(
      ToolItemBean(
        imageUrl: "imgs/date.svg",
        title: "时间转换",
        subTitle: "文本工具",
        desc: "时间和时间戳的互相转换",
        indexLetter: "shijian",
        clickUrl: Routes.dateToolPageUrl,
      ),
    );
    allToolItemBeans.add(
      ToolItemBean(
        imageUrl: "imgs/URL_args.svg",
        title: "URL编码/解码",
        subTitle: "文本工具",
        desc: "URL编码/解码互相转换",
        indexLetter: "url",
        clickUrl: Routes.urlToolPageUrl,
      ),
    );
    allToolItemBeans.add(
      ToolItemBean(
        imageUrl: "imgs/ip.svg",
        title: "IP查询",
        subTitle: "查询工具",
        desc: "IP查询，定位",
        indexLetter: "ip",
        clickUrl: Routes.ipToolPageUrl,
      ),
    );
    allToolItemBeans.add(
      ToolItemBean(
        imageUrl: "imgs/idcard.svg",
        title: "身份证查询",
        subTitle: "查询工具",
        desc: "身份证信息查询",
        indexLetter: "id",
        clickUrl: Routes.idToolPageUrl,
      ),
    );
    allToolItemBeans.add(
      ToolItemBean(
        imageUrl: "imgs/erweima.svg",
        title: "二维码工具",
        subTitle: "文本工具",
        desc: "二维码工具",
        indexLetter: "erweima",
        clickUrl: Routes.qrCodePageUrl,
      ),
    );
    allToolItemBeans.add(
      ToolItemBean(
        imageUrl: "imgs/img.svg",
        title: "图片格式转换",
        subTitle: "图片工具",
        desc: "图片格式转换",
        indexLetter: "imageformat",
        clickUrl: Routes.imageFormatConvertPageUrl,
      ),
    );
    allToolItemBeans.add(
      ToolItemBean(
        imageUrl: "imgs/img.svg",
        title: "图片压缩",
        subTitle: "图片工具",
        desc: "图片压缩介绍与下载",
        indexLetter: "imagecompress",
        clickUrl: Routes.imageCompressIntroPageUrl,
      ),
    );
    allToolItemBeans.add(
      ToolItemBean(
        imageUrl: "imgs/URL_args.svg",
        title: "JSON格式化",
        subTitle: "文本工具",
        desc: "JSON美化、压缩、复制",
        indexLetter: "json",
        clickUrl: Routes.jsonFormatterPageUrl,
      ),
    );
    allToolItemBeans.add(
      ToolItemBean(
        imageUrl: "imgs/jietu.svg",
        title: "视频工具",
        subTitle: "视频工具",
        desc: "视频截取图片",
        indexLetter: "video",
        clickUrl: Routes.thumbnailPageUrl,
      ),
    );
    showToolItemBeans = allToolItemBeans;
  }

  void _onSearchQuery(String query) {
    setState(() {
      showToolItemBeans = query.isEmpty
          ? allToolItemBeans
          : filter(allToolItemBeans, query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final topInset = InPageSearchBar.homeTabTopInset(context);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ColoredBox(
        color: GoodsPageStyle.pageBg(context),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final colCount = math.max(1, (constraints.maxWidth / 300).truncate());
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: InPageSearchBar(
                    height: topInset,
                    hintText: '快速搜索',
                    onQueryChanged: _onSearchQuery,
                  ),
                ),
                SliverMasonryGrid.count(
                  crossAxisCount: colCount,
                  mainAxisSpacing: 1.w,
                  crossAxisSpacing: 1.w,
                  childCount: showToolItemBeans.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.push(showToolItemBeans[index].clickUrl);
                      },
                      child: SizedBox(
                        height: 122,
                        child: ToolItem(showToolItemBeans[index]),
                      ),
                    );
                  },
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
              ],
            );
          },
        ),
      ),
    );
  }

  List<ToolItemBean> filter(List<ToolItemBean> items, String name) {
    final keyword = name.toLowerCase();
    return items
        .where((value) => value.indexLetter.toLowerCase().contains(keyword))
        .toList();
  }
}

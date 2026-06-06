import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lunar/calendar/Foto.dart';
import 'package:lunar/calendar/Holiday.dart';
import 'package:lunar/calendar/Lunar.dart';
import 'package:lunar/calendar/Solar.dart';
import 'package:lunar/calendar/Tao.dart';
import 'package:lunar/calendar/util/HolidayUtil.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/constant/api_constant.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarToolPage extends StatefulWidget {
  const CalendarToolPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CalendarToolPage();
  }
}

class _CalendarToolPage extends State<CalendarToolPage>
    with SingleTickerProviderStateMixin {
  // DateTime selectDate = DateTime.now();
  DateTime selectDate = DateTime.now();
  late TabController _tabController;
  late ScrollController _scrollviewController;
  final _tabs = <String>['今日热榜', '往日', '农历', '阳历', '佛历', '道历'];
  final _tabViews = [];
  List<dynamic> hot = [];

  @override
  void initState() {
    String data =
        "202312300120240101202312310120240101202401010120240101202402041020240210202402101120240210202402111120240210202402121120240210202402131120240210202402141120240210202402151120240210202402161120240210202402171120240210202402181020240210202404042120240404202404052120240404202404062120240404202404072020240404202404283020240501202405013120240501202405023120240501202405033120240501202405043120240501202405053120240501202405113020240501202406084120240610202406094120240610202406104120240610202409145020240917202409155120240917202409165120240917202409175120240917202409296020241001202410016120241001202410026120241001202410036120241001202410046120241001202410056120241001202410066120241001202410076120241001202410126020241001";
    HolidayUtil.fix(null, data);
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _scrollviewController = ScrollController(initialScrollOffset: 0.0);
    _tabViews.add(getHot());
    _tabViews.add(getHistory());
    _tabViews.add(getYinLi());
    _tabViews.add(getYangLi());
    _tabViews.add(getFoLi());
    _tabViews.add(getDaoLi());
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollviewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("万年历"),
        ),
        body: NestedScrollView(
          controller: _scrollviewController,
          headerSliverBuilder: (context, boxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                elevation: 0.5,
                expandedHeight: 355,
                automaticallyImplyLeading: false,
                backgroundColor: AppActionColors.surface(context),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Center(
                    child: SizedBox(
                      width: 500,
                      child: _buildCalendarView(),
                    ),
                  ),
                ),
                titleTextStyle: context.typo.sectionTitle.copyWith(
                  color: Colors.amber,
                ),
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                  labelColor: Colors.green,
                  unselectedLabelColor: AppActionColors.muted(context),
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: _tabs.map((String name) {
              return Builder(
                builder: (BuildContext context) {
                  return _tabViews[_tabController.index];
                },
              );
            }).toList(),
          ),
        ));
  }

  FutureBuilder getHistory() {
    DateTime? date = selectDate;
    var year = date.year;
    var month =
        date.month.truncate() > 9 ? date.month : '0' + date.month.toString();
    var day = date.day > 9 ? date.day : '0' + date.day.toString();
    var url = ApiConstant.DAY_HISTORY_NEWS_URL + '?day=$year$month$day';
    final dio = Dio();
    return FutureBuilder(
      future: dio.get(url),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Response response = snapshot.data;
          //发生错误
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          Map<String, dynamic> json = response.data;
          if (json["data"] == null) {
            return Text('无数据');
          }
          Map<String, dynamic> data = json["data"];
          List<dynamic> items = data["items"];
          List<ListTile> list = [];
          for (var value in items) {
            var title = value["title"];
            var url = value["date"];
            list.add(ListTile(
              // leading: Image.network(
              //   logo,
              //   height: 50,
              //   width: 50,
              // ),
              leading: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
                onPressed: () {
                  launchUrl(Uri.parse(url));
                },
                child: Text(url),
              ),
              title: Text(title),
            ));
          }
          return ListView.separated(
            itemCount: list.length,
            // itemCount: 100,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  list[index],
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 1.0, color: AppActionColors.borderSubtle(context)),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  FutureBuilder getHot() {
    DateTime date = selectDate;
    var year = date.year;
    var month =
        date.month.truncate() > 9 ? date.month : '0' + date.month.toString();
    var day = date.day > 9 ? date.day : '0' + date.day.toString();
    var url = ApiConstant.DAYHOT_NEWS_URL + '?date=$year$month$day';
    final dio = Dio();
    return FutureBuilder(
      future: dio.get(url),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Response response = snapshot.data;
          //发生错误
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          Map<String, dynamic> json = response.data;
          if (json["data"] == null) {
            return Text('无数据');
          }
          Map<String, dynamic> data = json["data"];
          List<dynamic> items = data["items"];
          List<ListTile> list = [];
          for (var value in items) {
            var title = value["title"];
            var url = value["url"];
            var logo = value["logo"];
            list.add(ListTile(
              // leading: Image.network(
              //   logo,
              //   height: 50,
              //   width: 50,
              // ),
              leading: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
                onPressed: () {
                  launchUrl(Uri.parse(url));
                },
                child: Text('详情'),
              ),
              title: Text(title),
            ));
          }
          return ListView.separated(
            itemCount: list.length,
            // itemCount: 100,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  list[index],
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 1.0, color: AppActionColors.borderSubtle(context)),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget getDaoLi({int count = 5, String name = ""}) {
    DateTime? date = selectDate;
    var d = Tao.fromLunar(Lunar.fromDate(date));
    List<ListTile> list = [];
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('总览:'),
      ),
      title: Text(d.toFullString()),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('道历:'),
      ),
      title: Text(d.getYearInChinese().toString() +
          '年 ' +
          d.getMonthInChinese().toString() +
          '月 ' +
          d.getDayInChinese().toString() +
          '日'),
    ));

    var l = d.getFestivals();
    String festivalStr = '';
    for (var i = 0, j = l.length; i < j; i++) {
      festivalStr += l[i].toString() + ',';
    }
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('节日:'),
      ),
      title: Text(festivalStr),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('三会日:'),
      ),
      title: Text(d.isDaySanHui() ? '是' : '否'),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('三元日:'),
      ),
      title: Text(d.isDaySanYuan() ? '是' : '否'),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('八节日:'),
      ),
      title: Text(d.isDayBaJie() ? '是' : '否'),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('五腊日:'),
      ),
      title: Text(d.isDayWuLa() ? '是' : '否'),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('八会日:'),
      ),
      title: Text(d.isDayBaHui() ? '是' : '否'),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('天赦日:'),
      ),
      title: Text(d.isDayTianShe() ? '是' : '否'),
    ));
    var wu = d.isDayWu() ? '是' : '否';
    var mingwu = d.isDayMingWu() ? '是' : '否';
    var anwu = d.isDayAnWu() ? '是' : '否';
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('戊日（禁忌日）:'),
      ),
      title: Text('戊日：$wu ，明：$mingwu，暗：$anwu'),
    ));

    return ListView.separated(
      itemCount: list.length,
      // itemCount: 100,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            list[index],
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 1.0, color: AppActionColors.borderSubtle(context)),
    );
  }

  Widget getYangLi({int count = 5, String name = ""}) {
    DateTime? date = selectDate;
    var d = Solar.fromDate(date);
    List<ListTile> list = [];
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('总览:'),
      ),
      title: Text(d.toFullString()),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('阳历:'),
      ),
      title: Text(d.getYear().toString() +
          '年 ' +
          d.getMonth().toString() +
          '月 ' +
          d.getDay().toString() +
          '日 周' +
          d.getWeek().toString()),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('是否闰年:'),
      ),
      title: Text(d.isLeapYear() ? '是' : '否'),
    ));

    var l = d.getFestivals();
    l.addAll(d.getOtherFestivals());
    String festival = '';
    for (var i = 0, j = l.length; i < j; i++) {
      festival += l[i] + ',';
    }
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('节日:'),
      ),
      title: Text(festival),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('星座:'),
      ),
      title: Text(d.getXingZuo()),
    ));

    return ListView.separated(
      itemCount: list.length,
      // itemCount: 100,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            list[index],
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 1.0, color: AppActionColors.borderSubtle(context)),
    );
  }

  Widget getFoLi({int count = 5, String name = ""}) {
    DateTime? date = selectDate;
    var d = Foto.fromLunar(Lunar.fromDate(date));

    List<ListTile> list = [];
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('总览:'),
      ),
      title: Text(d.toFullString()),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('佛历:'),
      ),
      title: Text(d.getYearInChinese().toString() +
          '年 ' +
          d.getMonthInChinese().toString() +
          '月 ' +
          d.getDayInChinese().toString() +
          '日'),
    ));
    String festival = '';
    var l = d.getFestivals();
    for (var i = 0, j = l.length; i < j; i++) {
      festival += l[i].toFullString() + '；';
    }
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('因果犯忌:'),
      ),
      title: Text(festival),
    ));

    var fesOthers = d.getOtherFestivals();
    String fesOtherStr = '';
    for (var i = 0, j = fesOthers.length; i < j; i++) {
      fesOtherStr += fesOthers[i] + ',';
    }
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('佛历纪念日:'),
      ),
      title: Text(fesOtherStr),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('月斋:'),
      ),
      title: Text(d.isMonthZhai() ? '是' : '否'),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('十斋日:'),
      ),
      title: Text(d.isDayZhaiTen() ? '是' : '否'),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('六斋日:'),
      ),
      title: Text(d.isDayZhaiSix() ? '是' : '否'),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('朔望斋:'),
      ),
      title: Text(d.isDayZhaiShuoWang() ? '是' : '否'),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('观音斋:'),
      ),
      title: Text(d.isDayZhaiGuanYin() ? '是' : '否'),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('杨公忌:'),
      ),
      title: Text(d.isDayYangGong() ? '是' : '否'),
    ));
    var xiu = d.getXiu();
    var animal = d.getAnimal();
    var xiuLuck = d.getXiuLuck();
    var song = d.getXiuSong();
    var gong = d.getGong();
    var shou = d.getShou();
    var zheng = d.getZheng();
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('二十七宿:'),
      ),
      title: Text('宿 -> $xiu ,'
          '动物 -> $animal ,'
          '星宿吉凶 -> $xiuLuck ,'
          '宫 -> $gong ,'
          '神兽 -> $shou ,'
          '七政 -> $zheng ,'),
      subtitle: Text(song),
    ));

    return ListView.separated(
      itemCount: list.length,
      // itemCount: 100,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            list[index],
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 1.0, color: AppActionColors.borderSubtle(context)),
    );
  }

  // 构建固定高度的SliverList，count为列表项属相
  Widget getYinLi({int count = 5, String name = ""}) {
    DateTime? date = selectDate;
    Lunar lunarDate = Lunar.fromDate(date);
    List<ListTile> list = [];
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('总览:'),
      ),
      title: Text(lunarDate.toFullString()),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('农历:'),
      ),
      title: Text(lunarDate.getYearInChinese() +
          '年 ' +
          lunarDate.getMonthInChinese() +
          '月 ' +
          lunarDate.getDayInChinese() +
          '日 周' +
          lunarDate.getWeekInChinese()),
    ));
    String festival = '';
    List<String> fes = lunarDate.getFestivals();
    fes.addAll(lunarDate.getOtherFestivals());
    for (var value in fes) {
      festival += '$value ';
    }
    ;
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('传统节日:'),
      ),
      title: Text(festival),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('生肖:'),
      ),
      title: Text(lunarDate.getYearShengXiao()),
    ));
    // 宜
    var yiStr = '';
    var daiyi = lunarDate.getDayYi();
    for (var i = 0, j = daiyi.length; i < j; i++) {
      yiStr += daiyi[i].toString() + ' ';
    }
    // 忌
    var jiStr = '';
    var daiji = lunarDate.getDayJi();
    for (var i = 0, j = daiji.length; i < j; i++) {
      jiStr += daiji[i].toString() + ' ';
    }
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('每日宜忌:'),
      ),
      title: Text('宜：$yiStr'),
      subtitle: Text('忌：$jiStr'),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('彭祖百忌:'),
      ),
      title: Text('天干百忌：' + lunarDate.getPengZuGan()),
      subtitle: Text('地支百忌：' + lunarDate.getPengZuZhi()),
    ));
    // var jieQi = lunarDate.getJieQiTable();
    var jieqi = lunarDate.getJieQi();
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('节气:'),
      ),
      title: Text(lunarDate.getJieQi()),
    ));
    var jinian = lunarDate.getYearInGanZhiByLiChun();
    var tiangan = lunarDate.getYearGanByLiChun();
    var dizhi = lunarDate.getYearZhiByLiChun();
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('干支(立春开始算):'),
      ),
      title: Text('干支纪年：$jinian， 天干：$tiangan ，地支：$dizhi'),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('禄:'),
      ),
      title: Text(lunarDate.getDayLu()),
    ));

    var xiu = lunarDate.getXiu();
    var animal = lunarDate.getAnimal();
    var xiuLuck = lunarDate.getXiuLuck();
    var song = lunarDate.getXiuSong();
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('二十八宿:'),
      ),
      title: Text('$xiu $animal $xiuLuck '),
      subtitle: Text(song),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('七曜:'),
      ),
      title: Text(lunarDate.getZheng()),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('四宫:'),
      ),
      title: Text(lunarDate.getGong()),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('四神兽:'),
      ),
      title: Text(lunarDate.getShou()),
    ));

    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('吉神方位:'),
      ),
      title: Text('喜神方位：' +
          lunarDate.getDayPositionXi() +
          ' = ' +
          lunarDate.getDayPositionXiDesc() +
          '，'
              '阳贵神方位：' +
          lunarDate.getDayPositionYangGui() +
          ' = ' +
          lunarDate.getDayPositionYangGuiDesc() +
          '，'
              '阴贵神方位：' +
          lunarDate.getDayPositionYinGui() +
          ' = ' +
          lunarDate.getDayPositionYinGuiDesc() +
          '，'
              '福神方位：' +
          lunarDate.getDayPositionFu() +
          ' = ' +
          lunarDate.getDayPositionFuDesc() +
          '，'
              '财神方位：' +
          lunarDate.getDayPositionCai() +
          ' = ' +
          lunarDate.getDayPositionCaiDesc()),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('胎神方位:'),
      ),
      title: Text('今日胎神：' +
          lunarDate.getDayPositionTai() +
          '，' +
          '本月胎神：' +
          lunarDate.getMonthPositionTai()),
    ));

    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('太岁方位:'),
      ),
      title: Text('日太岁方位：' +
          lunarDate.getDayPositionTaiSui() +
          '->' +
          lunarDate.getDayPositionTaiSuiDesc() +
          '，' +
          '月太岁方位：' +
          lunarDate.getMonthPositionTaiSui() +
          '->' +
          lunarDate.getMonthPositionTaiSuiDesc() +
          '，' +
          '年太岁方位：' +
          lunarDate.getYearPositionTaiSui() +
          '->' +
          lunarDate.getYearPositionTaiSuiDesc()),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('冲煞:'),
      ),
      title: Text('日冲：' +
          lunarDate.getDayChongDesc() +
          '，' +
          '日煞：' +
          lunarDate.getDaySha()),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('纳音五行:'),
      ),
      title: Text('年纳音：' +
          lunarDate.getYearNaYin() +
          '，'
              '月纳音：' +
          lunarDate.getMonthNaYin() +
          '，'
              '日纳音：' +
          lunarDate.getDayNaYin()),
    ));
    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('十二天神:'),
      ),
      title: Text('天神：' +
          lunarDate.getDayTianShen() +
          '，' +
          '黄道/黑道：' +
          lunarDate.getDayTianShenType() +
          '，' +
          '吉/凶：' +
          lunarDate.getDayTianShenLuck()),
    ));
    var d = lunarDate.getEightChar();
    var yun = d.getYun(1);
    var daYunArr = yun.getDaYun();
    var dayun = '';
    for (var i = 0, j = daYunArr.length; i < j; i++) {
      var daYun = daYunArr[i];
      dayun += '大运[' +
          i.toString() +
          '] = ' +
          daYun.getStartYear().toString() +
          '年 ' +
          daYun.getStartAge().toString() +
          '岁 ' +
          daYun.getGanZhi() +
          '；';
    }

    list.add(ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('八字:'),
      ),
      title: Text('八字：' +
          d.toString() +
          '，'
              '起运：' +
          '出生' +
          yun.getStartYear().toString() +
          '年' +
          yun.getStartMonth().toString() +
          '个月' +
          yun.getStartDay().toString() +
          '天后起运' +
          '；'
              '大运表：' +
          dayun),
    ));

    return ListView.separated(
      itemCount: list.length,
      // itemCount: 100,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            list[index],
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 1.0, color: AppActionColors.borderSubtle(context)),
    );
  }

  Widget _buildCalendarView() {
    final config = CalendarDatePicker2Config(
      selectedDayHighlightColor: Colors.amber[900],
      weekdayLabels: ['日', '一', '二', '三', '四', '五', '六'],
      weekdayLabelTextStyle: context.typo.label.copyWith(
        color: AppActionColors.strong(context),
        fontWeight: FontWeight.bold,
      ),
      firstDate: DateTime(1000),
      firstDayOfWeek: 1,
      controlsHeight: 50,
      centerAlignModePicker: true,
      customModePickerIcon: IconButton(
        onPressed: () async {
          final selectedDate = await showDatePicker(
              context: context,
              firstDate: DateTime(1000),
              currentDate: selectDate,
              lastDate: DateTime(2222));
          setState(() {
            selectDate = selectedDate!;
          });
        },
        icon: Icon(
          Icons.calendar_month,
          color: Colors.lightBlue,
        ),
      ),
      controlsTextStyle: context.typo.sectionTitle.copyWith(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: context.typo.bodyStrong.copyWith(
        color: Colors.amber,
        fontWeight: FontWeight.bold,
      ),
      disabledDayTextStyle: context.typo.caption.copyWith(
        color: AppActionColors.subtle(context),
      ),
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        return getDayWidget(
          date: date,
          textStyle: textStyle,
          decoration: decoration,
          isSelected: isSelected,
          isDisabled: isDisabled,
          isToday: isToday,
        );
      },
    );
    return CalendarDatePicker2(
      config: config,
      value: [selectDate],
      onValueChanged: (dates) {
        setState(() {
          selectDate = dates[0]!;
          _tabViews.clear();
          _tabViews.add(getHot());
          _tabViews.add(getHistory());
          _tabViews.add(getYinLi());
          _tabViews.add(getYangLi());
          _tabViews.add(getFoLi());
          _tabViews.add(getDaoLi());
        });
      },
    );
  }

  Widget getDayWidget({
    required DateTime date,
    textStyle,
    decoration,
    isSelected,
    isDisabled,
    isToday,
  }) {
    Lunar linarDate = Lunar.fromDate(date);
    String nongli = linarDate.getDayInChinese().toString();
    String text = '';
    bool hasFestival = false;
    List<String> festivals = linarDate.getFestivals();
    var solarDate = Solar.fromDate(date);
    festivals.addAll(solarDate.getFestivals());
    if (festivals.isEmpty) {
      text = nongli;
    } else {
      hasFestival = true;
      text = festivals.first;
    }
    Holiday? holiday =
        HolidayUtil.getHolidayByYmd(date.year, date.month, date.day);
    bool hasHoliday = holiday != null;
    String work = '';
    if (date.weekday == 6 || date.weekday == 7) {
      work = "末";
    }
    bool ifWork = false;
    if (hasHoliday) {
      if (holiday.isWork()) {
        ifWork = true;
        work = "班";
      } else {
        work = "休";
      }
    }
    return Container(
      // decoration: decoration,
      decoration: (work == "休")
          ? BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            )
          : (work == "班")
              ? BoxDecoration(
                  color: AppActionColors.borderSubtle(context),
                  shape: BoxShape.circle,
                )
              : decoration,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Text(
                  MaterialLocalizations.of(context).formatDecimal(date.day),
                  style: textStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25, bottom: 15),
                  child: Text(
                    work,
                    style: context.typo.caption.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: ifWork ? Colors.red : Colors.lightGreen,
                    ),
                  ),
                )
              ],
            ),
            Text(
              text,
              style: context.typo.caption.copyWith(
                fontSize: 8,
                color: hasFestival
                    ? Colors.red
                    : AppActionColors.subtle(context),
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

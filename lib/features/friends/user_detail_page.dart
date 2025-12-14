import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/color_constant.dart';
import '../video/myvideo_long_item.dart';
import 'friend_detail.dart';

class UserDetailPage extends StatefulWidget {
  final int userId;
  final bool showAppBar;

  UserDetailPage(this.userId, this.showAppBar, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserDetailPage();
  }
}

class _UserDetailPage extends State<UserDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollviewController;
  late PageController _pageController;
  final List<String> _pageViews = [];
  late int _curPageView = 0;
  bool _care = true;

  @override
  void initState() {
    super.initState();
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollviewController = ScrollController(initialScrollOffset: 0.0);
    _pageController = PageController();
    _pageViews.addAll([
      'imgs/defbak.png',
      'imgs/defbak1.png',
      'imgs/user_default.png',
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollviewController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.showAppBar
            ? AppBar(
                title: Text('用户详情'),
              )
            : null,
        body: NestedScrollView(
            controller: _scrollviewController,
            headerSliverBuilder: (context, boxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  elevation: 0.5,
                  forceElevated: true,
                  expandedHeight: 0.5.sh,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin, //视差效果
                      background: Column(
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              Container(
                                height: 0.3.sh,
                                child: _buildPageView(),
                              ),
                              _buildIndicator(),
                            ],
                          ),
                          Container(
                            color: Colors.white,
                            height: 0.2.sh - 50,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {},
                                          child: Image.asset(
                                            'imgs/user_default.png',
                                          ),
                                        ),
                                        Container(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              child: SelectableText(
                                                '名称：' +
                                                    widget.userId.toString(),
                                                style: TextStyle(
                                                    // color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                maxLines: 1,
                                              ),
                                            ),
                                            Expanded(
                                              child: SelectableText(
                                                '@Skuu.com',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                            Expanded(
                                              child: const Text(
                                                '关注 32 KW ◉ 活跃 333 KW',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ElevatedButton(
                                              style: _care
                                                  ? ElevatedButton.styleFrom(
                                                      minimumSize:
                                                          const Size(20, 35),
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                    )
                                                  : ElevatedButton.styleFrom(
                                                      minimumSize:
                                                          const Size(20, 35),
                                                      padding: EdgeInsets.only(
                                                          left: 13, right: 13),
                                                      backgroundColor:
                                                          ColorConstant
                                                              .ThemeGreen,
                                                    ),
                                              child: _care
                                                  ? Text(
                                                      "已关注",
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey),
                                                    )
                                                  : Text(
                                                      "关注",
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.white),
                                                    ),
                                              onPressed: () {
                                                setState(() {
                                                  _care = !_care;
                                                });
                                              },
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: const Size(20, 35),
                                                padding: EdgeInsets.only(
                                                    left: 13, right: 13),
                                                backgroundColor:
                                                    ColorConstant.ThemeGreen,
                                              ),
                                              child: Text(
                                                "发消息",
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {

                                              },
                                            ),
                                          ],
                                        ))),
                              ],
                            ),
                          ),
                        ],
                      )),
                  bottom: TabBar(
                      indicatorColor: Colors.grey,
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      isScrollable: false,
                      tabs: [
                        Tab(
                          text: "视频",
                        ),
                        Tab(
                          text: "播放列表",
                        ),
                        Tab(
                          text: "社区",
                        ),
                        Tab(
                          text: "简介",
                        )
                      ]),
                ),
              ];
            },
            body: TabBarView(
                controller: _tabController,
                // physics: NeverScrollableScrollPhysics(),
                children: [
                  MyVideoLongItem(),
                  MyVideoLongItem(),
                  MyVideoLongItem(),
                  FriendDetail(
                    title: '名称：' + widget.userId.toString(),
                  ),
                ])));
  }

  Widget _buildPageView() {
    var length = _pageViews.length;
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _curPageView = index;
        });
      },
      itemCount: length,
      itemBuilder: (context, index) {
        return Image.asset(
          _pageViews[index],
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 10,
      child: Row(
        children: _pageViews.map((s) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: ClipOval(
              child: Container(
                width: 8,
                height: 8,
                color: _pageViews.indexOf(s) == _curPageView
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

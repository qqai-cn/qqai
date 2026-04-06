import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/mybutton.dart';
import '../../../constant/constant.dart';
import '../../components/label.dart';
import '../douyin/widgets/douyin_service_strip.dart';
import '../my/providers/my_providers.dart';
import 'friend_blog_view.dart';
import 'friend_goods_view.dart';
import 'friend_video_list_view.dart';
import 'friend_video_view.dart';

class FriendsDetailView extends ConsumerStatefulWidget {
  final int userId;
  final bool showAppBar;

  const FriendsDetailView({
    super.key,
    required this.userId,
    required this.showAppBar,
  });

  @override
  ConsumerState<FriendsDetailView> createState() => _MyViewState();
}

class _MyViewState extends ConsumerState<FriendsDetailView>
    with TickerProviderStateMixin {
  late ScrollController _scrollviewController;
  late TabController _tabController;
  final _pageStorageBucket = PageStorageBucket();
  bool _care = true;
  String split_o = Constant.SPLIT_O;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _scrollviewController = ScrollController(initialScrollOffset: 0.0);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _scrollviewController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted) setState(() {}); // 触发 rebuild，更新 currentIndex
  }

  @override
  Widget build(BuildContext context) {
    final myState = ref.watch(myProvider);
    final myNotifier = ref.read(myProvider.notifier);
    final isWideScreen = 1.sw > 800;

    return NestedScrollView(
      controller: _scrollviewController,
      headerSliverBuilder: (context, boxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              pinned: true,
              floating: true,
              elevation: 0.5,
              forceElevated: true,
              expandedHeight: 450,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin, //视差效果
                background: Column(
                  children: [
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://file.qqai.cn/qqai/2025/09/1.webp',
                          ),
                          fit: BoxFit.cover, // 图片适应方式
                        ),
                      ),
                      child: Center(
                        child: Container(
                          color: Colors.transparent,
                          height: 0.2.sh - 50,
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 20),
                              InkWell(
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    'https://file.qqai.cn/qqai/2025/09/1.webp',
                                  ),
                                ),
                              ),
                              Container(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Spacer(),
                                  Expanded(
                                    child: SelectableText(
                                      '名称：QQAI',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: SelectableText(
                                      '@Skuu.com',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 220,
                      color: Colors.white,
                      child: Padding(
                        padding: .all(10),
                        child: Column(
                          crossAxisAlignment: .start,
                          spacing: 5,
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '5.6W',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '获赞',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Text(
                                      '3W',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '互关',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Text(
                                      '3.2W',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '关注',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Text(
                                      '3000W',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '粉丝',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text("关注"),
                                ),
                              ],
                            ),
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(text: '人生终究 '),
                                  TextSpan(
                                    text: '一场梦',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  TextSpan(text: ' 而已！\n'),
                                  TextSpan(text: ' 遗憾！！！'),
                                ],
                              ),
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Label(
                                  content: 'IP: 澳大利亚',
                                  backgroundColor: Colors.black12,
                                ),
                                Label(
                                  content: '女: 18岁',
                                  backgroundColor: Colors.black12,
                                ),
                              ],
                            ),
                            Spacer(),
                            DouyinServiceStrip(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                indicatorColor: Colors.grey,
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                isScrollable: false,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(text: "作品"),
                  Tab(text: "合集"),
                  Tab(text: "日常"),
                  Tab(text: "店铺"),
                  Tab(text: "喜欢"),
                ],
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          FriendVideoView(tabIndex: 0, currentIndex: _tabController.index),
          FriendVideoListView(tabIndex: 1, currentIndex: _tabController.index),
          FriendBlogView(tabIndex: 2, currentIndex: _tabController.index),
          FriendGoodsView(tabIndex: 3, currentIndex: _tabController.index),
          FriendVideoView(tabIndex: 4, currentIndex: _tabController.index),
        ],
      ),
    );
  }
}

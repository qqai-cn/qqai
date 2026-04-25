import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/label.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../constant/constant.dart';
import '../../douyin/widgets/douyin_service_strip.dart';
import '../providers/my_providers.dart';
import 'my_blog_view.dart';
import 'my_goods_view.dart';
import 'my_video_list_view.dart';
import 'my_video_view.dart';

class MyView extends ConsumerStatefulWidget {
  const MyView({super.key});

  @override
  ConsumerState<MyView> createState() => _MyViewState();
}

class _MyViewState extends ConsumerState<MyView> with TickerProviderStateMixin {
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
              expandedHeight: 400,
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
                                      style: context.typo.pageTitle.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: SelectableText(
                                      '@Skuu.com',
                                      textAlign: TextAlign.left,
                                      style: context.typo.cardSubtitle.copyWith(
                                        color: Colors.white,
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
                                      style: context.typo.pageTitle.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '获赞',
                                      style: context.typo.cardSubtitle,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Text(
                                      '3W',
                                      style: context.typo.pageTitle.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '互关',
                                      style: context.typo.cardSubtitle,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Text(
                                      '3.2W',
                                      style: context.typo.pageTitle.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '关注',
                                      style: context.typo.cardSubtitle,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Text(
                                      '3000W',
                                      style: context.typo.pageTitle.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '粉丝',
                                      style: context.typo.cardSubtitle,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text("编辑主页"),
                                ),
                              ],
                            ),
                            Text.rich(
                              TextSpan(
                                style: context.typo.body,
                                children: [
                                  TextSpan(text: '人生终究 '),
                                  TextSpan(
                                    text: '一场梦',
                                    style: context.typo.bodyStrong.copyWith(
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
          MyVideoView(tabIndex: 0, currentIndex: _tabController.index),
          MyVideoListView(tabIndex: 1, currentIndex: _tabController.index),
          MyBlogView(tabIndex: 2, currentIndex: _tabController.index),
          MyGoodsView(tabIndex: 3, currentIndex: _tabController.index),
          MyVideoView(tabIndex: 4, currentIndex: _tabController.index),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/label.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../douyin/widgets/douyin_service_strip.dart';
import '../../../providers/auth_providers.dart';
import '../providers/my_shop_profile.dart';
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

  static const String _defaultCover =
      'https://file.qqai.cn/qqai/2025/09/1.webp';

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
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final shopAsync = ref.watch(myShopProfileProvider);
    final shop = switch (shopAsync) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final nameTrim = shop?.name?.trim();
    final displayName = (nameTrim != null && nameTrim.isNotEmpty)
        ? nameTrim
        : (auth.username?.trim().isNotEmpty == true
            ? auth.username!.trim()
            : '我的主页');
    final subtitle = auth.userId != null && auth.userId!.isNotEmpty
        ? 'ID ${auth.userId}'
        : '';
    final coverTrim = shop?.coverUrl?.trim();
    final bannerUrl =
        (coverTrim != null && coverTrim.isNotEmpty) ? coverTrim : _defaultCover;
    final avatarUrl = bannerUrl;
    final introTrim = shop?.intro?.trim();
    final intro = (introTrim != null && introTrim.isNotEmpty)
        ? introTrim
        : '这个人很懒，还没有写签名。';
    final productCount = shop?.productCount;

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
                collapseMode: CollapseMode.pin,
                background: Column(
                  children: [
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(bannerUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          color: Colors.transparent,
                          height: 0.2.sh - 50,
                          child: Row(
                            children: <Widget>[
                              const SizedBox(width: 20),
                              InkWell(
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: CachedNetworkImageProvider(
                                    avatarUrl,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Spacer(),
                                    SelectableText(
                                      displayName,
                                      style: context.typo.pageTitle.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                    if (subtitle.isNotEmpty)
                                      SelectableText(
                                        subtitle,
                                        style: context.typo.cardSubtitle.copyWith(
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    const Spacer(),
                                  ],
                                ),
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
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            Row(
                              children: [
                                if (productCount != null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$productCount',
                                        style: context.typo.pageTitle.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '在售商品',
                                        style: context.typo.cardSubtitle,
                                      ),
                                    ],
                                  ),
                                if (productCount != null) const SizedBox(width: 20),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    ref.invalidate(myShopProfileProvider);
                                  },
                                  child: const Text('刷新店铺'),
                                ),
                              ],
                            ),
                            Text(
                              intro,
                              style: context.typo.body,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                if (shop != null && shop.status != null)
                                  Label(
                                    content: '店铺状态: ${shop.status}',
                                    backgroundColor: Colors.black12,
                                  ),
                                Label(
                                  content: shopAsync.isLoading
                                      ? '店铺加载中…'
                                      : (shopAsync.hasError ? '店铺加载失败' : '已登录'),
                                  backgroundColor: Colors.black12,
                                ),
                              ],
                            ),
                            const Spacer(),
                            const DouyinServiceStrip(),
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
                tabs: const [
                  Tab(text: '作品'),
                  Tab(text: '合集'),
                  Tab(text: '日常'),
                  Tab(text: '店铺'),
                  Tab(text: '喜欢'),
                ],
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          MyVideoView(
            tabIndex: 0,
            currentIndex: _tabController.index,
            kind: MyProfileWorkGridKind.works,
          ),
          MyVideoListView(
            tabIndex: 1,
            currentIndex: _tabController.index,
          ),
          MyBlogView(
            tabIndex: 2,
            currentIndex: _tabController.index,
          ),
          MyGoodsView(
            tabIndex: 3,
            currentIndex: _tabController.index,
          ),
          MyVideoView(
            tabIndex: 4,
            currentIndex: _tabController.index,
            kind: MyProfileWorkGridKind.likes,
          ),
        ],
      ),
    );
  }
}

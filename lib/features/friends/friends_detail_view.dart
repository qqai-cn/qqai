import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/app_typography.dart';

import 'data/friend_repo.dart';
import 'providers/friend_providers.dart';
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

  Future<void> _showEditRemarkDialog() async {
    final cache = ref.read(friendRemarkCacheProvider);
    final initial = cache[widget.userId] ?? '';
    final ctrl = TextEditingController(text: initial);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('修改备注'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '留空则清除备注',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    try {
      if (ok == true && mounted) {
        final text = ctrl.text.trim();
        await ref.read(friendRepoProvider).updateRemark(
              friendUserId: widget.userId,
              remark: text,
            );
        ref.read(friendRemarkCacheProvider.notifier).setRemark(
              widget.userId,
              text,
            );
        ref.invalidate(friendListGroupedProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('备注已更新')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('修改失败：$e')),
        );
      }
    } finally {
      ctrl.dispose();
    }
  }

  Future<void> _confirmDeleteFriend() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除好友'),
        content: const Text('确定删除该好友？删除后将无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(friendRepoProvider).deleteFriend(
            friendUserId: widget.userId,
          );
      ref.read(friendRemarkCacheProvider.notifier).setRemark(
            widget.userId,
            '',
          );
      ref.invalidate(friendListGroupedProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已删除好友')),
      );
      if (context.canPop()) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('删除失败：$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myState = ref.watch(myProvider);
    final myNotifier = ref.read(myProvider.notifier);
    final isWideScreen = 1.sw > 800;
    final remarkMap = ref.watch(friendRemarkCacheProvider);
    final remark = remarkMap[widget.userId];
    final headerName = (remark != null && remark.isNotEmpty)
        ? remark
        : '好友 ${widget.userId}';

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
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz),
                  onSelected: (value) {
                    if (value == 'remark') {
                      _showEditRemarkDialog();
                    } else if (value == 'delete') {
                      _confirmDeleteFriend();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'remark',
                      child: Text('修改备注'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        '删除好友',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ],
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
                                      '名称：$headerName',
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
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  child: Text("关注"),
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

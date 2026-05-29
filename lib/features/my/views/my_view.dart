import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/label.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/constant/constant.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/format_count.dart';

import '../../douyin/widgets/douyin_service_strip.dart';
import '../../friends/data/friend_repo.dart';
import '../../friends/providers/friend_providers.dart';
import '../data/models/area_models.dart';
import '../data/models/profile_models.dart';
import '../data/repos/profile_repo.dart';
import '../providers/my_page_profile.dart';
import '../providers/user_page_profile.dart';
import 'my_blog_view.dart';
import 'my_goods_view.dart';
import 'my_video_list_view.dart';
import 'my_video_view.dart';

class MyView extends ConsumerStatefulWidget {
  const MyView({
    super.key,
    this.userId,
    this.showLeadingBack = false,
  });

  /// 为空表示当前登录用户「我的」主页；有值表示查看他人主页（如好友详情）。
  final int? userId;
  final bool showLeadingBack;

  @override
  ConsumerState<MyView> createState() => _MyViewState();
}

class _MyViewState extends ConsumerState<MyView> with TickerProviderStateMixin {
  late ScrollController _scrollviewController;
  late TabController _tabController;
  bool? _followed;
  bool _followLoading = false;

  static const String _defaultCover =
      'https://file.qqai.cn/qqai/2025/09/1.webp';
  static const String _defaultAvatar = Constant.DEFAULT_USER_AVATAR;

  bool get _isSelf => widget.userId == null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _scrollviewController = ScrollController(initialScrollOffset: 0.0);
    _tabController.addListener(_handleTabChange);
    if (!_isSelf) {
      Future.microtask(_loadFollowState);
    }
  }

  @override
  void didUpdateWidget(covariant MyView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _followed = null;
      if (!_isSelf) {
        Future.microtask(_loadFollowState);
      }
    }
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

  Future<void> _loadFollowState() async {
    final userId = widget.userId;
    if (userId == null) return;
    try {
      final followed =
          await ref.read(profileRepoProvider).isFollowedByMe(userId);
      if (mounted) setState(() => _followed = followed);
    } catch (_) {}
  }

  Future<void> _toggleFollow() async {
    final userId = widget.userId;
    if (userId == null || _followLoading) return;
    setState(() => _followLoading = true);
    try {
      final repo = ref.read(profileRepoProvider);
      if (_followed == true) {
        await repo.unfollowUser(userId);
      } else {
        await repo.followUser(userId);
      }
      if (mounted) {
        setState(() => _followed = !(_followed == true));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败：$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _followLoading = false);
    }
  }

  Future<void> _showEditRemarkDialog() async {
    final userId = widget.userId;
    if (userId == null) return;
    final cache = ref.read(friendRemarkCacheProvider);
    final initial = cache[userId] ?? '';
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
              friendUserId: userId,
              remark: text,
            );
        ref.read(friendRemarkCacheProvider.notifier).setRemark(userId, text);
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
    final userId = widget.userId;
    if (userId == null) return;
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
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(friendRepoProvider).deleteFriend(friendUserId: userId);
      ref.read(friendRemarkCacheProvider.notifier).setRemark(userId, '');
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

  Widget _statColumn(String count, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: context.typo.pageTitle.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: context.typo.cardSubtitle),
      ],
    );
  }

  BlogMyPageResp? _resolvePage(AsyncValue<BlogMyPageResp> pageAsync) {
    return switch (pageAsync) {
      AsyncData(:final value) => value,
      _ => null,
    };
  }

  String _resolveDisplayName(BlogMyPageResp? page) {
    if (!_isSelf) {
      final remark = ref.watch(friendRemarkCacheProvider)[widget.userId!];
      if (remark != null && remark.isNotEmpty) return remark;
    }
    if (page?.nickname?.trim().isNotEmpty == true) {
      return page!.nickname!.trim();
    }
    if (_isSelf) return '我的主页';
    return '用户 ${widget.userId}';
  }

  Widget _buildActionButton() {
    if (_isSelf) {
      return ElevatedButton(
        onPressed: () async {
          await context.push(Routes.myProfileEdit);
          if (mounted) {
            ref.invalidate(myPageProfileProvider);
          }
        },
        child: const Text('编辑主页'),
      );
    }
    final followed = _followed == true;
    return ElevatedButton(
      onPressed: _followLoading ? null : _toggleFollow,
      child: _followLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(followed ? '已关注' : '关注'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageAsync = _isSelf
        ? ref.watch(myPageProfileProvider)
        : ref.watch(userPageProfileProvider(widget.userId!));
    final page = _resolvePage(pageAsync);

    final displayName = _resolveDisplayName(page);
    final qqId = page?.id ?? widget.userId;
    final subtitle = qqId != null ? '千千号：$qqId' : '';
    final bannerUrl = page?.backgroundUrl?.trim().isNotEmpty == true
        ? page!.backgroundUrl!.trim()
        : _defaultCover;
    final avatarUrl = page?.avatar?.trim();
    final intro = page?.intro?.trim().isNotEmpty == true
        ? page!.intro!.trim()
        : '这个人很懒，还没有写签名。';
    final targetUserId = widget.userId;

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
              automaticallyImplyLeading: widget.showLeadingBack,
              leading: widget.showLeadingBack
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    )
                  : null,
              backgroundColor: Colors.white,
              actions: _isSelf
                  ? null
                  : [
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
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: avatarUrl != null &&
                                        avatarUrl.isNotEmpty
                                    ? CachedNetworkImageProvider(avatarUrl)
                                    : const AssetImage(_defaultAvatar),
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
                                        style: context.typo.cardSubtitle
                                            .copyWith(
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
                                _statColumn(
                                  formatCompactCount(page?.likeReceivedCount),
                                  '获赞',
                                ),
                                const SizedBox(width: 20),
                                _statColumn(
                                  formatCompactCount(page?.mutualFollowCount),
                                  '互关',
                                ),
                                const SizedBox(width: 20),
                                _statColumn(
                                  formatCompactCount(page?.followingCount),
                                  '关注',
                                ),
                                const SizedBox(width: 20),
                                _statColumn(
                                  formatCompactCount(page?.followerCount),
                                  '粉丝',
                                ),
                                const Spacer(),
                                _buildActionButton(),
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
                                if (page?.address?.trim().isNotEmpty == true)
                                  Label(
                                    content: formatAddressForDisplay(
                                      page!.address,
                                      empty: '',
                                    ),
                                    backgroundColor: Colors.black12,
                                  ),
                                if (page?.age != null)
                                  Label(
                                    content: '${page!.age}岁',
                                    backgroundColor: Colors.black12,
                                  ),
                              ],
                            ),
                            if (_isSelf) ...[
                              const Spacer(),
                              const DouyinServiceStrip(),
                            ],
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
            userId: targetUserId,
          ),
          MyVideoListView(
            tabIndex: 1,
            currentIndex: _tabController.index,
            userId: targetUserId,
          ),
          MyBlogView(
            tabIndex: 2,
            currentIndex: _tabController.index,
            userId: targetUserId,
          ),
          MyGoodsView(
            tabIndex: 3,
            currentIndex: _tabController.index,
            userId: targetUserId,
          ),
          MyVideoView(
            tabIndex: 4,
            currentIndex: _tabController.index,
            kind: MyProfileWorkGridKind.likes,
            userId: targetUserId,
          ),
        ],
      ),
    );
  }
}

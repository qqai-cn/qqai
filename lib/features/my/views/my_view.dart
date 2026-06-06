import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/blog/detail_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/profile/profile_banner_overlay_buttons.dart';
import 'package:qqai/components/label.dart';
import 'package:qqai/components/app_action_outline_button.dart';
import 'package:qqai/components/follow_button.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/format_count.dart';

import '../../douyin/widgets/douyin_service_strip.dart';
import '../../chat/data/repos/chat_repo.dart';
import '../../chat/providers/chat_providers.dart';
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
  const MyView({super.key, this.userId, this.showLeadingBack = false});

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
  bool _messageLoading = false;

  static const String _defaultCover =
      'https://file.qqai.cn/qqai/2025/09/1.webp';

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
      final followed = await ref
          .read(profileRepoProvider)
          .isFollowedByMe(userId);
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('操作失败：$e')));
      }
    } finally {
      if (mounted) setState(() => _followLoading = false);
    }
  }

  Future<void> _openSingleConversation() async {
    final userId = widget.userId;
    if (userId == null || _messageLoading) return;
    setState(() => _messageLoading = true);
    try {
      final conversation = await ref
          .read(chatRepoProvider)
          .getOrCreateSingleConversation(userId);
      final conversationId = conversation.id;
      if (conversationId == null) {
        throw Exception('无会话编号');
      }
      ref.invalidate(chatConversationsProvider);
      if (!mounted) return;
      context.go('${Routes.messagePage}?conversationId=$conversationId');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('打开聊天失败：$e')));
      }
    } finally {
      if (mounted) setState(() => _messageLoading = false);
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
      useRootNavigator: true,
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
        await ref
            .read(friendRepoProvider)
            .updateRemark(friendUserId: userId, remark: text);
        ref.read(friendRemarkCacheProvider.notifier).setRemark(userId, text);
        ref.invalidate(friendListGroupedProvider);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('备注已更新')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('修改失败：$e')));
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
      useRootNavigator: true,
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('已删除好友')));
        if (context.canPop()) {
          context.pop();
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('删除失败：$e')));
      }
    }
  }

  Widget _statColumn(String count, String label, {VoidCallback? onTap}) {
    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: context.typo.pageTitle.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: context.typo.cardSubtitle),
      ],
    );
    if (onTap == null) return child;
    return InkWell(onTap: onTap, child: child);
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

  Future<void> _showOtherUserActionMenu(BuildContext anchorContext) async {
    final renderBox = anchorContext.findRenderObject() as RenderBox?;
    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize || overlayBox == null) return;

    final topLeft = renderBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    final bottomRight = renderBox.localToGlobal(
      renderBox.size.bottomRight(Offset.zero),
      ancestor: overlayBox,
    );
    final position = RelativeRect.fromRect(
      Rect.fromPoints(topLeft, bottomRight),
      Offset.zero & overlayBox.size,
    );

    final value = await showMenu<String>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(value: 'remark', child: Text('修改备注')),
        PopupMenuItem(
          value: 'delete',
          child: Text(
            '删除好友',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    );
    if (!mounted || value == null) return;

    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;

    switch (value) {
      case 'remark':
        await _showEditRemarkDialog();
      case 'delete':
        await _confirmDeleteFriend();
    }
  }

  Widget _buildOtherUserMoreMenu(BuildContext anchorContext) {
    return ProfileBannerOverlayMoreButton(
      onPressed: () => _showOtherUserActionMenu(anchorContext),
    );
  }

  void _showFullIntroSheet(BuildContext context, String intro) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: 0.6.sh),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('个性签名', style: context.typo.pageTitle),
              const SizedBox(height: 12),
              SelectableText(intro, style: context.typo.body),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    if (_isSelf) {
      return AppActionOutlineButton(
        label: '编辑主页',
        onTap: () async {
          await context.push(Routes.myProfileEdit);
          if (mounted) {
            ref.invalidate(myPageProfileProvider);
          }
        },
      );
    }
    final followed = _followed == true;
    return SizedBox(
      width: 96,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FollowButton(
            followed: followed,
            onTap: _followLoading ? null : _toggleFollow,
            loading: _followLoading,
          ),
          const SizedBox(height: 8),
          AppActionOutlineButton(
            label: '发消息',
            onTap: _messageLoading ? null : _openSingleConversation,
            loading: _messageLoading,
          ),
        ],
      ),
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
    final hasCustomIntro = page?.intro?.trim().isNotEmpty == true;
    final intro = hasCustomIntro
        ? page!.intro!.trim()
        : '这个人很懒，还没有写签名。';
    final targetUserId = widget.userId;

    final isWideScreen = MediaQuery.sizeOf(context).width > 800;
    final showBackButton = !_isSelf && widget.showLeadingBack;
    final showMoreButton = !_isSelf && (widget.showLeadingBack || isWideScreen);
    final useBannerOverlayNav = showBackButton || showMoreButton;
    const toolbarHeight = 0.0;
    const tabBarHeight = kTextTabBarHeight;
    const bannerHeight = 180.0;
    final hasProfileMeta =
        page?.address?.trim().isNotEmpty == true || page?.age != null;
    // 本人主页含 Douyin 入口需更高；他人主页内容较少，避免签名与 Tab 之间留白过大。
    final infoHeight = _isSelf
        ? 220.0
        : (hasProfileMeta ? 156.0 : 132.0);
    final expandedHeight =
        bannerHeight + infoHeight + toolbarHeight + tabBarHeight;

    return NestedScrollView(
      controller: _scrollviewController,
      headerSliverBuilder: (context, boxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              pinned: true,
              floating: false,
              primary: false,
              toolbarHeight: toolbarHeight,
              elevation: 0.5,
              forceElevated: true,
              expandedHeight: expandedHeight,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  children: [
                    SizedBox(
                      height: bannerHeight,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(bannerUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (useBannerOverlayNav)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: SafeArea(
                                bottom: false,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (showBackButton)
                                      ProfileBannerOverlayBackButton(
                                        onPressed: () => context.pop(),
                                      )
                                    else
                                      const SizedBox(width: 48),
                                    if (showMoreButton)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 4,
                                        ),
                                        child: Builder(
                                          builder: (menuContext) =>
                                              _buildOtherUserMoreMenu(
                                                menuContext,
                                              ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          Center(
                            child: Container(
                              color: Colors.transparent,
                              height: 0.2.sh - 50,
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(width: 20),
                                  buildDetailAvatar(
                                    avatarUrl: avatarUrl,
                                    size: 100,
                                    context: context,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const Spacer(),
                                        SelectableText(
                                          displayName,
                                          style: context.typo.pageTitle
                                              .copyWith(
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: infoHeight,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    onTap: _isSelf
                                        ? () => context.push(Routes.care)
                                        : null,
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
                              const SizedBox(height: 5),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: hasCustomIntro
                                        ? () => _showFullIntroSheet(
                                            context,
                                            intro,
                                          )
                                        : null,
                                    behavior: HitTestBehavior.opaque,
                                    child: Text(
                                      intro,
                                      style: context.typo.body,
                                      maxLines: _isSelf ? 3 : 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              if (hasProfileMeta) ...[
                                const SizedBox(height: 5),
                                Row(
                                  spacing: 10,
                                  children: [
                                    if (page?.address?.trim().isNotEmpty ==
                                        true)
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
                              ],
                              if (_isSelf) ...[
                                const SizedBox(height: 5),
                                const DouyinServiceStrip(),
                              ],
                            ],
                          ),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/level_icon.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/constant/constant.dart';
import 'package:qqai/features/my/data/models/profile_models.dart';
import 'package:qqai/features/my/providers/my_followers_providers.dart';
import 'package:qqai/features/my/providers/my_follows_providers.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/conversation_list_time_format.dart';
import 'package:qqai/util/format_count.dart';
import 'package:qqai/util/media_url.dart';

List<BlogFollowMember> filterFollowMembers(
  List<BlogFollowMember> items,
  String query,
) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return items;
  return items.where((member) {
    final name = member.nickname?.toLowerCase() ?? '';
    final id = (member.memberUserId ?? '').toString();
    return name.contains(q) || id.contains(q);
  }).toList();
}

/// 关注 / 粉丝（与发布页相同的分段 Tab 样式）。
class MyCarePage extends ConsumerStatefulWidget {
  const MyCarePage({super.key});

  @override
  ConsumerState<MyCarePage> createState() => _MyCarePageState();
}

class _MyCarePageState extends ConsumerState<MyCarePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          '关注',
          style: TextStyle(
            color: Color(0xFF202124),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(58),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5F8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE8EBF0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: const Color(0xFF202124),
                      unselectedLabelColor: const Color(0xFF6B7280),
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      tabs: const [
                        Tab(
                          height: 38,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person_add_alt_1_outlined, size: 16),
                              SizedBox(width: 4),
                              Text('关注'),
                            ],
                          ),
                        ),
                        Tab(
                          height: 38,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.people_outline, size: 16),
                              SizedBox(width: 4),
                              Text('粉丝'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索昵称或千千号',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE8EBF0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE8EBF0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF3578E5)),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _FollowingTab(searchQuery: _searchQuery),
                _FollowersTab(searchQuery: _searchQuery),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FollowingTab extends ConsumerWidget {
  const _FollowingTab({required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myFollowsProvider);
    final notifier = ref.read(myFollowsProvider.notifier);

    return state.pageData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$e', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: notifier.load, child: const Text('重试')),
          ],
        ),
      ),
      data: (_) => _MemberList(
        items: filterFollowMembers(state.allItems, searchQuery),
        hasMore: state.hasMore && searchQuery.trim().isEmpty,
        isLoadingMore: state.isLoadingMore,
        emptyText: searchQuery.trim().isEmpty ? '暂无关注' : '未找到相关用户',
        onRefresh: notifier.refresh,
        onLoadMore: notifier.loadMore,
        tileBuilder: (member) {
          final userId = member.memberUserId;
          final isUnfollowing =
              userId != null && state.unfollowingIds.contains(userId);
          return _FollowMemberTile(
            member: member,
            actionLabel: '取消关注',
            isActionLoading: isUnfollowing,
            onTap: userId == null
                ? null
                : () => context.push('${Routes.userDetail}/$userId/true'),
            onAction: () async {
              final err = await notifier.unfollow(member);
              if (err != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(err)),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class _FollowersTab extends ConsumerWidget {
  const _FollowersTab({required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myFollowersProvider);
    final notifier = ref.read(myFollowersProvider.notifier);

    return state.pageData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$e', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: notifier.load, child: const Text('重试')),
          ],
        ),
      ),
      data: (_) => _MemberList(
        items: filterFollowMembers(state.allItems, searchQuery),
        hasMore: state.hasMore && searchQuery.trim().isEmpty,
        isLoadingMore: state.isLoadingMore,
        emptyText: searchQuery.trim().isEmpty ? '暂无粉丝' : '未找到相关用户',
        onRefresh: notifier.refresh,
        onLoadMore: notifier.loadMore,
        tileBuilder: (member) {
          final userId = member.memberUserId;
          final isToggling =
              userId != null && state.togglingIds.contains(userId);
          final followed = member.isFollowedByMe;
          return _FollowMemberTile(
            member: member,
            actionLabel: followed ? '已关注' : '回关',
            isActionLoading: isToggling,
            onTap: userId == null
                ? null
                : () => context.push('${Routes.userDetail}/$userId/true'),
            onAction: () async {
              final err = await notifier.toggleFollow(member);
              if (err != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(err)),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class _MemberList extends StatelessWidget {
  const _MemberList({
    required this.items,
    required this.hasMore,
    required this.isLoadingMore,
    required this.emptyText,
    required this.onRefresh,
    required this.onLoadMore,
    required this.tileBuilder,
  });

  final List<BlogFollowMember> items;
  final bool hasMore;
  final bool isLoadingMore;
  final String emptyText;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final Widget Function(BlogFollowMember member) tileBuilder;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.35,
              child: Center(child: Text(emptyText)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length + (hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            if (!isLoadingMore) onLoadMore();
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return tileBuilder(items[index]);
        },
      ),
    );
  }
}

class _FollowMemberTile extends StatelessWidget {
  const _FollowMemberTile({
    required this.member,
    required this.actionLabel,
    required this.isActionLoading,
    this.onTap,
    required this.onAction,
  });

  final BlogFollowMember member;
  final String actionLabel;
  final bool isActionLoading;
  final VoidCallback? onTap;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final userId = member.memberUserId;
    final name = member.nickname?.trim();
    final displayName = name != null && name.isNotEmpty
        ? name
        : '用户 ${userId ?? ''}';
    final avatarUrl = resolveMediaUrl(member.avatar);
    final level = member.memberLevel;
    final followTime = formatConversationListTime(member.followTime);
    final fans = member.followerCount ?? 0;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 26,
        backgroundImage: avatarUrl != null
            ? CachedNetworkImageProvider(avatarUrl)
            : const AssetImage(Constant.DEFAULT_USER_AVATAR),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.typo.sectionTitle.copyWith(fontSize: 16),
            ),
          ),
          if (level != null && level > 0) LevelIcon(lv: level.clamp(1, 6)),
        ],
      ),
      subtitle: Text(
        [
          if (fans > 0) '粉丝 ${formatCompactCount(fans)}',
          if (followTime.isNotEmpty) '关注于 $followTime',
        ].join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.typo.caption,
      ),
      trailing: TextButton(
        onPressed: isActionLoading ? null : onAction,
        child: isActionLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(actionLabel),
      ),
    );
  }
}

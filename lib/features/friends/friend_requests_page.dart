import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/qq_tab_bar.dart';
import '../../router/app_routes.dart';
import '../../util/conversation_list_time_format.dart';
import 'apply_friend_dialog.dart';
import 'data/friend_repo.dart';
import 'providers/friend_providers.dart';

/// 新的朋友：待处理申请 + 发出的申请，并可发起添加好友
class FriendRequestsPage extends ConsumerStatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  ConsumerState<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends ConsumerState<FriendRequestsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showApplyDialog() => showApplyFriendDialog(context, ref);

  void _invalidateFriendData() {
    ref.invalidate(friendPendingIncomingProvider);
    ref.invalidate(friendPendingOutgoingProvider);
    ref.invalidate(friendListGroupedProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新的朋友'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: '添加好友',
            onPressed: _showApplyDialog,
          ),
        ],
        bottom: QqTabBarBottom(
          controller: _tabController,
          items: const [
            QqTabItem(label: '待我处理'),
            QqTabItem(label: '待对方通过'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _IncomingTab(onFriendDataChanged: _invalidateFriendData),
          _OutgoingTab(onRefresh: _invalidateFriendData),
        ],
      ),
    );
  }
}

class _IncomingTab extends ConsumerWidget {
  const _IncomingTab({required this.onFriendDataChanged});

  final VoidCallback onFriendDataChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(friendPendingIncomingProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(friendPendingIncomingProvider),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
      data: (list) {
        if (list.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(friendPendingIncomingProvider);
              await ref.read(friendPendingIncomingProvider.future);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: Text('暂无待处理申请')),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(friendPendingIncomingProvider);
            await ref.read(friendPendingIncomingProvider.future);
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = list[index];
              final applicantId = item.relatedUserId;
              return ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  backgroundImage: item.avatar != null &&
                          item.avatar!.trim().isNotEmpty
                      ? NetworkImage(item.avatar!)
                      : null,
                  child: item.avatar == null || item.avatar!.trim().isEmpty
                      ? Text(
                          item.displayName.isNotEmpty
                              ? item.displayName.substring(0, 1)
                              : '?',
                          style: const TextStyle(fontSize: 14),
                        )
                      : null,
                ),
                title: Text(item.displayName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.applyMessage?.trim().isNotEmpty == true
                          ? item.applyMessage!.trim()
                          : '申请添加你为好友',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    if (applicantId == null)
                      Text(
                        formatConversationListTime(item.createTime),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    else
                      Row(
                        children: [
                          Text(
                            formatConversationListTime(item.createTime),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () async {
                              try {
                                await ref.read(friendRepoProvider).rejectFriend(
                                      applicantUserId: applicantId,
                                    );
                                onFriendDataChanged();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('已拒绝')),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('$e')),
                                  );
                                }
                              }
                            },
                            child: const Text('拒绝'),
                          ),
                          FilledButton.tonal(
                            onPressed: () async {
                              try {
                                await ref.read(friendRepoProvider).acceptFriend(
                                      applicantUserId: applicantId,
                                    );
                                onFriendDataChanged();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('已同意')),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('$e')),
                                  );
                                }
                              }
                            },
                            child: const Text('同意'),
                          ),
                        ],
                      ),
                  ],
                ),
                onTap: applicantId == null
                    ? null
                    : () => context.push('${Routes.userDetail}/$applicantId/true'),
              );
            },
          ),
        );
      },
    );
  }
}

class _OutgoingTab extends ConsumerWidget {
  const _OutgoingTab({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(friendPendingOutgoingProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(friendPendingOutgoingProvider),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
      data: (list) {
        if (list.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              onRefresh();
              ref.invalidate(friendPendingOutgoingProvider);
              await ref.read(friendPendingOutgoingProvider.future);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: Text('暂无发出的申请')),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            onRefresh();
            ref.invalidate(friendPendingOutgoingProvider);
            await ref.read(friendPendingOutgoingProvider.future);
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = list[index];
              final uid = item.relatedUserId;
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: item.avatar != null &&
                          item.avatar!.trim().isNotEmpty
                      ? NetworkImage(item.avatar!)
                      : null,
                  child: item.avatar == null || item.avatar!.trim().isEmpty
                      ? Text(
                          item.displayName.isNotEmpty
                              ? item.displayName.substring(0, 1)
                              : '?',
                          style: const TextStyle(fontSize: 14),
                        )
                      : null,
                ),
                title: Text(item.displayName),
                subtitle: Text(
                  item.applyMessage?.trim().isNotEmpty == true
                      ? item.applyMessage!.trim()
                      : '等待对方通过',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  formatConversationListTime(item.createTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: uid == null
                    ? null
                    : () => context.push('${Routes.userDetail}/$uid/true'),
              );
            },
          ),
        );
      },
    );
  }
}

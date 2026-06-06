import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/qq_tab_bar.dart';
import '../../router/app_routes.dart';
import '../../util/conversation_list_time_format.dart';
import '../chat/data/repos/chat_repo.dart';
import '../chat/providers/chat_providers.dart';

/// 群聊邀请：待处理邀请 + 发出的邀请
class GroupInvitationsPage extends ConsumerStatefulWidget {
  const GroupInvitationsPage({super.key});

  @override
  ConsumerState<GroupInvitationsPage> createState() =>
      _GroupInvitationsPageState();
}

class _GroupInvitationsPageState extends ConsumerState<GroupInvitationsPage>
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

  void _invalidateData() {
    ref.invalidate(groupInvitationPendingIncomingProvider);
    ref.invalidate(groupInvitationPendingOutgoingProvider);
    ref.invalidate(chatConversationsProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('群聊邀请'),
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
          _IncomingTab(onDataChanged: _invalidateData),
          _OutgoingTab(onRefresh: _invalidateData),
        ],
      ),
    );
  }
}

class _IncomingTab extends ConsumerWidget {
  const _IncomingTab({required this.onDataChanged});

  final VoidCallback onDataChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(groupInvitationPendingIncomingProvider);

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
                    ref.invalidate(groupInvitationPendingIncomingProvider),
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
              ref.invalidate(groupInvitationPendingIncomingProvider);
              await ref.read(groupInvitationPendingIncomingProvider.future);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: Text('暂无待处理邀请')),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(groupInvitationPendingIncomingProvider);
            await ref.read(groupInvitationPendingIncomingProvider.future);
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = list[index];
              final invitationId = item.id;
              final inviterId = item.inviterUserId;
              return ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  backgroundImage: item.inviterAvatar != null &&
                          item.inviterAvatar!.trim().isNotEmpty
                      ? NetworkImage(item.inviterAvatar!)
                      : null,
                  child: item.inviterAvatar == null ||
                          item.inviterAvatar!.trim().isEmpty
                      ? Text(
                          item.inviterDisplayName.isNotEmpty
                              ? item.inviterDisplayName.substring(0, 1)
                              : '?',
                          style: const TextStyle(fontSize: 14),
                        )
                      : null,
                ),
                title: Text(item.inviterDisplayName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '邀请你加入「${item.groupDisplayName}」',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    if (invitationId == null)
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
                                await ref
                                    .read(chatRepoProvider)
                                    .rejectGroupInvitation(
                                      invitationId: invitationId,
                                    );
                                onDataChanged();
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
                                await ref
                                    .read(chatRepoProvider)
                                    .acceptGroupInvitation(
                                      invitationId: invitationId,
                                    );
                                onDataChanged();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('已加入群聊')),
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
                onTap: inviterId == null
                    ? null
                    : () => context.push('${Routes.userDetail}/$inviterId/true'),
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
    final async = ref.watch(groupInvitationPendingOutgoingProvider);

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
                    ref.invalidate(groupInvitationPendingOutgoingProvider),
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
              ref.invalidate(groupInvitationPendingOutgoingProvider);
              await ref.read(groupInvitationPendingOutgoingProvider.future);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: Text('暂无发出的邀请')),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(groupInvitationPendingOutgoingProvider);
            await ref.read(groupInvitationPendingOutgoingProvider.future);
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = list[index];
              final inviteeId = item.inviteeUserId;
              return ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  backgroundImage: item.inviteeAvatar != null &&
                          item.inviteeAvatar!.trim().isNotEmpty
                      ? NetworkImage(item.inviteeAvatar!)
                      : null,
                  child: item.inviteeAvatar == null ||
                          item.inviteeAvatar!.trim().isEmpty
                      ? Text(
                          item.inviteeDisplayName.isNotEmpty
                              ? item.inviteeDisplayName.substring(0, 1)
                              : '?',
                          style: const TextStyle(fontSize: 14),
                        )
                      : null,
                ),
                title: Text(item.inviteeDisplayName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '等待对方加入「${item.groupDisplayName}」',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatConversationListTime(item.createTime),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                onTap: inviteeId == null
                    ? null
                    : () => context.push('${Routes.userDetail}/$inviteeId/true'),
              );
            },
          ),
        );
      },
    );
  }
}

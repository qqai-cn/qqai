import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/app_action_colors.dart';

import '../../components/qq_tab_bar.dart';
import '../../router/app_routes.dart';
import '../../util/conversation_list_time_format.dart';
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

  Future<void> _showApplyDialog() async {
    final result = await showDialog<_ApplyFriendResult>(
      context: context,
      builder: (ctx) => const _ApplyFriendDialog(),
    );
    if (result == null || !mounted) return;
    final friendUserId = int.tryParse(result.friendUserIdRaw);
    if (friendUserId == null) return;
    try {
      await ref.read(friendRepoProvider).applyFriend(
            friendUserId: friendUserId,
            applyMessage:
                result.applyMessage.trim().isEmpty ? null : result.applyMessage.trim(),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('申请已发送')),
      );
      ref.invalidate(friendPendingOutgoingProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发送失败：$e')),
        );
      }
    }
  }

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

/// 添加好友弹窗的返回值（由 [_ApplyFriendDialog] 在点「发送」时 pop）
class _ApplyFriendResult {
  const _ApplyFriendResult({
    required this.friendUserIdRaw,
    required this.applyMessage,
  });

  final String friendUserIdRaw;
  final String applyMessage;
}

class _ApplyFriendDialog extends StatefulWidget {
  const _ApplyFriendDialog();

  @override
  State<_ApplyFriendDialog> createState() => _ApplyFriendDialogState();
}

class _ApplyFriendDialogState extends State<_ApplyFriendDialog> {
  late final TextEditingController _idCtrl;
  late final TextEditingController _msgCtrl;

  @override
  void initState() {
    super.initState();
    _idCtrl = TextEditingController();
    _msgCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label, {String? hintText}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFF8F9FB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF3578E5), width: 1.2),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  Widget _dialogHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.person_add_alt_1_rounded,
            color: Color(0xFF3578E5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '添加好友',
                style: TextStyle(
                  color: AppActionColors.strong(context),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '通过千千号搜索并发送好友申请',
                style: TextStyle(
                  color: AppActionColors.muted(context),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: '关闭',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  void _submit() {
    final id = _idCtrl.text.trim();
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入对方千千号')),
      );
      return;
    }
    Navigator.pop(
      context,
      _ApplyFriendResult(
        friendUserIdRaw: id,
        applyMessage: _msgCtrl.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _dialogHeader(),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _idCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.next,
                    decoration: _fieldDecoration(
                      '千千号 *',
                      hintText: '输入对方千千号',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _msgCtrl,
                    minLines: 2,
                    maxLines: 4,
                    decoration: _fieldDecoration(
                      '验证消息',
                      hintText: '简单介绍一下自己（可选）',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      backgroundColor: const Color(0xFF3578E5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                    onPressed: _submit,
                    child: const Text(
                      '发送申请',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

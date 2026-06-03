import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/default_asset_image.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/constant/constant.dart';
import 'package:qqai/features/chat/data/models/chat_models.dart';
import 'package:qqai/features/chat/data/repos/chat_repo.dart';
import 'package:qqai/features/chat/providers/chat_providers.dart';
import 'package:qqai/providers/auth_providers.dart';
import 'package:qqai/router/app_routes.dart';

class ChatConversationSettingsPage extends ConsumerStatefulWidget {
  const ChatConversationSettingsPage({super.key, required this.conversationId});

  final int conversationId;

  @override
  ConsumerState<ChatConversationSettingsPage> createState() =>
      _ChatConversationSettingsPageState();
}

class _ChatConversationSettingsPageState
    extends ConsumerState<ChatConversationSettingsPage> {
  bool _loading = true;
  String? _error;
  ChatConversationDto? _conversation;
  bool _saving = false;
  List<ChatGroupMemberDto> _members = [];
  bool _membersLoading = false;
  String? _membersError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final conversation = await ref
          .read(chatRepoProvider)
          .getConversation(widget.conversationId);
      if (!mounted) return;
      setState(() {
        _conversation = conversation;
        _loading = false;
      });
      if (conversation.isGroup) {
        await _loadMembers();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _loadMembers() async {
    setState(() {
      _membersLoading = true;
      _membersError = null;
    });
    try {
      final members = await ref
          .read(chatRepoProvider)
          .listGroupMembers(widget.conversationId);
      if (!mounted) return;
      setState(() {
        _members = members;
        _membersLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _membersError = e.toString();
        _membersLoading = false;
      });
    }
  }

  Future<void> _invalidateConversations() async {
    ref.invalidate(chatConversationsProvider);
  }

  Future<void> _togglePin(bool value) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(chatRepoProvider).updateConversationPinned(
            conversationId: widget.conversationId,
            pinned: value,
          );
      if (!mounted) return;
      setState(() {
        _conversation = _conversation?.copyWith(pinned: value);
        _saving = false;
      });
      await _invalidateConversations();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value ? '已置顶' : '已取消置顶')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('操作失败：$e')));
    }
  }

  Future<void> _toggleMute(bool value) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(chatRepoProvider).updateConversationMuted(
            conversationId: widget.conversationId,
            muted: value,
          );
      if (!mounted) return;
      setState(() {
        _conversation = _conversation?.copyWith(muted: value);
        _saving = false;
      });
      await _invalidateConversations();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value ? '已开启免打扰' : '已关闭免打扰')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('操作失败：$e')));
    }
  }

  Future<void> _editGroupName() async {
    final conversation = _conversation;
    if (conversation == null || !conversation.isGroup) return;

    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => _EditGroupNameDialog(
        initialName: conversation.name ?? '',
      ),
    );
    if (newName == null || newName.isEmpty || !mounted) return;

    setState(() => _saving = true);
    try {
      await ref.read(chatRepoProvider).updateGroupConversation(
            conversationId: widget.conversationId,
            name: newName,
          );
      if (!mounted) return;
      setState(() {
        _conversation = _conversation?.copyWith(name: newName);
        _saving = false;
      });
      await _invalidateConversations();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('群名称已更新')));
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('修改失败：$e')));
    }
  }

  Future<void> _confirmDelete() async {
    final conversation = _conversation;
    if (conversation == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除会话'),
        content: Text('确定删除与「${conversation.displayTitle}」的会话吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除', style: TextStyle(color: Color(0xFFE53935))),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    setState(() => _saving = true);
    try {
      await ref.read(chatRepoProvider).deleteConversation(widget.conversationId);
      await _invalidateConversations();
      if (!mounted) return;
      context.go(Routes.messagePage);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除失败：$e')));
    }
  }

  void _openUserProfile() {
    final peerUserId = _conversation?.peerUserId;
    if (peerUserId == null) return;
    context.push('${Routes.userDetail}/$peerUserId/true');
  }

  void _openMemberProfile(int userId) {
    context.push('${Routes.userDetail}/$userId/true');
  }

  Widget _buildAvatar(ChatConversationDto conversation) {
    final avatar = conversation.avatar;
    if (avatar != null && avatar.isNotEmpty) {
      return CircleAvatar(
        radius: 36,
        backgroundImage: CachedNetworkImageProvider(avatar),
      );
    }

    return const CircleAvatar(radius: 36, child: DefaultAssetImage());
  }

  @override
  Widget build(BuildContext context) {
    final conversation = _conversation;
    final isGroup = conversation?.isGroup == true;
    final selfId = int.tryParse(ref.watch(authProvider).userId ?? '');
    final isGroupOwner =
        isGroup && selfId != null && conversation?.creatorId == selfId;
    final showDeleteConversation = !isGroup || isGroupOwner;
    final title = isGroup ? '群聊设置' : '聊天设置';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('加载失败', style: context.typo.body),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _load, child: const Text('重试')),
                ],
              ),
            )
          : conversation == null
          ? const SizedBox.shrink()
          : ListView(
              children: [
                const SizedBox(height: 24),
                Column(
                  children: [
                    _buildAvatar(conversation),
                    const SizedBox(height: 12),
                    Text(
                      conversation.displayTitle,
                      style: context.typo.cardTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isGroup
                          ? '群聊 · ${conversation.memberCount ?? 0} 人'
                          : '单聊',
                      style: context.typo.caption.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (isGroup) ...[
                  _buildGroupMembersSection(),
                  const SizedBox(height: 12),
                ],
                _section([
                  SwitchListTile(
                    title: const Text('置顶聊天'),
                    secondary: const Icon(Icons.push_pin_outlined),
                    value: conversation.pinned == true,
                    onChanged: _saving
                        ? null
                        : (value) => _togglePin(value),
                  ),
                  const Divider(height: 1, indent: 16),
                  SwitchListTile(
                    title: const Text('消息免打扰'),
                    secondary: const Icon(CupertinoIcons.bell_slash),
                    value: conversation.muted == true,
                    onChanged: _saving
                        ? null
                        : (value) => _toggleMute(value),
                  ),
                ]),
                const SizedBox(height: 12),
                if (isGroup)
                  _section([
                    ListTile(
                      leading: const Icon(Icons.edit_outlined),
                      title: const Text('群聊名称'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              conversation.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: _saving ? null : _editGroupName,
                    ),
                  ])
                else
                  _section([
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('查看资料'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _openUserProfile,
                    ),
                  ]),
                if (showDeleteConversation) ...[
                  const SizedBox(height: 12),
                  _section([
                    ListTile(
                      leading: const Icon(
                        CupertinoIcons.delete,
                        color: Color(0xFFE53935),
                      ),
                      title: const Text(
                        '删除会话',
                        style: TextStyle(color: Color(0xFFE53935)),
                      ),
                      onTap: _saving ? null : _confirmDelete,
                    ),
                  ]),
                ],
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _buildGroupMembersSection() {
    final selfId = int.tryParse(ref.watch(authProvider).userId ?? '');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('群成员', style: context.typo.body.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (_membersLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_membersError != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Text(
                      '成员加载失败',
                      style: context.typo.caption.copyWith(color: Colors.grey[600]),
                    ),
                    TextButton(onPressed: _loadMembers, child: const Text('重试')),
                  ],
                ),
              )
            else if (_members.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '暂无成员',
                  style: context.typo.caption.copyWith(color: Colors.grey[600]),
                ),
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                children: [
                  for (final member in _members)
                    SizedBox(
                      width: 48,
                      child: _GroupMemberTile(
                        name: member.userId != null && member.userId == selfId
                            ? '${member.label}（我）'
                            : member.label,
                        avatar: member.avatar,
                        onTap: member.userId == null
                            ? null
                            : () => _openMemberProfile(member.userId!),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _section(List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }
}

class _EditGroupNameDialog extends StatefulWidget {
  const _EditGroupNameDialog({required this.initialName});

  final String initialName;

  @override
  State<_EditGroupNameDialog> createState() => _EditGroupNameDialogState();
}

class _EditGroupNameDialogState extends State<_EditGroupNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('修改群名称'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 30,
        decoration: const InputDecoration(hintText: '请输入群名称'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            final text = _controller.text.trim();
            if (text.isEmpty) return;
            Navigator.pop(context, text);
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}

class _GroupMemberTile extends StatelessWidget {
  const _GroupMemberTile({
    required this.name,
    required this.avatar,
    this.onTap,
  });

  final String name;
  final String? avatar;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: avatar != null && avatar!.isNotEmpty
                  ? Image(
                image: CachedNetworkImageProvider(avatar!),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const DefaultAssetImage(
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              )
                  : const DefaultAssetImage(
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.typo.caption.copyWith(fontSize: 10, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

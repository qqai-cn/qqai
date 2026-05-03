import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../chat/data/repos/chat_repo.dart';
import '../chat/providers/chat_providers.dart';
import '../../providers/auth_providers.dart';
import '../../router/app_routes.dart';

/// 解析「1,2,3」「1 2 3」「1，2」等成员 ID 列表。
List<int> parseMemberIdList(String raw) {
  final normalized = raw.replaceAll('，', ',').replaceAll('、', ',');
  final parts = normalized.split(RegExp(r'[\s,;，、]+'));
  final out = <int>[];
  for (final p in parts) {
    final v = int.tryParse(p.trim());
    if (v != null) out.add(v);
  }
  return out;
}

Future<void> showCreateGroupChatDialog(
  BuildContext parentContext,
  WidgetRef ref,
) async {
  final newId = await showDialog<int>(
    context: parentContext,
    builder: (ctx) => _CreateGroupChatForm(parentRef: ref),
  );
  if (newId == null) return;
  ref.invalidate(chatConversationsProvider);
  if (!parentContext.mounted) return;
  ScaffoldMessenger.of(parentContext).showSnackBar(
    const SnackBar(content: Text('群聊已创建')),
  );
  parentContext.push('${Routes.chat}/$newId');
}

class _CreateGroupChatForm extends StatefulWidget {
  const _CreateGroupChatForm({required this.parentRef});

  final WidgetRef parentRef;

  @override
  State<_CreateGroupChatForm> createState() => _CreateGroupChatFormState();
}

class _CreateGroupChatFormState extends State<_CreateGroupChatForm> {
  final _nameCtrl = TextEditingController();
  final _membersCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _membersCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = widget.parentRef.read(authProvider);
    final selfId = int.tryParse(auth.userId ?? '');
    var ids = parseMemberIdList(_membersCtrl.text);
    if (ids.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少填写一个成员用户 ID')),
      );
      return;
    }
    if (selfId != null && !ids.contains(selfId)) {
      ids = [selfId, ...ids];
    }
    setState(() => _submitting = true);
    try {
      final conv = await widget.parentRef.read(chatRepoProvider).createGroupConversation(
            name: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
            memberIds: ids,
          );
      final id = conv.id;
      if (!mounted) return;
      if (id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('创建成功但未返回会话 ID')),
        );
        Navigator.of(context).pop();
        return;
      }
      Navigator.of(context).pop(id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('创建失败：$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('创建群聊'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: '群名称（可选）',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _membersCtrl,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: '成员用户 ID',
                hintText: '多个用逗号或空格分隔；未填自己时将自动补充当前账号',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('创建'),
        ),
      ],
    );
  }
}

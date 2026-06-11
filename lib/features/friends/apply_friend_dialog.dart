import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';

import 'data/friend_repo.dart';
import 'providers/friend_providers.dart';

class ApplyFriendResult {
  const ApplyFriendResult({
    required this.friendUserIdRaw,
    required this.applyMessage,
  });

  final String friendUserIdRaw;
  final String applyMessage;
}

Future<void> showApplyFriendDialog(BuildContext context, WidgetRef ref) async {
  final result = await showDialog<ApplyFriendResult>(
    context: context,
    builder: (ctx) => const ApplyFriendDialog(),
  );
  if (result == null || !context.mounted) return;
  final friendUserId = int.tryParse(result.friendUserIdRaw);
  if (friendUserId == null) return;
  try {
    await ref.read(friendRepoProvider).applyFriend(
          friendUserId: friendUserId,
          applyMessage: result.applyMessage.trim().isEmpty
              ? null
              : result.applyMessage.trim(),
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('申请已发送')),
    );
    ref.invalidate(friendPendingOutgoingProvider);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送失败：$e')),
      );
    }
  }
}

class ApplyFriendDialog extends StatefulWidget {
  const ApplyFriendDialog({super.key});

  @override
  State<ApplyFriendDialog> createState() => _ApplyFriendDialogState();
}

class _ApplyFriendDialogState extends State<ApplyFriendDialog> {
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
      labelStyle: TextStyle(color: AppActionColors.muted(context)),
      hintStyle: TextStyle(color: AppActionColors.subtle(context)),
      filled: true,
      fillColor: GoodsPageStyle.imageBg(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: GoodsPageStyle.border(context)),
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
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFEFF6FF)
                : const Color(0xFF3578E5).withValues(alpha: 0.18),
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
          icon: Icon(
            Icons.close,
            color: AppActionColors.foreground(context),
          ),
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
      ApplyFriendResult(
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
            color: AppActionColors.surface(context),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: GoodsPageStyle.border(context)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.light
                      ? 0.12
                      : 0.35,
                ),
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
                    style: TextStyle(color: AppActionColors.strong(context)),
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
                    style: TextStyle(color: AppActionColors.strong(context)),
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
                      disabledBackgroundColor:
                          AppActionColors.borderSubtle(context),
                      disabledForegroundColor: AppActionColors.subtle(context),
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

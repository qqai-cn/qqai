import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';

import '../providers/ai_assistants_provider.dart';
import '../data/repos/ai_chat_repo.dart';

/// 添加 AI 助手（对标后管「新建对话」）
Future<int?> showAddAiAssistantDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final result = await showDialog<_AddAiAssistantResult>(
    context: context,
    builder: (ctx) => const _AddAiAssistantDialog(),
  );
  if (result == null || !context.mounted) return null;
  try {
    final id = await ref.read(aiChatRepoProvider).createAssistant(
          title: result.title,
          systemMessage: result.systemMessage.isEmpty
              ? null
              : result.systemMessage,
        );
    ref.invalidate(aiAssistantsProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已添加 AI 助手')),
      );
    }
    return id;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('添加失败：$e')),
      );
    }
    return null;
  }
}

class _AddAiAssistantResult {
  const _AddAiAssistantResult({
    required this.title,
    required this.systemMessage,
  });

  final String title;
  final String systemMessage;
}

class _AddAiAssistantDialog extends StatefulWidget {
  const _AddAiAssistantDialog();

  @override
  State<_AddAiAssistantDialog> createState() => _AddAiAssistantDialogState();
}

class _AddAiAssistantDialogState extends State<_AddAiAssistantDialog> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _sysCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: 'AI助手');
    _sysCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _sysCtrl.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: AppActionColors.muted(context)),
      hintStyle: TextStyle(color: AppActionColors.subtle(context)),
      filled: true,
      fillColor: GoodsPageStyle.sectionBg(context),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加AI助手'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              autofocus: true,
              decoration: _dec('助手名称', hint: '例如：写作助手'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _sysCtrl,
              minLines: 3,
              maxLines: 5,
              decoration: _dec('角色设定（可选）', hint: '例如：你是一位资深文案'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            final title = _titleCtrl.text.trim();
            if (title.isEmpty) return;
            Navigator.pop(
              context,
              _AddAiAssistantResult(
                title: title,
                systemMessage: _sysCtrl.text.trim(),
              ),
            );
          },
          child: const Text('添加'),
        ),
      ],
    );
  }
}

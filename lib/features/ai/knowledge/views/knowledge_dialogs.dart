import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/features/search/theme/search_ai_theme.dart';
import 'package:qqai/util/api_error_message.dart';

import '../data/knowledge_models.dart';
import '../data/knowledge_repo.dart';
import '../providers/knowledge_providers.dart';
import 'knowledge_ai_shell.dart';

void _toast(BuildContext context, Object error) {
  final messenger = ScaffoldMessenger.maybeOf(context) ??
      ScaffoldMessenger.of(
        Navigator.of(context, rootNavigator: true).context,
      );
  messenger.showSnackBar(
    SnackBar(
      content: Text(ApiErrorMessage.userMessage(error)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Future<bool> showKnowledgeFormDialog(
  BuildContext context,
  WidgetRef ref, {
  KnowledgeDto? existing,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (ctx) => _KnowledgeFormDialog(existing: existing),
  );
  if (ok == true) {
    ref.invalidate(knowledgeListProvider);
    if (existing?.id != null) {
      ref.invalidate(knowledgeDetailProvider(existing!.id!));
    }
  }
  return ok == true;
}

Future<bool> showKnowledgeSegmentFormDialog(
  BuildContext context,
  WidgetRef ref, {
  required int documentId,
  KnowledgeSegmentDto? existing,
}) async {
  final contentCtrl = TextEditingController(text: existing?.content ?? '');
  final ai = SearchAiTheme.of(context);
  final ok = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: ai.cardBg,
        surfaceTintColor: Colors.transparent,
        title: Text(
          existing == null ? '新增分段' : '编辑分段',
          style: TextStyle(color: ai.text, fontWeight: FontWeight.w700),
        ),
        content: SizedBox(
          width: 420,
          child: TextField(
            controller: contentCtrl,
            minLines: 6,
            maxLines: 12,
            style: TextStyle(color: ai.text),
            decoration: knowledgeAiInput(ctx, '分段内容').copyWith(labelText: null),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            style: knowledgeAiPrimaryButton(),
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(true),
            child: const Text('确定'),
          ),
        ],
      );
    },
  );
  if (ok != true) {
    contentCtrl.dispose();
    return false;
  }
  final text = contentCtrl.text.trim();
  contentCtrl.dispose();
  if (text.isEmpty) return false;
  try {
    final repo = ref.read(knowledgeRepoProvider);
    if (existing?.id != null) {
      await repo.updateSegment(id: existing!.id!, content: text);
    } else {
      await repo.createSegment(documentId: documentId, content: text);
    }
    ref.invalidate(knowledgeSegmentListProvider(documentId));
    return true;
  } catch (e) {
    if (context.mounted) _toast(context, e);
    return false;
  }
}

class _KnowledgeFormDialog extends ConsumerStatefulWidget {
  const _KnowledgeFormDialog({this.existing});

  final KnowledgeDto? existing;

  @override
  ConsumerState<_KnowledgeFormDialog> createState() =>
      _KnowledgeFormDialogState();
}

class _KnowledgeFormDialogState extends ConsumerState<_KnowledgeFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _topKCtrl;
  late final TextEditingController _thresholdCtrl;
  late bool _enabled;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _descCtrl = TextEditingController(text: e?.description ?? '');
    _topKCtrl = TextEditingController(text: '${e?.topK ?? 5}');
    _thresholdCtrl = TextEditingController(
      text: (e?.similarityThreshold ?? 0.5).toString(),
    );
    _enabled = e?.enabled ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _topKCtrl.dispose();
    _thresholdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _toast(context, '请输入知识库名称');
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(knowledgeRepoProvider);
      final topK = int.tryParse(_topKCtrl.text.trim());
      final threshold = double.tryParse(_thresholdCtrl.text.trim());
      final status = _enabled ? 0 : 1;
      if (widget.existing?.id != null) {
        await repo.update(
          id: widget.existing!.id!,
          name: name,
          description: _descCtrl.text.trim(),
          topK: topK,
          similarityThreshold: threshold,
          status: status,
        );
      } else {
        await repo.create(
          name: name,
          description: _descCtrl.text.trim(),
          topK: topK,
          similarityThreshold: threshold,
          status: status,
        );
      }
      if (!mounted) return;
      // 成功后立刻关掉弹窗，不要再 setState，否则退出动画中重建会导致弹层关不掉
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop(true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _toast(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return AlertDialog(
      backgroundColor: ai.cardBg,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: ai.cardBorder),
      ),
      title: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: ai.aiBadgeGradient,
            ),
            child: const Icon(Icons.auto_awesome, size: 15, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            widget.existing == null ? '新建知识库' : '编辑知识库',
            style: TextStyle(color: ai.text, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameCtrl,
                style: TextStyle(color: ai.text),
                decoration: knowledgeAiInput(context, '知识库名称'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descCtrl,
                minLines: 2,
                maxLines: 4,
                style: TextStyle(color: ai.text),
                decoration: knowledgeAiInput(context, '知识库描述'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _topKCtrl,
                      style: TextStyle(color: ai.text),
                      keyboardType: TextInputType.number,
                      decoration: knowledgeAiInput(context, '检索 topK'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _thresholdCtrl,
                      style: TextStyle(color: ai.text),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: knowledgeAiInput(context, '相似度阈值'),
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('启用', style: TextStyle(color: ai.text)),
                activeThumbColor: SearchAiTheme.cyan,
                value: _enabled,
                onChanged: _saving ? null : (v) => setState(() => _enabled = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving
              ? null
              : () => Navigator.of(context, rootNavigator: true).pop(false),
          child: Text('取消', style: TextStyle(color: ai.textSecondary)),
        ),
        FilledButton(
          style: knowledgeAiPrimaryButton(),
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('确定'),
        ),
      ],
    );
  }
}

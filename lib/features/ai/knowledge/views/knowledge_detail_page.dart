import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/features/ai/providers/ai_assistants_provider.dart';
import 'package:qqai/features/search/theme/search_ai_theme.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/api_base_client.dart';
import 'package:qqai/util/api_error_message.dart';

import '../data/knowledge_models.dart';
import '../data/knowledge_repo.dart';
import '../providers/knowledge_providers.dart';
import 'knowledge_ai_shell.dart';
import 'knowledge_dialogs.dart';

class KnowledgeDetailPage extends ConsumerWidget {
  const KnowledgeDetailPage({super.key, required this.knowledgeId});

  final int knowledgeId;

  Future<void> _ask(BuildContext context, WidgetRef ref) async {
    try {
      final id = await ref.read(knowledgeRepoProvider).createChat(knowledgeId);
      ref.invalidate(aiAssistantsProvider);
      if (context.mounted) {
        context.go('${Routes.messagePage}?aiConversationId=$id');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ApiErrorMessage.userMessage(e)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _uploadFiles(BuildContext context, WidgetRef ref) async {
    const group = XTypeGroup(
      label: '文档',
      extensions: ['txt', 'md', 'html', 'csv', 'json'],
    );
    final files = await openFiles(acceptedTypeGroups: [group]);
    if (files.isEmpty || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Text('正在导入文档…'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    try {
      final repo = ref.read(knowledgeRepoProvider);
      for (final file in files) {
        final url = await ApiBaseClient.uploadFile(
          file: file,
          directory: 'qqai/knowledge',
        );
        await repo.createDocument(
          knowledgeId: knowledgeId,
          name: file.name,
          url: url,
          segmentMaxTokens: 500,
        );
      }
      ref.invalidate(knowledgeDocumentListProvider(knowledgeId));
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text('已导入 ${files.length} 个文档'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(ApiErrorMessage.userMessage(e)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _importUrl(BuildContext context, WidgetRef ref) async {
    final nameCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    final ai = SearchAiTheme.of(context);
    final ok = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: ai.cardBg,
        surfaceTintColor: Colors.transparent,
        title: Text(
          '从链接导入',
          style: TextStyle(color: ai.text, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: TextStyle(color: ai.text),
              decoration: knowledgeAiInput(ctx, '文档名称'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlCtrl,
              style: TextStyle(color: ai.text),
              decoration: knowledgeAiInput(ctx, '文档 URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(false),
            child: Text('取消', style: TextStyle(color: ai.textSecondary)),
          ),
          FilledButton(
            style: knowledgeAiPrimaryButton(),
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(true),
            child: const Text('导入'),
          ),
        ],
      ),
    );
    final name = nameCtrl.text.trim();
    final url = urlCtrl.text.trim();
    nameCtrl.dispose();
    urlCtrl.dispose();
    if (ok != true || name.isEmpty || url.isEmpty) return;
    try {
      await ref.read(knowledgeRepoProvider).createDocument(
            knowledgeId: knowledgeId,
            name: name,
            url: url,
            segmentMaxTokens: 500,
          );
      ref.invalidate(knowledgeDocumentListProvider(knowledgeId));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ApiErrorMessage.userMessage(e)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final knowledge = ref.watch(knowledgeDetailProvider(knowledgeId));
    final docs = ref.watch(knowledgeDocumentListProvider(knowledgeId));
    final ai = SearchAiTheme.of(context);
    return KnowledgeAiScaffold(
      title: knowledge.asData?.value.name ?? '知识库',
      actions: [
        IconButton(
          tooltip: '编辑',
          icon: const Icon(Icons.edit_outlined),
          color: SearchAiTheme.cyan,
          onPressed: () {
            final current = knowledge.asData?.value;
            if (current != null) {
              showKnowledgeFormDialog(context, ref, existing: current);
            }
          },
        ),
        IconButton(
          tooltip: '召回测试',
          icon: const Icon(Icons.manage_search_outlined),
          onPressed: () =>
              context.push('${Routes.knowledge}/$knowledgeId/retrieval'),
        ),
        IconButton(
          tooltip: '问答',
          icon: const Icon(Icons.auto_awesome),
          color: SearchAiTheme.cyan,
          onPressed: () => _ask(context, ref),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: SearchAiTheme.brandRed,
        foregroundColor: Colors.white,
        onPressed: () async {
          final action = await showModalBottomSheet<String>(
            context: context,
            useRootNavigator: true,
            backgroundColor: ai.cardBg,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (ctx) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.upload_file,
                      color: SearchAiTheme.cyan,
                    ),
                    title: Text('上传文件', style: TextStyle(color: ai.text)),
                    subtitle: Text(
                      'txt / md / html / csv',
                      style: TextStyle(color: ai.textSecondary),
                    ),
                    onTap: () =>
                        Navigator.of(ctx, rootNavigator: true).pop('file'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.link, color: SearchAiTheme.cyan),
                    title: Text('从链接导入', style: TextStyle(color: ai.text)),
                    onTap: () =>
                        Navigator.of(ctx, rootNavigator: true).pop('url'),
                  ),
                ],
              ),
            ),
          );
          if (!context.mounted) return;
          if (action == 'file') await _uploadFiles(context, ref);
          if (!context.mounted) return;
          if (action == 'url') await _importUrl(context, ref);
        },
        icon: const Icon(Icons.add),
        label: const Text('添加文档'),
      ),
      body: docs.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: SearchAiTheme.cyan),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              ApiErrorMessage.userMessage(e),
              style: TextStyle(color: ai.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 44,
                      color: SearchAiTheme.cyan.withValues(alpha: 0.9),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '还没有文档',
                      style: TextStyle(
                        color: ai.text,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '上传资料后，AI 就能按你的知识库回答',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ai.textSecondary, height: 1.5),
                    ),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            color: SearchAiTheme.cyan,
            onRefresh: () async {
              ref.invalidate(knowledgeDocumentListProvider(knowledgeId));
              await ref.read(knowledgeDocumentListProvider(knowledgeId).future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: list.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final doc = list[index];
                return _DocumentTile(
                  knowledgeId: knowledgeId,
                  document: doc,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _DocumentTile extends ConsumerWidget {
  const _DocumentTile({required this.knowledgeId, required this.document});

  final int knowledgeId;
  final KnowledgeDocumentDto document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ai = SearchAiTheme.of(context);
    return KnowledgeAiCard(
      onTap: document.id == null
          ? null
          : () => context.push(
                '${Routes.knowledge}/$knowledgeId/document/${document.id}',
              ),
      padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: ai.aiBadgeGradient,
            ),
            child: const Icon(Icons.description_outlined, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name ?? '未命名文档',
                  style: TextStyle(
                    color: ai.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    if (document.contentLength != null)
                      '${document.contentLength} 字',
                    if (document.tokens != null) '${document.tokens} token',
                    if (!document.enabled) '已停用',
                  ].join(' · '),
                  style: TextStyle(color: ai.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            activeThumbColor: SearchAiTheme.cyan,
            value: document.enabled,
            onChanged: document.id == null
                ? null
                : (v) async {
                    try {
                      await ref.read(knowledgeRepoProvider).updateDocumentStatus(
                            id: document.id!,
                            status: v ? 0 : 1,
                          );
                      ref.invalidate(
                        knowledgeDocumentListProvider(knowledgeId),
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ApiErrorMessage.userMessage(e)),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
          ),
          PopupMenuButton<String>(
            color: ai.cardBg,
            icon: Icon(Icons.more_horiz, color: ai.textSecondary),
            onSelected: (value) async {
              final repo = ref.read(knowledgeRepoProvider);
              if (value == 'segments' && document.id != null) {
                context.push(
                  '${Routes.knowledge}/$knowledgeId/document/${document.id}',
                );
                return;
              }
              if (value == 'delete' && document.id != null) {
                final ok = await showDialog<bool>(
                  context: context,
                  useRootNavigator: true,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: ai.cardBg,
                    title: Text('删除文档', style: TextStyle(color: ai.text)),
                    content: Text(
                      '确定删除「${document.name ?? ''}」吗？',
                      style: TextStyle(color: ai.textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.of(ctx, rootNavigator: true).pop(false),
                        child: const Text('取消'),
                      ),
                      FilledButton(
                        style: knowledgeAiPrimaryButton(),
                        onPressed: () =>
                            Navigator.of(ctx, rootNavigator: true).pop(true),
                        child: const Text('删除'),
                      ),
                    ],
                  ),
                );
                if (ok != true) return;
                try {
                  await repo.deleteDocument(document.id!);
                  ref.invalidate(knowledgeDocumentListProvider(knowledgeId));
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ApiErrorMessage.userMessage(e)),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'segments',
                child: Text('分段', style: TextStyle(color: ai.text)),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  '删除',
                  style: TextStyle(color: SearchAiTheme.brandRed),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

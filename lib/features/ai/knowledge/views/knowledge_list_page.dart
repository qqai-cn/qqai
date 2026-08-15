import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/features/ai/providers/ai_assistants_provider.dart';
import 'package:qqai/features/search/theme/search_ai_theme.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/api_error_message.dart';

import '../data/knowledge_models.dart';
import '../data/knowledge_repo.dart';
import '../providers/knowledge_providers.dart';
import 'knowledge_ai_shell.dart';
import 'knowledge_dialogs.dart';

class KnowledgeListPage extends ConsumerWidget {
  const KnowledgeListPage({super.key});

  Future<void> _ask(BuildContext context, WidgetRef ref, KnowledgeDto item) async {
    if (item.id == null) return;
    try {
      final id = await ref.read(knowledgeRepoProvider).createChat(item.id!);
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

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    KnowledgeDto item,
  ) async {
    final ai = SearchAiTheme.of(context);
    final ok = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: ai.cardBg,
        title: Text('删除知识库', style: TextStyle(color: ai.text)),
        content: Text(
          '确定删除「${item.name ?? ''}」及其中的文档吗？',
          style: TextStyle(color: ai.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            style: knowledgeAiPrimaryButton(),
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (ok != true || item.id == null) return;
    try {
      await ref.read(knowledgeRepoProvider).delete(item.id!);
      ref.invalidate(knowledgeListProvider);
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
    final async = ref.watch(knowledgeListProvider);
    final ai = SearchAiTheme.of(context);
    return KnowledgeAiScaffold(
      title: '知识库',
      actions: [
        IconButton(
          tooltip: '新建知识库',
          icon: const Icon(Icons.add_circle_outline),
          color: SearchAiTheme.cyan,
          onPressed: () => showKnowledgeFormDialog(context, ref),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: SearchAiTheme.brandRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('创建知识库'),
        onPressed: () => showKnowledgeFormDialog(context, ref),
      ),
      body: async.when(
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
                      size: 48,
                      color: SearchAiTheme.cyan.withValues(alpha: 0.9),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '还没有知识库',
                      style: TextStyle(
                        color: ai.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '把文档交给 AI，问答、召回都基于你的资料',
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
              ref.invalidate(knowledgeListProvider);
              await ref.read(knowledgeListProvider.future);
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                const padding = 16.0;
                const gap = 12.0;
                const minCard = 280.0;
                final inner = (constraints.maxWidth - padding * 2).clamp(
                  0.0,
                  double.infinity,
                );
                final columns = inner < minCard
                    ? 1
                    : (inner / (minCard + gap)).floor().clamp(1, 4);
                return GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(padding, 12, padding, 100),
                  itemCount: list.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: gap,
                    mainAxisSpacing: gap,
                    mainAxisExtent: 200,
                  ),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _KnowledgeListCard(
                      item: item,
                      onOpen: item.id == null
                          ? null
                          : () => context.push(
                              '${Routes.knowledge}/${item.id}',
                            ),
                      onMenu: (value) async {
                        if (value == 'edit') {
                          await showKnowledgeFormDialog(
                            context,
                            ref,
                            existing: item,
                          );
                        } else if (value == 'docs' && item.id != null) {
                          context.push('${Routes.knowledge}/${item.id}');
                        } else if (value == 'retrieval' && item.id != null) {
                          context.push(
                            '${Routes.knowledge}/${item.id}/retrieval',
                          );
                        } else if (value == 'ask') {
                          await _ask(context, ref, item);
                        } else if (value == 'delete') {
                          await _delete(context, ref, item);
                        }
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _KnowledgeListCard extends StatelessWidget {
  const _KnowledgeListCard({
    required this.item,
    required this.onMenu,
    this.onOpen,
  });

  final KnowledgeDto item;
  final VoidCallback? onOpen;
  final ValueChanged<String> onMenu;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    final desc = item.description ?? '';
    return KnowledgeAiCard(
      expand: true,
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: ai.aiBadgeGradient,
                ),
                child: const Icon(
                  Icons.menu_book_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                color: ai.cardBg,
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_horiz, color: ai.textSecondary),
                onSelected: onMenu,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('编辑', style: TextStyle(color: ai.text)),
                  ),
                  PopupMenuItem(
                    value: 'docs',
                    child: Text('文档', style: TextStyle(color: ai.text)),
                  ),
                  PopupMenuItem(
                    value: 'retrieval',
                    child: Text('召回测试', style: TextStyle(color: ai.text)),
                  ),
                  PopupMenuItem(
                    value: 'ask',
                    child: Text('问答', style: TextStyle(color: ai.text)),
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
          const SizedBox(height: 10),
          Text(
            item.name ?? '未命名',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ai.text,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              desc.isEmpty ? '暂无简介' : desc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: desc.isEmpty
                    ? ai.textSecondary.withValues(alpha: 0.7)
                    : ai.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _AiChip(
                label: item.enabled ? '已启用' : '已停用',
                active: item.enabled,
              ),
              _AiChip(label: 'topK ${item.topK ?? 5}'),
              _AiChip(label: item.embeddingModel ?? '向量模型'),
            ],
          ),
        ],
      ),
    );
  }
}

class _AiChip extends StatelessWidget {
  const _AiChip({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: active ? ai.accentSoft : ai.chipBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active ? SearchAiTheme.cyan.withValues(alpha: 0.45) : ai.chipBorder,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: active ? SearchAiTheme.cyan : ai.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

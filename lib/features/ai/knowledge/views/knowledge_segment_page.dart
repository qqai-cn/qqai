import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/features/search/theme/search_ai_theme.dart';
import 'package:qqai/util/api_error_message.dart';

import '../data/knowledge_repo.dart';
import '../providers/knowledge_providers.dart';
import 'knowledge_ai_shell.dart';
import 'knowledge_dialogs.dart';

class KnowledgeSegmentPage extends ConsumerWidget {
  const KnowledgeSegmentPage({
    super.key,
    required this.knowledgeId,
    required this.documentId,
  });

  final int knowledgeId;
  final int documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(knowledgeSegmentListProvider(documentId));
    final ai = SearchAiTheme.of(context);
    return KnowledgeAiScaffold(
      title: '文档分段',
      actions: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          color: SearchAiTheme.cyan,
          tooltip: '新增分段',
          onPressed: () => showKnowledgeSegmentFormDialog(
            context,
            ref,
            documentId: documentId,
          ),
        ),
      ],
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
              child: Text('暂无分段', style: TextStyle(color: ai.textSecondary)),
            );
          }
          return RefreshIndicator(
            color: SearchAiTheme.cyan,
            onRefresh: () async {
              ref.invalidate(knowledgeSegmentListProvider(documentId));
              await ref.read(knowledgeSegmentListProvider(documentId).future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: list.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = list[index];
                return KnowledgeAiCard(
                  padding: EdgeInsets.zero,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      expansionTileTheme: ExpansionTileThemeData(
                        iconColor: ai.textSecondary,
                        collapsedIconColor: ai.textSecondary,
                      ),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        '分段 ${item.id ?? index + 1}',
                        style: TextStyle(
                          color: ai.text,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        [
                          if (item.contentLength != null)
                            '${item.contentLength} 字',
                          if (item.tokens != null) '${item.tokens} token',
                          if (!item.enabled) '已停用',
                        ].join(' · '),
                        style: TextStyle(
                          color: ai.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item.content ?? '',
                              style: TextStyle(color: ai.text, height: 1.5),
                            ),
                          ),
                        ),
                        OverflowBar(
                          children: [
                            TextButton(
                              onPressed: item.id == null
                                  ? null
                                  : () => showKnowledgeSegmentFormDialog(
                                        context,
                                        ref,
                                        documentId: documentId,
                                        existing: item,
                                      ),
                              child: const Text('编辑'),
                            ),
                            TextButton(
                              onPressed: item.id == null
                                  ? null
                                  : () async {
                                      try {
                                        await ref
                                            .read(knowledgeRepoProvider)
                                            .updateSegmentStatus(
                                              id: item.id!,
                                              status: item.enabled ? 1 : 0,
                                            );
                                        ref.invalidate(
                                          knowledgeSegmentListProvider(
                                            documentId,
                                          ),
                                        );
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                ApiErrorMessage.userMessage(e),
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      }
                                    },
                              child: Text(item.enabled ? '停用' : '启用'),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: SearchAiTheme.brandRed,
                              ),
                              onPressed: item.id == null
                                  ? null
                                  : () async {
                                      try {
                                        await ref
                                            .read(knowledgeRepoProvider)
                                            .deleteSegment(item.id!);
                                        ref.invalidate(
                                          knowledgeSegmentListProvider(
                                            documentId,
                                          ),
                                        );
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                ApiErrorMessage.userMessage(e),
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      }
                                    },
                              child: const Text('删除'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/features/search/theme/search_ai_theme.dart';
import 'package:qqai/util/api_error_message.dart';

import '../data/knowledge_models.dart';
import '../data/knowledge_repo.dart';
import 'knowledge_ai_shell.dart';

class KnowledgeRetrievalPage extends ConsumerStatefulWidget {
  const KnowledgeRetrievalPage({super.key, required this.knowledgeId});

  final int knowledgeId;

  @override
  ConsumerState<KnowledgeRetrievalPage> createState() =>
      _KnowledgeRetrievalPageState();
}

class _KnowledgeRetrievalPageState
    extends ConsumerState<KnowledgeRetrievalPage> {
  final _queryCtrl = TextEditingController();
  int _topK = 5;
  bool _loading = false;
  List<KnowledgeSearchHitDto> _hits = const [];

  @override
  void dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _queryCtrl.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入要检索的内容'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final hits = await ref.read(knowledgeRepoProvider).search(
            knowledgeId: widget.knowledgeId,
            content: query,
            topK: _topK,
          );
      if (mounted) setState(() => _hits = hits);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ApiErrorMessage.userMessage(e)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return KnowledgeAiScaffold(
      title: '召回测试',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          KnowledgeAiCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _queryCtrl,
                  minLines: 4,
                  maxLines: 8,
                  maxLength: 200,
                  style: TextStyle(color: ai.text),
                  decoration: knowledgeAiInput(context, '查询文本').copyWith(
                    hintText: '输入一段话，看知识库会召回哪些段落',
                    labelText: null,
                    counterStyle: TextStyle(color: ai.textSecondary),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'topK',
                      style: TextStyle(color: ai.textSecondary),
                    ),
                    Expanded(
                      child: Slider(
                        min: 1,
                        max: 10,
                        divisions: 9,
                        activeColor: SearchAiTheme.cyan,
                        value: _topK.toDouble(),
                        label: '$_topK',
                        onChanged: (v) => setState(() => _topK = v.round()),
                      ),
                    ),
                    Text('$_topK', style: TextStyle(color: ai.text)),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: knowledgeAiPrimaryButton(),
                    onPressed: _loading ? null : _search,
                    child: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('开始召回'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (!_loading && _hits.isEmpty)
            Text(
              '暂无召回结果',
              style: TextStyle(color: ai.textSecondary),
            ),
          if (_hits.isNotEmpty)
            Text(
              '${_hits.length} 个召回段落',
              style: TextStyle(color: ai.text, fontWeight: FontWeight.w700),
            ),
          const SizedBox(height: 8),
          for (final hit in _hits) ...[
            KnowledgeAiCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '分段(${hit.id ?? '-'})',
                    style: TextStyle(fontSize: 12, color: ai.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hit.content ?? '',
                    style: TextStyle(color: ai.text, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

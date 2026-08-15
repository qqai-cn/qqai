import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/knowledge_models.dart';
import '../data/knowledge_repo.dart';

final knowledgeListProvider =
    FutureProvider.autoDispose<List<KnowledgeDto>>((ref) async {
  final result = await ref.watch(knowledgeRepoProvider).page(pageSize: 50);
  return result.list;
});

final knowledgeDetailProvider =
    FutureProvider.autoDispose.family<KnowledgeDto, int>((ref, id) async {
  return ref.watch(knowledgeRepoProvider).get(id);
});

final knowledgeDocumentListProvider = FutureProvider.autoDispose
    .family<List<KnowledgeDocumentDto>, int>((ref, knowledgeId) async {
  final result = await ref
      .watch(knowledgeRepoProvider)
      .documentPage(knowledgeId: knowledgeId, pageSize: 100);
  return result.list;
});

final knowledgeSegmentListProvider = FutureProvider.autoDispose
    .family<List<KnowledgeSegmentDto>, int>((ref, documentId) async {
  final result = await ref
      .watch(knowledgeRepoProvider)
      .segmentPage(documentId: documentId, pageSize: 100);
  return result.list;
});

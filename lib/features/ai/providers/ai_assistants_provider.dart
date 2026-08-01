import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/ai_chat_models.dart';
import '../data/repos/ai_chat_repo.dart';

/// AI 助手好友列表（含默认「千千AI助手」）
final aiAssistantsProvider =
    FutureProvider.autoDispose<List<AiChatConversationDto>>((ref) async {
  return ref.watch(aiChatRepoProvider).listAssistants();
});

final aiChatModelsProvider =
    FutureProvider.autoDispose<List<AiModelSimpleDto>>((ref) async {
  return ref.watch(aiChatRepoProvider).listChatModels();
});

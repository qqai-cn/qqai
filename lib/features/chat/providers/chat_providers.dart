import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/chat_models.dart';
import '../data/repos/chat_repo.dart';

part 'chat_providers.g.dart';

@riverpod
Future<List<ChatConversationDto>> chatConversations(Ref ref) async {
  return ref.watch(chatRepoProvider).listConversations();
}

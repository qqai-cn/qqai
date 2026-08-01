import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/ai_chat_models.dart';
import '../data/repos/ai_chat_repo.dart';

class AiChatPageState {
  const AiChatPageState({
    this.conversations = const [],
    this.messages = const [],
    this.activeConversationId,
    this.loadingConversations = false,
    this.loadingMessages = false,
    this.streaming = false,
    this.error,
    this.useContext = true,
  });

  final List<AiChatConversationDto> conversations;
  final List<AiChatMessageDto> messages;
  final int? activeConversationId;
  final bool loadingConversations;
  final bool loadingMessages;
  final bool streaming;
  final String? error;
  final bool useContext;

  AiChatConversationDto? get activeConversation {
    final id = activeConversationId;
    if (id == null) return null;
    for (final c in conversations) {
      if (c.id == id) return c;
    }
    return null;
  }

  AiChatPageState copyWith({
    List<AiChatConversationDto>? conversations,
    List<AiChatMessageDto>? messages,
    int? activeConversationId,
    bool clearActive = false,
    bool? loadingConversations,
    bool? loadingMessages,
    bool? streaming,
    String? error,
    bool clearError = false,
    bool? useContext,
  }) {
    return AiChatPageState(
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      activeConversationId:
          clearActive ? null : (activeConversationId ?? this.activeConversationId),
      loadingConversations: loadingConversations ?? this.loadingConversations,
      loadingMessages: loadingMessages ?? this.loadingMessages,
      streaming: streaming ?? this.streaming,
      error: clearError ? null : (error ?? this.error),
      useContext: useContext ?? this.useContext,
    );
  }
}

class AiChatNotifier extends Notifier<AiChatPageState> {
  CancelToken? _streamCancel;

  IAiChatRepo get _repo => ref.read(aiChatRepoProvider);

  @override
  AiChatPageState build() {
    ref.onDispose(() {
      _streamCancel?.cancel();
      _streamCancel = null;
    });
    return const AiChatPageState();
  }

  Future<void> bootstrap({int? conversationId}) async {
    await refreshConversations(selectId: conversationId);
  }

  Future<void> refreshConversations({int? selectId}) async {
    state = state.copyWith(loadingConversations: true, clearError: true);
    try {
      final list = await _repo.listMyConversations();
      list.sort((a, b) {
        final ap = a.pinned == true ? 1 : 0;
        final bp = b.pinned == true ? 1 : 0;
        if (ap != bp) return bp - ap;
        final at = a.createTimeParsed?.millisecondsSinceEpoch ?? 0;
        final bt = b.createTimeParsed?.millisecondsSinceEpoch ?? 0;
        return bt.compareTo(at);
      });
      final preferred = selectId ?? state.activeConversationId;
      int? nextId = preferred;
      if (nextId != null && !list.any((c) => c.id == nextId)) {
        nextId = list.isNotEmpty ? list.first.id : null;
      } else if (nextId == null && list.isNotEmpty) {
        nextId = list.first.id;
      }
      state = state.copyWith(
        conversations: list,
        loadingConversations: false,
        activeConversationId: nextId,
        clearActive: nextId == null,
      );
      if (nextId != null) {
        await selectConversation(nextId);
      } else {
        state = state.copyWith(messages: const []);
      }
    } catch (e) {
      state = state.copyWith(
        loadingConversations: false,
        error: e.toString(),
      );
    }
  }

  Future<void> selectConversation(int id) async {
    if (state.streaming) return;
    state = state.copyWith(
      activeConversationId: id,
      loadingMessages: true,
      clearError: true,
    );
    try {
      final messages = await _repo.listMessages(id);
      state = state.copyWith(messages: messages, loadingMessages: false);
    } catch (e) {
      state = state.copyWith(loadingMessages: false, error: e.toString());
    }
  }

  Future<void> createConversation() async {
    if (state.streaming) return;
    try {
      final id = await _repo.createMyConversation();
      await refreshConversations(selectId: id);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteConversation(int id) async {
    if (state.streaming) return;
    try {
      await _repo.deleteMyConversation(id);
      final clear = state.activeConversationId == id;
      await refreshConversations(selectId: clear ? null : state.activeConversationId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> togglePin(AiChatConversationDto conversation) async {
    final id = conversation.id;
    if (id == null) return;
    try {
      await _repo.updateMyConversation(
        id: id,
        pinned: !(conversation.pinned == true),
      );
      await refreshConversations(selectId: state.activeConversationId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void setUseContext(bool value) {
    state = state.copyWith(useContext: value);
  }

  Future<void> stopStreaming() => _stopStream();

  Future<void> _stopStream() async {
    _streamCancel?.cancel();
    _streamCancel = null;
    if (state.streaming) {
      state = state.copyWith(streaming: false);
    }
  }

  Future<void> sendMessage(String raw) async {
    final content = raw.trim();
    final conversationId = state.activeConversationId;
    if (content.isEmpty || conversationId == null || state.streaming) return;

    await _stopStream();

    final optimisticUser = AiChatMessageDto(
      id: -1,
      conversationId: conversationId,
      type: AiChatMessageDto.typeUser,
      content: content,
    );
    final optimisticAssistant = AiChatMessageDto(
      id: -2,
      conversationId: conversationId,
      type: AiChatMessageDto.typeAssistant,
      content: '',
    );
    state = state.copyWith(
      messages: [...state.messages, optimisticUser, optimisticAssistant],
      streaming: true,
      clearError: true,
    );

    final cancel = CancelToken();
    _streamCancel = cancel;
    var assistantContent = '';
    var reasoningContent = '';
    var userId = -1;
    var assistantId = -2;

    try {
      final stream = _repo.sendMessageStream(
        conversationId: conversationId,
        content: content,
        useContext: state.useContext,
        cancelToken: cancel,
      );

      await for (final chunk in stream) {
        if (!chunk.isOk) {
          throw Exception(chunk.msg ?? '生成失败');
        }
        final send = chunk.send;
        final receive = chunk.receive;
        if (send?.id != null) userId = send!.id!;
        if (receive?.id != null) assistantId = receive!.id!;

        final delta = receive?.content;
        if (delta != null && delta.isNotEmpty) {
          // 末包会推全量 content：若是当前缓冲的前缀扩展则替换，否则按增量拼接
          if (assistantContent.isNotEmpty &&
              (delta == assistantContent ||
                  (delta.length >= assistantContent.length &&
                      delta.startsWith(assistantContent)))) {
            assistantContent = delta;
          } else {
            assistantContent += delta;
          }
        }
        final thinkDelta = receive?.reasoningContent;
        if (thinkDelta != null && thinkDelta.isNotEmpty) {
          if (reasoningContent.isNotEmpty &&
              (thinkDelta == reasoningContent ||
                  (thinkDelta.length >= reasoningContent.length &&
                      thinkDelta.startsWith(reasoningContent)))) {
            reasoningContent = thinkDelta;
          } else {
            reasoningContent += thinkDelta;
          }
        }

        state = state.copyWith(
          messages: _replaceOptimistic(
            userId: userId,
            assistantId: assistantId,
            userContent: content,
            assistantContent: assistantContent,
            reasoningContent: reasoningContent,
            conversationId: conversationId,
          ),
        );
      }

      // 流结束后刷新列表标题等；消息已本地完整，不必强制重拉
      unawaited(_refreshConversationTitles(keepId: conversationId));
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        // 用户主动停止：保留已生成内容
      } else {
        state = state.copyWith(error: e.message ?? e.toString());
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      _streamCancel = null;
      state = state.copyWith(streaming: false);
    }
  }

  Future<void> _refreshConversationTitles({required int keepId}) async {
    try {
      final list = await _repo.listMyConversations();
      list.sort((a, b) {
        final ap = a.pinned == true ? 1 : 0;
        final bp = b.pinned == true ? 1 : 0;
        if (ap != bp) return bp - ap;
        final at = a.createTimeParsed?.millisecondsSinceEpoch ?? 0;
        final bt = b.createTimeParsed?.millisecondsSinceEpoch ?? 0;
        return bt.compareTo(at);
      });
      state = state.copyWith(
        conversations: list,
        activeConversationId: keepId,
      );
    } catch (_) {}
  }

  List<AiChatMessageDto> _replaceOptimistic({
    required int userId,
    required int assistantId,
    required String userContent,
    required String assistantContent,
    required String reasoningContent,
    required int conversationId,
  }) {
    final list = List<AiChatMessageDto>.from(state.messages);
    if (list.length >= 2) {
      list[list.length - 2] = AiChatMessageDto(
        id: userId,
        conversationId: conversationId,
        type: AiChatMessageDto.typeUser,
        content: userContent,
      );
      list[list.length - 1] = AiChatMessageDto(
        id: assistantId,
        conversationId: conversationId,
        type: AiChatMessageDto.typeAssistant,
        content: assistantContent,
        reasoningContent:
            reasoningContent.isEmpty ? null : reasoningContent,
      );
    }
    return list;
  }
}

final aiChatProvider =
    NotifierProvider.autoDispose<AiChatNotifier, AiChatPageState>(
  AiChatNotifier.new,
);

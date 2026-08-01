import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/ai_chat_models.dart';
import '../data/repos/ai_chat_repo.dart';

class AiChatSessionState {
  const AiChatSessionState({
    this.title,
    this.messages = const [],
    this.loading = true,
    this.streaming = false,
    this.useContext = true,
    this.error,
  });

  final String? title;
  final List<AiChatMessageDto> messages;
  final bool loading;
  final bool streaming;
  final bool useContext;
  final String? error;

  AiChatSessionState copyWith({
    String? title,
    List<AiChatMessageDto>? messages,
    bool? loading,
    bool? streaming,
    bool? useContext,
    String? error,
    bool clearError = false,
  }) {
    return AiChatSessionState(
      title: title ?? this.title,
      messages: messages ?? this.messages,
      loading: loading ?? this.loading,
      streaming: streaming ?? this.streaming,
      useContext: useContext ?? this.useContext,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AiChatSessionNotifier extends Notifier<AiChatSessionState> {
  AiChatSessionNotifier(this.conversationId);

  final int conversationId;
  CancelToken? _cancel;

  IAiChatRepo get _repo => ref.read(aiChatRepoProvider);

  @override
  AiChatSessionState build() {
    ref.onDispose(() {
      _cancel?.cancel();
      _cancel = null;
    });
    Future.microtask(_load);
    return const AiChatSessionState();
  }

  Future<void> _load() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final conv = await _repo.getMyConversation(conversationId);
      final messages = await _repo.listMessages(conversationId);
      state = state.copyWith(
        loading: false,
        title: conv?.title,
        messages: messages,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> reload() => _load();

  void setUseContext(bool value) {
    state = state.copyWith(useContext: value);
  }

  Future<void> stopStreaming() async {
    _cancel?.cancel();
    _cancel = null;
    if (state.streaming) {
      state = state.copyWith(streaming: false);
    }
  }

  Future<void> sendMessage(String raw) async {
    final content = raw.trim();
    if (content.isEmpty || state.streaming) return;

    await stopStreaming();

    state = state.copyWith(
      messages: [
        ...state.messages,
        AiChatMessageDto(
          id: -1,
          conversationId: conversationId,
          type: AiChatMessageDto.typeUser,
          content: content,
        ),
        AiChatMessageDto(
          id: -2,
          conversationId: conversationId,
          type: AiChatMessageDto.typeAssistant,
          content: '',
        ),
      ],
      streaming: true,
      clearError: true,
    );

    final cancel = CancelToken();
    _cancel = cancel;
    var assistantContent = '';
    var reasoningContent = '';
    var userId = -1;
    var assistantId = -2;

    try {
      await for (final chunk in _repo.sendMessageStream(
        conversationId: conversationId,
        content: content,
        useContext: state.useContext,
        cancelToken: cancel,
      )) {
        if (!chunk.isOk) {
          throw Exception(chunk.msg ?? '生成失败');
        }
        final send = chunk.send;
        final receive = chunk.receive;
        if (send?.id != null) userId = send!.id!;
        if (receive?.id != null) assistantId = receive!.id!;

        final delta = receive?.content;
        if (delta != null && delta.isNotEmpty) {
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

        final list = List<AiChatMessageDto>.from(state.messages);
        if (list.length >= 2) {
          list[list.length - 2] = AiChatMessageDto(
            id: userId,
            conversationId: conversationId,
            type: AiChatMessageDto.typeUser,
            content: content,
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
        state = state.copyWith(messages: list);
      }
    } on DioException catch (e) {
      if (!CancelToken.isCancel(e)) {
        state = state.copyWith(error: e.message ?? e.toString());
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      _cancel = null;
      state = state.copyWith(streaming: false);
    }
  }
}

final aiChatSessionProvider = NotifierProvider.autoDispose
    .family<AiChatSessionNotifier, AiChatSessionState, int>(
  AiChatSessionNotifier.new,
);

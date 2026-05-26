/// Demo 流式聊天状态（原 flyer_chat_text_stream_message 内联，避免 gpt_markdown 依赖）。
sealed class StreamState {
  const StreamState();
}

class StreamStateLoading extends StreamState {
  const StreamStateLoading();
}

class StreamStateStreaming extends StreamState {
  final String accumulatedText;
  const StreamStateStreaming(this.accumulatedText);
}

class StreamStateCompleted extends StreamState {
  final String finalText;
  const StreamStateCompleted(this.finalText);
}

class StreamStateError extends StreamState {
  final Object error;
  final String? accumulatedText;
  const StreamStateError(this.error, {this.accumulatedText});
}

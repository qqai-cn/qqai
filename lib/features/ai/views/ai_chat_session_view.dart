import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/search/theme/search_ai_theme.dart';

import '../data/models/ai_chat_models.dart';
import '../providers/ai_chat_session_providers.dart';

/// 嵌入消息 Tab / 全屏聊天壳的 AI 会话面板（无独立会话列表）。
class AiChatSessionView extends ConsumerStatefulWidget {
  const AiChatSessionView({
    super.key,
    required this.conversationId,
    this.showAppBar = false,
  });

  final int conversationId;
  final bool showAppBar;

  @override
  ConsumerState<AiChatSessionView> createState() => _AiChatSessionViewState();
}

class _AiChatSessionViewState extends ConsumerState<AiChatSessionView> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _onSend() async {
    final text = _inputController.text;
    if (text.trim().isEmpty) return;
    _inputController.clear();
    await ref
        .read(aiChatSessionProvider(widget.conversationId).notifier)
        .sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SearchAiTheme.of(context);
    final state = ref.watch(aiChatSessionProvider(widget.conversationId));
    final notifier =
        ref.read(aiChatSessionProvider(widget.conversationId).notifier);

    ref.listen(aiChatSessionProvider(widget.conversationId), (prev, next) {
      if (prev?.messages.length != next.messages.length ||
          (prev?.messages.isNotEmpty == true &&
              next.messages.isNotEmpty &&
              prev!.messages.last.content != next.messages.last.content)) {
        _scrollToBottom();
      }
      final err = next.error;
      if (err != null && err != prev?.error && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err), behavior: SnackBarBehavior.floating),
        );
      }
    });

    final body = Column(
      children: [
        Expanded(child: _buildMessages(theme, state)),
        _buildComposer(theme, state, notifier),
      ],
    );

    if (!widget.showAppBar) {
      return Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: body,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.title?.isNotEmpty == true ? state.title! : 'AI 助手',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: body,
    );
  }

  Widget _buildMessages(SearchAiTheme theme, AiChatSessionState state) {
    if (state.loading && state.messages.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: SearchAiTheme.cyan),
      );
    }
    if (state.messages.isEmpty) {
      return Center(
        child: Text(
          '发一条消息开始对话',
          style: TextStyle(color: AppActionColors.muted(context)),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final msg = state.messages[index];
        return _Bubble(
          theme: theme,
          message: msg,
          streaming: state.streaming &&
              index == state.messages.length - 1 &&
              msg.isAssistant,
        );
      },
    );
  }

  Widget _buildComposer(
    SearchAiTheme theme,
    AiChatSessionState state,
    AiChatSessionNotifier notifier,
  ) {
    final canSend = !state.streaming && !state.loading;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
        decoration: BoxDecoration(
          color: AppActionColors.surface(context),
          border: Border(
            top: BorderSide(color: AppActionColors.borderSubtle(context)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                FilterChip(
                  selected: state.useContext,
                  label: const Text('上下文'),
                  onSelected:
                      state.streaming ? null : (v) => notifier.setUseContext(v),
                  selectedColor: SearchAiTheme.cyan.withValues(alpha: 0.22),
                  labelStyle: TextStyle(
                    color: AppActionColors.muted(context),
                    fontSize: 12.sp,
                  ),
                ),
                const Spacer(),
                if (state.streaming)
                  TextButton.icon(
                    onPressed: notifier.stopStreaming,
                    icon: Icon(
                      Icons.stop_circle_outlined,
                      color: SearchAiTheme.brandRed,
                      size: 18.sp,
                    ),
                    label: Text(
                      '停止',
                      style: TextStyle(color: SearchAiTheme.brandRed),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    minLines: 1,
                    maxLines: 5,
                    enabled: !state.loading,
                    style: TextStyle(
                      color: AppActionColors.strong(context),
                      fontSize: 15.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: '输入消息…',
                      hintStyle:
                          TextStyle(color: AppActionColors.muted(context)),
                      filled: true,
                      fillColor: theme.searchBarBg,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.r),
                        borderSide: BorderSide(color: theme.line),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.r),
                        borderSide: BorderSide(color: theme.line),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.r),
                        borderSide:
                            const BorderSide(color: SearchAiTheme.cyan),
                      ),
                    ),
                    onSubmitted: (_) {
                      if (canSend) _onSend();
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Material(
                  color: canSend
                      ? SearchAiTheme.brandRed
                      : AppActionColors.muted(context).withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(22.r),
                  child: InkWell(
                    onTap: canSend ? _onSend : null,
                    borderRadius: BorderRadius.circular(22.r),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.theme,
    required this.message,
    required this.streaming,
  });

  final SearchAiTheme theme;
  final AiChatMessageDto message;
  final bool streaming;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final content = message.content ?? '';
    final reasoning = message.reasoningContent;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 0.82.sw),
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isUser
                ? SearchAiTheme.brandRed.withValues(alpha: 0.92)
                : theme.cardBg,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14.r),
              topRight: Radius.circular(14.r),
              bottomLeft: Radius.circular(isUser ? 14.r : 4.r),
              bottomRight: Radius.circular(isUser ? 4.r : 14.r),
            ),
            border: isUser ? null : Border.all(color: theme.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser && reasoning != null && reasoning.isNotEmpty) ...[
                Text(
                  '思考',
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  reasoning,
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 12.sp,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 8.h),
              ],
              if (content.isEmpty && streaming)
                SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isUser ? Colors.white : SearchAiTheme.cyan,
                  ),
                )
              else
                SelectableText(
                  content.isEmpty ? '…' : content,
                  style: TextStyle(
                    color: isUser ? Colors.white : theme.text,
                    fontSize: 15.sp,
                    height: 1.45,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

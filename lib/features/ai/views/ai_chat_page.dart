import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../search/theme/search_ai_theme.dart';
import '../data/models/ai_chat_models.dart';
import '../providers/ai_chat_providers.dart';

/// App 端 AI 对话（对齐后管：会话列表 + 流式消息）。
class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key, this.initialConversationId});

  final int? initialConversationId;

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiChatProvider.notifier).bootstrap(
            conversationId: widget.initialConversationId,
          );
    });
  }

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
    await ref.read(aiChatProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SearchAiTheme.of(context);
    final state = ref.watch(aiChatProvider);
    final notifier = ref.read(aiChatProvider.notifier);

    ref.listen<AiChatPageState>(aiChatProvider, (prev, next) {
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme.overlayStyle,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.pageGradient,
          ),
        ),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: theme.appBarBg,
            elevation: 0,
            title: Text(
              state.activeConversation?.title?.isNotEmpty == true
                  ? state.activeConversation!.title!
                  : 'AI 对话',
              style: TextStyle(
                color: theme.text,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            iconTheme: IconThemeData(color: theme.text),
            actions: [
              IconButton(
                tooltip: '会话列表',
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                icon: Icon(Icons.chat_bubble_outline, color: theme.text),
              ),
              IconButton(
                tooltip: '新建对话',
                onPressed: state.streaming
                    ? null
                    : () => notifier.createConversation(),
                icon: Icon(Icons.add_comment_outlined, color: theme.text),
              ),
            ],
          ),
          endDrawer: _ConversationDrawer(theme: theme),
          body: Column(
            children: [
              Expanded(child: _buildMessageArea(theme, state)),
              _buildComposer(theme, state, notifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageArea(SearchAiTheme theme, AiChatPageState state) {
    if (state.loadingConversations && state.conversations.isEmpty) {
      return Center(child: CircularProgressIndicator(color: SearchAiTheme.cyan));
    }
    if (state.activeConversationId == null) {
      return _EmptyHint(
        theme: theme,
        title: '开始一次 AI 对话',
        subtitle: '点击右上角「新建」创建会话，然后输入问题',
        actionLabel: '新建对话',
        onAction: () => ref.read(aiChatProvider.notifier).createConversation(),
      );
    }
    if (state.loadingMessages && state.messages.isEmpty) {
      return Center(child: CircularProgressIndicator(color: SearchAiTheme.cyan));
    }
    if (state.messages.isEmpty) {
      return _EmptyHint(
        theme: theme,
        title: '还没有消息',
        subtitle: '在下方输入内容，开始与模型对话',
      );
    }
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final msg = state.messages[index];
        return _MessageBubble(
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
    AiChatPageState state,
    AiChatNotifier notifier,
  ) {
    final canSend = state.activeConversationId != null && !state.streaming;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
        decoration: BoxDecoration(
          color: theme.cardBg,
          border: Border(top: BorderSide(color: theme.line)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                FilterChip(
                  selected: state.useContext,
                  label: const Text('上下文'),
                  onSelected: state.streaming
                      ? null
                      : (v) => notifier.setUseContext(v),
                  selectedColor: SearchAiTheme.cyan.withValues(alpha: 0.22),
                  checkmarkColor: theme.text,
                  labelStyle: TextStyle(color: theme.textSecondary, fontSize: 12.sp),
                ),
                const Spacer(),
                if (state.streaming)
                  TextButton.icon(
                    onPressed: () => notifier.stopStreaming(),
                    icon: Icon(Icons.stop_circle_outlined,
                        color: SearchAiTheme.brandRed, size: 18.sp),
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
                    enabled: state.activeConversationId != null,
                    textInputAction: TextInputAction.newline,
                    style: TextStyle(color: theme.text, fontSize: 15.sp),
                    decoration: InputDecoration(
                      hintText: '输入消息…',
                      hintStyle: TextStyle(color: theme.textSecondary),
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
                        borderSide: const BorderSide(color: SearchAiTheme.cyan),
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
                      : theme.textSecondary.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(22.r),
                  child: InkWell(
                    onTap: canSend ? _onSend : null,
                    borderRadius: BorderRadius.circular(22.r),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Icon(Icons.send_rounded, color: Colors.white, size: 20.sp),
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

class _ConversationDrawer extends ConsumerWidget {
  const _ConversationDrawer({required this.theme});

  final SearchAiTheme theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiChatProvider);
    final notifier = ref.read(aiChatProvider.notifier);
    return Drawer(
      backgroundColor: theme.cardBg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 8.w, 8.h),
              child: Row(
                children: [
                  Text(
                    '会话',
                    style: TextStyle(
                      color: theme.text,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: state.streaming
                        ? null
                        : () async {
                            await notifier.createConversation();
                            if (context.mounted) Navigator.pop(context);
                          },
                    child: const Text('新建'),
                  ),
                ],
              ),
            ),
            if (state.loadingConversations)
              LinearProgressIndicator(
                minHeight: 2,
                color: SearchAiTheme.cyan,
                backgroundColor: theme.line,
              ),
            Expanded(
              child: state.conversations.isEmpty
                  ? Center(
                      child: Text(
                        '暂无会话',
                        style: TextStyle(color: theme.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      itemCount: state.conversations.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: theme.line),
                      itemBuilder: (context, index) {
                        final c = state.conversations[index];
                        final selected = c.id == state.activeConversationId;
                        return ListTile(
                          selected: selected,
                          selectedTileColor:
                              SearchAiTheme.cyan.withValues(alpha: 0.12),
                          title: Text(
                            c.title?.isNotEmpty == true ? c.title! : '新对话',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.text,
                              fontWeight:
                                  selected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            c.model ?? '',
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 12.sp,
                            ),
                          ),
                          leading: Icon(
                            c.pinned == true
                                ? Icons.push_pin
                                : Icons.chat_outlined,
                            color: theme.textSecondary,
                            size: 20.sp,
                          ),
                          trailing: PopupMenuButton<String>(
                            enabled: !state.streaming,
                            onSelected: (value) async {
                              final id = c.id;
                              if (id == null) return;
                              if (value == 'pin') {
                                await notifier.togglePin(c);
                              } else if (value == 'delete') {
                                await notifier.deleteConversation(id);
                              }
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                value: 'pin',
                                child: Text(
                                  c.pinned == true ? '取消置顶' : '置顶',
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('删除'),
                              ),
                            ],
                          ),
                          onTap: state.streaming
                              ? null
                              : () async {
                                  await notifier.selectConversation(c.id!);
                                  if (context.mounted) Navigator.pop(context);
                                },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
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
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bg = isUser
        ? SearchAiTheme.brandRed.withValues(alpha: 0.92)
        : theme.cardBg;
    final fg = isUser ? Colors.white : theme.text;
    final content = message.content ?? '';
    final reasoning = message.reasoningContent;

    return Align(
      alignment: align,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 0.82.sw),
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14.r),
              topRight: Radius.circular(14.r),
              bottomLeft: Radius.circular(isUser ? 14.r : 4.r),
              bottomRight: Radius.circular(isUser ? 4.r : 14.r),
            ),
            border: isUser ? null : Border.all(color: theme.cardBorder),
            boxShadow: isUser ? null : theme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (reasoning != null && reasoning.isNotEmpty) ...[
                Text(
                  '思考',
                  style: TextStyle(
                    color: isUser
                        ? Colors.white70
                        : theme.textSecondary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  reasoning,
                  style: TextStyle(
                    color: isUser
                        ? Colors.white70
                        : theme.textSecondary,
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
                    color: fg,
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

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({
    required this.theme,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final SearchAiTheme theme;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 42.sp, color: SearchAiTheme.cyan),
            SizedBox(height: 14.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.text,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.textSecondary, fontSize: 13.sp),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 18.h),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: SearchAiTheme.brandRed,
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

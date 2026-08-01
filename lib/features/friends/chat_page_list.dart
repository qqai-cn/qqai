import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:qqai/components/chat/chat_widget.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/constant/constant.dart';
import 'package:qqai/features/ai/data/models/ai_chat_models.dart';
import 'package:qqai/features/ai/data/repos/ai_chat_repo.dart';
import 'package:qqai/features/ai/providers/ai_assistants_provider.dart';
import 'package:qqai/features/ai/widgets/ai_assistant_avatar.dart';
import 'package:qqai/features/chat/data/models/chat_models.dart';
import 'package:qqai/features/chat/data/repos/chat_repo.dart';
import 'package:qqai/features/chat/providers/chat_providers.dart';
import 'package:qqai/features/search/theme/search_ai_theme.dart';
import 'package:qqai/providers/auth_providers.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/api_base_client.dart';
import 'package:qqai/util/conversation_list_time_format.dart';

/// 消息 Tab：左侧会话列表（IM + AI 助手），右侧或全屏进入聊天。
class ChatPageList extends ConsumerStatefulWidget {
  const ChatPageList({
    super.key,
    this.initialConversationId,
    this.initialAiConversationId,
  });

  final int? initialConversationId;
  final int? initialAiConversationId;

  @override
  ConsumerState<ChatPageList> createState() => _ChatPageListState();
}

class _ChatPageListState extends ConsumerState<ChatPageList> {
  int? _selectedConversationId;
  bool _selectedIsAi = false;
  final String useDefault = 'imgs/user_default.png';

  static Color _selectedTileBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFE3F2FD)
        : const Color(0xFF1E3A5F);
  }

  static Color _selectedTitleColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF1565C0)
        : const Color(0xFF90CAF9);
  }

  static Color _avatarShadowColor(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Colors.black.withValues(alpha: isLight ? 0.08 : 0.35);
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialAiConversationId != null) {
      _selectedConversationId = widget.initialAiConversationId;
      _selectedIsAi = true;
    } else {
      _selectedConversationId = widget.initialConversationId;
      _selectedIsAi = false;
    }
  }

  @override
  void didUpdateWidget(covariant ChatPageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialAiConversationId != null &&
        widget.initialAiConversationId != oldWidget.initialAiConversationId) {
      _selectedConversationId = widget.initialAiConversationId;
      _selectedIsAi = true;
    } else if (oldWidget.initialConversationId != widget.initialConversationId &&
        widget.initialConversationId != null) {
      _selectedConversationId = widget.initialConversationId;
      _selectedIsAi = false;
    }
  }

  Future<void> _refreshConversations() async {
    ref.invalidate(chatConversationsProvider);
    ref.invalidate(aiAssistantsProvider);
    await ref.read(messageInboxConversationsProvider.future);
  }

  bool _isSelected(ChatConversationDto c) {
    return c.id != null &&
        c.id == _selectedConversationId &&
        c.isAi == _selectedIsAi;
  }

  Future<void> _openConversation(ChatConversationDto c) async {
    final id = c.id;
    if (id == null) return;
    setState(() {
      _selectedConversationId = id;
      _selectedIsAi = c.isAi;
    });
    if (1.sw < Constant.CHAT_TWO_VIEW_WIDTH) {
      if (c.isAi) {
        await context.push('${Routes.chat}/ai/$id');
      } else {
        await context.push('${Routes.chat}/$id');
      }
      if (mounted) {
        await _refreshConversations();
      }
    }
  }

  Future<void> _showConversationActions(
    ChatConversationDto c,
    LongPressStartDetails details,
  ) async {
    final muted = c.muted == true;
    final pinned = c.pinned == true;
    final menuRect = Rect.fromCenter(
      center: details.globalPosition,
      width: 0,
      height: 0,
    );

    await showPullDownMenu(
      context: context,
      position: menuRect,
      items: [
        PullDownMenuItem(
          title: pinned ? '取消置顶' : '置顶',
          icon: pinned ? Icons.push_pin : Icons.push_pin_outlined,
          onTap: () {
            if (!mounted) return;
            unawaited(_togglePin(c));
          },
        ),
        if (!c.isAi)
          PullDownMenuItem(
            title: muted ? '取消免打扰' : '免打扰',
            icon: muted ? CupertinoIcons.bell : CupertinoIcons.bell_slash,
            onTap: () {
              if (!mounted) return;
              unawaited(_toggleMute(c));
            },
          ),
        if (!(c.isAi && c.name == kDefaultAiAssistantTitle))
          PullDownMenuItem(
            title: '删除',
            icon: CupertinoIcons.delete,
            isDestructive: true,
            onTap: () {
              if (!mounted) return;
              unawaited(_confirmDelete(c));
            },
          ),
      ],
    );
  }

  Future<void> _togglePin(ChatConversationDto c) async {
    final id = c.id;
    if (id == null) return;
    final nextPinned = !(c.pinned == true);
    try {
      if (c.isAi) {
        await ref.read(aiChatRepoProvider).updateMyConversation(
              id: id,
              pinned: nextPinned,
            );
        ref.invalidate(aiAssistantsProvider);
      } else {
        await ref.read(chatRepoProvider).updateConversationPinned(
              conversationId: id,
              pinned: nextPinned,
            );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(nextPinned ? '已置顶' : '已取消置顶')));
      await _refreshConversations();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('操作失败：$e')));
    }
  }

  Future<void> _toggleMute(ChatConversationDto c) async {
    final id = c.id;
    if (id == null) return;
    final nextMuted = !(c.muted == true);
    try {
      await ref
          .read(chatRepoProvider)
          .updateConversationMuted(conversationId: id, muted: nextMuted);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(nextMuted ? '已开启免打扰' : '已关闭免打扰')));
      await _refreshConversations();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('操作失败：$e')));
    }
  }

  Future<void> _confirmDelete(ChatConversationDto c) async {
    final id = c.id;
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除会话'),
        content: Text('确定删除与「${c.displayTitle}」的会话吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除', style: TextStyle(color: Color(0xFFE53935))),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      if (c.isAi) {
        await ref.read(aiChatRepoProvider).deleteMyConversation(id);
        ref.invalidate(aiAssistantsProvider);
      } else {
        await ref.read(chatRepoProvider).deleteConversation(id);
      }
      if (_selectedConversationId == id && _selectedIsAi == c.isAi) {
        setState(() {
          _selectedConversationId = null;
          _selectedIsAi = false;
        });
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('会话已删除')));
      await _refreshConversations();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除失败：$e')));
    }
  }

  Widget _unreadBadge(BuildContext context, int count) {
    final label = count > 99 ? '99+' : '$count';
    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: EdgeInsets.symmetric(horizontal: count > 9 ? 5 : 0),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppActionColors.surface(context), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final asyncConvs = ref.watch(messageInboxConversationsProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: AppActionColors.surface(context),
              border: Border(
                right: BorderSide(
                  color: AppActionColors.borderSubtle(context),
                  width: 1,
                ),
              ),
            ),
            // 依赖会话列表刷新时保留旧数据，避免右侧会话被反复卸载重建
            child: asyncConvs.when(
              skipLoadingOnReload: true,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '$e',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppActionColors.muted(context)),
                  ),
                ),
              ),
              data: (convs) {
                if (convs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 80,
                          color: AppActionColors.borderSubtle(context),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '暂无会话',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppActionColors.muted(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () async {
                            await _refreshConversations();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('点击刷新'),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: _refreshConversations,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: convs.length,
                    separatorBuilder: (context, index) =>
                        Divider(
                          height: 1,
                          indent: 80,
                          color: AppActionColors.borderSubtle(context),
                        ),
                    itemBuilder: (context, position) {
                      final c = convs[position];
                      final selected = _selectedConversationId == null
                          ? position == 0
                          : _isSelected(c);
                      return _conversationTile(c, selected);
                    },
                  ),
                );
              },
            ),
          ),
        ),
        if (1.sw > Constant.CHAT_TWO_VIEW_WIDTH)
          Expanded(
            flex: 5,
            child: asyncConvs.maybeWhen(
              skipLoadingOnReload: true,
              data: (convs) {
                if (convs.isEmpty) {
                  return ColoredBox(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_outlined,
                            size: 100,
                            color: AppActionColors.borderSubtle(context),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '请选择会话开始聊天',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppActionColors.muted(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                ChatConversationDto? selected;
                for (final c in convs) {
                  if (_selectedConversationId == null) {
                    selected = convs.first;
                    break;
                  }
                  if (_isSelected(c)) {
                    selected = c;
                    break;
                  }
                }
                selected ??= convs.first;
                final id = selected.id;
                if (id == null) {
                  return const SizedBox.shrink();
                }
                return ColoredBox(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ChatWidget(
                    key: ValueKey<String>(
                      '${selected.isAi ? 'ai' : 'im'}-$id',
                    ),
                    currentUserId: authState.userId ?? '0',
                    conversationId: id,
                    initialMessages: const [],
                    dio: ApiBaseClient.dio,
                    token: authState.token,
                    enableSocket: !selected.isAi,
                    isAi: selected.isAi,
                  ),
                );
              },
              orElse: () => ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
      ],
    );
  }

  Widget _conversationTile(ChatConversationDto c, bool selected) {
    const notiSize = 20.0;
    final avatar = c.avatar;
    final unreadCount = c.unreadCount ?? 0;
    final hasUnread = unreadCount > 0;
    final muted = c.muted == true;
    final pinned = c.pinned == true;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? _selectedTileBg(context) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        onLongPressStart: (details) => _showConversationActions(c, details),
        child: InkWell(
          onTap: () => _openConversation(c),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                // 头像
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _avatarShadowColor(context),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: c.isAi
                            ? AiAssistantAvatar(
                                isDefault: c.isDefaultAi ||
                                    c.name == kDefaultAiAssistantTitle,
                                avatarUrl: avatar,
                                size: 52,
                              )
                            : avatar != null && avatar.isNotEmpty
                            ? Image.network(
                                avatar,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Image.asset(
                                  useDefault,
                                  width: 52,
                                  height: 52,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                useDefault,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    if (c.listSourceBadge != null)
                      Positioned(
                        top: -7,
                        left: -14,
                        child: _sourceBadge(context, c.listSourceBadge!),
                      ),
                    if (hasUnread)
                      Positioned(
                        top: -2,
                        right: -4,
                        child: _unreadBadge(context, unreadCount),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // 消息内容
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.displayTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: hasUnread
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: selected
                                    ? _selectedTitleColor(context)
                                    : (hasUnread
                                          ? AppActionColors.strong(context)
                                          : AppActionColors.muted(context)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formatConversationListTime(
                              c.lastMessageTime ?? c.updateTime,
                            ),
                            style: TextStyle(
                              fontSize: 13,
                              color: hasUnread
                                  ? const Color(0xFFE53935)
                                  : AppActionColors.muted(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.lastMessageSummary ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: hasUnread
                                    ? AppActionColors.muted(context)
                                    : AppActionColors.subtle(context),
                                fontWeight: hasUnread
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (pinned)
                            Icon(
                              Icons.push_pin,
                              color: AppActionColors.subtle(context),
                              size: 16,
                            ),
                          if (pinned) const SizedBox(width: 4),
                          if (muted)
                            Icon(
                              Icons.notifications_off,
                              color: AppActionColors.subtle(context),
                              size: notiSize,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sourceBadge(BuildContext context, String label) {
    final color = label == '广场'
        ? const Color(0xFF7B1FA2)
        : const Color(0xFFE65100);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: AppActionColors.surface(context), width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          height: 1.1,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/chat/chat_widget.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/constant/constant.dart';
import 'package:qqai/features/chat/data/models/chat_models.dart';
import 'package:qqai/features/chat/providers/chat_providers.dart';
import 'package:qqai/providers/auth_providers.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/api_base_client.dart';
import 'package:qqai/util/conversation_list_time_format.dart';

/// 消息 Tab：左侧会话列表（接口 [CHAT_CONVERSATION_LIST]），右侧或全屏进入聊天。
class ChatPageList extends ConsumerStatefulWidget {
  const ChatPageList({super.key});

  @override
  ConsumerState<ChatPageList> createState() => _ChatPageListState();
}

class _ChatPageListState extends ConsumerState<ChatPageList> {
  int? _selectedConversationId;
  bool ignore = false;
  final String useDefault = 'imgs/user_default.png';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final asyncConvs = ref.watch(chatConversationsProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                right: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: asyncConvs.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('$e', textAlign: TextAlign.center),
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
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '暂无会话',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () async {
                            ref.invalidate(chatConversationsProvider);
                            await ref.read(chatConversationsProvider.future);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('点击刷新'),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(chatConversationsProvider);
                    await ref.read(chatConversationsProvider.future);
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: convs.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      indent: 80,
                      color: Colors.grey[200],
                    ),
                    itemBuilder: (context, position) {
                      final c = convs[position];
                      final selected = c.id != null &&
                          c.id ==
                              (_selectedConversationId ?? convs.first.id);
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
              data: (convs) {
                if (convs.isEmpty) {
                  return ColoredBox(
                    color: const Color(0xFFF5F7FA),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_outlined,
                            size: 100,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '请选择会话开始聊天',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final id = _selectedConversationId ?? convs.first.id;
                if (id == null) {
                  return const SizedBox.shrink();
                }
                return ColoredBox(
                  color: const Color(0xFFF5F7FA),
                  child: ChatWidget(
                    key: ValueKey<int>(id),
                    currentUserId: authState.userId ?? '0',
                    conversationId: id,
                    initialMessages: const [],
                    dio: ApiBaseClient.dio,
                    token: authState.token,
                  ),
                );
              },
              orElse: () => const ColoredBox(
                color: Color(0xFFF5F7FA),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
      ],
    );
  }

  Widget _conversationTile(ChatConversationDto c, bool selected) {
    const notiSize = 20.0;
    final avatar = c.avatar;
    final hasUnread = (c.unreadCount ?? 0) > 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFE3F2FD)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          final id = c.id;
          if (id == null) return;
          setState(() => _selectedConversationId = id);
          if (1.sw < Constant.CHAT_TWO_VIEW_WIDTH) {
            context.push('${Routes.chat}/$id');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              // 头像
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: avatar != null && avatar.isNotEmpty
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
                  // 未读消息小圆点
                  if (hasUnread)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE53935).withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            (c.unreadCount ?? 0) > 99
                                ? '99+'
                                : '${c.unreadCount ?? 0}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
                                  ? const Color(0xFF1565C0)
                                  : (hasUnread
                                      ? const Color(0xFF212121)
                                      : const Color(0xFF424242)),
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
                                : Colors.grey[500],
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
                                  ? const Color(0xFF616161)
                                  : Colors.grey[600],
                              fontWeight: hasUnread
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 通知图标
                        Icon(
                          ignore ? Icons.notifications_off : Icons.notifications_none,
                          color: Colors.grey[400],
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
    );
  }
}

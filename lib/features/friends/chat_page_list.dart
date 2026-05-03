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
                  child: TextButton(
                    onPressed: () async {
                      ref.invalidate(chatConversationsProvider);
                      await ref.read(chatConversationsProvider.future);
                    },
                    child: const Text('暂无会话，点击刷新'),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(chatConversationsProvider);
                  await ref.read(chatConversationsProvider.future);
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: convs.length,
                  itemExtent: Constant.HEAD_IMG_SEZE + 20,
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
        if (1.sw > Constant.CHAT_TWO_VIEW_WIDTH)
          Expanded(
            flex: 5,
            child: asyncConvs.maybeWhen(
              data: (convs) {
                if (convs.isEmpty) {
                  return const ColoredBox(
                    color: Color(0xFFE8F5E9),
                    child: Center(child: Text('请选择会话')),
                  );
                }
                final id = _selectedConversationId ?? convs.first.id;
                if (id == null) {
                  return const SizedBox.shrink();
                }
                return ColoredBox(
                  color: const Color(0xFFE8F5E9),
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
                color: Color(0xFFE8F5E9),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
      ],
    );
  }

  Widget _conversationTile(ChatConversationDto c, bool selected) {
    const notiSize = 25.0;
    final avatar = c.avatar;
    return ListTile(
      selected: selected,
      selectedTileColor: Constant.SELECT_COLOR,
      leading: avatar != null && avatar.isNotEmpty
          ? ClipOval(
              child: Image.network(
                avatar,
                width: Constant.HEAD_IMG_SEZE,
                height: Constant.HEAD_IMG_SEZE,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Image.asset(
                  useDefault,
                  width: Constant.HEAD_IMG_SEZE,
                  height: Constant.HEAD_IMG_SEZE,
                  fit: BoxFit.fill,
                ),
              ),
            )
          : Image.asset(
              useDefault,
              width: Constant.HEAD_IMG_SEZE,
              height: Constant.HEAD_IMG_SEZE,
              fit: BoxFit.fill,
            ),
      title: Container(
        padding: const EdgeInsets.only(top: 10),
        decoration: const UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.black12),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.displayTitle,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.pageTitle.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    c.lastMessageSummary ?? '',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: context.typo.cardSubtitle.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => setState(() => ignore = !ignore),
                  child: Icon(
                    ignore ? Icons.notifications_off : Icons.notifications,
                    color: Colors.grey,
                    size: notiSize,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formatConversationListTime(
                    c.lastMessageTime ?? c.updateTime,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.caption.copyWith(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        final id = c.id;
        if (id == null) return;
        setState(() => _selectedConversationId = id);
        if (1.sw < Constant.CHAT_TWO_VIEW_WIDTH) {
          context.push('${Routes.chat}/$id');
        }
      },
    );
  }
}

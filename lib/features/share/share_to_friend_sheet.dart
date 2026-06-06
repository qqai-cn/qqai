import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_providers.dart';
import '../../router/app_routes.dart';
import '../../util/content_share_service.dart';
import '../../util/media_url.dart';
import '../chat/data/repos/chat_repo.dart';
import '../friends/data/friend_models.dart';
import '../friends/providers/friend_providers.dart';

Future<bool> showShareToFriendSheet(
  BuildContext context,
  ProviderContainer container,
  ContentSharePayload payload,
) async {
  if (!container.read(authProvider).isAuthenticated) {
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('请先登录'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    context.push(Routes.login);
    return false;
  }

  final friend = await showModalBottomSheet<FriendGroupedUserDto>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _ShareToFriendSheet(payload: payload),
  );
  if (friend == null) return false;

  final userId = friend.friendUserId;
  if (userId == null || userId <= 0) return false;

  try {
    final chatRepo = container.read(chatRepoProvider);
    final conversation = await chatRepo.getOrCreateSingleConversation(userId);
    final conversationId = conversation.id;
    if (conversationId == null || conversationId <= 0) {
      throw Exception('无法创建会话');
    }
    await chatRepo.sendMessage(
      conversationId: conversationId,
      type: 1,
      content: buildAppFriendShareText(payload),
    );
    if (context.mounted) {
      final name = _friendDisplayName(friend);
      ScaffoldMessenger.maybeOf(context)
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('已发送给${name.isNotEmpty ? name : '好友'}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
    return true;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.maybeOf(context)
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('发送失败：$e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
    return false;
  }
}

class _ShareToFriendSheet extends ConsumerStatefulWidget {
  const _ShareToFriendSheet({required this.payload});

  final ContentSharePayload payload;

  @override
  ConsumerState<_ShareToFriendSheet> createState() =>
      _ShareToFriendSheetState();
}

class _ShareToFriendSheetState extends ConsumerState<_ShareToFriendSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupedAsync = ref.watch(friendListGroupedProvider);
    final theme = Theme.of(context);
    return SafeArea(
      child: SizedBox(
        height: mathMin(MediaQuery.sizeOf(context).height * 0.72, 560),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      '发送给好友',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.payload.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (value) => setState(() => _query = value),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: '搜索昵称',
                  prefixIcon: Icon(Icons.search, size: 22),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                        ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.45),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: groupedAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: TextButton(
                    onPressed: () => ref.invalidate(friendListGroupedProvider),
                    child: Text('加载失败，点击重试\n$e'),
                  ),
                ),
                data: (groups) {
                  final friends = _filterFriends(_flattenFriends(groups));
                  if (friends.isEmpty) {
                    return Center(
                      child: Text(
                        _query.trim().isEmpty ? '暂无好友' : '未找到匹配的好友',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: friends.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (ctx, index) {
                      final friend = friends[index];
                      final avatar = resolveMediaUrl(friend.avatar);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              avatar != null ? NetworkImage(avatar) : null,
                          child: avatar == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(_friendDisplayName(friend)),
                        subtitle: _friendSearchSubtitle(friend),
                        onTap: () => Navigator.pop(context, friend),
                      );
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

  List<FriendGroupedUserDto> _flattenFriends(
    List<FriendLetterGroupDto> groups,
  ) {
    final result = <FriendGroupedUserDto>[];
    for (final group in groups) {
      for (final friend in group.friends ?? const <FriendGroupedUserDto>[]) {
        if (friend.friendUserId != null && friend.friendUserId! > 0) {
          result.add(friend);
        }
      }
    }
    return result;
  }

  List<FriendGroupedUserDto> _filterFriends(List<FriendGroupedUserDto> friends) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return friends;
    return friends.where((friend) => _friendMatchesQuery(friend, q)).toList();
  }
}

double mathMin(double a, double b) => a < b ? a : b;

String _friendDisplayName(FriendGroupedUserDto friend) {
  final remark = friend.remark?.trim();
  if (remark != null && remark.isNotEmpty) return remark;
  final display = friend.displayName?.trim();
  if (display != null && display.isNotEmpty) return display;
  final nickname = friend.nickname?.trim();
  if (nickname != null && nickname.isNotEmpty) return nickname;
  return '用户 ${friend.friendUserId ?? ''}';
}

bool _friendMatchesQuery(FriendGroupedUserDto friend, String query) {
  for (final field in [
    friend.nickname,
    friend.remark,
    friend.displayName,
    _friendDisplayName(friend),
  ]) {
    final text = field?.trim();
    if (text != null && text.isNotEmpty && text.toLowerCase().contains(query)) {
      return true;
    }
  }
  return false;
}

Widget? _friendSearchSubtitle(FriendGroupedUserDto friend) {
  final nickname = friend.nickname?.trim();
  final remark = friend.remark?.trim();
  if (remark != null &&
      remark.isNotEmpty &&
      nickname != null &&
      nickname.isNotEmpty &&
      remark != nickname) {
    return Text(
      '昵称：$nickname',
      style: const TextStyle(fontSize: 12),
    );
  }
  return null;
}

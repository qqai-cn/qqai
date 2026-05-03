import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/friend_models.dart';
import '../data/friend_repo.dart';

part 'friend_providers.g.dart';

@riverpod
Future<List<FriendPendingDto>> friendPendingIncoming(Ref ref) async {
  return ref.watch(friendRepoProvider).listPendingIncoming();
}

@riverpod
Future<List<FriendPendingDto>> friendPendingOutgoing(Ref ref) async {
  return ref.watch(friendRepoProvider).listPendingOutgoing();
}

@riverpod
Future<List<FriendLetterGroupDto>> friendListGrouped(Ref ref) async {
  return ref.watch(friendRepoProvider).listFriendsGrouped();
}

/// 本地备注缓存（修改成功后写入，用于好友列表展示）
@Riverpod(keepAlive: true)
class FriendRemarkCache extends _$FriendRemarkCache {
  @override
  Map<int, String> build() => {};

  void setRemark(int userId, String remark) {
    final next = Map<int, String>.from(state);
    if (remark.isEmpty) {
      next.remove(userId);
    } else {
      next[userId] = remark;
    }
    state = next;
  }

  /// 与通讯录接口中的备注字段对齐（服务端为准）
  void syncFromGroupedFriends(Iterable<FriendLetterGroupDto> groups) {
    final next = Map<int, String>.from(state);
    for (final g in groups) {
      for (final f in g.friends ?? []) {
        final id = f.friendUserId;
        if (id == null) continue;
        final r = f.remark?.trim();
        if (r != null && r.isNotEmpty) {
          next[id] = r!;
        } else {
          next.remove(id);
        }
      }
    }
    if (next.length == state.length) {
      var same = true;
      for (final e in next.entries) {
        if (state[e.key] != e.value) {
          same = false;
          break;
        }
      }
      if (same) return;
    }
    state = next;
  }
}

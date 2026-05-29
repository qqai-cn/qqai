import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/constant/constant.dart';

import '../../../util/media_url.dart';
import '../../../util/utils.dart';
import '../../components/azlist/az_common.dart';
import '../../components/azlist/az_listview.dart';
import '../../components/azlist/index_bar.dart';
import '../../router/app_routes.dart';
import '../data/models/contact.dart';
import 'data/friend_models.dart';
import 'friends_detail_view.dart';
import 'providers/friend_providers.dart';

/// 好友列表（消息 Tab → 好友）
class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({super.key});

  @override
  ConsumerState<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage> {
  int indexSel = 0;

  final List<ContactInfo> _topList = [
    ContactInfo(
      id: 12,
      name: '新的朋友',
      tagIndex: '↑',
      bgColor: Colors.orange,
      iconData: Icons.person_add,
    ),
    ContactInfo(
      id: 13,
      name: '群聊',
      tagIndex: '↑',
      bgColor: Colors.green,
      iconData: Icons.people,
    ),
    ContactInfo(
      id: 14,
      name: '标签',
      tagIndex: '↑',
      bgColor: Colors.blue,
      iconData: Icons.local_offer,
    ),
    ContactInfo(
      id: 15,
      name: '公众号',
      tagIndex: '↑',
      bgColor: Colors.blueAccent,
      iconData: Icons.person,
    ),
  ];

  static String _normSuspTag(String? letter) {
    if (letter == null || letter.trim().isEmpty) return '#';
    final u = letter.trim().toUpperCase();
    if (u.length == 1 && RegExp(r'[A-Z]').hasMatch(u)) return u;
    if (u == '#') return '#';
    return '#';
  }

  static int _tagRank(String t) {
    if (t == '↑') return -2;
    if (t == '#') return 27;
    if (t.length == 1) {
      final o = t.codeUnitAt(0);
      if (o >= 65 && o <= 90) return o - 65;
    }
    return 26;
  }

  List<ContactInfo> _buildRowsFromGroups(List<FriendLetterGroupDto> groups) {
    final flat = <ContactInfo>[];
    final sorted = [...groups]
      ..sort((a, b) => _tagRank(_normSuspTag(a.letter))
          .compareTo(_tagRank(_normSuspTag(b.letter))));
    for (final g in sorted) {
      final friends = [...?(g.friends)];
      friends.sort((a, b) {
        final na = (a.displayName?.trim().isNotEmpty == true
                ? a.displayName!
                : a.nickname) ??
            '';
        final nb = (b.displayName?.trim().isNotEmpty == true
                ? b.displayName!
                : b.nickname) ??
            '';
        return na.compareTo(nb);
      });
      for (final f in friends) {
        final id = f.friendUserId;
        if (id == null) continue;
        final display = (f.displayName?.trim().isNotEmpty == true)
            ? f.displayName!.trim()
            : (f.nickname?.trim().isNotEmpty == true
                ? f.nickname!.trim()
                : '用户$id');
        final tag = _normSuspTag(f.sortLetter ?? g.letter);
        flat.add(
          ContactInfo(
            name: display,
            tagIndex: tag,
            img: f.avatar,
            id: id,
          ),
        );
      }
    }
    for (final c in flat) {
      c.namePinyin = PinyinHelper.getPinyinE(c.name);
    }
    flat.sort((a, b) {
      final ra = _tagRank(a.tagIndex ?? '#');
      final rb = _tagRank(b.tagIndex ?? '#');
      if (ra != rb) return ra.compareTo(rb);
      return (a.namePinyin ?? '').compareTo(b.namePinyin ?? '');
    });
    SuspensionUtil.setShowSuspensionStatus(flat);
    flat.insertAll(0, _topList);
    return flat;
  }

  ContactInfo? _firstSelectableFriend(List<ContactInfo> rows) {
    for (final c in rows) {
      if (!c.isTopEntry && c.id != null) return c;
    }
    return null;
  }

  void _ensureSelection(List<ContactInfo> rows) {
    final first = _firstSelectableFriend(rows);
    if (first == null) return;
    var found = false;
    for (final c in rows) {
      if (c.id == indexSel && !c.isTopEntry) {
        found = true;
        break;
      }
    }
    if (!found || indexSel == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          indexSel = first.id!;
        });
      });
    }
  }

  String _contactTitle(ContactInfo model) {
    final id = model.id;
    if (id != null) {
      final remarks = ref.watch(friendRemarkCacheProvider);
      final r = remarks[id];
      if (r != null && r.isNotEmpty) return r;
    }
    return model.name;
  }

  Widget? _newFriendsTrailing() {
    return ref.watch(friendPendingIncomingProvider).when(
          data: (l) => l.isEmpty
              ? null
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    l.length > 99 ? '99+' : '${l.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
          loading: () => const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (_, _) => null,
        );
  }

  Future<void> _onRefresh() async {
    ref.invalidate(friendListGroupedProvider);
    ref.invalidate(friendPendingIncomingProvider);
    await ref.read(friendListGroupedProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final groupedAsync = ref.watch(friendListGroupedProvider);

    return groupedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _onRefresh,
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
      data: (groups) {
        ref.read(friendRemarkCacheProvider.notifier).syncFromGroupedFriends(groups);
        final contactList = _buildRowsFromGroups(groups);
        _ensureSelection(contactList);

        final wide = 1.sw > Constant.CHAT_TWO_VIEW_WIDTH;
        ContactInfo? selectedRow;
        for (final c in contactList) {
          if (c.id == indexSel) {
            selectedRow = c;
            break;
          }
        }
        final showDetail = wide &&
            selectedRow != null &&
            !selectedRow.isTopEntry;

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: AzListView(
                  data: contactList,
                  itemCount: contactList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final model = contactList[index];
                    return getWeChatListItem(
                      context,
                      model,
                      defHeaderBgColor: const Color(0xFFE5E5E5),
                    );
                  },
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  susItemBuilder: (BuildContext context, int index) {
                    final model = contactList[index];
                    if ('↑' == model.getSuspensionTag()) {
                      return Container();
                    }
                    return Utils.getSusItem(context, model.getSuspensionTag());
                  },
                  indexBarData: ['↑', '☆', ...kIndexBarData],
                  indexBarOptions: IndexBarOptions(
                    needRebuild: true,
                    ignoreDragCancel: true,
                    downTextStyle: context.typo.label
                        .copyWith(fontSize: 12, color: Colors.white),
                    downItemDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    indexHintWidth: 120 / 2,
                    indexHintHeight: 100 / 2,
                    indexHintDecoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          Utils.getImgPath('ic_index_bar_bubble_gray'),
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                    indexHintAlignment: 1.sw > Constant.CHAT_TWO_VIEW_WIDTH
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    indexHintChildAlignment: const Alignment(-0.25, 0.0),
                    indexHintOffset: 1.sw > Constant.CHAT_TWO_VIEW_WIDTH
                        ? Offset((1 / 7).sw, 0)
                        : Offset.zero,
                  ),
                ),
              ),
            ),
            if (wide)
              Expanded(
                flex: 5,
                child: showDetail
                    ? FriendsDetailView(userId: indexSel, showAppBar: false)
                    : const Center(
                        child: Text('请选择好友'),
                      ),
              ),
          ],
        );
      },
    );
  }

  Widget getWeChatListItem(
    BuildContext context,
    ContactInfo model, {
    double susHeight = 40,
    Color? defHeaderBgColor,
  }) {
    return getWeChatItem(context, model, defHeaderBgColor: defHeaderBgColor);
  }

  Widget getWeChatItem(
    BuildContext context,
    ContactInfo model, {
    Color? defHeaderBgColor,
  }) {
    return ListTile(
      selected: model.id != null && indexSel == model.id,
      selectedTileColor: Constant.SELECT_COLOR,
      leading: _buildFriendLeading(context, model, defHeaderBgColor: defHeaderBgColor),
      title: Text(_contactTitle(model)),
      trailing: model.id == 12 ? _newFriendsTrailing() : null,
      onTap: () {
        if (model.id == 12) {
          context.push(Routes.friendPendingIncoming);
          return;
        }
        setState(() {
          indexSel = model.id ?? indexSel;
        });
        if (1.sw < Constant.CHAT_TWO_VIEW_WIDTH) {
          context.push('${Routes.userDetail}/${indexSel.toString()}/true');
        }
      },
    );
  }

  Widget _buildFriendLeading(
    BuildContext context,
    ContactInfo model, {
    Color? defHeaderBgColor,
  }) {
    const size = 36.0;
    final resolvedAvatar = resolveMediaUrl(model.img);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4.0),
        color: model.bgColor ?? defHeaderBgColor,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: model.iconData != null && resolvedAvatar == null
          ? Icon(model.iconData, color: Colors.white, size: 20)
          : resolvedAvatar != null
              ? CachedNetworkImage(
                  key: ValueKey(resolvedAvatar),
                  imageUrl: resolvedAvatar,
                  cacheKey: resolvedAvatar,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 150),
                  errorWidget: (_, _, _) => _letterLeading(context, model),
                )
              : _letterLeading(context, model),
    );
  }

  Widget _letterLeading(BuildContext context, ContactInfo model) {
    return Text(
      PinyinHelper.getPinyinE(model.name).substring(0, 1).toUpperCase(),
      style: context.typo.bodyStrong.copyWith(color: Colors.blue),
    );
  }
}

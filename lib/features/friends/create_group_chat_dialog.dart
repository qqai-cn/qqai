import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lpinyin/lpinyin.dart';

import '../../constant/color_constant.dart';
import '../../constant/constant.dart';
import '../../providers/auth_providers.dart';
import '../../router/app_routes.dart';
import '../chat/data/repos/chat_repo.dart';
import '../chat/providers/chat_providers.dart';
import '../my/data/repos/profile_repo.dart';
import 'data/friend_models.dart';
import 'providers/friend_providers.dart';

class _PickerPalette {
  const _PickerPalette({
    required this.pageBg,
    required this.panelBg,
    required this.panelBgAlt,
    required this.searchBg,
    required this.rowSelectedBg,
    required this.divider,
    required this.desktopDivider,
    required this.mutedText,
    required this.primaryText,
    required this.hintText,
    required this.iconMuted,
    required this.avatarBg,
    required this.cancelButtonBg,
    required this.disabledGreen,
    required this.selectedCheck,
    required this.closeButtonBg,
    required this.indexText,
  });

  final Color pageBg;
  final Color panelBg;
  final Color panelBgAlt;
  final Color searchBg;
  final Color rowSelectedBg;
  final Color divider;
  final Color desktopDivider;
  final Color mutedText;
  final Color primaryText;
  final Color hintText;
  final Color iconMuted;
  final Color avatarBg;
  final Color cancelButtonBg;
  final Color disabledGreen;
  final Color selectedCheck;
  final Color closeButtonBg;
  final Color indexText;

  static _PickerPalette of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const _PickerPalette(
        pageBg: Color(0xFF111111),
        panelBg: Color(0xFF171717),
        panelBgAlt: Color(0xFF20282B),
        searchBg: Color(0xFF242424),
        rowSelectedBg: Color(0xFF343434),
        divider: Color(0xFF2A2A2A),
        desktopDivider: Color(0xFF50585B),
        mutedText: Color(0xFF8A8A8A),
        primaryText: Color(0xFFE8E8E8),
        hintText: Color(0xFF5E5E5E),
        iconMuted: Color(0xFF666666),
        avatarBg: Color(0xFFE4E4E4),
        cancelButtonBg: Color(0xFF293235),
        disabledGreen: Color(0xFF235A3D),
        selectedCheck: Color(0xFF111111),
        closeButtonBg: Color(0xFF9EA3A5),
        indexText: Color(0xFF626262),
      );
    }
    return const _PickerPalette(
      pageBg: Color(0xFFF5F5F5),
      panelBg: Colors.white,
      panelBgAlt: Color(0xFFF7F9FA),
      searchBg: Color(0xFFF2F3F5),
      rowSelectedBg: Color(0xFFEDEDED),
      divider: Color(0xFFE6E6E6),
      desktopDivider: Color(0xFFD4D8DB),
      mutedText: Color(0xFF858585),
      primaryText: Color(0xFF1F1F1F),
      hintText: Color(0xFF9A9A9A),
      iconMuted: Color(0xFF8A8A8A),
      avatarBg: Color(0xFFEDEFF2),
      cancelButtonBg: Color(0xFFE9ECEF),
      disabledGreen: Color(0xFFA8D9C1),
      selectedCheck: Colors.white,
      closeButtonBg: Color(0xFFD6D8DA),
      indexText: Color(0xFF8A8A8A),
    );
  }
}

/// 解析「1,2,3」「1 2 3」「1，2」等成员 ID 列表。
///
/// 旧表单时代留下的工具函数，保留给单元测试或其他调用方。
List<int> parseMemberIdList(String raw) {
  final normalized = raw.replaceAll('，', ',').replaceAll('、', ',');
  final parts = normalized.split(RegExp(r'[\s,;，、]+'));
  final out = <int>[];
  for (final p in parts) {
    final v = int.tryParse(p.trim());
    if (v != null) out.add(v);
  }
  return out;
}

Future<void> showCreateGroupChatDialog(
  BuildContext parentContext,
  WidgetRef ref,
) async {
  final wide =
      MediaQuery.sizeOf(parentContext).width > Constant.CHAT_TWO_VIEW_WIDTH;
  final isDark = Theme.of(parentContext).brightness == Brightness.dark;
  final newId = wide
      ? await showDialog<int>(
          // ignore: use_build_context_synchronously
          context: parentContext,
          barrierColor: Colors.black.withValues(alpha: isDark ? 0.68 : 0.34),
          builder: (_) => _CreateGroupChatDialog(parentRef: ref),
        )
      // ignore: use_build_context_synchronously
      : await Navigator.of(parentContext).push<int>(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => _CreateGroupChatPage(parentRef: ref),
          ),
        );
  if (newId == null) return;
  if (!parentContext.mounted) return;
  ref.invalidate(chatConversationsProvider);
  ScaffoldMessenger.of(
    parentContext,
  ).showSnackBar(const SnackBar(content: Text('群聊已创建')));
  parentContext.go(Routes.messagePage);
}

class _CreateGroupChatPage extends StatelessWidget {
  const _CreateGroupChatPage({required this.parentRef});

  final WidgetRef parentRef;

  @override
  Widget build(BuildContext context) {
    return _GroupChatPicker(parentRef: parentRef, mode: _PickerMode.mobile);
  }
}

class _CreateGroupChatDialog extends StatelessWidget {
  const _CreateGroupChatDialog({required this.parentRef});

  final WidgetRef parentRef;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 44, vertical: 36),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width < 1024 ? size.width - 88 : 980,
          maxHeight: size.height - 72,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: _GroupChatPicker(
            parentRef: parentRef,
            mode: _PickerMode.desktop,
          ),
        ),
      ),
    );
  }
}

enum _PickerMode { mobile, desktop }

class _GroupChatPicker extends ConsumerStatefulWidget {
  const _GroupChatPicker({required this.parentRef, required this.mode});

  final WidgetRef parentRef;
  final _PickerMode mode;

  @override
  ConsumerState<_GroupChatPicker> createState() => _GroupChatPickerState();
}

class _GroupChatPickerState extends ConsumerState<_GroupChatPicker> {
  final _searchCtrl = TextEditingController();
  final Set<int> _selectedIds = <int>{};
  var _submitting = false;
  var _query = '';

  bool get _isDesktop => widget.mode == _PickerMode.desktop;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedIds.isEmpty || _submitting) return;
    final auth = widget.parentRef.read(authProvider);
    final selfId = int.tryParse(auth.userId ?? '');
    final ids = <int>[?selfId, ..._selectedIds.where((id) => id != selfId)];
    final creatorName = await _resolveCreatorDisplayName(widget.parentRef);
    final groupName = '$creatorName的群聊';

    setState(() => _submitting = true);
    try {
      final conv = await widget.parentRef
          .read(chatRepoProvider)
          .createGroupConversation(name: groupName, memberIds: ids);
      final id = conv.id;
      if (!mounted) return;
      if (id == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('创建成功但未返回会话 ID')));
        Navigator.of(context).pop();
        return;
      }
      Navigator.of(context).pop(id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('创建失败：$e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _toggle(_GroupContact contact) {
    setState(() {
      if (_selectedIds.contains(contact.id)) {
        _selectedIds.remove(contact.id);
      } else {
        _selectedIds.add(contact.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupedAsync = ref.watch(friendListGroupedProvider);
    return groupedAsync.when(
      loading: () => _ScaffoldShell(
        mode: widget.mode,
        selectedCount: _selectedIds.length,
        submitting: _submitting,
        onCancel: () => Navigator.of(context).pop(),
        onSubmit: null,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => _ScaffoldShell(
        mode: widget.mode,
        selectedCount: _selectedIds.length,
        submitting: _submitting,
        onCancel: () => Navigator.of(context).pop(),
        onSubmit: null,
        child: _LoadError(
          message: '$e',
          onRetry: () => ref.invalidate(friendListGroupedProvider),
        ),
      ),
      data: (groups) {
        final contacts = _buildContacts(groups);
        final selected = contacts
            .where((c) => _selectedIds.contains(c.id))
            .toList();
        final filtered = _filterContacts(contacts);
        final onSubmit = _selectedIds.isEmpty ? null : _submit;
        return _ScaffoldShell(
          mode: widget.mode,
          selectedCount: _selectedIds.length,
          submitting: _submitting,
          onCancel: () => Navigator.of(context).pop(),
          onSubmit: onSubmit,
          child: _isDesktop
              ? _buildDesktop(context, filtered, selected)
              : _buildMobile(context, filtered, selected),
        );
      },
    );
  }

  List<_GroupContact> _buildContacts(List<FriendLetterGroupDto> groups) {
    final contacts = <_GroupContact>[];
    for (final group in groups) {
      for (final friend in group.friends ?? <FriendGroupedUserDto>[]) {
        final id = friend.friendUserId;
        if (id == null) continue;
        final name = _displayName(friend, id);
        final pinyin = PinyinHelper.getPinyinE(name);
        final tag = _normTag(
          friend.sortLetter ?? group.letter,
          fallback: pinyin,
        );
        contacts.add(
          _GroupContact(
            id: id,
            name: name,
            avatar: friend.avatar?.trim(),
            tag: tag,
            pinyin: pinyin,
          ),
        );
      }
    }
    contacts.sort((a, b) {
      final tag = _tagRank(a.tag).compareTo(_tagRank(b.tag));
      if (tag != 0) return tag;
      return a.pinyin.compareTo(b.pinyin);
    });
    return contacts;
  }

  List<_GroupContact> _filterContacts(List<_GroupContact> contacts) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return contacts;
    return contacts
        .where(
          (c) =>
              c.name.toLowerCase().contains(q) ||
              c.pinyin.toLowerCase().contains(q) ||
              c.id.toString().contains(q),
        )
        .toList();
  }

  Widget _buildMobile(
    BuildContext context,
    List<_GroupContact> contacts,
    List<_GroupContact> selected,
  ) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 34, 18),
                child: _SearchAndSelectedBar(
                  controller: _searchCtrl,
                  selected: selected,
                  onChanged: (value) => setState(() => _query = value),
                  onRemove: (id) => setState(() => _selectedIds.remove(id)),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: _MobileOptionRows()),
            ..._sectionSlivers(contacts, selectedShade: false),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
        Positioned(
          right: 5,
          top: 332,
          bottom: 18,
          child: _IndexRail(tags: _visibleTags(contacts)),
        ),
      ],
    );
  }

  Widget _buildDesktop(
    BuildContext context,
    List<_GroupContact> contacts,
    List<_GroupContact> selected,
  ) {
    final colors = _PickerPalette.of(context);
    return Row(
      children: [
        SizedBox(
          width: 438,
          child: ColoredBox(
            color: colors.panelBg,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(36, 28, 36, 20),
                    child: _SearchField(
                      controller: _searchCtrl,
                      onChanged: (value) => setState(() => _query = value),
                      focusedBorder: true,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: _StarFriendsHeader()),
                ..._sectionSlivers(contacts, selectedShade: true),
                const SliverToBoxAdapter(child: SizedBox(height: 28)),
              ],
            ),
          ),
        ),
        VerticalDivider(width: 1, thickness: 1, color: colors.desktopDivider),
        Expanded(
          child: ColoredBox(
            color: colors.panelBgAlt,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(48, 32, 48, 18),
                  child: Row(
                    children: [
                      Text(
                        '发起群聊',
                        style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '已选择 ${selected.length} 个联系人',
                        style: TextStyle(
                          color: colors.mutedText,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _SelectedGrid(
                    selected: selected,
                    onRemove: (id) => setState(() => _selectedIds.remove(id)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(76, 16, 76, 38),
                  child: Row(
                    children: [
                      Expanded(
                        child: _DesktopButton(
                          label: '取消',
                          color: colors.cancelButtonBg,
                          foregroundColor: colors.primaryText,
                          onPressed: _submitting
                              ? null
                              : () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 28),
                      Expanded(
                        child: _DesktopButton(
                          label: _submitting ? '创建中...' : '创建',
                          color: ColorConstant.ThemeGreen,
                          foregroundColor: Colors.white,
                          onPressed: _selectedIds.isEmpty || _submitting
                              ? null
                              : _submit,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _sectionSlivers(
    List<_GroupContact> contacts, {
    required bool selectedShade,
  }) {
    final slivers = <Widget>[];
    var lastTag = '';
    for (final contact in contacts) {
      if (contact.tag != lastTag) {
        lastTag = contact.tag;
        slivers.add(
          SliverToBoxAdapter(
            child: _SectionHeader(tag: contact.tag, desktop: _isDesktop),
          ),
        );
      }
      final selected = _selectedIds.contains(contact.id);
      slivers.add(
        SliverToBoxAdapter(
          child: _ContactTile(
            contact: contact,
            selected: selected,
            selectedShade: selectedShade,
            desktop: _isDesktop,
            onTap: () => _toggle(contact),
          ),
        ),
      );
    }
    if (contacts.isEmpty) {
      slivers.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Builder(
              builder: (context) {
                final colors = _PickerPalette.of(context);
                return Text('暂无联系人', style: TextStyle(color: colors.mutedText));
              },
            ),
          ),
        ),
      );
    }
    return slivers;
  }
}

class _ScaffoldShell extends StatelessWidget {
  const _ScaffoldShell({
    required this.mode,
    required this.selectedCount,
    required this.submitting,
    required this.onCancel,
    required this.onSubmit,
    required this.child,
  });

  final _PickerMode mode;
  final int selectedCount;
  final bool submitting;
  final VoidCallback onCancel;
  final VoidCallback? onSubmit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = _PickerPalette.of(context);
    if (mode == _PickerMode.desktop) {
      return SizedBox(height: 660, child: child);
    }
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: colors.pageBg,
        appBarTheme: AppBarTheme(
          backgroundColor: colors.pageBg,
          foregroundColor: colors.primaryText,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 86,
          leading: TextButton(
            onPressed: submitting ? null : onCancel,
            child: Text(
              '取消',
              style: TextStyle(color: colors.primaryText, fontSize: 18),
            ),
          ),
          title: const Text(
            '发起群聊',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: ColorConstant.ThemeGreen,
                  disabledBackgroundColor: colors.disabledGreen,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: colors.mutedText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: submitting ? null : onSubmit,
                child: Text(
                  submitting ? '创建中...' : '完成 ($selectedCount)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: child,
      ),
    );
  }
}

class _SearchAndSelectedBar extends StatelessWidget {
  const _SearchAndSelectedBar({
    required this.controller,
    required this.selected,
    required this.onChanged,
    required this.onRemove,
  });

  final TextEditingController controller;
  final List<_GroupContact> selected;
  final ValueChanged<String> onChanged;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = _PickerPalette.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.panelBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.divider),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        runSpacing: 8,
        children: [
          for (final contact in selected.take(6))
            _SelectedMiniAvatar(
              contact: contact,
              onRemove: () => onRemove(contact.id),
            ),
          SizedBox(
            width: selected.isEmpty ? 280 : 145,
            child: _SearchField(
              controller: controller,
              onChanged: onChanged,
              focusedBorder: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.focusedBorder,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool focusedBorder;

  @override
  Widget build(BuildContext context) {
    final colors = _PickerPalette.of(context);
    return TextField(
      controller: controller,
      autofocus: focusedBorder,
      cursorColor: ColorConstant.ThemeGreen,
      style: TextStyle(color: colors.primaryText, fontSize: 18),
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        hintText: '搜索',
        hintStyle: TextStyle(color: colors.hintText),
        prefixIcon: Icon(Icons.search, color: colors.iconMuted, size: 22),
        prefixIconConstraints: const BoxConstraints(minWidth: 34),
        filled: true,
        fillColor: focusedBorder ? colors.searchBg : Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: focusedBorder
                ? ColorConstant.ThemeGreen
                : Colors.transparent,
            width: focusedBorder ? 1.2 : 0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: ColorConstant.ThemeGreen,
            width: focusedBorder ? 1.2 : 0,
          ),
        ),
      ),
    );
  }
}

class _MobileOptionRows extends StatelessWidget {
  const _MobileOptionRows();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        _CreateLabel(),
        _OptionRow(label: '面对面建群'),
        _OptionRow(label: '选择群聊中的朋友'),
        _OptionRow(label: '选择企业微信联系人'),
      ],
    );
  }
}

class _CreateLabel extends StatelessWidget {
  const _CreateLabel();

  @override
  Widget build(BuildContext context) {
    final colors = _PickerPalette.of(context);
    return Container(
      height: 46,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.divider)),
      ),
      child: Text(
        '创建新群聊',
        style: TextStyle(color: colors.mutedText, fontSize: 17),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = _PickerPalette.of(context);
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: colors.panelBg,
        border: Border(bottom: BorderSide(color: colors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: colors.primaryText, fontSize: 20),
            ),
          ),
          Icon(Icons.chevron_right, color: colors.iconMuted, size: 32),
        ],
      ),
    );
  }
}

class _StarFriendsHeader extends StatelessWidget {
  const _StarFriendsHeader();

  @override
  Widget build(BuildContext context) {
    final colors = _PickerPalette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 0, 36, 22),
      child: Row(
        children: [
          Icon(Icons.star_border, color: colors.mutedText, size: 24),
          const SizedBox(width: 8),
          Text(
            '星标朋友',
            style: TextStyle(
              color: colors.mutedText,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.tag, required this.desktop});

  final String tag;
  final bool desktop;

  @override
  Widget build(BuildContext context) {
    final colors = _PickerPalette.of(context);
    return Container(
      height: desktop ? 34 : 44,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: desktop ? 36 : 18),
      color: desktop ? colors.panelBg : colors.pageBg,
      child: Text(
        tag,
        style: TextStyle(
          color: colors.mutedText,
          fontSize: desktop ? 18 : 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.contact,
    required this.selected,
    required this.selectedShade,
    required this.desktop,
    required this.onTap,
  });

  final _GroupContact contact;
  final bool selected;
  final bool selectedShade;
  final bool desktop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = _PickerPalette.of(context);
    final avatarSize = desktop ? 44.0 : 56.0;
    final rowHeight = desktop ? 70.0 : 88.0;
    return Material(
      color: selected && selectedShade
          ? colors.rowSelectedBg
          : (desktop ? colors.panelBg : colors.pageBg),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: rowHeight,
          child: Row(
            children: [
              SizedBox(width: desktop ? 36 : 18),
              _CheckCircle(selected: selected, size: desktop ? 24 : 28),
              SizedBox(width: desktop ? 16 : 20),
              _Avatar(contact: contact, size: avatarSize),
              SizedBox(width: desktop ? 16 : 14),
              Expanded(
                child: Container(
                  height: rowHeight,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: desktop ? Colors.transparent : colors.divider,
                      ),
                    ),
                  ),
                  child: Text(
                    contact.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.primaryText,
                      fontSize: desktop ? 18 : 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: desktop ? 22 : 34),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckCircle extends StatelessWidget {
  const _CheckCircle({required this.selected, required this.size});

  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = _PickerPalette.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 130),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? ColorConstant.ThemeGreen : Colors.transparent,
        border: selected
            ? null
            : Border.all(color: colors.iconMuted, width: 1.8),
      ),
      child: selected
          ? Icon(Icons.check, color: colors.selectedCheck, size: size * 0.72)
          : null,
    );
  }
}

class _SelectedGrid extends StatelessWidget {
  const _SelectedGrid({required this.selected, required this.onRemove});

  final List<_GroupContact> selected;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(58, 18, 58, 18),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 112,
        mainAxisExtent: 104,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
      ),
      itemCount: selected.length,
      itemBuilder: (context, index) {
        final contact = selected[index];
        return _SelectedPerson(
          contact: contact,
          onRemove: () => onRemove(contact.id),
        );
      },
    );
  }
}

class _SelectedPerson extends StatelessWidget {
  const _SelectedPerson({required this.contact, required this.onRemove});

  final _GroupContact contact;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = _PickerPalette.of(context);
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            _Avatar(contact: contact, size: 58),
            Positioned(
              top: -9,
              right: -9,
              child: InkWell(
                onTap: onRemove,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: colors.closeButtonBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 17, color: colors.primaryText),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          contact.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SelectedMiniAvatar extends StatelessWidget {
  const _SelectedMiniAvatar({required this.contact, required this.onRemove});

  final _GroupContact contact;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRemove,
      borderRadius: BorderRadius.circular(8),
      child: _Avatar(contact: contact, size: 44),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.contact, required this.size});

  final _GroupContact contact;
  final double size;

  @override
  Widget build(BuildContext context) {
    final avatar = contact.avatar;
    final colors = _PickerPalette.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: size,
        height: size,
        color: colors.avatarBg,
        alignment: Alignment.center,
        child: avatar != null && avatar.isNotEmpty
            ? Image.network(
                avatar,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _AvatarLetter(contact: contact),
              )
            : _AvatarLetter(contact: contact),
      ),
    );
  }
}

class _AvatarLetter extends StatelessWidget {
  const _AvatarLetter({required this.contact});

  final _GroupContact contact;

  @override
  Widget build(BuildContext context) {
    return Text(
      contact.name.characters.first.toUpperCase(),
      style: const TextStyle(
        color: Colors.blue,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _IndexRail extends StatelessWidget {
  const _IndexRail({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final colors = _PickerPalette.of(context);
    final items = <String>[
      '⌕',
      ...tags.where((t) => t != '#'),
      if (tags.contains('#')) '#',
    ];
    return IgnorePointer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final item in items)
            SizedBox(
              width: 22,
              height: 18,
              child: Center(
                child: Text(
                  item,
                  style: TextStyle(
                    color: colors.indexText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DesktopButton extends StatelessWidget {
  const _DesktopButton({
    required this.label,
    required this.color,
    required this.foregroundColor,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final Color foregroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = _PickerPalette.of(context);
    return SizedBox(
      height: 44,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color.withValues(alpha: 0.45),
          foregroundColor: foregroundColor,
          disabledForegroundColor: colors.mutedText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = _PickerPalette.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.primaryText),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('重试')),
        ],
      ),
    );
  }
}

class _GroupContact {
  const _GroupContact({
    required this.id,
    required this.name,
    required this.avatar,
    required this.tag,
    required this.pinyin,
  });

  final int id;
  final String name;
  final String? avatar;
  final String tag;
  final String pinyin;
}

String _displayName(FriendGroupedUserDto friend, int id) {
  final displayName = friend.displayName?.trim();
  if (displayName != null && displayName.isNotEmpty) return displayName;
  final remark = friend.remark?.trim();
  if (remark != null && remark.isNotEmpty) return remark;
  final nickname = friend.nickname?.trim();
  if (nickname != null && nickname.isNotEmpty) return nickname;
  return '用户$id';
}

String _normTag(String? letter, {required String fallback}) {
  final raw = letter?.trim().toUpperCase();
  if (raw != null && raw.length == 1 && RegExp(r'[A-Z]').hasMatch(raw)) {
    return raw;
  }
  final first = fallback.isNotEmpty
      ? fallback.substring(0, 1).toUpperCase()
      : '#';
  if (RegExp(r'[A-Z]').hasMatch(first)) return first;
  return '#';
}

int _tagRank(String tag) {
  if (tag == '#') return 27;
  if (tag.length == 1) {
    final code = tag.codeUnitAt(0);
    if (code >= 65 && code <= 90) return code - 65;
  }
  return 26;
}

List<String> _visibleTags(List<_GroupContact> contacts) {
  final tags = <String>[];
  for (final contact in contacts) {
    if (!tags.contains(contact.tag)) tags.add(contact.tag);
  }
  tags.sort((a, b) => _tagRank(a).compareTo(_tagRank(b)));
  return tags;
}

Future<String> _resolveCreatorDisplayName(WidgetRef ref) async {
  try {
    final page = await ref.read(profileRepoProvider).getMyPage();
    final nickname = page.nickname?.trim();
    if (nickname != null && nickname.isNotEmpty) return nickname;
  } catch (_) {}
  final username = ref.read(authProvider).username?.trim();
  if (username != null && username.isNotEmpty) return username;
  return '我';
}

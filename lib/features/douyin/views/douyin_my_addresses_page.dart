import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/theme/app_action_colors.dart';
import '../../../config/theme/app_typography.dart';
import '../../my/data/models/area_models.dart';
import '../../my/data/models/member_address_models.dart';
import '../../my/data/repos/area_repo.dart';
import '../../my/data/repos/member_address_repo.dart';
import '../../my/widgets/area_picker_sheet.dart';
import '../theme/douyin_theme.dart';

abstract final class _AddressUi {
  static Color chipSelectedBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFFFECEC)
        : DouyinTheme.accent.withValues(alpha: 0.18);
  }

  static Color tagBg(BuildContext context, {required bool strong}) {
    if (strong) {
      return Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : DouyinTheme.card(context);
    }
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFFFF3EA)
        : DouyinTheme.accent.withValues(alpha: 0.12);
  }
}

class DouyinMyAddressesPage extends ConsumerStatefulWidget {
  const DouyinMyAddressesPage({super.key});

  @override
  ConsumerState<DouyinMyAddressesPage> createState() =>
      _DouyinMyAddressesPageState();
}

class _DouyinMyAddressesPageState extends ConsumerState<DouyinMyAddressesPage> {
  final _addresses = <MemberAddress>[];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await ref.read(memberAddressRepoProvider).getList();
      if (!mounted) return;
      setState(() {
        _addresses
          ..clear()
          ..addAll(list);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _openEditor([MemberAddress? address]) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => MemberAddressEditPage(address: address),
      ),
    );
    if (changed == true) _load();
  }

  Future<void> _delete(MemberAddress address) async {
    final id = address.id;
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除收货地址'),
        content: Text('确定删除 ${address.name ?? '该地址'} 的收货地址吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(memberAddressRepoProvider).delete(id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已删除')));
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除失败: $e')));
    }
  }

  Future<void> _copy(MemberAddress address) async {
    final text = [
      address.name,
      address.mobile,
      address.fullAddress,
    ].where((e) => e?.trim().isNotEmpty == true).join(' ');
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('地址已复制')));
  }

  Future<void> _setDefault(MemberAddress address) async {
    final id = address.id;
    final areaId = address.areaId;
    if (id == null || areaId == null) return;
    try {
      await ref
          .read(memberAddressRepoProvider)
          .update(
            MemberAddressSaveReq(
              id: id,
              name: address.name ?? '',
              mobile: address.mobile ?? '',
              areaId: areaId,
              detailAddress: address.detailAddress ?? '',
              defaultStatus: true,
            ),
          );
      if (!mounted) return;
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('设置失败: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DouyinTheme.bg(context),
      appBar: AppBar(
        backgroundColor: DouyinTheme.bg(context),
        foregroundColor: DouyinTheme.text(context),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          '收货地址',
          style: context.typo.sectionTitle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(child: _buildBody()),
            _BottomButton(text: '新增收货地址', onPressed: () => _openEditor()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _CenteredContent(
        icon: Icons.location_off_outlined,
        title: '地址加载失败',
        subtitle: _error!,
        actionText: '重试',
        onAction: _load,
      );
    }
    if (_addresses.isEmpty) {
      return _CenteredContent(
        icon: Icons.add_location_alt_outlined,
        title: '还没有收货地址',
        subtitle: '新增后下单时可以优先使用默认地址',
        actionText: '新增地址',
        onAction: () => _openEditor(),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: _AddressTabs()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                sliver: SliverList.separated(
                  itemCount: _addresses.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final address = _addresses[index];
                    return _AddressCard(
                      address: address,
                      onDefault: () => _setDefault(address),
                      onCopy: () => _copy(address),
                      onEdit: () => _openEditor(address),
                      onDelete: () => _delete(address),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemberAddressEditPage extends ConsumerStatefulWidget {
  const MemberAddressEditPage({super.key, this.address});

  final MemberAddress? address;

  @override
  ConsumerState<MemberAddressEditPage> createState() =>
      _MemberAddressEditPageState();
}

class _MemberAddressEditPageState extends ConsumerState<MemberAddressEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _detailCtrl;
  int? _areaId;
  String? _areaName;
  bool _defaultStatus = false;
  bool _saving = false;
  int _scene = 0;
  int _tag = 1;

  bool get _isEdit => widget.address?.id != null;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    _nameCtrl = TextEditingController(text: address?.name ?? '');
    _mobileCtrl = TextEditingController(text: address?.mobile ?? '');
    _detailCtrl = TextEditingController(text: address?.detailAddress ?? '');
    _areaId = address?.areaId;
    _areaName = address?.areaName;
    _defaultStatus = address?.defaultStatus ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _detailCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickArea() async {
    final tree = await _loadAreaTree();
    if (tree == null || tree.isEmpty || !mounted) return;
    final picked = await showAreaPickerSheet(
      context,
      provinces: tree,
      initialAreaId: _areaId,
    );
    if (picked == null) return;
    setState(() {
      _areaId = picked.areaId;
      _areaName = picked.label.replaceFirst('中国 · ', '');
    });
  }

  Future<List<AppAreaNode>?> _loadAreaTree() async {
    final cached = ref.read(areaTreeProvider);
    final tree = cached.maybeWhen<List<AppAreaNode>?>(
      data: (value) => value,
      orElse: () => null,
    );
    if (tree != null && tree.isNotEmpty) return tree;
    try {
      final loaded = await ref.read(areaRepoProvider).getTree();
      ref.invalidate(areaTreeProvider);
      return loaded;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('地区加载失败: $e')));
      }
      return null;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final areaId = _areaId;
    if (areaId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请选择所在地区')));
      return;
    }
    setState(() => _saving = true);
    final req = MemberAddressSaveReq(
      id: widget.address?.id,
      name: _nameCtrl.text.trim(),
      mobile: _mobileCtrl.text.trim(),
      areaId: areaId,
      detailAddress: _detailCtrl.text.trim(),
      defaultStatus: _defaultStatus,
    );
    try {
      if (_isEdit) {
        await ref.read(memberAddressRepoProvider).update(req);
      } else {
        await ref.read(memberAddressRepoProvider).create(req);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
    }
  }

  Future<void> _delete() async {
    final id = widget.address?.id;
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除收货地址'),
        content: const Text('删除后无法恢复，确定继续吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(memberAddressRepoProvider).delete(id);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除失败: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DouyinTheme.bg(context),
      appBar: AppBar(
        backgroundColor: DouyinTheme.bg(context),
        foregroundColor: DouyinTheme.text(context),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          _isEdit ? '编辑收货地址' : '新增收货地址',
          style: context.typo.sectionTitle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_isEdit)
            TextButton(
              onPressed: _saving ? null : _delete,
              child: Text(
                '删除',
                style: TextStyle(color: DouyinTheme.text(context), fontSize: 16),
              ),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _EditCard(
                            children: [
                              _TextInputRow(
                                label: '收货人',
                                controller: _nameCtrl,
                                hintText: '请输入收货人姓名',
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? '请输入收货人'
                                    : null,
                              ),
                              const _DividerLine(),
                              _TextInputRow(
                                label: '手机号',
                                controller: _mobileCtrl,
                                hintText: '请输入手机号',
                                keyboardType: TextInputType.phone,
                                validator: (v) {
                                  final text = v?.trim() ?? '';
                                  if (text.isEmpty) return '请输入手机号';
                                  if (text.length < 7) return '手机号格式不正确';
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _EditCard(
                            children: [
                              _TapRow(
                                label: '所在地区',
                                value: _areaName ?? '请选择省市区',
                                placeholder: _areaName == null,
                                onTap: _pickArea,
                              ),
                              const _DividerLine(),
                              _TextInputRow(
                                label: '详细地址',
                                controller: _detailCtrl,
                                hintText: '街道、楼牌号等',
                                maxLines: 2,
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? '请输入详细地址'
                                    : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _EditCard(
                            children: [
                              _DefaultRow(
                                value: _defaultStatus,
                                onChanged: (value) {
                                  setState(() => _defaultStatus = value);
                                },
                              ),
                              const _DividerLine(),
                              _ChoiceSection(
                                label: '使用场景',
                                options: const ['购物', '秒送/外卖'],
                                selected: _scene,
                                onSelected: (i) => setState(() => _scene = i),
                              ),
                              const SizedBox(height: 12),
                              _ChoiceSection(
                                label: '地址标签',
                                options: const ['学校', '家', '公司', '自定义'],
                                selected: _tag,
                                onSelected: (i) => setState(() => _tag = i),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _BottomButton(
              text: _saving ? '保存中...' : '确认',
              onPressed: _saving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressTabs extends StatelessWidget {
  const _AddressTabs();

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('推荐', true),
      ('购物', false),
      ('秒送', false),
      ('外卖', false),
      ('服务', false),
    ];
    return Container(
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: BoxDecoration(
        color: DouyinTheme.bg(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Wrap(
        spacing: 26,
        runSpacing: 10,
        children: [
          for (final tab in tabs)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tab.$1,
                  style: TextStyle(
                    color: tab.$2 ? DouyinTheme.accent : DouyinTheme.text(context),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 28,
                  height: 3,
                  decoration: BoxDecoration(
                    color: tab.$2 ? DouyinTheme.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.onDefault,
    required this.onCopy,
    required this.onEdit,
    required this.onDelete,
  });

  final MemberAddress address;
  final VoidCallback onDefault;
  final VoidCallback onCopy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DouyinTheme.card(context),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  address.name ?? '收货人',
                  style: context.typo.cardTitle.copyWith(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: DouyinTheme.text(context),
                  ),
                ),
                Text(
                  address.mobile ?? '',
                  style: context.typo.cardTitle.copyWith(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: DouyinTheme.text(context),
                  ),
                ),
                if (address.defaultStatus)
                  const _MiniTag(text: '默认', strong: true),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              address.fullAddress,
              style: context.typo.body.copyWith(
                color: DouyinTheme.sub(context),
                fontSize: 17,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                InkWell(
                  onTap: address.defaultStatus ? null : onDefault,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        address.defaultStatus
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: address.defaultStatus
                            ? DouyinTheme.text(context)
                            : DouyinTheme.line(context),
                        size: 22,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        address.defaultStatus ? '已设购物默认' : '设为购物默认',
                        style: context.typo.caption.copyWith(
                          color: DouyinTheme.sub(context),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                _TextAction('删除', onDelete),
                const _ActionSep(),
                _TextAction('复制', onCopy),
                const _ActionSep(),
                _TextAction('修改', onEdit),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EditCard extends StatelessWidget {
  const _EditCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DouyinTheme.card(context),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(children: children),
      ),
    );
  }
}

class _TextInputRow extends StatelessWidget {
  const _TextInputRow({
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final int maxLines;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: maxLines > 1
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 86,
          child: Padding(
            padding: EdgeInsets.only(top: maxLines > 1 ? 14 : 0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: DouyinTheme.text(context),
              ),
            ),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            style: TextStyle(fontSize: 18, color: DouyinTheme.text(context)),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: DouyinTheme.sub(context)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}

class _TapRow extends StatelessWidget {
  const _TapRow({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: Row(
          children: [
            SizedBox(
              width: 86,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: DouyinTheme.text(context),
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  color: placeholder
                      ? DouyinTheme.sub(context)
                      : DouyinTheme.text(context),
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: DouyinTheme.sub(context)),
          ],
        ),
      ),
    );
  }
}

class _DefaultRow extends StatelessWidget {
  const _DefaultRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '设为默认地址',
                    style: TextStyle(
                      fontSize: 18,
                      color: DouyinTheme.text(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '提醒：下单时会优先使用该地址',
                    style: TextStyle(
                      fontSize: 15,
                      color: DouyinTheme.sub(context),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: value
                    ? DouyinTheme.accent
                    : DouyinTheme.chip(context),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: value ? DouyinTheme.accent : DouyinTheme.line(context),
                ),
              ),
              child: value
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceSection extends StatelessWidget {
  const _ChoiceSection({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 86,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: DouyinTheme.text(context),
              ),
            ),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              for (var i = 0; i < options.length; i++)
                ChoiceChip(
                  label: Text(options[i]),
                  selected: selected == i,
                  showCheckmark: false,
                  selectedColor: _AddressUi.chipSelectedBg(context),
                  backgroundColor: DouyinTheme.chip(context),
                  side: BorderSide(
                    color: selected == i
                        ? DouyinTheme.accent
                        : DouyinTheme.line(context),
                  ),
                  labelStyle: TextStyle(
                    color: selected == i
                        ? DouyinTheme.accent
                        : DouyinTheme.text(context),
                    fontSize: 17,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  onSelected: (_) => onSelected(i),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CenteredContent extends StatelessWidget {
  const _CenteredContent({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: DouyinTheme.sub(context)),
            const SizedBox(height: 16),
            Text(
              title,
              style: context.typo.bodyStrong.copyWith(
                fontSize: 18,
                color: DouyinTheme.text(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: context.typo.caption.copyWith(
                fontSize: 14,
                color: DouyinTheme.sub(context),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: DouyinTheme.accent,
                foregroundColor: Colors.white,
              ),
              child: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppActionColors.surface(context),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: onPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: DouyinTheme.accent,
                  disabledBackgroundColor: DouyinTheme.accent.withValues(
                    alpha: 0.45,
                  ),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.text, this.strong = false});

  final String text;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _AddressUi.tagBg(context, strong: strong),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: DouyinTheme.accent),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          text,
          style: const TextStyle(
            color: DouyinTheme.accent,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction(this.text, this.onTap);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Text(
          text,
          style: TextStyle(
            color: DouyinTheme.sub(context),
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _ActionSep extends StatelessWidget {
  const _ActionSep();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '|',
        style: TextStyle(color: DouyinTheme.line(context)),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.7,
      color: DouyinTheme.line(context),
    );
  }
}

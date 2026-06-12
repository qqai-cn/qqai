import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/default_asset_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/api_base_client.dart';
import 'package:qqai/util/media_url.dart';

import '../data/models/area_models.dart';
import '../data/models/profile_models.dart';
import '../data/repos/area_repo.dart';
import '../data/repos/profile_repo.dart';
import '../providers/my_page_profile.dart';
import '../widgets/area_picker_sheet.dart';

class MyProfileEditPage extends ConsumerStatefulWidget {
  const MyProfileEditPage({super.key});

  @override
  ConsumerState<MyProfileEditPage> createState() => _MyProfileEditPageState();
}

class _MyProfileEditPageState extends ConsumerState<MyProfileEditPage> {
  static const String _defaultCover =
      'https://file.qqai.cn/qqai/2025/09/1.webp';

  bool _loading = true;
  String? _nickname;
  String? _intro;
  String? _avatarUrl;
  String? _coverUrl;
  String? _address;
  int? _areaId;
  String? _birthday;
  int? _sex;
  int? _qqId;
  int _shopStatus = 1;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final page = await ref.read(profileRepoProvider).getMyPage();
      final shop = await ref.read(profileRepoProvider).getMyShop();
      if (!mounted) return;
      setState(() {
        _qqId = page.id;
        _nickname = page.nickname;
        _intro = page.intro;
        _avatarUrl = page.avatar;
        _coverUrl = page.backgroundUrl;
        _address = page.address;
        _areaId = page.areaId;
        _birthday = page.birthday;
        _sex = page.sex;
        _shopStatus = shop?.status ?? 1;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  int get _completionPercent {
    const keys = [
      '_nickname',
      '_intro',
      '_avatarUrl',
      '_coverUrl',
      '_sex',
      '_birthday',
      '_address',
    ];
    var filled = 0;
    if (_nickname?.trim().isNotEmpty == true) filled++;
    if (_intro?.trim().isNotEmpty == true) filled++;
    if (_avatarUrl?.trim().isNotEmpty == true) filled++;
    if (_coverUrl?.trim().isNotEmpty == true) filled++;
    if (_sex != null) filled++;
    if (_birthday?.trim().isNotEmpty == true) filled++;
    if (_address?.trim().isNotEmpty == true) filled++;
    return ((filled / keys.length) * 100).round();
  }

  String get _coverDisplay => (_coverUrl?.trim().isNotEmpty == true)
      ? _coverUrl!.trim()
      : _defaultCover;

  String _sexLabel(int? sex) => switch (sex) {
    1 => '男',
    2 => '女',
    _ => '未设置',
  };

  String get _addressDisplay => formatAddressForDisplay(_address);

  Future<void> _persistMember({
    String? nickname,
    String? avatar,
    int? sex,
    String? birthday,
    int? areaId,
  }) async {
    await ref
        .read(profileRepoProvider)
        .updateMemberUser(
          MemberUserUpdateReq(
            nickname: nickname ?? _nickname,
            avatar: avatar ?? _avatarUrl,
            sex: sex ?? _sex,
            birthday: birthday ?? _birthday,
            areaId: areaId ?? _areaId,
          ),
        );
  }

  Future<void> _persistShop({
    String? name,
    String? intro,
    String? coverUrl,
  }) async {
    await ref
        .read(profileRepoProvider)
        .updateMyShop(
          BlogShopSaveReq(
            name: name ?? _nickname,
            intro: intro ?? _intro,
            coverUrl: coverUrl ?? _coverUrl,
            status: _shopStatus,
          ),
        );
  }

  Future<void> _refreshHomeProfile() async {
    ref.invalidate(myPageProfileProvider);
  }

  Future<void> _pickAndUploadCover() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;
    try {
      final url = await ApiBaseClient.uploadFile(
        file: file,
        directory: 'qqai/profile',
      );
      await _persistShop(coverUrl: url);
      setState(() => _coverUrl = url);
      await _refreshHomeProfile();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('封面上传失败: $e')));
      }
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;
    try {
      final url = await ApiBaseClient.uploadFile(
        file: file,
        directory: 'qqai/profile',
      );
      await _persistMember(avatar: url);
      setState(() => _avatarUrl = url);
      await _refreshHomeProfile();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('头像上传失败: $e')));
      }
    }
  }

  Future<void> _editNickname() async {
    final controller = TextEditingController(text: _nickname ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('修改名字'),
        content: TextField(
          controller: controller,
          maxLength: 20,
          decoration: const InputDecoration(hintText: '请输入昵称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty) return;
    await _persistMember(nickname: result);
    await _persistShop(name: result);
    setState(() => _nickname = result);
    await _refreshHomeProfile();
  }

  Future<void> _editIntro() async {
    final controller = TextEditingController(text: _intro ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('修改简介'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          maxLength: 200,
          decoration: const InputDecoration(hintText: '介绍一下自己吧'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result == null) return;
    await _persistShop(intro: result);
    setState(() => _intro = result);
    await _refreshHomeProfile();
  }

  Future<void> _editSex() async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('男'),
              onTap: () => Navigator.pop(ctx, 1),
            ),
            ListTile(
              title: const Text('女'),
              onTap: () => Navigator.pop(ctx, 2),
            ),
            ListTile(
              title: const Text('不展示'),
              onTap: () => Navigator.pop(ctx, 0),
            ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    await _persistMember(sex: picked);
    setState(() => _sex = picked);
    await _refreshHomeProfile();
  }

  Future<void> _editBirthday() async {
    final initial = _birthday != null ? DateTime.tryParse(_birthday!) : null;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime(1995, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    final value =
        '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    await _persistMember(birthday: value);
    setState(() => _birthday = value);
    await _refreshHomeProfile();
  }

  Future<void> _editArea() async {
    final treeAsync = ref.read(areaTreeProvider);
    final tree = treeAsync.when(
      data: (value) => value,
      loading: () => null,
      error: (error, stackTrace) => null,
    );
    if (tree == null || tree.isEmpty) {
      try {
        final loaded = await ref.read(areaRepoProvider).getTree();
        if (!mounted) return;
        if (loaded.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('地区数据加载失败')));
          return;
        }
        ref.invalidate(areaTreeProvider);
        await _openAreaPicker(loaded);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('地区加载失败: $e')));
        }
      }
      return;
    }
    await _openAreaPicker(tree);
  }

  Future<void> _openAreaPicker(List<AppAreaNode> tree) async {
    final picked = await showAreaPickerSheet(
      context,
      provinces: tree,
      initialAreaId: _areaId,
    );
    if (picked == null) return;
    await _persistMember(areaId: picked.areaId);
    setState(() {
      _areaId = picked.areaId;
      _address = picked.label;
    });
    await _refreshHomeProfile();
  }

  Color get _pageBackground {
    final scheme = Theme.of(context).colorScheme;
    return Theme.of(context).brightness == Brightness.dark
        ? Color.alphaBlend(Colors.white.withValues(alpha: 0.03), scheme.surface)
        : const Color(0xFFF6F7F9);
  }

  Color get _panelColor {
    final scheme = Theme.of(context).colorScheme;
    return Theme.of(context).brightness == Brightness.dark
        ? Color.alphaBlend(Colors.white.withValues(alpha: 0.05), scheme.surface)
        : scheme.surface;
  }

  Color get _softPanelColor {
    final scheme = Theme.of(context).colorScheme;
    return Theme.of(context).brightness == Brightness.dark
        ? Color.alphaBlend(Colors.white.withValues(alpha: 0.04), scheme.surface)
        : const Color(0xFFF9FAFB);
  }

  Color get _dividerColor => AppActionColors.borderSubtle(context);

  List<BoxShadow> get _panelShadow {
    if (Theme.of(context).brightness == Brightness.dark) return const [];
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ];
  }

  String get _nicknameDisplay =>
      _nickname?.trim().isNotEmpty == true ? _nickname!.trim() : '未设置昵称';

  String get _introDisplay =>
      _intro?.trim().isNotEmpty == true ? _intro!.trim() : '这个人很懒，还没有写签名。';

  Widget _buildTopBar({required bool wide}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(wide ? 8 : 4, 8, wide ? 8 : 4, 10),
      child: Row(
        children: [
          IconButton(
            tooltip: '返回',
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '编辑主页',
              style: context.typo.pageTitle.copyWith(
                color: AppActionColors.strong(context),
              ),
            ),
          ),
          _buildCompletionPill(),
        ],
      ),
    );
  }

  Widget _buildCompletionPill() {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_outlined, size: 16, color: color),
          const SizedBox(width: 5),
          Text(
            '$_completionPercent%',
            style: context.typo.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewPanel({required bool wide}) {
    final coverHeight = wide ? 260.0 : 190.0;
    final avatarRadius = wide ? 46.0 : 42.0;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: _panelColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _dividerColor),
        boxShadow: _panelShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: coverHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: _coverDisplay,
                  cacheKey: mediaCacheKey(_coverDisplay),
                  fit: BoxFit.cover,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.10),
                        Colors.black.withValues(alpha: 0.54),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 14,
                  top: 14,
                  child: _glassButton(
                    icon: Icons.photo_camera_outlined,
                    label: '封面',
                    onTap: _pickAndUploadCover,
                  ),
                ),
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 18,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildAvatar(radius: avatarRadius),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _nicknameDisplay,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.typo.pageTitle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _introDisplay,
                                maxLines: wide ? 2 : 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.typo.caption.copyWith(
                                  color: Colors.white.withValues(alpha: 0.84),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '主页资料',
                        style: context.typo.sectionTitle.copyWith(
                          color: AppActionColors.strong(context),
                        ),
                      ),
                    ),
                    Text(
                      '千千号 ${_qqId?.toString() ?? '--'}',
                      style: context.typo.caption.copyWith(
                        color: AppActionColors.subtle(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 7,
                    value: _completionPercent / 100,
                    backgroundColor: scheme.primary.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _infoChip(Icons.person_outline, _sexLabel(_sex)),
                    _infoChip(
                      Icons.cake_outlined,
                      _birthday?.trim().isNotEmpty == true
                          ? _birthday!.trim()
                          : '生日未设置',
                    ),
                    _infoChip(Icons.place_outlined, _addressDisplay),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar({required double radius}) {
    return GestureDetector(
      onTap: _pickAndUploadAvatar,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: _panelColor,
            child: CircleAvatar(
              radius: radius - 2,
              backgroundImage: _avatarUrl?.trim().isNotEmpty == true
                  ? CachedNetworkImageProvider(
                      _avatarUrl!.trim(),
                      cacheKey: mediaCacheKey(_avatarUrl!.trim()),
                    )
                  : null,
              child: _avatarUrl?.trim().isNotEmpty == true
                  ? null
                  : DefaultAssetImage(
                      width: (radius - 2) * 2,
                      height: (radius - 2) * 2,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.24),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.photo_camera_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.black.withValues(alpha: 0.34),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 17),
              const SizedBox(width: 5),
              Text(
                label,
                style: context.typo.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: _softPanelColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppActionColors.subtle(context)),
          const SizedBox(width: 5),
          Text(
            label,
            style: context.typo.caption.copyWith(
              color: AppActionColors.muted(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: _panelColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _dividerColor),
        boxShadow: _panelShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              title,
              style: context.typo.sectionTitle.copyWith(
                color: AppActionColors.strong(context),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _row({
    required String label,
    required String value,
    VoidCallback? onTap,
    bool showChevron = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 78,
                child: Text(
                  label,
                  style: context.typo.body.copyWith(
                    color: AppActionColors.muted(context),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: context.typo.body.copyWith(
                    color: AppActionColors.strong(context),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showChevron)
                Icon(
                  Icons.chevron_right,
                  color: AppActionColors.subtle(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, indent: 16, color: _dividerColor);
  }

  Widget _buildEditSections() {
    return Column(
      children: [
        _section(
          title: '基础资料',
          children: [
            _row(label: '名字', value: _nicknameDisplay, onTap: _editNickname),
            _divider(),
            _row(label: '简介', value: _introDisplay, onTap: _editIntro),
            _divider(),
            _row(label: '性别', value: _sexLabel(_sex), onTap: _editSex),
            _divider(),
            _row(
              label: '生日',
              value: _birthday?.trim().isNotEmpty == true
                  ? _birthday!.trim()
                  : '未设置',
              onTap: _editBirthday,
            ),
            _divider(),
            _row(label: '所在地', value: _addressDisplay, onTap: _editArea),
            _divider(),
            _row(
              label: '千千号',
              value: _qqId?.toString() ?? '--',
              showChevron: false,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _section(
          title: '主页展示',
          children: [
            _row(label: '服务挂件', value: '团购橱窗、直播预告、公开群', onTap: () {}),
            _divider(),
            _row(label: '合作设置', value: '主页展示「找我官方合作」', onTap: () {}),
            _divider(),
            _row(label: '挂件中心', value: '管理头像挂件', onTap: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 28),
      children: [
        _buildTopBar(wide: false),
        _buildPreviewPanel(wide: false),
        const SizedBox(height: 14),
        _buildEditSections(),
      ],
    );
  }

  Widget _buildWideLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1120),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
          child: Column(
            children: [
              _buildTopBar(wide: true),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 400, child: _buildPreviewPanel(wide: true)),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 620),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              _buildEditSections(),
                              const SizedBox(height: 28),
                            ],
                          ),
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: _pageBackground,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 840;
            return wide ? _buildWideLayout() : _buildNarrowLayout();
          },
        ),
      ),
    );
  }
}

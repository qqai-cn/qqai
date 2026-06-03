import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/default_asset_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/api_base_client.dart';

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
  static const double _contentMaxWidth = 600;

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

  Widget _buildHeader() {
    const coverHeight = 200.0;
    const avatarRadius = 44.0;

    return SizedBox(
      height: coverHeight + avatarRadius,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: coverHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(imageUrl: _coverDisplay, fit: BoxFit.cover),
                Positioned(
                  left: 8,
                  top: MediaQuery.paddingOf(context).top + 4,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    onPressed: () => context.pop(),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: MediaQuery.paddingOf(context).top + 12,
                  child: TextButton.icon(
                    onPressed: _pickAndUploadCover,
                    icon: const Icon(
                      Icons.photo_camera_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      '更换封面',
                      style: context.typo.body.copyWith(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black38,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: coverHeight - avatarRadius,
            child: GestureDetector(
              onTap: _pickAndUploadAvatar,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: avatarRadius - 2,
                      backgroundImage: _avatarUrl?.trim().isNotEmpty == true
                          ? CachedNetworkImageProvider(_avatarUrl!.trim())
                          : null,
                      child: _avatarUrl?.trim().isNotEmpty == true
                          ? null
                          : DefaultAssetImage(
                              width: (avatarRadius - 2) * 2,
                              height: (avatarRadius - 2) * 2,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Container(
                    width: avatarRadius * 2,
                    height: avatarRadius * 2,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.photo_camera_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                        Text(
                          '更换头像',
                          style: context.typo.caption.copyWith(
                            color: Colors.white,
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
      ),
    );
  }

  Widget _row({
    required String label,
    required String value,
    VoidCallback? onTap,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            SizedBox(width: 72, child: Text(label, style: context.typo.body)),
            Expanded(
              child: Text(
                value,
                style: context.typo.body.copyWith(color: Colors.black87),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showChevron)
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
          child: Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '资料完成度 $_completionPercent%',
                        style: context.typo.caption.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    const Divider(height: 1),
                    _row(
                      label: '名字',
                      value: _nickname?.trim().isNotEmpty == true
                          ? _nickname!.trim()
                          : '未设置',
                      onTap: _editNickname,
                    ),
                    const Divider(height: 1, indent: 16),
                    _row(
                      label: '简介',
                      value: _intro?.trim().isNotEmpty == true
                          ? _intro!.trim()
                          : '这个人很懒，还没有写签名。',
                      onTap: _editIntro,
                    ),
                    const Divider(height: 1, indent: 16),
                    _row(label: '性别', value: _sexLabel(_sex), onTap: _editSex),
                    const Divider(height: 1, indent: 16),
                    _row(
                      label: '生日',
                      value: _birthday?.trim().isNotEmpty == true
                          ? _birthday!.trim()
                          : '未设置',
                      onTap: _editBirthday,
                    ),
                    const Divider(height: 1, indent: 16),
                    _row(
                      label: '所在地',
                      value: _addressDisplay,
                      onTap: _editArea,
                    ),
                    const Divider(height: 1, indent: 16),
                    _row(
                      label: '千千号',
                      value: _qqId?.toString() ?? '',
                      showChevron: false,
                    ),
                    const Divider(
                      height: 24,
                      thickness: 8,
                      color: Color(0xFFF5F5F5),
                    ),
                    _row(label: '服务挂件', value: '团购橱窗、直播预告、公开群', onTap: () {}),
                    const Divider(height: 1, indent: 16),
                    _row(label: '合作设置', value: '主页展示「找我官方合作」', onTap: () {}),
                    const Divider(height: 1, indent: 16),
                    _row(label: '挂件中心', value: '管理头像挂件', onTap: () {}),
                    const SizedBox(height: 32),
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

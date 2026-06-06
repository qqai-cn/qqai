import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';

import '../../../util/api_base_client.dart';
import '../data/models/profile_models.dart';
import '../data/repos/profile_repo.dart';

Future<bool> showCreateCollectionDialog(
  BuildContext parentContext,
  WidgetRef ref,
) async {
  final created = await showDialog<bool>(
    context: parentContext,
    builder: (ctx) => const _CreateCollectionForm(),
  );
  if (created != true || !parentContext.mounted) return false;
  ScaffoldMessenger.of(parentContext).showSnackBar(
    const SnackBar(content: Text('合集已创建')),
  );
  return true;
}

Future<bool> showEditCollectionDialog(
  BuildContext parentContext,
  WidgetRef ref, {
  required BlogCollectionResp collection,
}) async {
  final updated = await showDialog<bool>(
    context: parentContext,
    builder: (ctx) => _CreateCollectionForm(collection: collection),
  );
  if (updated != true || !parentContext.mounted) return false;
  ScaffoldMessenger.of(parentContext).showSnackBar(
    const SnackBar(content: Text('合集已更新')),
  );
  return true;
}

class _CreateCollectionForm extends ConsumerStatefulWidget {
  const _CreateCollectionForm({this.collection});

  final BlogCollectionResp? collection;

  @override
  ConsumerState<_CreateCollectionForm> createState() =>
      _CreateCollectionFormState();
}

class _CreateCollectionFormState extends ConsumerState<_CreateCollectionForm> {
  final _nameCtrl = TextEditingController();
  final _introCtrl = TextEditingController();
  final _picker = ImagePicker();
  XFile? _imgFile;
  String? _existingCoverUrl;
  bool _coverRemoved = false;
  bool _submitting = false;
  int _visible = 1;

  bool get _isEdit => widget.collection?.id != null;

  @override
  void initState() {
    super.initState();
    final collection = widget.collection;
    if (collection != null) {
      _nameCtrl.text = collection.name ?? '';
      _introCtrl.text = collection.intro ?? '';
      _visible = collection.visible ?? 1;
      _existingCoverUrl = collection.coverUrl;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _introCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;
    setState(() {
      _imgFile = file;
      _coverRemoved = false;
    });
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写合集名称')),
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      final req = BlogCollectionSaveReq(
        name: name,
        visible: _visible,
        intro: _introCtrl.text.trim().isEmpty ? null : _introCtrl.text.trim(),
        coverUrl: await _resolveCoverUrlForSubmit(),
      );
      if (_isEdit) {
        await ref.read(profileRepoProvider).updateCollection(
              widget.collection!.id!,
              req,
            );
      } else {
        await ref.read(profileRepoProvider).createCollection(req);
      }
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_isEdit ? '更新' : '创建'}失败：$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<String?> _resolveCoverUrlForSubmit() async {
    if (_imgFile != null) {
      return ApiBaseClient.uploadFile(file: _imgFile!);
    }
    if (_coverRemoved) return '';
    return _existingCoverUrl;
  }

  void _clearCover() {
    setState(() {
      _imgFile = null;
      _existingCoverUrl = null;
      _coverRemoved = true;
    });
  }

  Widget _imagePickRow() {
    final remoteCoverUrl =
        !_coverRemoved &&
            _imgFile == null &&
            (_existingCoverUrl?.isNotEmpty ?? false)
        ? _existingCoverUrl
        : null;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _submitting ? null : _pickImage,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: GoodsPageStyle.imageBg(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GoodsPageStyle.border(context)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _imgFile != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      FutureBuilder(
                        future: _imgFile!.readAsBytes(),
                        builder: (context, snap) {
                          if (!snap.hasData) {
                            return const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }
                          return Image.memory(snap.data!, fit: BoxFit.cover);
                        },
                      ),
                      _coverClearButton(onClear: _clearCover),
                    ],
                  )
                : remoteCoverUrl != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: remoteCoverUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _coverPlaceholder(),
                      ),
                      _coverClearButton(onClear: _clearCover),
                    ],
                  )
                : _coverPlaceholder(),
          ),
        ),
      ),
    );
  }

  Widget _coverClearButton({required VoidCallback onClear}) {
    return Positioned(
      right: 10,
      top: 10,
      child: IconButton.filled(
        style: IconButton.styleFrom(
          backgroundColor: Colors.black.withValues(alpha: 0.56),
          minimumSize: const Size(34, 34),
          fixedSize: const Size(34, 34),
        ),
        onPressed: _submitting ? null : onClear,
        icon: const Icon(Icons.close, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _coverPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppActionColors.surface(context),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add_photo_alternate_outlined,
            color: Color(0xFF3578E5),
            size: 28,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '上传合集封面',
          style: TextStyle(
            color: AppActionColors.strong(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '建议使用横向图片',
          style: TextStyle(
            color: AppActionColors.subtle(context),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  InputDecoration _fieldDecoration(String label, {String? hintText}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      labelStyle: TextStyle(color: AppActionColors.muted(context)),
      hintStyle: TextStyle(color: AppActionColors.subtle(context)),
      filled: true,
      fillColor: GoodsPageStyle.imageBg(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: GoodsPageStyle.border(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF3578E5), width: 1.2),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  Widget _dialogHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFEFF6FF)
                : const Color(0xFF3578E5).withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.collections_bookmark_outlined,
            color: Color(0xFF3578E5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEdit ? '编辑合集' : '创建合集',
                style: TextStyle(
                  color: AppActionColors.strong(context),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                _isEdit ? '修改合集名称、封面与可见性' : '把作品整理成系列，方便观众连续观看',
                style: TextStyle(
                  color: AppActionColors.muted(context),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: '关闭',
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close,
            color: AppActionColors.foreground(context),
          ),
        ),
      ],
    );
  }

  Widget _visibilityRow() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: GoodsPageStyle.imageBg(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GoodsPageStyle.border(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '公开合集',
                    style: TextStyle(
                      color: AppActionColors.strong(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '关闭后仅自己可见',
                    style: TextStyle(
                      color: AppActionColors.subtle(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: _visible == 1,
              activeTrackColor: const Color(0xFF3578E5),
              onChanged: _submitting
                  ? null
                  : (v) => setState(() => _visible = v ? 1 : 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    final enabled = !_submitting;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const accent = Color(0xFF3578E5);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: enabled
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [Color(0xFF2A62D4), Color(0xFF4A88F5)]
                    : const [Color(0xFF3578E5), Color(0xFF5B9CFF)],
              )
            : null,
        color: enabled ? null : AppActionColors.borderSubtle(context),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: isDark ? 0.38 : 0.32),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? _submit : null,
          borderRadius: BorderRadius.circular(24),
          splashColor: Colors.white.withValues(alpha: 0.12),
          highlightColor: Colors.white.withValues(alpha: 0.06),
          child: SizedBox(
            height: 48,
            child: Center(
              child: _submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.collections_bookmark_rounded,
                          size: 20,
                          color: enabled
                              ? Colors.white
                              : AppActionColors.subtle(context),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isEdit ? '保存修改' : '创建合集',
                          style: TextStyle(
                            color: enabled
                                ? Colors.white
                                : AppActionColors.subtle(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppActionColors.surface(context),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: GoodsPageStyle.border(context)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.light
                      ? 0.12
                      : 0.35,
                ),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _dialogHeader(),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameCtrl,
                    enabled: !_submitting,
                    maxLength: 64,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: AppActionColors.strong(context)),
                    decoration: _fieldDecoration(
                      '合集名称 *',
                      hintText: '给合集取个名字',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _introCtrl,
                    enabled: !_submitting,
                    maxLength: 512,
                    minLines: 2,
                    maxLines: 4,
                    style: TextStyle(color: AppActionColors.strong(context)),
                    decoration: _fieldDecoration(
                      '合集简介',
                      hintText: '简单介绍这个合集',
                    ),
                  ),
                  const SizedBox(height: 14),
                  _imagePickRow(),
                  const SizedBox(height: 14),
                  _visibilityRow(),
                  const SizedBox(height: 20),
                  _submitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

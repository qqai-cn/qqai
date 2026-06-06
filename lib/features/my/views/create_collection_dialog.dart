import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qqai/config/theme/app_action_colors.dart';

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

class _CreateCollectionForm extends ConsumerStatefulWidget {
  const _CreateCollectionForm();

  @override
  ConsumerState<_CreateCollectionForm> createState() =>
      _CreateCollectionFormState();
}

class _CreateCollectionFormState extends ConsumerState<_CreateCollectionForm> {
  final _nameCtrl = TextEditingController();
  final _introCtrl = TextEditingController();
  final _picker = ImagePicker();
  XFile? _imgFile;
  bool _submitting = false;
  int _visible = 1;

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
    setState(() => _imgFile = file);
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
      String? coverUrl;
      if (_imgFile != null) {
        coverUrl = await ApiBaseClient.uploadFile(file: _imgFile!);
      }
      await ref.read(profileRepoProvider).createCollection(
            BlogCollectionSaveReq(
              name: name,
              visible: _visible,
              intro: _introCtrl.text.trim().isEmpty
                  ? null
                  : _introCtrl.text.trim(),
              coverUrl: coverUrl,
            ),
          );
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('创建失败：$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _imagePickRow({
    required XFile? file,
    required VoidCallback onPick,
    required VoidCallback onClear,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _submitting ? null : onPick,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE1E5EB)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: file == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Color(0xFF3578E5),
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '上传合集封面',
                        style: TextStyle(
                          color: Color(0xFF202124),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '建议使用横向图片',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      FutureBuilder(
                        future: file.readAsBytes(),
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
                      Positioned(
                        right: 10,
                        top: 10,
                        child: IconButton.filled(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withValues(
                              alpha: 0.56,
                            ),
                            minimumSize: const Size(34, 34),
                            fixedSize: const Size(34, 34),
                          ),
                          onPressed: _submitting ? null : onClear,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, {String? hintText}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFF8F9FB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
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
            color: const Color(0xFFEFF6FF),
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
                '创建合集',
                style: TextStyle(
                  color: AppActionColors.strong(context),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '把作品整理成系列，方便观众连续观看',
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
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _visibilityRow() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '公开合集',
                    style: TextStyle(
                      color: Color(0xFF202124),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '关闭后仅自己可见',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
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
    return FilledButton(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        backgroundColor: const Color(0xFF3578E5),
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFE5E7EB),
        disabledForegroundColor: const Color(0xFF9CA3AF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      ),
      onPressed: _submitting ? null : _submit,
      child: _submitting
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('创建合集', style: TextStyle(fontWeight: FontWeight.w700)),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
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
                    decoration: _fieldDecoration(
                      '合集简介',
                      hintText: '简单介绍这个合集',
                    ),
                  ),
                  const SizedBox(height: 14),
                  _imagePickRow(
                    file: _imgFile,
                    onPick: _pickImage,
                    onClear: () => setState(() => _imgFile = null),
                  ),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../util/api_base_client.dart';
import '../../../util/media_url.dart';
import '../data/models/square_model.dart';
import '../data/models/square_save_req_vo.dart';
import '../data/repos/square_repo.dart';
import '../providers/square_detail_provider.dart';
import '../providers/square_providers.dart';

Future<bool> showEditSquareDialog(
  BuildContext parentContext,
  WidgetRef ref, {
  required SquareItem square,
}) async {
  final id = square.id;
  if (id == null || id <= 0) return false;

  final updated = await showDialog<bool>(
    context: parentContext,
    builder: (ctx) => _EditSquareForm(square: square, parentRef: ref),
  );
  if (updated != true || !parentContext.mounted) return false;

  ref.invalidate(squareDetailProvider(id));
  await ref.read(squareProvider.notifier).refresh();
  if (!parentContext.mounted) return false;
  ScaffoldMessenger.of(parentContext).showSnackBar(
    const SnackBar(content: Text('广场已更新')),
  );
  return true;
}

class _EditSquareForm extends StatefulWidget {
  const _EditSquareForm({
    required this.square,
    required this.parentRef,
  });

  final SquareItem square;
  final WidgetRef parentRef;

  @override
  State<_EditSquareForm> createState() => _EditSquareFormState();
}

class _EditSquareFormState extends State<_EditSquareForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  final _picker = ImagePicker();
  XFile? _imgFile;
  bool _submitting = false;
  late String? _existingImgUrl;

  @override
  void initState() {
    super.initState();
    final square = widget.square;
    _nameCtrl = TextEditingController(text: square.squareName ?? '');
    _descCtrl = TextEditingController(text: square.squareDesc ?? '');
    _existingImgUrl = square.squareImg;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
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
      _existingImgUrl = null;
    });
  }

  Future<void> _submit() async {
    final id = widget.square.id;
    if (id == null || id <= 0) return;

    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写广场名称')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      String? imgUrl = _existingImgUrl;
      if (_imgFile != null) {
        imgUrl = await ApiBaseClient.uploadFile(file: _imgFile!);
      }
      final desc = _descCtrl.text.trim();
      final req = SquareSaveReqVO(
        id: id,
        squareName: name,
        userId: widget.square.userId,
        squareImg: imgUrl,
        squareDesc: desc.isEmpty ? null : desc,
        chatConversationId: widget.square.chatConversationId,
      );
      await widget.parentRef.read(squareRepoProvider).updateSquare(req);
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新失败：$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  static const double _previewHeight = 200;

  Widget _imagePreview() {
    if (_imgFile != null) {
      return FutureBuilder(
        future: _imgFile!.readAsBytes(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const SizedBox(
              height: _previewHeight,
              width: double.infinity,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          return Image.memory(
            snap.data!,
            height: _previewHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      );
    }
    final url = resolveMediaUrl(_existingImgUrl);
    if (url == null) return const SizedBox.shrink();
    return CachedNetworkImage(
      imageUrl: url,
      cacheKey: mediaCacheKey(url),
      height: _previewHeight,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPreview = _imgFile != null ||
        (resolveMediaUrl(_existingImgUrl) != null);

    return AlertDialog(
      title: const Text('编辑广场'),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameCtrl,
                enabled: !_submitting,
                decoration: const InputDecoration(
                  labelText: '广场名称 *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descCtrl,
                enabled: !_submitting,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: '广场描述',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Text('广场图标', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _submitting ? null : _pickImage,
                    icon: const Icon(Icons.photo_outlined, size: 18),
                    label: const Text('选择图片'),
                  ),
                  if (hasPreview) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _submitting
                          ? null
                          : () => setState(() {
                                _imgFile = null;
                                _existingImgUrl = null;
                              }),
                      child: const Text('清除'),
                    ),
                  ],
                ],
              ),
              if (hasPreview) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: _previewHeight,
                    width: double.infinity,
                    child: _imagePreview(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('保存'),
        ),
      ],
    );
  }
}

bool isSquareOwner(SquareItem square, String? authUserId) {
  if (authUserId == null || authUserId.isEmpty) return false;
  final uid = int.tryParse(authUserId);
  final ownerId = square.userId;
  return uid != null && ownerId != null && ownerId == uid;
}

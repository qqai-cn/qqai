import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../router/app_routes.dart';
import '../../../util/api_base_client.dart';
import '../data/models/square_create_req_vo.dart';
import '../data/models/square_model.dart';
import '../data/repos/square_repo.dart';
import '../providers/square_providers.dart';

Future<void> showCreateSquareDialog(
  BuildContext parentContext,
  WidgetRef ref,
) async {
  final created = await showDialog<SquareItem>(
    context: parentContext,
    builder: (ctx) => _CreateSquareForm(parentRef: ref),
  );
  if (created == null || !parentContext.mounted) return;
  await ref.read(squareProvider.notifier).refresh();
  if (!parentContext.mounted) return;
  ScaffoldMessenger.of(parentContext).showSnackBar(
    const SnackBar(content: Text('广场已创建')),
  );
  final id = created.id;
  if (id != null && id > 0) {
    parentContext.push(Routes.squareBlogView, extra: id);
  }
}

class _CreateSquareForm extends StatefulWidget {
  const _CreateSquareForm({required this.parentRef});

  final WidgetRef parentRef;

  @override
  State<_CreateSquareForm> createState() => _CreateSquareFormState();
}

class _CreateSquareFormState extends State<_CreateSquareForm> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _picker = ImagePicker();
  XFile? _imgFile;
  bool _submitting = false;

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
    setState(() => _imgFile = file);
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写广场名称')),
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      String? imgUrl;
      if (_imgFile != null) {
        imgUrl = await ApiBaseClient.uploadFile(file: _imgFile!);
      }
      final req = SquareCreateReqVO(
        squareName: name,
        squareImg: imgUrl,
        squareDesc: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      );
      final item = await widget.parentRef.read(squareRepoProvider).createSquare(req);
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(item);
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
    required String label,
    required XFile? file,
    required VoidCallback onPick,
    required VoidCallback onClear,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: _submitting ? null : onPick,
              icon: const Icon(Icons.photo_outlined, size: 18),
              label: const Text('选择图片'),
            ),
            if (file != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: _submitting ? null : onClear,
                child: const Text('清除'),
              ),
            ],
          ],
        ),
        if (file != null) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FutureBuilder(
              future: file.readAsBytes(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const SizedBox(
                    height: 72,
                    width: 72,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return Image.memory(
                  snap.data!,
                  height: 72,
                  width: 72,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('创建广场'),
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
              _imagePickRow(
                label: '广场图标',
                file: _imgFile,
                onPick: _pickImage,
                onClear: () => setState(() => _imgFile = null),
              ),
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
              : const Text('创建'),
        ),
      ],
    );
  }
}

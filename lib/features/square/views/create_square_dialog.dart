import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';

import '../../../router/app_routes.dart';
import '../../../util/api_base_client.dart';
import '../../my/data/models/area_models.dart';
import '../../my/data/repos/area_repo.dart';
import '../../my/widgets/area_picker_sheet.dart';
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
  ScaffoldMessenger.of(
    parentContext,
  ).showSnackBar(const SnackBar(content: Text('广场已创建')));
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
  int? _areaId;
  String? _areaLabel;
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

  Future<void> _pickArea() async {
    final ref = widget.parentRef;
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('地区数据加载失败')),
          );
          return;
        }
        ref.invalidate(areaTreeProvider);
        await _openAreaPicker(loaded);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('地区加载失败: $e')),
          );
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
    if (picked == null || !mounted) return;
    setState(() {
      _areaId = picked.areaId;
      _areaLabel = picked.label;
    });
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请填写广场名称')));
      return;
    }
    if (_areaId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请选择所在地区')));
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
        squareDesc: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        areaId: _areaId,
      );
      final item = await widget.parentRef
          .read(squareRepoProvider)
          .createSquare(req);
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(item);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('创建失败：$e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _areaPickRow() {
    final label = _areaLabel?.trim().isNotEmpty == true
        ? _areaLabel!
        : '请选择省 / 市 / 区';
    final hasValue = _areaLabel?.trim().isNotEmpty == true;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: _submitting ? null : _pickArea,
      child: InputDecorator(
        decoration: _fieldDecoration('所在地区 *'),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: hasValue
                      ? AppActionColors.strong(context)
                      : AppActionColors.subtle(context),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppActionColors.subtle(context),
            ),
          ],
        ),
      ),
    );
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
            color: GoodsPageStyle.imageBg(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GoodsPageStyle.border(context)),
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
                        '上传广场封面',
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
          child: const Icon(Icons.grid_view_rounded, color: Color(0xFF3578E5)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '创建广场',
                style: TextStyle(
                  color: AppActionColors.strong(context),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '建立一个新的作品聚合空间',
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

  Widget _submitButton() {
    return FilledButton(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        backgroundColor: const Color(0xFF3578E5),
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppActionColors.borderSubtle(context),
        disabledForegroundColor: AppActionColors.subtle(context),
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
          : const Text('创建广场', style: TextStyle(fontWeight: FontWeight.w700)),
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
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: AppActionColors.strong(context)),
                    decoration: _fieldDecoration('广场名称 *', hintText: '给广场取个名字'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descCtrl,
                    enabled: !_submitting,
                    minLines: 2,
                    maxLines: 4,
                    style: TextStyle(color: AppActionColors.strong(context)),
                    decoration: _fieldDecoration('广场描述', hintText: '简单介绍这个广场'),
                  ),
                  const SizedBox(height: 12),
                  _areaPickRow(),
                  const SizedBox(height: 14),
                  _imagePickRow(
                    file: _imgFile,
                    onPick: _pickImage,
                    onClear: () => setState(() => _imgFile = null),
                  ),
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

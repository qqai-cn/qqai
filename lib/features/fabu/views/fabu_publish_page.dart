import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../data/models/address_entity.dart';
import '../../index/presentation/views/filter_page.dart';
import '../providers/fabu_providers.dart';
import 'fabu_media_preview_tile.dart';

enum FabuPublishType {
  dynamic('发布动态', true),
  video('发布视频', false),
  goods('发布商品', true),
  aixin('发布爱心', true);

  const FabuPublishType(this.title, this.allowImages);

  final String title;
  final bool allowImages;
}

class FabuPublishPage extends ConsumerStatefulWidget {
  const FabuPublishPage({
    super.key,
    required this.type,
  });

  final FabuPublishType type;

  @override
  ConsumerState<FabuPublishPage> createState() => _FabuPublishPageState();
}

class _FabuPublishPageState extends ConsumerState<FabuPublishPage> {
  final _contentController = TextEditingController();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _targetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_syncContent);
    _titleController.addListener(_syncContent);
    _priceController.addListener(_syncContent);
    _targetController.addListener(_syncContent);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _syncContent() {
    final notifier = ref.read(fabuProvider.notifier);
    final content = switch (widget.type) {
      FabuPublishType.dynamic => _contentController.text,
      FabuPublishType.video => [
          _titleController.text.trim(),
          _contentController.text.trim(),
        ].where((text) => text.isNotEmpty).join('\n'),
      FabuPublishType.goods => [
          _titleController.text.trim(),
          if (_priceController.text.trim().isNotEmpty)
            '¥${_priceController.text.trim()}',
          _contentController.text.trim(),
        ].where((text) => text.isNotEmpty).join('\n'),
      FabuPublishType.aixin => [
          _contentController.text.trim(),
          if (_targetController.text.trim().isNotEmpty)
            '目标：${_targetController.text.trim()}',
        ].where((text) => text.isNotEmpty).join('\n'),
    };
    notifier.updateTextContent(content);
  }

  @override
  Widget build(BuildContext context) {
    final fabuState = ref.watch(fabuProvider);
    final fabuNotifier = ref.read(fabuProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFECEEF2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildInputFields(fabuState, fabuNotifier),
                  14.verticalSpace,
                  _buildMediaPicker(fabuState, fabuNotifier),
                  16.verticalSpace,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FB),
                        border: Border.all(color: const Color(0xFFECEEF2)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          _ActionRow(
                            icon: Icons.add_location_alt_outlined,
                            title: fabuState.selAddressEntity?.name ?? '所在位置',
                            trailing: fabuState.isLoadingGPS
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.chevron_right),
                            onTap: fabuState.isLoadingGPS
                                ? null
                                : () => _showAddressSheet(fabuState, fabuNotifier),
                          ),
                          _ActionRow(
                            icon: Icons.tag_outlined,
                            title: fabuState.huatiSel.isEmpty
                                ? '话题'
                                : fabuState.huatiSel.values.join('、'),
                            onTap: () => _showTopicSheet(fabuState, fabuNotifier),
                          ),
                          _ActionRow(
                            icon: Icons.person_outline,
                            title: fabuState.whoCanSeeSel == null
                                ? '公开'
                                : fabuState.whoCanSee[fabuState.whoCanSeeSel!],
                            showDivider: false,
                            onTap: () => _showVisibilitySheet(fabuState, fabuNotifier),
                          ),
                        ],
                      ),
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

  List<Widget> _buildInputFields(FabuState state, FabuNotifier notifier) {
    final fields = <Widget>[];

    switch (widget.type) {
      case FabuPublishType.dynamic:
        fields.add(_TextBox(
          controller: _contentController,
          hintText: '这一刻的想法...',
          minLines: 5,
          maxLines: 10,
        ));
      case FabuPublishType.video:
        fields.addAll([
          _TextBox(
            controller: _titleController,
            hintText: '标题',
            minLines: 1,
            maxLines: 1,
            maxLength: 80,
          ),
          8.verticalSpace,
          _TextBox(
            controller: _contentController,
            hintText: '描述一下这个视频...',
            minLines: 4,
            maxLines: 8,
          ),
        ]);
      case FabuPublishType.goods:
        fields.addAll([
          _TextBox(
            controller: _titleController,
            hintText: '商品标题',
            minLines: 1,
            maxLines: 1,
            maxLength: 80,
          ),
          8.verticalSpace,
          _TextBox(
            controller: _priceController,
            hintText: '价格',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            minLines: 1,
            maxLines: 1,
            maxLength: 20,
          ),
          8.verticalSpace,
          _TextBox(
            controller: _contentController,
            hintText: '介绍一下商品...',
            minLines: 4,
            maxLines: 8,
          ),
        ]);
      case FabuPublishType.aixin:
        fields.addAll([
          _TextBox(
            controller: _contentController,
            hintText: '说说需要帮助或想帮助什么...',
            minLines: 4,
            maxLines: 8,
          ),
          8.verticalSpace,
          _TextBox(
            controller: _targetController,
            hintText: '目标',
            minLines: 1,
            maxLines: 1,
            maxLength: 80,
          ),
          8.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('求助')),
                ButtonSegment(value: 1, label: Text('帮助')),
              ],
              selected: {state.aixinType},
              onSelectionChanged: (selected) {
                notifier.changeAiXinType(selected.first);
              },
            ),
          ),
        ]);
    }

    return fields;
  }

  Widget _buildMediaPicker(FabuState state, FabuNotifier notifier) {
    if (state.files.isEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _pickMedia(notifier),
          child: Container(
            width: widget.type == FabuPublishType.video ? double.infinity : 132,
            height: widget.type == FabuPublishType.video ? null : 132,
            constraints: widget.type == FabuPublishType.video
                ? BoxConstraints(minHeight: 180.h)
                : null,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE1E5EB)),
            ),
            child: AspectRatio(
              aspectRatio: widget.type == FabuPublishType.video ? 15 / 9 : 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        widget.type == FabuPublishType.video
                            ? Icons.video_call_outlined
                            : Icons.add_photo_alternate_outlined,
                        color: const Color(0xFF3578E5),
                        size: 32,
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    widget.type == FabuPublishType.video ? '添加视频' : '添加图片/视频',
                    style: context.typo.caption.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (state.videoFiles.isNotEmpty) {
      final videoFile = state.videoFiles.first;
      return FabuMediaPreviewTile(
        file: videoFile,
        isVideo: true,
        onRemove: notifier.clearVideo,
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        children: state.files.map((file) {
          return FabuMediaPreviewTile(
            file: file,
            isVideo: false,
            onRemove: () => notifier.clearList(file),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _pickMedia(FabuNotifier notifier) async {
    const imageGroup = XTypeGroup(
      label: '图片',
      extensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
    );
    const videoGroup = XTypeGroup(
      label: '视频',
      extensions: ['mp4', 'mov', 'avi', 'mkv'],
    );
    final files = await openFiles(
      acceptedTypeGroups:
          widget.type.allowImages ? [imageGroup, videoGroup] : [videoGroup],
    );
    if (!mounted || files.isEmpty) return;

    final videoFiles = files.where(_isVideoFile).toList();
    if (videoFiles.isNotEmpty) {
      await notifier.addVideoFiles([videoFiles.first]);
      return;
    }

    if (widget.type.allowImages) {
      await notifier.selectFile(files, context);
    }
  }

  bool _isVideoFile(XFile file) {
    final mimeType = file.mimeType?.toLowerCase();
    if (mimeType?.startsWith('video/') == true) {
      return true;
    }

    final name = file.name.toLowerCase();
    final path = file.path.toLowerCase();
    return _hasVideoExtension(name) || _hasVideoExtension(path);
  }

  bool _hasVideoExtension(String value) {
    return value.endsWith('.mp4') ||
        value.endsWith('.mov') ||
        value.endsWith('.avi') ||
        value.endsWith('.mkv');
  }

  Future<void> _showAddressSheet(
    FabuState state,
    FabuNotifier notifier,
  ) async {
    await notifier.loadGPSAddress();
    if (!mounted) return;
    final currentState = ref.read(fabuProvider);

    final selectedAddress = await showModalBottomSheet<AddressEntity>(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: currentState.addressList.length,
          itemBuilder: (context, index) {
            final address = currentState.addressList[index];
            return ListTile(
              title: Text(address.name),
              subtitle: address.detail.isNotEmpty
                  ? Text(address.detail)
                  : null,
              onTap: () => Navigator.pop(context, address),
            );
          },
        );
      },
    );

    if (selectedAddress != null) {
      notifier.setAddress(selectedAddress);
    }
  }

  Future<void> _showTopicSheet(FabuState state, FabuNotifier notifier) async {
    final result = await showModalBottomSheet<Map<int, String>>(
      context: context,
      builder: (context) => FilterPage(state.huatiSel, state.topicList),
    );
    if (result != null) {
      notifier.setHuati(result);
    }
  }

  Future<void> _showVisibilitySheet(
    FabuState state,
    FabuNotifier notifier,
  ) async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: state.whoCanSee.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(state.whoCanSee[index]),
              trailing: state.whoCanSeeSel == index
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () => Navigator.pop(context, index),
            );
          },
        );
      },
    );
    if (selected != null) {
      notifier.setWhoCanSee(selected);
    }
  }
}

class _TextBox extends StatelessWidget {
  const _TextBox({
    required this.controller,
    required this.hintText,
    required this.minLines,
    required this.maxLines,
    this.maxLength = 1000,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      style: context.typo.inputText,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF8F9FB),
        hintText: hintText,
        hintStyle: context.typo.inputHint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3578E5), width: 1.2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing = const Icon(Icons.chevron_right),
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            border: showDivider
                ? const Border(
                    bottom: BorderSide(color: Color(0xFFECEEF2)),
                  )
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF4B5563), size: 20),
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.body.copyWith(
                    color: const Color(0xFF202124),
                  ),
                ),
              ),
              IconTheme(
                data: const IconThemeData(color: Color(0xFF6B7280), size: 22),
                child: trailing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

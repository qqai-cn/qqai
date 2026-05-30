import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/components/video_player/local_qqai_player.dart';

import '../../data/models/address_entity.dart';
import '../../index/presentation/views/filter_page.dart';
import '../../tool/video_cover_style_preview.dart';
import '../../tool/video_cover_tool.dart';
import '../providers/fabu_providers.dart';
import '../widgets/collection_picker_sheet.dart';
import 'fabu_media_preview_tile.dart';

enum FabuPublishType {
  dynamic('发布动态', true),
  video('发布视频', false),
  help('发布求助', true);

  const FabuPublishType(this.title, this.allowImages);

  final String title;
  final bool allowImages;
}

class FabuPublishPage extends ConsumerStatefulWidget {
  const FabuPublishPage({super.key, required this.type});

  final FabuPublishType type;

  @override
  ConsumerState<FabuPublishPage> createState() => _FabuPublishPageState();
}

class _FabuPublishPageState extends ConsumerState<FabuPublishPage> {
  static const List<int> _rewardOptions = [50, 100, 150];

  final _contentController = TextEditingController();
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  int? _rewardAmountCents;

  final _coverRepaintKey = GlobalKey();
  final _coverPreviewKey = GlobalKey<VideoCoverStylePreviewState>();
  final _videoPreviewController = LocalQqaiPlayerController();
  bool _showWidgetCoverPreview = false;
  int _coverDurationSeconds = 60;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_syncContent);
    _titleController.addListener(_syncContent);
    _targetController.addListener(_syncContent);
    if (widget.type == FabuPublishType.video) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref
            .read(fabuProvider.notifier)
            .setWidgetCoverCapture(_captureWidgetCoverForPublish);
      });
    }
  }

  Future<Uint8List?> _captureWidgetCoverForPublish() async {
    return captureVideoCoverStylePreviewWhenReady(_coverRepaintKey);
  }

  Future<Uint8List?> _captureVisibleCoverPreview() {
    return captureVideoCoverStylePreviewWhenReady(_coverRepaintKey);
  }

  @override
  void dispose() {
    if (widget.type == FabuPublishType.video) {
      ref.read(fabuProvider.notifier).setWidgetCoverCapture(null);
    }
    _contentController.dispose();
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _syncContent() {
    final notifier = ref.read(fabuProvider.notifier);
    notifier.updateRewardAmount(
      widget.type == FabuPublishType.help ? _rewardAmountCents : null,
    );
    final content = switch (widget.type) {
      FabuPublishType.dynamic => _contentController.text,
      FabuPublishType.video => _contentController.text.trim(),
      FabuPublishType.help => [
        _contentController.text.trim(),
        if (_targetController.text.trim().isNotEmpty)
          '目标：${_targetController.text.trim()}',
        if (_rewardAmountCents != null)
          '悬赏金额：${_formatYuan(_rewardAmountCents!)}元',
      ].where((text) => text.isNotEmpty).join('\n'),
    };
    notifier.updateTextContent(content);
    if (widget.type == FabuPublishType.video) {
      notifier.updateBlogTitle(_titleController.text.trim());
    }
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
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.chevron_right),
                            onTap: fabuState.isLoadingGPS
                                ? null
                                : () => _showAddressSheet(
                                    fabuState,
                                    fabuNotifier,
                                  ),
                          ),
                          _ActionRow(
                            icon: Icons.tag_outlined,
                            title: fabuState.huatiSel.isEmpty
                                ? '话题'
                                : fabuState.huatiSel.values.join('、'),
                            onTap: () =>
                                _showTopicSheet(fabuState, fabuNotifier),
                          ),
                          if (widget.type == FabuPublishType.video)
                            _ActionRow(
                              icon: Icons.collections_bookmark_outlined,
                              title: fabuState.collectionSel.isEmpty
                                  ? '合集'
                                  : fabuState.collectionSel.values.join('、'),
                              onTap: () => _showCollectionSheet(fabuNotifier),
                            ),
                          _ActionRow(
                            icon: Icons.person_outline,
                            title: fabuState.whoCanSeeSel == null
                                ? '公开'
                                : fabuState.whoCanSee[fabuState.whoCanSeeSel!],
                            showDivider: false,
                            onTap: () =>
                                _showVisibilitySheet(fabuState, fabuNotifier),
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
        fields.add(
          _TextBox(
            controller: _contentController,
            hintText: '这一刻的想法...',
            minLines: 5,
            maxLines: 10,
          ),
        );
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
      case FabuPublishType.help:
        fields.addAll([
          _TextBox(
            controller: _contentController,
            hintText: '说说你需要什么帮助...',
            minLines: 4,
            maxLines: 8,
          ),
          8.verticalSpace,
          _TextBox(
            controller: _targetController,
            hintText: '求助目标',
            minLines: 1,
            maxLines: 1,
            maxLength: 80,
          ),
          12.verticalSpace,
          _RewardSelector(
            options: _rewardOptions,
            selectedAmountCents: _rewardAmountCents,
            balanceCents: 1000,
            onSelected: (amountCents) {
              setState(() {
                _rewardAmountCents = _rewardAmountCents == amountCents
                    ? null
                    : amountCents;
              });
              _syncContent();
            },
            onCustomSelected: _showCustomRewardDialog,
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FabuMediaPreviewTile(
            file: videoFile,
            isVideo: true,
            videoPlayerController: _videoPreviewController,
            onRemove: notifier.clearVideo,
          ),
          12.verticalSpace,
          _buildVideoCoverPicker(state, notifier),
        ],
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

  Widget _buildVideoCoverPicker(FabuState state, FabuNotifier notifier) {
    final coverFile = state.coverFile;
    final previewBytes = state.coverPreviewBytes;
    final styledPreviewActive =
        _showWidgetCoverPreview && state.videoFiles.isNotEmpty;
    final hasManualPreview =
        !styledPreviewActive && (previewBytes != null || coverFile != null);
    final hasDisplay = styledPreviewActive || hasManualPreview;
    final videoFile = state.videoFiles.isNotEmpty
        ? state.videoFiles.first
        : null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E5EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasDisplay ? '视频封面预览' : '视频封面',
                        style: context.typo.body.copyWith(
                          color: const Color(0xFF202124),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        _coverStatusText(state, hasDisplay: hasDisplay),
                        style: context.typo.caption.copyWith(
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            if (videoFile != null)
              LocalVideoAspectRatioBox(
                file: videoFile,
                builder: (context, aspectRatio) {
                  if (styledPreviewActive) {
                    return _WidgetVideoCoverPreviewCard(
                      videoPath: videoFile.path,
                      styleId: state.selectedCoverStyleId,
                      durationSeconds: _coverDurationSeconds,
                      repaintKey: _coverRepaintKey,
                      previewKey: _coverPreviewKey,
                      aspectRatio: aspectRatio,
                      onTap: () => _showWidgetCoverFullPreview(),
                    );
                  }
                  return _VideoCoverPreviewCard(
                    bytes: previewBytes,
                    file: coverFile,
                    isLoading: state.isCoverPreviewing,
                    aspectRatio: aspectRatio,
                    onTap: hasDisplay
                        ? () => _showCoverFullPreview(
                            bytes: previewBytes,
                            file: coverFile,
                          )
                        : null,
                  );
                },
              ),
            12.verticalSpace,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: qqaiVideoCoverStyles.map((style) {
                final selected = style.id == state.selectedCoverStyleId;
                return ChoiceChip(
                  label: Text(style.label),
                  selected: selected,
                  onSelected: (_) {
                    notifier.setCoverStyle(style.id);
                    if (_showWidgetCoverPreview) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _coverPreviewKey.currentState?.regenerate();
                      });
                    }
                  },
                  selectedColor: const Color(0xFFEAF2FF),
                  side: BorderSide(
                    color: selected
                        ? const Color(0xFF3578E5)
                        : const Color(0xFFE1E5EB),
                  ),
                  labelStyle: context.typo.caption.copyWith(
                    color: selected
                        ? const Color(0xFF3578E5)
                        : const Color(0xFF6B7280),
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
            10.verticalSpace,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _pickVideoCover(notifier),
                  icon: const Icon(Icons.upload_file_outlined, size: 18),
                  label: const Text('选择封面'),
                ),
                OutlinedButton.icon(
                  onPressed: state.isCoverPreviewing
                      ? null
                      : () => _useCurrentVideoFrameAsCover(notifier),
                  icon: const Icon(Icons.movie_creation_outlined, size: 18),
                  label: const Text('使用当前帧'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _refreshCoverPreview(notifier),
                  icon: const Icon(Icons.video_settings_outlined, size: 18),
                  label: const Text('生成预览'),
                ),
                if (hasDisplay)
                  TextButton(
                    onPressed: () {
                      setState(() => _showWidgetCoverPreview = false);
                      notifier.clearVideoCover();
                    },
                    child: const Text('移除'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _coverStatusText(FabuState state, {required bool hasDisplay}) {
    if (_showWidgetCoverPreview) {
      return '当前预览将作为封面，发布时自动上传';
    }
    if (state.coverFile != null) {
      return '当前封面将在发布时上传';
    }
    if (hasDisplay) {
      return '当前预览将作为封面，发布时自动上传';
    }
    return '拖动进度条定位画面后点击「使用当前帧」，或上传/生成封面';
  }

  Future<void> _useCurrentVideoFrameAsCover(FabuNotifier notifier) async {
    final state = ref.read(fabuProvider);
    if (state.videoFiles.isEmpty) return;

    final position = _videoPreviewController.position;
    if (position == null) {
      _showMessage('视频尚未就绪，请稍后再试');
      return;
    }

    setState(() => _showWidgetCoverPreview = false);
    try {
      await notifier.captureVideoCoverAtTimeMs(
        state.videoFiles.first,
        position.inMilliseconds,
      );
    } catch (e) {
      if (!mounted) return;
      _showMessage('截取封面失败：$e');
    }
  }

  Future<void> _refreshCoverPreview(FabuNotifier notifier) async {
    final state = ref.read(fabuProvider);
    if (state.videoFiles.isEmpty) return;
    final video = state.videoFiles.first;
    try {
      final seconds = await notifier.getVideoDurationSeconds(video);
      if (!mounted) return;
      if (state.coverFile != null) {
        notifier.clearVideoCover();
      }
      setState(() {
        _showWidgetCoverPreview = true;
        _coverDurationSeconds = seconds ?? 60;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _coverPreviewKey.currentState?.regenerate();
      });
    } catch (e) {
      if (!mounted) return;
      _showMessage('封面预览失败：$e');
    }
  }

  Future<void> _showWidgetCoverFullPreview() async {
    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      },
    );

    Uint8List? bytes;
    try {
      bytes = await _captureVisibleCoverPreview();
    } finally {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    if (!mounted) return;
    if (bytes == null) {
      _showMessage('封面预览尚未就绪，请稍后再试');
      return;
    }

    await _showCoverFullPreview(
      bytes: bytes,
      useStyledFrame: true,
      alreadyFramed: true,
    );
  }

  Future<void> _showCoverFullPreview({
    Uint8List? bytes,
    XFile? file,
    bool useStyledFrame = false,
    bool alreadyFramed = false,
  }) async {
    if (bytes == null && file == null) return;
    final resolvedBytes = bytes ?? await file!.readAsBytes();
    if (!mounted) return;

    if (useStyledFrame) {
      await showDialog<void>(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.92),
        builder: (context) {
          return _VideoCoverStyledFullscreenDialog(
            bytes: resolvedBytes,
            alreadyFramed: alreadyFramed,
          );
        },
      );
      return;
    }

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (context) {
        return Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              PhotoView(
                imageProvider: MemoryImage(resolvedBytes),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2.5,
                backgroundDecoration: const BoxDecoration(color: Colors.black),
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + 8,
                right: 8,
                child: IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.45),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickVideoCover(FabuNotifier notifier) async {
    const coverGroup = XTypeGroup(
      label: '视频封面',
      extensions: qqaiVideoCoverImageExtensions,
    );
    final file = await openFile(acceptedTypeGroups: [coverGroup]);
    if (file == null) return;
    setState(() => _showWidgetCoverPreview = false);
    await notifier.selectVideoCover(file);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
      acceptedTypeGroups: widget.type.allowImages
          ? [imageGroup, videoGroup]
          : [videoGroup],
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

  Future<void> _showAddressSheet(FabuState state, FabuNotifier notifier) async {
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
              subtitle: address.detail.isNotEmpty ? Text(address.detail) : null,
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

  Future<void> _showCollectionSheet(FabuNotifier notifier) async {
    final state = ref.read(fabuProvider);
    final result = await showCollectionPickerSheet(
      context,
      initialSelection: state.collectionSel,
    );
    if (result != null) {
      notifier.setCollectionSel(result);
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

  Future<void> _showCustomRewardDialog() async {
    final controller = TextEditingController(
      text: _rewardAmountCents != null && _rewardAmountCents! >= 20000
          ? _formatYuan(_rewardAmountCents!)
          : '200',
    );
    final amount = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('自定义悬赏金额'),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              prefixText: '¥ ',
              hintText: '请输入金额',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                final cents = _parseYuanToCents(controller.text);
                Navigator.pop(context, cents);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (amount == null || amount <= 0 || !mounted) return;
    setState(() {
      _rewardAmountCents = amount;
    });
    _syncContent();
  }
}

int? _parseYuanToCents(String value) {
  final text = value.trim();
  if (text.isEmpty) return null;
  final yuan = double.tryParse(text);
  if (yuan == null || yuan <= 0) return null;
  return (yuan * 100).round();
}

String _formatYuan(int cents) {
  final yuan = cents / 100;
  if (cents % 100 == 0) return yuan.toStringAsFixed(0);
  return yuan.toStringAsFixed(2);
}

class _RewardSelector extends StatelessWidget {
  const _RewardSelector({
    required this.options,
    required this.selectedAmountCents,
    required this.balanceCents,
    required this.onSelected,
    required this.onCustomSelected,
  });

  final List<int> options;
  final int? selectedAmountCents;
  final int balanceCents;
  final ValueChanged<int> onSelected;
  final VoidCallback onCustomSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFECEEF2))),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xFFFFD31A),
                  child: Icon(
                    Icons.workspace_premium,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '悬赏金额',
                  style: context.typo.sectionTitle.copyWith(
                    color: const Color(0xFF202124),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.help_outline,
                  size: 18,
                  color: Color(0xFFB5BAC3),
                ),
                const Spacer(),
                Text(
                  '账户余额',
                  style: context.typo.body.copyWith(
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatYuan(balanceCents),
                  style: context.typo.body.copyWith(
                    color: const Color(0xFFFF8A00),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
              ],
            ),
            6.verticalSpace,
            Text(
              '悬赏越高，召唤的吧友越多哦',
              style: context.typo.body.copyWith(color: const Color(0xFFA7ADB7)),
            ),
            14.verticalSpace,
            Row(
              children: [
                ...options.map((amount) {
                  final amountCents = amount * 100;
                  final selected = selectedAmountCents == amountCents;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _RewardOptionButton(
                        label: '$amount',
                        selected: selected,
                        onTap: () => onSelected(amountCents),
                      ),
                    ),
                  );
                }),
                Expanded(
                  child: _RewardOptionButton(
                    label:
                        selectedAmountCents != null &&
                            selectedAmountCents! >= 20000
                        ? _formatYuan(selectedAmountCents!)
                        : '自定义',
                    selected:
                        selectedAmountCents != null &&
                        selectedAmountCents! >= 20000,
                    onTap: onCustomSelected,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WidgetVideoCoverPreviewCard extends StatelessWidget {
  const _WidgetVideoCoverPreviewCard({
    required this.videoPath,
    required this.styleId,
    required this.durationSeconds,
    required this.repaintKey,
    required this.previewKey,
    required this.aspectRatio,
    this.onTap,
  });

  final String videoPath;
  final int styleId;
  final int durationSeconds;
  final GlobalKey repaintKey;
  final GlobalKey<VideoCoverStylePreviewState> previewKey;
  final double aspectRatio;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(180.0, 320.0);
        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: width,
            child: AspectRatio(
              aspectRatio: qqaiVideoCoverAspectRatio,
              child: Material(
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onTap,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      RepaintBoundary(
                        key: repaintKey,
                        child: VideoCoverFramedContent(
                          child: VideoCoverStylePreview(
                            key: previewKey,
                            videoPath: videoPath,
                            styleId: styleId,
                            durationSeconds: durationSeconds,
                          ),
                        ),
                      ),
                      if (onTap != null)
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.zoom_out_map,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '查看大图',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
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
      },
    );
  }
}

class _VideoCoverStyledFullscreenDialog extends StatelessWidget {
  const _VideoCoverStyledFullscreenDialog({
    required this.bytes,
    this.alreadyFramed = false,
  });

  final Uint8List bytes;
  final bool alreadyFramed;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final size = MediaQuery.sizeOf(context);
    final previewSize = resolveVideoCoverPreviewSize(
      maxWidth: size.width - 32,
      maxHeight: size.height - padding.top - padding.bottom - 80,
    );

    final image = Image.memory(
      bytes,
      width: previewSize.width,
      height: previewSize.height,
      fit: BoxFit.fill,
      gaplessPlayback: true,
    );

    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: previewSize.width,
              height: previewSize.height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Material(
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  child: alreadyFramed
                      ? image
                      : VideoCoverFramedContent(child: image),
                ),
              ),
            ),
          ),
          Positioned(
            top: padding.top + 8,
            right: 8,
            child: IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.45),
              ),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoCoverPreviewCard extends StatelessWidget {
  const _VideoCoverPreviewCard({
    required this.bytes,
    required this.file,
    required this.isLoading,
    required this.aspectRatio,
    this.onTap,
  });

  final Uint8List? bytes;
  final XFile? file;
  final bool isLoading;
  final double aspectRatio;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(180.0, 320.0);
        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: width,
            child: AspectRatio(
              aspectRatio: qqaiVideoCoverAspectRatio,
              child: Material(
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onTap,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (bytes != null)
                        Image.memory(
                          bytes!,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        )
                      else if (file != null)
                        _VideoCoverPreview(file: file!)
                      else if (isLoading)
                        const _VideoCoverPlaceholder()
                      else
                        const _VideoCoverPlaceholder(),
                      if (isLoading)
                        Container(
                          color: Colors.black.withValues(alpha: 0.12),
                          alignment: Alignment.center,
                          child: const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      if (onTap != null && !isLoading)
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.zoom_out_map,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '查看大图',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
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
      },
    );
  }
}

class _VideoCoverPlaceholder extends StatelessWidget {
  const _VideoCoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFECEFF3), Color(0xFFD7DCE3)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Icon(
                Icons.image_outlined,
                color: Color(0xFF9CA3AF),
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '封面占位',
            style: context.typo.caption.copyWith(
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '点击「生成预览」查看效果',
            style: context.typo.caption.copyWith(
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoCoverPreview extends StatelessWidget {
  const _VideoCoverPreview({required this.file});

  final XFile file;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: file.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data!, fit: BoxFit.cover);
        }
        if (snapshot.hasError) {
          return _buildError(context, snapshot.error!, snapshot.stackTrace);
        }
        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }

  Widget _buildError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image_outlined, color: Color(0xFF9CA3AF)),
    );
  }
}

class _RewardOptionButton extends StatelessWidget {
  const _RewardOptionButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedColor = const Color(0xFFFFF3D7);
    final selectedBorder = const Color(0xFFFFC54D);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? selectedColor : const Color(0xFFF6F6FA),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? selectedBorder : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: context.typo.body.copyWith(
            color: selected ? const Color(0xFFE58A00) : const Color(0xFFB8BBC3),
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _TextBox extends StatelessWidget {
  const _TextBox({
    required this.controller,
    required this.hintText,
    required this.minLines,
    required this.maxLines,
    this.maxLength = 1000,
  });

  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      style: context.typo.inputText,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF8F9FB),
        hintText: hintText,
        hintStyle: context.typo.inputHint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3578E5), width: 1.2),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
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
                ? const Border(bottom: BorderSide(color: Color(0xFFECEEF2)))
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

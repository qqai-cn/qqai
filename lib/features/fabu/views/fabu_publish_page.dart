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

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_syncContent);
    _titleController.addListener(_syncContent);
    _targetController.addListener(_syncContent);
  }

  @override
  void dispose() {
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
      FabuPublishType.video => [
        _titleController.text.trim(),
        _contentController.text.trim(),
      ].where((text) => text.isNotEmpty).join('\n'),
      FabuPublishType.help => [
        _contentController.text.trim(),
        if (_targetController.text.trim().isNotEmpty)
          '目标：${_targetController.text.trim()}',
        if (_rewardAmountCents != null)
          '悬赏金额：${_formatYuan(_rewardAmountCents!)}元',
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

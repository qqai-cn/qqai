import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/components/video_player/local_qqai_player.dart';
import 'package:qqai/util/media_url.dart';

import '../../data/models/address_entity.dart';
import '../../blog/data/repos/blog_repo.dart';
import '../../tool/video_cover_style_preview.dart';
import '../../tool/video_cover_sampling.dart';
import '../../tool/video_cover_tool.dart';
import '../providers/fabu_providers.dart';
import '../theme/fabu_publish_theme.dart';
import '../widgets/collection_picker_sheet.dart';
import '../widgets/fabu_web_publish_widgets.dart';
import '../widgets/shop_product_picker_sheet.dart';
import '../../goods/data/models/mall_product_model.dart';
import '../data/models/topic_model.dart';
import 'fabu_media_preview_tile.dart';

enum FabuPublishType {
  dynamic('发布动态', true),
  video('发布视频', false),
  help('发布求助', true);

  const FabuPublishType(this.title, this.allowImages);

  final String title;
  final bool allowImages;

  /// 后端 categary：1 动态 / 2 视频 / 3 求助
  int get categary => switch (this) {
    FabuPublishType.dynamic => 1,
    FabuPublishType.video => 2,
    FabuPublishType.help => 3,
  };

  /// 后端 blogType：视频 Tab 为 2，其余为 1
  int get blogType => this == FabuPublishType.video ? 2 : 1;
}

class FabuPublishPage extends ConsumerStatefulWidget {
  const FabuPublishPage({super.key, required this.type});

  final FabuPublishType type;

  @override
  ConsumerState<FabuPublishPage> createState() => _FabuPublishPageState();
}

class _FabuPublishPageState extends ConsumerState<FabuPublishPage> {
  static const List<int> _rewardOptions = [50, 100, 150];

  late final FabuNotifier _fabuNotifier;
  late final IBlogRepo _blogRepo;

  final _contentController = TextEditingController();
  final _contentFocusNode = FocusNode();
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  int? _rewardAmountCents;

  final _coverRepaintKey = GlobalKey();
  final _coverPreviewKey = GlobalKey<VideoCoverStylePreviewState>();
  final _videoPreviewController = LocalQqaiPlayerController();
  bool _showWidgetCoverPreview = false;
  int _coverDurationSeconds = 60;
  int? _defaultVideoCoverSeekMs;
  final _videoSegmentsPageController = PageController();
  int _currentVideoSegmentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fabuNotifier = ref.read(fabuProvider.notifier);
    _blogRepo = ref.read(blogRepoProvider);
    _contentController.addListener(_syncContent);
    _titleController.addListener(_syncContent);
    _targetController.addListener(_syncContent);
    _videoSegmentsPageController.addListener(_onVideoSegmentPageChanged);
    if (widget.type == FabuPublishType.video) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        _fabuNotifier.setWidgetCoverCapture(_captureWidgetCoverForPublish);
      });
    }
  }

  void _onVideoSegmentPageChanged() {
    final page = _videoSegmentsPageController.page?.round();
    if (page == null || page == _currentVideoSegmentIndex) return;
    if (!mounted) return;
    setState(() => _currentVideoSegmentIndex = page);
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
      _fabuNotifier.setWidgetCoverCapture(null);
    }
    _videoSegmentsPageController.removeListener(_onVideoSegmentPageChanged);
    _videoPreviewController.detach();
    _videoSegmentsPageController.dispose();
    _contentFocusNode.dispose();
    _contentController.dispose();
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _syncContent() {
    _fabuNotifier.updateRewardAmount(
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
    _fabuNotifier.updateTextContent(content);
    if (widget.type == FabuPublishType.video) {
      _fabuNotifier.updateBlogTitle(_titleController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final fabuState = ref.watch(fabuProvider);
    final fabuNotifier = ref.read(fabuProvider.notifier);
    return _buildPublishLayout(fabuState, fabuNotifier);
  }

  Widget _buildPublishLayout(FabuState state, FabuNotifier notifier) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hPad = constraints.maxWidth >= 960 ? 24.0 : 14.0;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FabuWebSectionCard(
                    title: '基础信息',
                    child: _buildWebBasicSection(state, notifier),
                  ),
                  const SizedBox(height: 16),
                  FabuWebSectionCard(
                    title: '扩展信息',
                    child: _buildWebExtendedSection(state, notifier),
                  ),
                  if (widget.type != FabuPublishType.help) ...[
                    const SizedBox(height: 16),
                    FabuWebSectionCard(
                      title: '团购带货',
                      child: _buildGroupBuySection(state, notifier),
                    ),
                  ],
                  const SizedBox(height: 16),
                  FabuWebSectionCard(
                    title: '发布设置',
                    child: _buildWebPublishSettings(state, notifier),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _insertIntoContent(String text) {
    final controller = _contentController;
    final value = controller.value;
    final content = value.text;
    final start = value.selection.start >= 0 ? value.selection.start : content.length;
    final end = value.selection.end >= 0 ? value.selection.end : content.length;
    final updated = content.replaceRange(start, end, text);
    controller.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: start + text.length),
    );
    _contentFocusNode.requestFocus();
    _syncContent();
  }

  Future<void> _showTopicSheet(FabuState state, FabuNotifier notifier) async {
    _insertIntoContent('#');

    final topic = await showModalBottomSheet<SkuuTopicResVO>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TopicPickerSheet(topics: state.topicList),
    );

    if (!mounted || topic == null) return;
    _appendTopicToContent(topic, notifier);
  }

  void _onMentionFriendTap() {
    _insertIntoContent('@');
  }

  void _appendTopicToContent(SkuuTopicResVO topic, FabuNotifier notifier) {
    final name = topic.topicName?.trim() ?? '';
    final id = topic.id;
    if (name.isEmpty || id == null) return;

    _insertIntoContent('$name ');
    final current = ref.read(fabuProvider);
    final next = Map<int, String>.from(current.huatiSel)..[id] = name;
    notifier.setHuati(next);
  }

  Widget _buildWebBasicSection(FabuState state, FabuNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '作品描述',
          style: context.typo.body.copyWith(
            color: FabuPublishTheme.text(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ..._buildInputFields(state, notifier),
        const SizedBox(height: 12),
        Row(
          children: [
            _WebTagButton(
              label: '# 添加话题',
              onTap: () => _showTopicSheet(state, notifier),
            ),
            const SizedBox(width: 12),
            _WebTagButton(
              label: '@ 好友',
              onTap: _onMentionFriendTap,
            ),
          ],
        ),
        if (state.topicList.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildRecommendedTopics(state, notifier),
        ],
        if (widget.type == FabuPublishType.video ||
            widget.type.allowImages) ...[
          const SizedBox(height: 20),
          _buildMediaPicker(state, notifier),
        ],
        if (widget.type == FabuPublishType.video) ...[
          const SizedBox(height: 16),
          _buildWebCollectionRow(state, notifier),
        ],
      ],
    );
  }

  Widget _buildRecommendedTopics(FabuState state, FabuNotifier notifier) {
    final topics = state.topicList.take(8).toList();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final topic in topics)
          if (topic.id != null && (topic.topicName ?? '').isNotEmpty)
            ActionChip(
              label: Text('#${topic.topicName}'),
              backgroundColor: FabuPublishTheme.panelBg(context),
              side: BorderSide(color: FabuPublishTheme.border(context)),
              labelStyle: context.typo.caption.copyWith(
                color: FabuPublishTheme.chipLabel(context),
              ),
              onPressed: () {
                final name = topic.topicName!.trim();
                _insertIntoContent('#$name ');
                final id = topic.id!;
                final next = Map<int, String>.from(state.huatiSel)..[id] = name;
                notifier.setHuati(next);
              },
            ),
        if (state.topicList.length > 8)
          ActionChip(
            label: Text('+${state.topicList.length - 8}'),
            backgroundColor: FabuPublishTheme.panelBg(context),
            side: BorderSide(color: FabuPublishTheme.border(context)),
            labelStyle: context.typo.caption.copyWith(
              color: FabuPublishTheme.chipLabel(context),
            ),
            onPressed: () => _showTopicSheet(state, notifier),
          ),
      ],
    );
  }

  Widget _buildWebCollectionRow(FabuState state, FabuNotifier notifier) {
    final hasCollection = state.collectionSel.isNotEmpty;
    final collectionName = hasCollection
        ? state.collectionSel.values.first
        : null;
    final itemCount = state.collectionItemCount ?? 0;
    final episode = state.collectionEpisode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '添加合集',
                style: context.typo.body.copyWith(
                  color: FabuPublishTheme.text(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CollectionSelectField(
                    label: collectionName ?? '请选择合集',
                    trailing: hasCollection ? '共$itemCount个作品' : null,
                    onTap: () => _showCollectionSheet(notifier),
                  ),
                  if (hasCollection) ...[
                    const SizedBox(height: 10),
                    _CollectionSelectField(
                      label: episode != null ? '第$episode集' : '请选择集数',
                      highlighted: true,
                      onTap: () => _showEpisodeSheet(state, notifier),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showEpisodeSheet(FabuState state, FabuNotifier notifier) async {
    if (state.collectionSel.isEmpty) return;
    final itemCount = state.collectionItemCount ?? 0;
    final maxEpisode = itemCount + 1;
    final selected = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EpisodePickerSheet(
        maxEpisode: maxEpisode,
        selectedEpisode: state.collectionEpisode,
      ),
    );
    if (selected != null && mounted) {
      notifier.setCollectionEpisode(selected);
    }
  }

  Widget _buildWebExtendedSection(FabuState state, FabuNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.type == FabuPublishType.help) ...[
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
          const SizedBox(height: 8),
        ],
        Text(
          '添加标签',
          style: context.typo.body.copyWith(
            color: FabuPublishTheme.text(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _WebDropdownField(
                label: state.selAddressEntity?.name ?? '位置',
                onTap: state.isLoadingGPS
                    ? null
                    : () => _showAddressSheet(state, notifier),
                trailing: state.isLoadingGPS
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
              ),
            ),
            if (widget.type == FabuPublishType.video) ...[
              const SizedBox(width: 12),
              Expanded(
                child: _WebDropdownField(
                  label: state.soundMode == 2 ? '循环背景音乐' : '视频原声',
                  onTap: () => _showSoundModeSheet(state, notifier),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildGroupBuySection(FabuState state, FabuNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '挂载商品后，观众可在作品中查看并购买',
          style: context.typo.caption.copyWith(
            color: AppActionColors.muted(context),
          ),
        ),
        const SizedBox(height: 12),
        _CollectionSelectField(
          label: state.shopProducts.isEmpty
              ? '添加商品'
              : '已选 ${state.shopProducts.length} 件商品',
          onTap: () => _showShopProductSheet(state, notifier),
        ),
        if (state.shopProducts.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...state.shopProducts.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _SelectedShopProductTile(
                product: product,
                onRemove: () {
                  final id = product.id;
                  if (id != null) notifier.removeShopProduct(id);
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showShopProductSheet(
    FabuState state,
    FabuNotifier notifier,
  ) async {
    final selected = await showShopProductPickerSheet(
      context,
      initialSelection: state.shopProducts,
    );
    if (selected != null && mounted) {
      notifier.setShopProducts(selected);
    }
  }

  Widget _buildWebPublishSettings(FabuState state, FabuNotifier notifier) {
    return FabuWebSettingRow(
      label: '谁可以看',
      showDivider: false,
      child: FabuWebRadioGroup(
        options: state.whoCanSee.take(3).toList(),
        selectedIndex: state.whoCanSeeSel ?? 0,
        onChanged: notifier.setWhoCanSee,
      ),
    );
  }

  List<Widget> _buildInputFields(FabuState state, FabuNotifier notifier) {
    final fields = <Widget>[];

    switch (widget.type) {
      case FabuPublishType.video:
        fields.addAll([
          _WebInlineField(
            controller: _titleController,
            hintText: '填写标题，为作品获得更多流量',
            maxLength: _maxTitleLength,
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          _WebInlineField(
            controller: _contentController,
            hintText: '添加作品简介',
            maxLines: 5,
            focusNode: _contentFocusNode,
          ),
        ]);
      case FabuPublishType.help:
        fields.addAll([
          _WebInlineField(
            controller: _contentController,
            hintText: '说说你需要什么帮助...',
            maxLines: 5,
            focusNode: _contentFocusNode,
          ),
          const SizedBox(height: 8),
          _WebInlineField(
            controller: _targetController,
            hintText: '求助目标',
            maxLength: 80,
            maxLines: 1,
          ),
        ]);
      case FabuPublishType.dynamic:
        fields.add(
          _WebInlineField(
            controller: _contentController,
            hintText: '这一刻的想法...',
            maxLines: 6,
            focusNode: _contentFocusNode,
          ),
        );
    }

    return fields;
  }

  Widget _buildMediaPicker(FabuState state, FabuNotifier notifier) {
    if (state.videoFiles.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVideoSegmentsPreview(state, notifier),
          12.verticalSpace,
          _buildVideoCoverPicker(state, notifier),
        ],
      );
    }

    if (state.files.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => _pickMedia(notifier),
              child: Container(
                width: widget.type == FabuPublishType.video
                    ? double.infinity
                    : 132,
                height: widget.type == FabuPublishType.video ? null : 132,
                constraints: widget.type == FabuPublishType.video
                    ? BoxConstraints(minHeight: 180.h)
                    : null,
                decoration: BoxDecoration(
                  color: FabuPublishTheme.panelBg(context),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: FabuPublishTheme.border(context)),
                ),
                child: AspectRatio(
                  aspectRatio: widget.type == FabuPublishType.video
                      ? 15 / 9
                      : 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppActionColors.surface(context),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: FabuPublishTheme.cardShadowAlpha(context),
                              ),
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
                            color: FabuPublishTheme.infoBlue(context),
                            size: 32,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        widget.type == FabuPublishType.video
                            ? '添加视频'
                            : '添加图片/视频',
                        style: context.typo.caption.copyWith(
                          color: AppActionColors.muted(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          12.verticalSpace,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '图片预览',
                style: context.typo.body.copyWith(
                  color: FabuPublishTheme.text(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _buildVideoMusicButton(state, notifier),
            TextButton.icon(
              onPressed: () => _pickMedia(notifier),
              icon: Icon(
                Icons.add,
                size: 18,
                color: FabuPublishTheme.infoBlue(context),
              ),
              label: const Text('继续添加'),
              style: TextButton.styleFrom(
                foregroundColor: FabuPublishTheme.infoBlue(context),
              ),
            ),
          ],
        ),
        8.verticalSpace,
        Align(
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
        ),
      ],
    );
  }

  Widget _buildVideoMusicButton(FabuState state, FabuNotifier notifier) {
    final hasMusic =
        state.backgroundMusicFile != null ||
        (state.uploadedBackgroundMusicUrl?.isNotEmpty == true);
    final musicName = state.backgroundMusicName?.trim();
    final label = hasMusic && musicName != null && musicName.isNotEmpty
        ? musicName
        : '选择背景音乐';

    return TextButton.icon(
      onPressed: () => _showBackgroundMusicSheet(notifier),
      icon: Icon(Icons.music_note_outlined, size: 18, color: FabuPublishTheme.infoBlue(context)),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      style: TextButton.styleFrom(
        foregroundColor: FabuPublishTheme.infoBlue(context),
      ),
    );
  }

  Widget _buildVideoSegmentsPreview(FabuState state, FabuNotifier notifier) {
    final videoFiles = state.videoFiles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                videoFiles.length > 1
                    ? '分段视频（${videoFiles.length} 段，可左右滑动预览）'
                    : '视频预览',
                style: context.typo.body.copyWith(
                  color: FabuPublishTheme.text(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _buildVideoMusicButton(state, notifier),
            TextButton.icon(
              onPressed: () => _pickMedia(notifier),
              icon: Icon(Icons.add, size: 18, color: FabuPublishTheme.infoBlue(context)),
              label: const Text('继续添加'),
              style: TextButton.styleFrom(
                foregroundColor: FabuPublishTheme.infoBlue(context),
              ),
            ),
          ],
        ),
        8.verticalSpace,
        SizedBox(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 15 / 9,
            child: PageView.builder(
              controller: _videoSegmentsPageController,
              itemCount: videoFiles.length,
              itemBuilder: (context, index) {
                final file = videoFiles[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: FabuMediaPreviewTile(
                          file: file,
                          isVideo: true,
                          enableVideoPlayer: index == _currentVideoSegmentIndex,
                          videoPlayerController: index == 0
                              ? _videoPreviewController
                              : null,
                          initialVideoSeekMs: index == 0
                              ? _defaultVideoCoverSeekMs
                              : null,
                          onRemove: () => notifier.removeVideoFile(file),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Text(
                              '${index + 1}/${videoFiles.length}',
                              style: context.typo.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
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

    if (videoFile == null) {
      return const SizedBox.shrink();
    }

    return LocalVideoAspectRatioBox(
      file: videoFile,
      fallbackAspectRatio: 9 / 16,
      builder: (context, videoAspectRatio) {
        return _buildVideoCoverPickerContent(
          state: state,
          notifier: notifier,
          videoFile: videoFile,
          videoAspectRatio: videoAspectRatio,
          coverFile: coverFile,
          previewBytes: previewBytes,
          styledPreviewActive: styledPreviewActive,
          hasManualPreview: hasManualPreview,
          hasDisplay: hasDisplay,
        );
      },
    );
  }

  Widget _buildVideoCoverPickerContent({
    required FabuState state,
    required FabuNotifier notifier,
    required XFile videoFile,
    required double videoAspectRatio,
    required XFile? coverFile,
    required Uint8List? previewBytes,
    required bool styledPreviewActive,
    required bool hasManualPreview,
    required bool hasDisplay,
  }) {
    final availableStyles = qqaiVideoCoverStylesForAspectRatio(
      videoAspectRatio,
    );
    final selectedCoverStyleId = state.selectedCoverStyleId;
    if (!availableStyles.any((style) => style.id == selectedCoverStyleId)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        if (!qqaiVideoCoverStylesForAspectRatio(
          videoAspectRatio,
        ).any((style) => style.id == selectedCoverStyleId)) {
          notifier.setCoverStyle(
            qqaiDefaultVideoCoverStyleForAspectRatio(videoAspectRatio),
          );
          if (_showWidgetCoverPreview) {
            _coverPreviewKey.currentState?.regenerate();
          }
        }
      });
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FabuPublishTheme.panelBg(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: FabuPublishTheme.border(context)),
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
                          color: FabuPublishTheme.text(context),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        _coverStatusText(state, hasDisplay: hasDisplay),
                        style: context.typo.caption.copyWith(
                          color: AppActionColors.muted(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            styledPreviewActive
                ? _WidgetVideoCoverPreviewCard(
                    videoPath: videoFile.path,
                    styleId: state.selectedCoverStyleId,
                    durationSeconds: _coverDurationSeconds,
                    repaintKey: _coverRepaintKey,
                    previewKey: _coverPreviewKey,
                    onTap: () => _showWidgetCoverFullPreview(),
                  )
                : _VideoCoverPreviewCard(
                    bytes: previewBytes,
                    file: coverFile,
                    isLoading: state.isCoverPreviewing,
                    onTap: hasDisplay
                        ? () => _showCoverFullPreview(
                            bytes: previewBytes,
                            file: coverFile,
                          )
                        : null,
                  ),
            12.verticalSpace,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableStyles.map((style) {
                final selected = style.id == state.selectedCoverStyleId;
                return ChoiceChip(
                  label: Text(style.label),
                  selected: selected,
                  backgroundColor: FabuPublishTheme.coverStyleChipBg(context),
                  onSelected: (_) {
                    notifier.setCoverStyle(style.id);
                    if (_showWidgetCoverPreview) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _coverPreviewKey.currentState?.regenerate();
                      });
                    }
                  },
                  selectedColor: FabuPublishTheme.accentTintBg(context),
                  side: BorderSide(
                    color: selected
                        ? FabuPublishTheme.infoBlue(context)
                        : FabuPublishTheme.border(context),
                  ),
                  labelStyle: context.typo.caption.copyWith(
                    color: FabuPublishTheme.coverStyleChipLabel(
                      context,
                      selected: selected,
                    ),
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
                  style: FabuPublishTheme.coverActionButtonStyle(context),
                  icon: const Icon(Icons.upload_file_outlined, size: 18),
                  label: const Text('选择封面'),
                ),
                OutlinedButton.icon(
                  onPressed: state.isCoverPreviewing
                      ? null
                      : () => _useCurrentVideoFrameAsCover(notifier),
                  style: FabuPublishTheme.coverActionButtonStyle(context),
                  icon: const Icon(Icons.movie_creation_outlined, size: 18),
                  label: const Text('使用当前帧'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _refreshCoverPreview(notifier),
                  style: FabuPublishTheme.coverActionButtonStyle(context),
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

  Future<void> _importBackgroundMusic(FabuNotifier notifier) async {
    const audioGroup = XTypeGroup(
      label: '背景音乐',
      extensions: ['mp3', 'm4a', 'aac', 'wav', 'flac', 'ogg'],
    );
    final file = await openFile(acceptedTypeGroups: [audioGroup]);
    if (file == null) return;
    notifier.selectBackgroundMusic(file);
  }

  Future<void> _showBackgroundMusicSheet(FabuNotifier notifier) async {
    final selected = await showModalBottomSheet<BlogBackgroundMusicItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BackgroundMusicSheet(
        repo: _blogRepo,
        onImport: () async => _importBackgroundMusic(notifier),
      ),
    );
    if (selected == null || !context.mounted) return;
    // 等 BottomSheet 关闭并完成 finalizeTree 后再改 provider，避免 deactivate 期间 rebuild 触发 ref 报错
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      notifier.selectBackgroundMusicFromLibrary(
        url: selected.musicUrl,
        name: selected.musicName,
      );
    });
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
      await notifier.addVideoFiles(videoFiles);
      _fillTitleFromFileIfEmpty(videoFiles.first);
      final durationSeconds = await notifier.getVideoDurationSeconds(
        videoFiles.first,
      );
      if (mounted && durationSeconds != null && durationSeconds > 0) {
        setState(() {
          _defaultVideoCoverSeekMs = defaultVideoCoverTimeMs(
            durationSeconds * 1000,
          );
        });
      }
      return;
    }

    if (widget.type.allowImages) {
      await notifier.selectFile(files, context);
    }
  }

  static const int _maxTitleLength = 30;

  void _fillTitleFromFileIfEmpty(XFile file) {
    if (widget.type != FabuPublishType.video) return;
    if (_titleController.text.trim().isNotEmpty) return;

    var name = file.name.trim();
    if (name.isEmpty) {
      final path = file.path.trim();
      if (path.isNotEmpty) {
        name = path.split(RegExp(r'[/\\]')).last;
      }
    }
    if (name.isEmpty) return;

    final dot = name.lastIndexOf('.');
    if (dot > 0) {
      name = name.substring(0, dot);
    }
    name = name.trim();
    if (name.isEmpty) return;

    if (name.length > _maxTitleLength) {
      name = name.substring(0, _maxTitleLength);
    }

    _titleController.text = name;
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
      backgroundColor: AppActionColors.surface(context),
      builder: (context) {
        return ListView.builder(
          itemCount: currentState.addressList.length,
          itemBuilder: (context, index) {
            final address = currentState.addressList[index];
            return ListTile(
              title: Text(
                address.name,
                style: TextStyle(color: FabuPublishTheme.text(context)),
              ),
              subtitle: address.detail.isNotEmpty
                  ? Text(
                      address.detail,
                      style: TextStyle(color: AppActionColors.muted(context)),
                    )
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

  Future<void> _showCollectionSheet(FabuNotifier notifier) async {
    final state = ref.read(fabuProvider);
    final initialId =
        state.collectionSel.isEmpty ? null : state.collectionSel.keys.first;
    final selected = await showSingleCollectionPickerSheet(
      context,
      initialCollectionId: initialId,
    );
    if (selected != null) {
      notifier.setCollection(selected);
    }
  }

  Future<void> _showSoundModeSheet(
    FabuState state,
    FabuNotifier notifier,
  ) async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppActionColors.surface(context),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  '视频原声',
                  style: TextStyle(color: FabuPublishTheme.text(context)),
                ),
                subtitle: Text(
                  '播放视频自带声音',
                  style: TextStyle(color: AppActionColors.muted(context)),
                ),
                trailing: state.soundMode == 1
                    ? Icon(Icons.check, color: FabuPublishTheme.infoBlue(context))
                    : null,
                onTap: () => Navigator.pop(context, 1),
              ),
              ListTile(
                title: Text(
                  '循环背景音乐',
                  style: TextStyle(color: FabuPublishTheme.text(context)),
                ),
                subtitle: Text(
                  '静音视频原声，播放选择的背景音乐',
                  style: TextStyle(color: AppActionColors.muted(context)),
                ),
                trailing: state.soundMode == 2
                    ? Icon(Icons.check, color: FabuPublishTheme.infoBlue(context))
                    : null,
                onTap: () => Navigator.pop(context, 2),
              ),
            ],
          ),
        );
      },
    );
    if (selected == null || !context.mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      notifier.setSoundMode(selected);
    });
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
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: FabuPublishTheme.border(context)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: FabuPublishTheme.rewardBadgeBg,
                  child: Icon(
                    Icons.workspace_premium,
                    size: 15,
                    color: FabuPublishTheme.onAccent(context),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '悬赏金额',
                  style: context.typo.sectionTitle.copyWith(
                    color: FabuPublishTheme.text(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.help_outline,
                  size: 18,
                  color: AppActionColors.subtle(context),
                ),
                const Spacer(),
                Text(
                  '账户余额',
                  style: context.typo.body.copyWith(
                    color: AppActionColors.subtle(context),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatYuan(balanceCents),
                  style: context.typo.body.copyWith(
                    color: FabuPublishTheme.balanceAmount(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppActionColors.subtle(context),
                ),
              ],
            ),
            6.verticalSpace,
            Text(
              '悬赏越高，召唤的吧友越多哦',
              style: context.typo.body.copyWith(
                color: AppActionColors.subtle(context),
              ),
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
    this.onTap,
  });

  final String videoPath;
  final int styleId;
  final int durationSeconds;
  final GlobalKey repaintKey;
  final GlobalKey<VideoCoverStylePreviewState> previewKey;
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
                color: AppActionColors.surface(context),
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
                  color: AppActionColors.surface(context),
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
    this.onTap,
  });

  final Uint8List? bytes;
  final XFile? file;
  final bool isLoading;
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
                color: AppActionColors.surface(context),
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
                          cacheWidth: 640,
                          cacheHeight: 800,
                          filterQuality: FilterQuality.low,
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
    final isLight = Theme.of(context).brightness == Brightness.light;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isLight
              ? const [Color(0xFFECEFF3), Color(0xFFD7DCE3)]
              : [
                  FabuPublishTheme.panelBg(context),
                  AppActionColors.surface(context),
                ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: isLight
                  ? Colors.white.withValues(alpha: 0.72)
                  : Colors.white.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Icon(
                Icons.image_outlined,
                color: AppActionColors.subtle(context),
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '封面占位',
            style: context.typo.caption.copyWith(
              color: AppActionColors.muted(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '点击「生成预览」查看效果',
            style: context.typo.caption.copyWith(
              color: AppActionColors.subtle(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundMusicSheet extends StatefulWidget {
  const _BackgroundMusicSheet({required this.repo, required this.onImport});

  final IBlogRepo repo;
  final Future<void> Function() onImport;

  @override
  State<_BackgroundMusicSheet> createState() => _BackgroundMusicSheetState();
}

class _BackgroundMusicSheetState extends State<_BackgroundMusicSheet> {
  static const _tabs = [('推荐', 'recommend'), ('热门', 'hot'), ('收藏', 'favorite')];

  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  var _tab = 'recommend';
  var _items = const <BlogBackgroundMusicItem>[];
  var _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await widget.repo.searchBackgroundMusic(
        keyword: _searchController.text,
        tab: _tab,
        pageSize: 30,
      );
      if (!mounted) return;
      setState(() => _items = items);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearchChanged(String _) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), _load);
  }

  Future<void> _importAudio() async {
    await widget.onImport();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.58,
        decoration: BoxDecoration(
          color: AppActionColors.surface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          children: [
            8.verticalSpace,
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: FabuPublishTheme.dragHandle(context),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            14.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: FabuPublishTheme.panelBg(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(color: FabuPublishTheme.text(context)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppActionColors.subtle(context),
                    ),
                    hintText: '搜索歌名/歌手/歌词/情绪',
                    hintStyle: TextStyle(color: AppActionColors.subtle(context)),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            14.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: _tabs
                          .map(
                            (tab) => Expanded(
                              child: _MusicTabButton(
                                title: tab.$1,
                                selected: _tab == tab.$2,
                                onTap: () {
                                  if (_tab == tab.$2) return;
                                  setState(() => _tab = tab.$2);
                                  _load();
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _importAudio,
                    icon: const Icon(Icons.library_music_outlined, size: 18),
                    label: const Text('导入'),
                    style: TextButton.styleFrom(
                      foregroundColor: FabuPublishTheme.text(context),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (_error != null) {
      return Center(
        child: Text(
          '背景音乐加载失败',
          style: context.typo.caption.copyWith(color: AppActionColors.muted(context)),
        ),
      );
    }
    if (_items.isEmpty) {
      return Center(
        child: Text(
          '暂无可选背景音乐',
          style: context.typo.caption.copyWith(color: AppActionColors.muted(context)),
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 4, 16.w, 16),
      itemCount: _items.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 56,
        color: FabuPublishTheme.border(context),
      ),
      itemBuilder: (context, index) {
        final item = _items[index];
        return _BackgroundMusicRow(
          item: item,
          selected: index == 0 && _tab == 'recommend',
          onTap: () => Navigator.pop(context, item),
        );
      },
    );
  }
}

class _MusicTabButton extends StatelessWidget {
  const _MusicTabButton({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.typo.body.copyWith(
                color: selected
                    ? FabuPublishTheme.text(context)
                    : AppActionColors.muted(context),
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            8.verticalSpace,
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: selected ? 26 : 0,
              height: 2,
              decoration: BoxDecoration(
                color: selected
                    ? FabuPublishTheme.text(context)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundMusicRow extends StatelessWidget {
  const _BackgroundMusicRow({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final BlogBackgroundMusicItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final coverUrl = resolveMediaUrl(item.coverUrl);
    final subtitleParts = [
      if ((item.creatorName ?? '').trim().isNotEmpty) item.creatorName!.trim(),
      if ((item.durationText ?? '').trim().isNotEmpty)
        item.durationText!.trim(),
    ];
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 46,
                height: 46,
                child: coverUrl == null
                    ? ColoredBox(
                        color: FabuPublishTheme.accentTintBg(context),
                        child: Icon(
                          Icons.music_note,
                          color: FabuPublishTheme.accent,
                        ),
                      )
                    : Image.network(
                        coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => ColoredBox(
                          color: FabuPublishTheme.accentTintBg(context),
                          child: Icon(
                            Icons.music_note,
                            color: FabuPublishTheme.accent,
                          ),
                        ),
                      ),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.musicName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.typo.body.copyWith(
                            color: selected
                                ? FabuPublishTheme.accent
                                : FabuPublishTheme.text(context),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (selected)
                        Icon(
                          Icons.graphic_eq,
                          color: FabuPublishTheme.accent,
                          size: 18,
                        ),
                    ],
                  ),
                  4.verticalSpace,
                  Text(
                    subtitleParts.isEmpty ? '视频原声' : subtitleParts.join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.caption.copyWith(
                      color: AppActionColors.subtle(context),
                    ),
                  ),
                ],
              ),
            ),
            10.horizontalSpace,
            IconButton(
              onPressed: onTap,
              icon: Icon(
                Icons.content_cut,
                color: FabuPublishTheme.text(context),
              ),
            ),
            IconButton(
              onPressed: onTap,
              icon: Icon(
                item.favorite ? Icons.star : Icons.star_border,
                color: FabuPublishTheme.starYellow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoCoverPreview extends StatelessWidget {
  const _VideoCoverPreview({required this.file});

  final XFile file;

  @override
  Widget build(BuildContext context) {
    final image = kIsWeb
        ? Image.network(
            file.path,
            fit: BoxFit.cover,
            cacheWidth: 640,
            cacheHeight: 800,
            filterQuality: FilterQuality.low,
            errorBuilder: _buildImageError,
          )
        : Image.file(
            File(file.path),
            fit: BoxFit.cover,
            cacheWidth: 640,
            cacheHeight: 800,
            filterQuality: FilterQuality.low,
            errorBuilder: _buildImageError,
          );
    return image;
  }

  Widget _buildImageError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return ColoredBox(
      color: AppActionColors.surface(context),
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: AppActionColors.muted(context),
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
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? FabuPublishTheme.rewardSelectedBg(context)
              : FabuPublishTheme.panelBg(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? FabuPublishTheme.rewardBorder : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: context.typo.body.copyWith(
            color: selected
                ? FabuPublishTheme.rewardTextSelected(context)
                : AppActionColors.subtle(context),
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SelectedShopProductTile extends StatelessWidget {
  const _SelectedShopProductTile({
    required this.product,
    required this.onRemove,
  });

  final MallProduct product;
  final VoidCallback onRemove;

  String _formatPrice(int? cents) {
    if (cents == null) return '';
    final yuan = cents / 100;
    if (cents % 100 == 0) return '¥${yuan.toStringAsFixed(0)}';
    return '¥${yuan.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final coverUrl = resolveMediaUrl(product.picUrl);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FabuPublishTheme.panelBg(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: FabuPublishTheme.border(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 44,
                height: 44,
                child: coverUrl == null
                    ? ColoredBox(
                        color: AppActionColors.surface(context),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: AppActionColors.muted(context),
                        ),
                      )
                    : Image.network(
                        coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => ColoredBox(
                          color: AppActionColors.surface(context),
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            color: AppActionColors.muted(context),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '商品',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.body.copyWith(
                      color: FabuPublishTheme.text(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatPrice(product.price),
                    style: context.typo.caption.copyWith(
                      color: FabuPublishTheme.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: Icon(
                Icons.close,
                size: 18,
                color: AppActionColors.muted(context),
              ),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebInlineField extends StatelessWidget {
  const _WebInlineField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.maxLength,
    this.focusNode,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final int? maxLength;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      minLines: maxLines == 1 ? 1 : 3,
      maxLength: maxLength,
      style: context.typo.inputText.copyWith(
        color: FabuPublishTheme.text(context),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: context.typo.inputHint.copyWith(
          color: AppActionColors.subtle(context),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: const UnderlineInputBorder(),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: FabuPublishTheme.border(context)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: FabuPublishTheme.accent, width: 1.2),
        ),
        counterStyle: context.typo.caption.copyWith(
          color: AppActionColors.subtle(context),
        ),
      ),
    );
  }
}

class _WebTagButton extends StatelessWidget {
  const _WebTagButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        foregroundColor: AppActionColors.muted(context),
        side: BorderSide(color: FabuPublishTheme.border(context)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(label, style: context.typo.caption),
    );
  }
}

class _WebDropdownField extends StatelessWidget {
  const _WebDropdownField({
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: FabuPublishTheme.panelBg(context),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: FabuPublishTheme.border(context)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.body.copyWith(
                    color: AppActionColors.subtle(context),
                  ),
                ),
              ),
              trailing ??
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppActionColors.muted(context),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicPickerSheet extends StatelessWidget {
  const _TopicPickerSheet({required this.topics});

  final List<SkuuTopicResVO> topics;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.52;
    return SafeArea(
      top: false,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppActionColors.surface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: FabuPublishTheme.dragHandle(context),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    '选择话题',
                    style: context.typo.sectionTitle.copyWith(
                      color: FabuPublishTheme.text(context),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: FabuPublishTheme.border(context)),
            Expanded(
              child: topics.isEmpty
                  ? Center(
                      child: Text(
                        '暂无话题',
                        style: context.typo.body.copyWith(
                          color: AppActionColors.muted(context),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: topics.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        indent: 20,
                        endIndent: 20,
                        color: FabuPublishTheme.border(context),
                      ),
                      itemBuilder: (context, index) {
                        final topic = topics[index];
                        final name = topic.topicName?.trim() ?? '';
                        if (name.isEmpty) return const SizedBox.shrink();
                        return ListTile(
                          title: Text(
                            '#$name',
                            style: context.typo.body.copyWith(
                              color: FabuPublishTheme.text(context),
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: AppActionColors.muted(context),
                          ),
                          onTap: () => Navigator.pop(context, topic),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionSelectField extends StatelessWidget {
  const _CollectionSelectField({
    required this.label,
    required this.onTap,
    this.trailing,
    this.highlighted = false,
  });

  final String label;
  final VoidCallback onTap;
  final String? trailing;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = label == '请选择合集' || label == '请选择集数';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: FabuPublishTheme.panelBg(context),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: highlighted
                ? FabuPublishTheme.accent
                : FabuPublishTheme.border(context),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.body.copyWith(
                    color: isPlaceholder
                        ? AppActionColors.subtle(context)
                        : FabuPublishTheme.text(context),
                  ),
                ),
              ),
              if (trailing != null) ...[
                Text(
                  trailing!,
                  style: context.typo.caption.copyWith(
                    color: AppActionColors.muted(context),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Icon(
                Icons.keyboard_arrow_down,
                color: AppActionColors.muted(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EpisodePickerSheet extends StatelessWidget {
  const _EpisodePickerSheet({
    required this.maxEpisode,
    this.selectedEpisode,
  });

  final int maxEpisode;
  final int? selectedEpisode;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.45;
    return SafeArea(
      top: false,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppActionColors.surface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: FabuPublishTheme.dragHandle(context),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    '选择集数',
                    style: context.typo.sectionTitle.copyWith(
                      color: FabuPublishTheme.text(context),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: FabuPublishTheme.border(context)),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: maxEpisode,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                  color: FabuPublishTheme.border(context),
                ),
                itemBuilder: (context, index) {
                  final episode = index + 1;
                  final selected = selectedEpisode == episode;
                  return ListTile(
                    title: Text(
                      '第$episode集',
                      style: context.typo.body.copyWith(
                        color: selected
                            ? FabuPublishTheme.accent
                            : FabuPublishTheme.text(context),
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                    trailing: selected
                        ? Icon(Icons.check, color: FabuPublishTheme.accent)
                        : null,
                    onTap: () => Navigator.pop(context, episode),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/fabu/theme/fabu_publish_theme.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/qq_tab_bar.dart';
import '../providers/fabu_providers.dart';
import '../widgets/fabu_ai_publish_overlay.dart';
import 'fabu_publish_page.dart';

class FabuView extends ConsumerStatefulWidget {
  const FabuView({
    super.key,
    this.squareId,
    this.initialType = FabuPublishType.dynamic,
  });

  final int? squareId;
  final FabuPublishType initialType;

  @override
  ConsumerState<FabuView> createState() => _FabuViewState();
}

class _FabuViewState extends ConsumerState<FabuView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _formGeneration = 0;
  final List<FabuPublishType> _tabTypes = const [
    FabuPublishType.dynamic,
    FabuPublishType.video,
    FabuPublishType.help,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTypes.length, vsync: this);
    final initialIndex = _tabTypes.indexOf(widget.initialType);
    if (initialIndex > 0) {
      _tabController.index = initialIndex;
    }
    // 加载地址数据和话题列表
    Future.microtask(() {
      ref.read(fabuProvider.notifier).loadAddressData();
      ref.read(fabuProvider.notifier).loadTopicList();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final fabuState = ref.read(fabuProvider);
    final fabuNotifier = ref.read(fabuProvider.notifier);
    final publishType = _tabTypes[_tabController.index];

    try {
      await fabuNotifier.publishBlog(
        squareId: widget.squareId,
        categary: publishType == FabuPublishType.help ? 2 : 1,
        blogType:
            publishType == FabuPublishType.video ||
                fabuState.videoFiles.isNotEmpty
            ? 2
            : 1,
        addressId: fabuState.selAddressEntity?.id,
        address: fabuState.selAddressEntity?.name,
        shareType: fabuState.whoCanSeeSel,
        topicIds: fabuState.huatiSel.isNotEmpty
            ? fabuState.huatiSel.keys.join(',')
            : null,
        rewardAmount: publishType == FabuPublishType.help
            ? fabuState.aixinType
            : null,
      );

      if (mounted) {
        setState(() => _formGeneration++);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('发布成功'),
            content: const Text('发布成功！'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('发布失败'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fabuState = ref.watch(fabuProvider);
    return Scaffold(
      backgroundColor: GoodsPageStyle.pageBg(context),
      appBar: AppBar(
        backgroundColor: AppActionColors.surface(context),
        surfaceTintColor: AppActionColors.surface(context),
        foregroundColor: AppActionColors.onSurface(context),
        iconTheme: IconThemeData(color: AppActionColors.onSurface(context)),
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        title: QqTabBar(
          controller: _tabController,
          shrinkWrap: true,
          items: _tabTypes
              .map(
                (type) => QqTabItem(
                  label: type.title.replaceFirst('发布', ''),
                  icon: _iconFor(type),
                ),
              )
              .toList(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              style: FabuPublishTheme.publishButtonStyle(context).copyWith(
                minimumSize: const WidgetStatePropertyAll(Size(72, 36)),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 18),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              onPressed: fabuState.isLoading || fabuState.isCoverPreviewing
                  ? null
                  : _publish,
              child: fabuState.isLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: FabuPublishTheme.onAccent(context),
                      ),
                    )
                  : const Text(
                      '发布',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: _tabTypes
                .map(
                  (type) => FabuPublishPage(
                    key: ValueKey('fabu-${type.name}-$_formGeneration'),
                    type: type,
                  ),
                )
                .toList(),
          ),
          if (fabuState.isUploading)
            FabuAiPublishOverlay(
              progress: fabuState.publishProgress,
              stage: fabuState.publishStage,
            ),
        ],
      ),
    );
  }

  IconData _iconFor(FabuPublishType type) {
    return switch (type) {
      FabuPublishType.dynamic => Icons.edit_note_outlined,
      FabuPublishType.video => Icons.play_circle_outline,
      FabuPublishType.help => Icons.volunteer_activism_outlined,
    };
  }
}

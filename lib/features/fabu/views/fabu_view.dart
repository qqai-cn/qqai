import 'package:flutter/material.dart';
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
  late final List<FabuPublishType> _tabTypes = [
    FabuPublishType.dynamic,
    FabuPublishType.video,
    FabuPublishType.help,
  ];
  late final List<Widget> _tabBoby = _tabTypes
      .map((type) => FabuPublishPage(type: type))
      .toList();

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
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('发布成功'),
            content: const Text('博客已成功发布！'),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          '发布',
          style: TextStyle(
            color: Color(0xFF202124),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size(72, 36),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                backgroundColor: const Color(0xFF3578E5),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFE5E7EB),
                disabledForegroundColor: const Color(0xFF9CA3AF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: fabuState.isLoading || fabuState.isCoverPreviewing
                  ? null
                  : _publish,
              child: fabuState.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      '发布',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
        bottom: QqTabBarBottom(
          controller: _tabController,
          items: _tabTypes
              .map(
                (type) => QqTabItem(
                  label: type.title.replaceFirst('发布', ''),
                  icon: _iconFor(type),
                ),
              )
              .toList(),
        ),
      ),
      body: Stack(
        children: [
          TabBarView(controller: _tabController, children: _tabBoby),
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

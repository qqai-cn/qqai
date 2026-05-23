import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/fabu_providers.dart';
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
  late final List<String> _tabTitle = _tabTypes
      .map((type) => type.title)
      .toList();
  late final List<Widget> _tabBoby = _tabTypes
      .map((type) => FabuPublishPage(type: type))
      .toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitle.length, vsync: this);
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(58),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5F8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE8EBF0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: const Color(0xFF202124),
                      unselectedLabelColor: const Color(0xFF6B7280),
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      tabs: _tabTypes.map((type) {
                        return Tab(
                          height: 38,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_iconFor(type), size: 16),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  type.title.replaceFirst('发布', ''),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: _tabBoby),
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

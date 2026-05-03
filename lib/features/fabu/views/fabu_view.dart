import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/my_fonts.dart';

import '../../../config/theme/app_typography.dart';
import '../../../constant/color_constant.dart';
import '../providers/fabu_providers.dart';
import 'fabu_aixin_page.dart';
import 'fabu_dynamic_page.dart';
import 'fabu_goods_page.dart';
import 'fabu_video_page.dart';

class FabuView extends ConsumerStatefulWidget {
  const FabuView({super.key});

  @override
  ConsumerState<FabuView> createState() => _FabuViewState();
}

class _FabuViewState extends ConsumerState<FabuView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final List<String> _tabTitle = ['发布动态', '发布视频', '发布商品', '发布爱心'];
  late final List<Widget> _tabBoby = [
    FabuDynamicPage(),
    FabuVideoPage(),
    FabuGoodsPage(),
    FabuAiXinPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitle.length, vsync: this);
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
    
    try {
      // For now, we'll just pass null for resources—you might want to process files/videos here
      await fabuNotifier.publishBlog(
        categary: 1,
        blogType: fabuState.videoFiles.isNotEmpty ? 2 : 1,
        addressId: fabuState.selAddressEntity?.id,
        address: fabuState.selAddressEntity?.name,
        shareType: fabuState.whoCanSeeSel,
        topicIds: fabuState.huatiSel.isNotEmpty ? fabuState.huatiSel.keys.join(',') : null,
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
    final fabuNotifier = ref.read(fabuProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: _tabTitle.length > 2,
          tabs: _tabTitle.map((e) {
            return Container(
              height: 120.h,
              width: 100.w,
              alignment: Alignment.center,
              child: Text(e),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: fabuState.isLoading ? null : _publish,
            child: fabuState.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    '发布',
                    style: TextStyle(color: Colors.blue),
                  ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabBoby,
      ),
    );
  }

}
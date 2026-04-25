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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          ElevatedButton(
            onPressed: () {
              final index = _tabController.index;
              if (index == 0) {
                // 发布动态
              } else if (index == 1) {
                // 发布视频
                // TODO: 实现发布视频逻辑
              } else if (index == 2) {
                // 发布商品
                // TODO: 实现发布商品逻辑
              } else if (index == 3) {
                // 发布爱心
                // TODO: 实现发布爱心逻辑
              }
            },
            child: Text(
              '发布',
              style: context.typo.button.copyWith(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.ThemeGreen,
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: TabBarView(controller: _tabController, children: _tabBoby),
    );
  }
}

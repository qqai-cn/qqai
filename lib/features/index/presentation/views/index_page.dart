import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/components/KeepAliveTabWrapper.dart';
import 'package:qqai/features/index/providers/index_providers.dart';
import 'package:qqai/features/lookart/presentation/views/look_art_right.dart';

import '../../../blog/presentation/views/blog_view.dart';
import '../../../goods/goods_page.dart';
import '../../../help/presentation/views/help_view.dart';
import '../../../share/presentation/views/share_view.dart';
import '../../../square/views/square_view.dart';
import '../../../tool/tool_page.dart';

class IndexPage extends ConsumerStatefulWidget {
  const IndexPage({super.key});

  @override
  ConsumerState<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends ConsumerState<IndexPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: IndexNotifier.tabItems.map((m) => Tab(text: m)).toList(),
        ),
      ),
      body: Center(
        child: TabBarView(
          controller: _tabController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            KeepAliveTabWrapper(child: BlogView(0)),
            KeepAliveTabWrapper(child: BlogView(1)),
            KeepAliveTabWrapper(child: BlogView(2)),
            KeepAliveTabWrapper(child: SquareView()),
            KeepAliveTabWrapper(child: GoodsPage()),
            KeepAliveTabWrapper(child: HelpView(6)),
            KeepAliveTabWrapper(child: ShareView(7)),
            KeepAliveTabWrapper(child: ToolPage()),
          ],
        ),
      ),
    );
  }
}

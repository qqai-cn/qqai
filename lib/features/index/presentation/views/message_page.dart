import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../providers/home_providers.dart';
import '../widgets/brand_drawer_leading.dart';
import '../widgets/drawer_page.dart';
import '../widgets/lazy_tab_slot.dart';
import '../../../../router/app_routes.dart';
import '../../../friends/chat_page_list.dart';
import '../../../friends/create_group_chat_dialog.dart';
import '../../../friends/friends_page.dart';

class MessagePage extends ConsumerStatefulWidget {
  const MessagePage({super.key, this.initialConversationId});

  final int? initialConversationId;

  @override
  ConsumerState<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends ConsumerState<MessagePage>
    with TickerProviderStateMixin, LazyTabMountMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    onLazyTabChanged(_tabController);
  }

  @override
  void didUpdateWidget(covariant MessagePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialConversationId != widget.initialConversationId &&
        widget.initialConversationId != null &&
        _tabController.index != 0) {
      _tabController.index = 0;
      lazyTabMount(0);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = 1.sw > 800;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 132,
        leading: BrandDrawerLeading(isWideScreen: isWideScreen),
        automaticallyImplyLeading: false,
        title: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: HomeNotifier.messageTabItems
              .map((e) => Tab(text: e, height: 40))
              .toList(),
          onTap: lazyTabMount,
        ),
        actions: [
          IconButton(
            tooltip: '创建群聊',
            icon: const Icon(Icons.group_add),
            onPressed: () => showCreateGroupChatDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_sharp),
            onPressed: () => context.push(Routes.publishZuoPinPageUrl),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push(Routes.searchPage),
          ),
        ],
      ),
      drawer: isWideScreen ? null : const DrawerPage(),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(2, _tabBody),
      ),
    );
  }

  Widget _tabBody(int index) {
    return LazyTabSlot(
      isMounted: lazyTabMountedIndices.contains(index),
      builder: (_) => switch (index) {
        0 => ChatPageList(initialConversationId: widget.initialConversationId),
        _ => const FriendsPage(),
      },
    );
  }
}

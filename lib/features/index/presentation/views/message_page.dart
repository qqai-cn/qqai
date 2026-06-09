import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/refresh_status_badge.dart';

import '../../../../components/qq_tab_bar.dart';
import '../../../../config/theme/app_action_colors.dart';
import '../../../chat/providers/chat_providers.dart';
import '../../providers/home_providers.dart';
import '../../providers/main_shell_tab_reselect_provider.dart';
import '../widgets/app_bar_publish_search_actions.dart';
import '../widgets/brand_drawer_leading.dart';
import '../widgets/drawer_page.dart';
import '../widgets/lazy_tab_slot.dart';
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
  bool _showBottomRefreshStatus = false;

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

  Future<void> _refreshFirstTabWithStatus() async {
    if (_showBottomRefreshStatus) return;
    setState(() => _showBottomRefreshStatus = true);
    ref.invalidate(chatConversationsProvider);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 650));
    } finally {
      if (mounted) {
        setState(() => _showBottomRefreshStatus = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = 1.sw > 800;

    ref.listen(mainShellTabActivationProvider(2), (
      MainShellTabActivation? previous,
      next,
    ) {
      if (!context.mounted) return;
      if (previous == null || next.nonce <= previous.nonce) return;
      lazyTabMount(0);
      if (_tabController.index != 0) {
        _tabController.animateTo(0);
      }
      if (next.refresh) {
        Future.microtask(_refreshFirstTabWithStatus);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leadingWidth: isWideScreen ? 148 : 48,
        leading: BrandDrawerLeading(isWideScreen: isWideScreen),
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        title: QqTabBar(
          controller: _tabController,
          onTap: lazyTabMount,
          alignment: Alignment.centerLeft,
          shrinkWrap: true,
          items: HomeNotifier.messageTabItems
              .map((e) => QqTabItem(label: e))
              .toList(),
        ),
        actions: [
          IconButton(
            tooltip: '创建群聊',
            icon: Icon(
              Icons.group_add,
              color: AppActionColors.foreground(context),
            ),
            onPressed: () => showCreateGroupChatDialog(context, ref),
          ),
          const AppBarPublishSearchActions(),
        ],
      ),
      drawer: isWideScreen ? null : const DrawerPage(),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            physics: isWideScreen
                ? const NeverScrollableScrollPhysics()
                : const PageScrollPhysics(),
            children: List.generate(2, _tabBody),
          ),
          Positioned(
            top: kToolbarHeight,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _showBottomRefreshStatus
                    ? const RefreshStatusBadge()
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
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

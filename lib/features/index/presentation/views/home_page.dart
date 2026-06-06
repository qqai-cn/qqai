import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/AnimatedBottomBar.dart';
import '../../../../components/AnimatedLeftBar.dart';
import '../../../../config/theme/shell_nav_colors.dart';
import '../../../../features/chat/providers/chat_providers.dart';
import '../../providers/home_providers.dart';
import '../../providers/main_shell_tab_reselect_provider.dart';
import '../../../../providers/auth_providers.dart';
import '../widgets/drawer_page.dart';
import '../widgets/lazy_shell_tab.dart';
import '../widgets/wide_sidebar_profile_entry.dart';
import '../widgets/wide_sidebar_theme_toggle.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void _onMainTabTap(int index) {
    final shell = widget.navigationShell;
    if (shell.currentIndex == index) {
      ref.read(mainShellTabReselectProvider(index).notifier).bump();
      return;
    }
    shell.goBranch(index);
    // goBranch 不会触发 HomePage rebuild，需同步 MainShellIndexScope 供 LazyShellTab 挂载。
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final bool isWideScreen = 1.sw > 800;
    final shell = widget.navigationShell;
    final messageUnreadCount = _messageUnreadCount();

    return MainShellIndexScope(
      currentIndex: shell.currentIndex,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: isWideScreen ? const DrawerPage() : null,
        body: isWideScreen
            ? getWideScreen(homeState, shell)
            : shell,
        bottomNavigationBar: !isWideScreen
            ? SafeArea(
                child: AnimatedBottomBar(
                  selectedBarIndex: shell.currentIndex,
                  barItems: HomeNotifier.barItems,
                  badgeCounts: [0, 0, messageUnreadCount, 0],
                  onBarTap: _onMainTabTap,
                  animationDuration: const Duration(milliseconds: 150),
                  barStyle: const BarStyle(),
                ),
              )
            : null,
      ),
    );
  }

  int _messageUnreadCount() {
    final auth = ref.watch(authProvider);
    if (!auth.isAuthenticated) {
      return 0;
    }
    return ref.watch(chatConversationsProvider).maybeWhen(
          data: (conversations) => conversations.fold<int>(
            0,
            (sum, conversation) => sum + (conversation.unreadCount ?? 0),
          ),
          orElse: () => 0,
        );
  }

  Widget getWideScreen(HomeState homeState, StatefulNavigationShell shell) {
    return Row(
      children: [
        Drawer(
          width: homeState.isExtended ? 200 : 70,
          backgroundColor: ShellNavColors.background(context),
          shape: const BorderDirectional(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: ShellNavColors.border(context)),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WideSidebarProfileEntry(isExtended: homeState.isExtended),
                  Expanded(
                    child: Animatedleftbar(
                      selectedBarIndex: shell.currentIndex,
                      barItems: HomeNotifier.barItems,
                      onBarTap: _onMainTabTap,
                      animationDuration: const Duration(milliseconds: 150),
                      barStyle: BarStyle(fontSize: 15.0, iconSize: 20.0),
                      isExtended: homeState.isExtended,
                      footerAboveBeian: WideSidebarThemeToggle(
                        isExtended: homeState.isExtended,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: shell),
      ],
    );
  }
}

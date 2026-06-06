import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../me/presentation/providers/me_providers.dart';
import '../../../my/views/my_view.dart';
import '../widgets/app_bar_publish_search_actions.dart';
import '../widgets/brand_drawer_leading.dart';
import '../widgets/drawer_page.dart';

class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(meProvider);
    final isWideScreen = MediaQuery.sizeOf(context).width > 800;
    return Scaffold(
      appBar: getAppbar2(context, isWideScreen),
      drawer: isWideScreen ? null : const DrawerPage(),
      body: const MyView(),
    );
  }

  PreferredSizeWidget getAppbar2(
    BuildContext context,
    bool isWideScreen,
  ) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 132,
      leading: BrandDrawerLeading(isWideScreen: isWideScreen),
      automaticallyImplyLeading: false,
      actions: const [AppBarPublishSearchActions()],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../providers/home_providers.dart';
import '../widgets/drawer_page.dart';
import '../../../../router/app_routes.dart';
import '../../../video/short_video_player/short_video_player/short_video_player.dart';
import '../../../video/views/long_video_view.dart';

class VideoPage extends ConsumerStatefulWidget {
  const VideoPage({super.key});

  @override
  ConsumerState<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends ConsumerState<VideoPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = 1.sw > 800;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            if (isWideScreen) {
              ref.read(homeProvider.notifier).changeExtended();
            } else {
              Scaffold.of(context).openDrawer();
            }
          },
          child: Image.asset('imgs/hy.gif'),
        ),
        automaticallyImplyLeading: false,
        title: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: false,
          tabs: HomeNotifier.videoTabItems.map((e) {
            return Tab(
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: Text(e),
              ),
            );
          }).toList(),
        ),
        actions: [
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
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [ShortVideoPlayer(), LongVideoView()],
      ),
    );
  }
}

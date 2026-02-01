import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/features/video/views/video_list_view.dart';
import 'package:qqai/features/video/views/video_service.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../router/app_routes.dart';
import '../../comment/providers/comment_providers.dart';
import '../../index/presentation/widgets/drawer_page.dart';
import '../../index/providers/home_providers.dart';
import '../data/mock_data.dart';
import 'multi_manager/flick_multi_manager.dart';
import 'multi_manager/flick_multi_player.dart';

class VideoView extends ConsumerStatefulWidget {
  const VideoView({Key? key}) : super(key: key);

  @override
  _VideoView createState() => _VideoView();
}

class _VideoView extends ConsumerState<VideoView>
    with TickerProviderStateMixin {
  late FlickMultiManager flickMultiManager;
  List items = shortVideoMockData['items'];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    flickMultiManager = FlickMultiManager();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging && mounted) setState(() {
      if(_tabController.index != 0){
        final commentNotifier = ref.read(commentProvider.notifier);
        commentNotifier.dontShowComment();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getVideoData() async {
    List<String> paths = await Future.wait([
      for (var data in shortVideoMockData['items'])
        VideoService.getVideoPath(data['trailer_url']),
    ]);
    items.addAll(paths);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = 1.sw > 800;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            if (isWideScreen) {
              ref.read(homeProvider.notifier).changeExtended();
            } else {
              Scaffold.of(context).openDrawer();
            }
          },
          child: Icon(
            Icons.menu,
            color: getFontColor(_tabController),
            size: 28,
          ),
        ),
        automaticallyImplyLeading: false,
        title: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: getFontColor(_tabController), width: 3),
            ),
          ),
          isScrollable: true,
          tabs: HomeNotifier.videoTabItems.map((e) {
            return Tab(
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  e,
                  style: TextStyle(color: getFontColor(_tabController)),
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_sharp),
            color: getFontColor(_tabController),
            onPressed: () => context.push(Routes.publishZuoPinPageUrl),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            color: getFontColor(_tabController),
            onPressed: () => context.push(Routes.searchPage),
          ),
        ],
      ),
      drawer: isWideScreen ? null : const DrawerPage(),
      body: TabBarView(
        controller: _tabController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [getVideoPlayer(), VideoListView()],
      ),
    );
  }

  Color getFontColor(TabController _tabController) {
    if (_tabController.index == 0) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Widget getVideoPlayer() {
    return VisibilityDetector(
      key: ObjectKey(flickMultiManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          flickMultiManager.pause();
        }
      },
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            height: 800,
            // margin: const EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FlickMultiPlayer(
                url: items[index]['trailer_url'],
                flickMultiManager: flickMultiManager,
                image: shortVideoMockData['items'][index]['image'],
              ),
            ),
          );
        },
      ),
    );
  }
}

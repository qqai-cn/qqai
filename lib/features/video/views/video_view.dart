import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/components/video_player/qqai_player.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/video/views/short_video_controls.dart';
import 'package:qqai/features/video/views/video_list_view.dart';

import '../../../router/app_routes.dart';
import '../../comment/providers/comment_providers.dart';
import '../../index/presentation/widgets/brand_drawer_leading.dart';
import '../../index/presentation/widgets/drawer_page.dart';
import '../../index/providers/home_providers.dart';
import '../providers/video_recommend_providers.dart';

const String _defaultVideoCover =
    'https://file.qqai.cn/qqai/2025/09/1.webp';

class VideoView extends ConsumerStatefulWidget {
  const VideoView({Key? key}) : super(key: key);

  @override
  _VideoView createState() => _VideoView();
}

class _VideoView extends ConsumerState<VideoView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging && mounted) {
      setState(() {
        if (_tabController.index != 0) {
          ref.read(commentProvider.notifier).dontShowComment();
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BlogItem> _playableItems(List<BlogItem> raw) {
    return raw
        .where(
          (e) => firstPlayableVideoUrlFromResources(e.resources) != null,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = 1.sw > 800;
    final recommendState = ref.watch(videoRecommendProvider);
    final recommendNotifier = ref.read(videoRecommendProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 132,
        leading: BrandDrawerLeading(isWideScreen: isWideScreen),
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
                  style: context.typo.sectionTitle
                      .copyWith(color: getFontColor(_tabController)),
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
        children: [
          _buildRecommendTab(recommendState, recommendNotifier),
          const VideoListView(),
        ],
      ),
    );
  }

  Widget _buildRecommendTab(
    VideoRecommendState recommendState,
    VideoRecommendNotifier recommendNotifier,
  ) {
    return recommendState.blogPageData.when(
      loading: () => const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => ColoredBox(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                e.toString(),
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => recommendNotifier.load(),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
      data: (_) {
        final playable = _playableItems(recommendState.allItems);
        if (playable.isEmpty) {
          return ColoredBox(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '暂无推荐视频',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => recommendNotifier.refresh(),
                    child: const Text('刷新', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        }
        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: playable.length,
          onPageChanged: (index) {
            if (index >= playable.length - 2) {
              recommendNotifier.loadMore();
            }
          },
          itemBuilder: (context, index) {
            final item = playable[index];
            final url =
                firstPlayableVideoUrlFromResources(item.resources) ?? '';
            final cover = firstStillImageUrlFromResources(
                  item.resources,
                  fallback: _defaultVideoCover,
                ) ??
                _defaultVideoCover;
            return ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: QqaiPlayer(
                url: url,
                image: cover,
                controls: ShortVideoControls(),
                autoPlay: true,
                videoFit: BoxFit.contain,
              ),
            );
          },
        );
      },
    );
  }

  Color getFontColor(TabController tabController) {
    if (tabController.index == 0) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}

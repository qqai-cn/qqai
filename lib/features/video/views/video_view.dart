import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/views/blog_detail_ui.dart';
import 'package:qqai/features/blog/views/blog_detail_video_toolbar.dart';
import 'package:qqai/features/blog/views/blog_video_detail_player.dart';
import 'package:qqai/features/video/views/video_list_view.dart';

import '../../../router/app_routes.dart';
import '../../comment/providers/comment_providers.dart';
import '../../my/data/repos/profile_repo.dart';
import '../../index/presentation/widgets/brand_drawer_leading.dart';
import '../../index/presentation/widgets/drawer_page.dart';
import '../../index/presentation/widgets/lazy_tab_slot.dart';
import '../../index/providers/home_providers.dart';
import '../providers/video_play_queue_provider.dart';
import '../providers/video_recommend_providers.dart';

class VideoView extends ConsumerStatefulWidget {
  const VideoView({super.key, this.isActive = true});

  final bool isActive;

  @override
  ConsumerState<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends ConsumerState<VideoView>
    with TickerProviderStateMixin, LazyTabMountMixin {
  late TabController _tabController;

  static const _tabPlaceholder = ColoredBox(
    color: Colors.black,
    child: SizedBox.expand(),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      ref.read(videoSubTabIndexProvider.notifier).select(_tabController.index);
    });
  }

  void _onTabChanged() {
    onLazyTabChanged(
      _tabController,
      onSettled: () {
        ref
            .read(videoSubTabIndexProvider.notifier)
            .select(_tabController.index);
        if (_tabController.index != 0) {
          ref.read(commentProvider.notifier).dontShowComment();
        }
      },
    );
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: isWideScreen ? 148 : 48,
        leading: BrandDrawerLeading(isWideScreen: isWideScreen),
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              border: Border(
                bottom: const BorderSide(color: Colors.white, width: 3),
              ),
            ),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.zero,
            onTap: lazyTabMount,
          tabs: HomeNotifier.videoTabItems.map((e) {
            return Tab(
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  e,
                  style: context.typo.sectionTitle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_sharp),
            color: Colors.white,
            onPressed: () => context.push(Routes.publishZuoPinPageUrl),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () => context.push(Routes.searchPage),
          ),
        ],
      ),
      drawer: isWideScreen ? null : const DrawerPage(),
      body: TabBarView(
        controller: _tabController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: List.generate(2, _tabBody),
      ),
    );
  }

  Widget _tabBody(int index) {
    return LazyTabSlot(
      isMounted: lazyTabMountedIndices.contains(index),
      placeholder: _tabPlaceholder,
      builder: (context) => switch (index) {
        0 => _VideoRecommendTab(
          isActive: widget.isActive && index == _tabController.index,
        ),
        _ => const VideoListView(),
      },
    );
  }
}

class _VideoRecommendTab extends ConsumerStatefulWidget {
  const _VideoRecommendTab({required this.isActive});

  final bool isActive;

  @override
  ConsumerState<_VideoRecommendTab> createState() => _VideoRecommendTabState();
}

class _VideoRecommendTabState extends ConsumerState<_VideoRecommendTab> {
  final PageController _pageController = PageController();
  final Map<int, BlogItem> _collectionNextItems = {};
  bool _openingNextCollectionVideo = false;
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<BlogItem> _playableItems(List<BlogItem> raw, List<BlogItem> queued) {
    final base = raw
        .where((e) => firstPlayableVideoUrlFromResources(e.resources) != null)
        .toList();
    if (_collectionNextItems.isEmpty && queued.isEmpty) return base;

    final result = <BlogItem>[];
    final seen = <int>{};
    void addWithCollectionChain(BlogItem item) {
      final id = item.id;
      if (id != null && !seen.add(id)) return;
      result.add(item);
      if (id == null) return;

      var next = _collectionNextItems[id];
      while (next != null) {
        final nextId = next.id;
        if (nextId == null || !seen.add(nextId)) return;
        result.add(next);
        next = _collectionNextItems[nextId];
      }
    }

    for (final item in base) {
      addWithCollectionChain(item);
    }
    for (final item in queued) {
      addWithCollectionChain(item);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = 1.sw > 800;
    final toolbarHeight =
        blogDetailVideoToolbarHeight(showControlsRow: isWideScreen);
    final recommendState = ref.watch(videoRecommendProvider);
    final recommendNotifier = ref.read(videoRecommendProvider.notifier);
    final playQueue = ref.watch(videoPlayQueueProvider);
    final adTopInset = kToolbarHeight;

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
        final playable = _playableItems(recommendState.allItems, playQueue);
        if (playable.isEmpty) {
          return ColoredBox(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('暂无推荐视频', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => recommendNotifier.refresh(),
                    child: const Text(
                      '刷新',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          final current = ref.read(videoRecommendCurrentBlogProvider);
          final currentStillVisible =
              current?.id != null &&
              playable.any((item) => item.id == current!.id);
          if (currentStillVisible) return;
          ref
              .read(videoRecommendCurrentBlogProvider.notifier)
              .select(playable.first);
        });
        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: playable.length,
          onPageChanged: (index) {
            if (index < playable.length) {
              setState(() => _currentPage = index);
              ref
                  .read(videoRecommendCurrentBlogProvider.notifier)
                  .select(playable[index]);
            }
            if (index >= playable.length - 2) {
              recommendNotifier.loadMore();
            }
          },
          itemBuilder: (context, index) {
            final item = playable[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  BlogVideoDetailPlayer(
                    key: ValueKey('video_recommend_player_${item.id ?? index}'),
                    blog: item,
                    adTopInset: adTopInset,
                    isActive: widget.isActive && index == _currentPage,
                    showToolbarControlsRow: isWideScreen,
                    onCompleted: () => _openNextCollectionVideo(item),
                  ),
                  BlogDetailMediaOverlay(
                    blog: item,
                    bottomInset: toolbarHeight,
                    onCommentTap: () =>
                        ref.read(commentProvider.notifier).changeShowComment(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  BlogItemCollection? _effectiveCollection(
    BlogItem blog,
    BlogItemCollection? selected,
  ) {
    final collections = blog.collections ?? const <BlogItemCollection>[];
    if (collections.isEmpty) return null;
    final selectedId = selected?.id;
    if (selectedId != null) {
      for (final collection in collections) {
        if (collection.id == selectedId) return collection;
      }
    }
    return collections.first;
  }

  Future<void> _openNextCollectionVideo(BlogItem currentBlog) async {
    final currentId = currentBlog.id;
    final commentState = ref.read(commentProvider);
    final collection = _effectiveCollection(
      currentBlog,
      commentState.selectedCollection,
    );
    final collectionId = collection?.id;
    if (_openingNextCollectionVideo ||
        currentId == null ||
        collection == null ||
        collectionId == null) {
      return;
    }

    _openingNextCollectionVideo = true;
    try {
      final detail = await ref
          .read(profileRepoProvider)
          .getCollectionDetail(collectionId);
      final videos = (detail.blogs ?? [])
          .where((b) => b.id != null && b.blogType == 2)
          .toList();
      final currentIndex = videos.indexWhere((b) => b.id == currentId);
      if (!mounted || currentIndex < 0 || currentIndex + 1 >= videos.length) {
        return;
      }

      final nextBlog = videos[currentIndex + 1].copyWith(
        collections: [collection],
      );
      final nextId = nextBlog.id;
      if (nextId == null) return;

      _showAutoPlayNextTip();
      setState(() => _collectionNextItems[currentId] = nextBlog);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted || !_pageController.hasClients) return;
        final items = _playableItems(
          ref.read(videoRecommendProvider).allItems,
          ref.read(videoPlayQueueProvider),
        );
        final nextPage = items.indexWhere((item) => item.id == nextId);
        if (nextPage < 0) return;
        ref.read(videoRecommendCurrentBlogProvider.notifier).select(nextBlog);
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );
      });
    } finally {
      _openingNextCollectionVideo = false;
    }
  }

  void _showAutoPlayNextTip() {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('即将自动播放下一集'),
          duration: const Duration(milliseconds: 1600),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

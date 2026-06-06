import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/blog/async_masonry_feed.dart';
import 'package:qqai/components/imgpreview/preview_img.dart';
import 'package:qqai/components/video_player/video_ad_overlay.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/blog/data/blog_feed_state_interactions.dart';
import 'package:qqai/features/blog/data/blog_route_extra.dart';
import 'package:qqai/features/blog/data/home_blog_tab.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/data/repos/blog_repo.dart';
import 'package:qqai/features/blog/providers/blog_feed_list_actions.dart';
import 'package:qqai/features/blog/views/blog_avatar_preview.dart';
import 'package:qqai/features/blog/views/blog_img_item_view.dart';
import 'package:qqai/features/blog/views/blog_video_item_view.dart';
import 'package:qqai/router/app_routes.dart';

import '../data/models/profile_models.dart';
import '../data/repos/profile_repo.dart';

/// 合集作品列表页：从个人主页「合集」进入，展示合集内博客卡片。
class CollectionBlogListPage extends ConsumerStatefulWidget {
  const CollectionBlogListPage({
    super.key,
    required this.collectionId,
    this.initialCollection,
  });

  final int collectionId;
  final BlogCollectionResp? initialCollection;

  @override
  ConsumerState<CollectionBlogListPage> createState() =>
      _CollectionBlogListPageState();
}

class _CollectionBlogListPageState extends ConsumerState<CollectionBlogListPage>
    implements BlogFeedListActions {
  static const int _feedCategory = HomeBlogTab.recommend;

  AsyncValue<BlogPageModelData> _blogPageData = const AsyncLoading();
  List<BlogItem> _items = [];
  BlogCollectionResp? _collection;

  @override
  void initState() {
    super.initState();
    _collection = widget.initialCollection;
    scheduleMicrotask(_load);
  }

  @override
  void didUpdateWidget(covariant CollectionBlogListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collectionId != widget.collectionId) {
      _collection = widget.initialCollection;
      _items = [];
      _blogPageData = const AsyncLoading();
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    setState(() {
      _blogPageData = const AsyncLoading();
    });
    try {
      final detail = await ref
          .read(profileRepoProvider)
          .getCollectionDetail(widget.collectionId);
      if (!mounted) return;
      final collection = BlogItemCollection(
        id: detail.id,
        name: detail.name,
        coverUrl: detail.coverUrl,
        intro: detail.intro,
        itemCount: detail.itemCount,
      );
      final items = (detail.blogs ?? const <BlogItem>[])
          .map(
            (item) => item.collections?.isNotEmpty == true
                ? item
                : item.copyWith(collections: [collection]),
          )
          .toList();
      setState(() {
        _collection = detail;
        _items = items;
        _blogPageData = AsyncData(
          BlogPageModelData(list: items, total: detail.itemCount),
        );
      });
    } catch (e, st) {
      if (!mounted) return;
      setState(() {
        _blogPageData = AsyncError(e, st);
      });
    }
  }

  Future<void> _refresh() => _load();

  void _applyFeedPatch({
    required List<BlogItem> allItems,
    required AsyncValue<BlogPageModelData> blogPageData,
    String? error,
  }) {
    if (!mounted) return;
    setState(() {
      _items = allItems;
      _blogPageData = blogPageData;
    });
    if (error != null && error.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  void onBlogItemTap(
    BuildContext context,
    BlogItem blogItem, {
    String? mediaHeroTag,
    VideoAdPlaybackState? videoAdState,
  }) {
    if (blogItem.blogType == 1) {
      context.push(
        Routes.blogImgDetailView,
        extra: blogDetailRouteExtra(blogItem, mediaHeroTag: mediaHeroTag),
      );
    } else {
      context.push(
        Routes.blogVideoDetailView,
        extra: blogDetailRouteExtra(
          blogItem,
          mediaHeroTag: mediaHeroTag,
          videoAdState: videoAdState,
        ),
      );
    }
  }

  @override
  void onBlogImgItemTap(
    BuildContext context,
    BlogItem blogItem,
    int index,
    String heroTag,
    List<String> imageUrls,
  ) {
    context.push(
      Routes.watchImgUrl,
      extra: PreviewImg(
        id: blogItem.id?.toInt(),
        url: blogItem.resources,
        index: index,
        heroTag: heroTag,
        allUris: imageUrls,
      ),
    );
  }

  @override
  void onBlogAvatarTap(
    BuildContext context,
    BlogItem blogItem,
    String heroTag,
    String avatarUrl,
  ) {
    openBlogAvatarPreview(
      context,
      blog: blogItem,
      heroTag: heroTag,
      imageUrl: avatarUrl,
    );
  }

  @override
  void onCareTap(BlogItem blogItem) {
    unawaited(
      runToggleCareOnFeedState(
        profileRepo: ref.read(profileRepoProvider),
        allItems: _items,
        blogPageData: _blogPageData,
        blogItem: blogItem,
        apply: _applyFeedPatch,
      ),
    );
  }

  @override
  void onCollectTap(BlogItem blogItem) {
    unawaited(
      runToggleCollectOnFeedState(
        repo: ref.read(blogRepoProvider),
        allItems: _items,
        blogPageData: _blogPageData,
        blogItem: blogItem,
        apply: _applyFeedPatch,
      ),
    );
  }

  @override
  Future<void> onNotInterestedTap(BlogItem blogItem) {
    return runNotInterestedOnFeedState(
      repo: ref.read(blogRepoProvider),
      allItems: _items,
      blogPageData: _blogPageData,
      blogItem: blogItem,
      apply: _applyFeedPatch,
    );
  }

  @override
  void onShareTap(BlogItem blogItem) {
    unawaited(
      runRecordShareOnFeedState(
        repo: ref.read(blogRepoProvider),
        allItems: _items,
        blogPageData: _blogPageData,
        blogItem: blogItem,
        apply: _applyFeedPatch,
      ),
    );
  }

  @override
  void onZanTap(BlogItem blogItem) {
    unawaited(
      runToggleZanOnFeedState(
        repo: ref.read(blogRepoProvider),
        allItems: _items,
        blogPageData: _blogPageData,
        blogItem: blogItem,
        apply: _applyFeedPatch,
      ),
    );
  }

  @override
  double getVideoItemHeightWithWidth(int colCount, double screenWidth) {
    final spacing = (colCount - 1) * 8;
    final width = (screenWidth - spacing) / colCount;
    return width * 1.35;
  }

  Widget _buildBody() {
    if (_blogPageData is AsyncData<BlogPageModelData> && _items.isEmpty) {
      return Center(
        child: Text(
          '暂无合集作品',
          style: context.typo.body.copyWith(
            color: AppActionColors.muted(context),
          ),
        ),
      );
    }
    return AsyncMasonryFeed<BlogItem>(
      asyncItems: _blogPageData.whenData((data) => data.list ?? []),
      items: _items,
      hasMore: false,
      onRetry: _load,
      onRefresh: _refresh,
      itemBuilder: (context, index, item) {
        if (item.blogType == 1) {
          return BlogImgItemView(_feedCategory, item, feedActions: this);
        }
        return BlogVideoItemView(_feedCategory, item, feedActions: this);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _collection?.name?.trim();
    final title = name?.isNotEmpty == true ? name! : '合集';
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            if (_collection?.itemCount != null)
              Text(
                '${_collection!.itemCount} 个作品',
                style: context.typo.caption,
              ),
          ],
        ),
        backgroundColor: AppActionColors.surface(context),
        foregroundColor: AppActionColors.strong(context),
      ),
      body: _buildBody(),
    );
  }
}

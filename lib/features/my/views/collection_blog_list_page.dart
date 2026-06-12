import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/blog/async_masonry_feed.dart';
import 'package:qqai/components/in_page_search_bar.dart';
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
import 'package:qqai/features/fabu/providers/fabu_providers.dart';
import 'package:qqai/features/index/presentation/widgets/app_bar_publish_search_actions.dart';
import 'package:qqai/providers/auth_providers.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/media_video_precache.dart';

import '../data/models/profile_models.dart';
import '../data/repos/profile_repo.dart';
import 'create_collection_dialog.dart';

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
  List<BlogItem> _allItems = [];
  List<BlogItem> _items = [];
  BlogCollectionResp? _collection;
  final _searchController = TextEditingController();
  String _searchKeyword = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchQuery(String query) {
    if (query == _searchKeyword) return;
    setState(() {
      _searchKeyword = query;
      _items = _filterItems(_allItems, query);
      if (_blogPageData case AsyncData<BlogPageModelData>(:final value)) {
        _blogPageData = AsyncData(
          value.copyWith(list: _items, total: _items.length),
        );
      }
    });
  }

  List<BlogItem> _filterItems(List<BlogItem> source, String keyword) {
    final q = keyword.trim().toLowerCase();
    if (q.isEmpty) return List<BlogItem>.from(source);
    return source.where((item) {
      final title = item.title?.toLowerCase() ?? '';
      final content = item.content?.toLowerCase() ?? '';
      final creator =
          item.creatorName?.toLowerCase() ?? item.creator?.toLowerCase() ?? '';
      return title.contains(q) || content.contains(q) || creator.contains(q);
    }).toList();
  }

  List<BlogItem> _mergePatchedItems(
    List<BlogItem> source,
    List<BlogItem> patched,
  ) {
    if (patched.isEmpty) return source;
    final byId = {
      for (final item in patched)
        if (item.id != null) item.id!: item,
    };
    return source
        .map((item) {
          final id = item.id;
          if (id != null && byId.containsKey(id)) return byId[id]!;
          return item;
        })
        .toList(growable: false);
  }

  void _setLoadedItems(List<BlogItem> items) {
    _allItems = items;
    _items = _filterItems(items, _searchKeyword);
    _blogPageData = AsyncData(
      BlogPageModelData(list: _items, total: _items.length),
    );
  }

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
      _allItems = [];
      _items = [];
      _searchKeyword = '';
      _searchController.clear();
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
        _setLoadedItems(items);
      });
    } catch (e, st) {
      if (!mounted) return;
      setState(() {
        _blogPageData = AsyncError(e, st);
      });
    }
  }

  Future<void> _refresh() => _load();

  bool get _canPublish {
    final collectionUserId = _collection?.userId;
    final authUserId = int.tryParse(
      (ref.read(authProvider).userId ?? '').trim(),
    );
    return collectionUserId != null &&
        authUserId != null &&
        collectionUserId == authUserId;
  }

  Future<void> _openPublish() async {
    final collection = _collection;
    if (collection == null) return;
    final notifier = ref.read(fabuProvider.notifier);
    notifier.resetPublishForm();
    notifier.setCollection(collection);
    await context.push('${Routes.publishZuoPinPageUrl}?type=video');
    if (!mounted) return;
    await _refresh();
  }

  Future<void> _editCollection() async {
    final collection = _collection;
    if (collection == null) return;
    final updated = await showEditCollectionDialog(
      context,
      ref,
      collection: collection,
    );
    if (!updated || !mounted) return;
    await _refresh();
  }

  Widget? _searchBarTrailing() {
    if (!_canPublish) return null;
    return IconButton(
      tooltip: '编辑合集',
      icon: Icon(
        Icons.edit_outlined,
        color: AppActionColors.foreground(context),
      ),
      onPressed: _editCollection,
    );
  }

  void _applyFeedPatch({
    required List<BlogItem> allItems,
    required AsyncValue<BlogPageModelData> blogPageData,
    String? error,
  }) {
    if (!mounted) return;
    setState(() {
      _items = allItems;
      _allItems = _mergePatchedItems(_allItems, allItems);
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
  Future<void> onBlogDeleted(BlogItem blogItem) async {
    final id = blogItem.id;
    if (id == null) return;
    if (!mounted) return;
    setState(() {
      _allItems = _allItems.where((item) => item.id != id).toList();
      _items = _filterItems(_allItems, _searchKeyword);
      _blogPageData = AsyncData(
        BlogPageModelData(list: _items, total: _items.length),
      );
    });
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
          _searchKeyword.isNotEmpty ? '未找到相关作品' : '暂无合集作品',
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
      videoUrlForPrecache: blogItemVideoUrlForPrecache,
      precacheVideoAheadCount: 2,
      itemBuilder: (context, index, item) {
        if (item.blogType == 1) {
          return BlogImgItemView(
            _feedCategory,
            item,
            feedActions: this,
            heroScope: blogFeedListItemHeroScope(
              category: _feedCategory,
              listIndex: index,
              prefix: 'collection-${widget.collectionId}',
            ),
          );
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
        actions: [
          if (_canPublish)
            AppBarPublishSearchActions(
              showSearch: false,
              onPublish: _openPublish,
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InPageSearchBar(
            controller: _searchController,
            height: 8,
            hintText: '搜索作品标题、内容或作者',
            onQueryChanged: _onSearchQuery,
            trailing: _searchBarTrailing(),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}

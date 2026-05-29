import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/models/profile_models.dart';
import '../data/repos/profile_repo.dart';
import 'create_collection_dialog.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 「合集」Tab：我的合集分页。
class MyVideoListView extends ConsumerStatefulWidget {
  final int tabIndex;
  final int currentIndex;
  final int? userId;

  const MyVideoListView({
    super.key,
    required this.tabIndex,
    required this.currentIndex,
    this.userId,
  });

  @override
  ConsumerState<MyVideoListView> createState() => _MyVideoListViewState();
}

class _MyVideoListViewState extends ConsumerState<MyVideoListView>
    with AutomaticKeepAliveClientMixin {
  static const int _pageSize = 12;
  static const String _placeholderCover =
      'https://file.qqai.cn/qqai/2025/09/1.webp';

  final ScrollController _scrollController = ScrollController();

  List<BlogCollectionResp> _items = [];
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.tabIndex == widget.currentIndex) {
      scheduleMicrotask(_loadFirstPage);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MyVideoListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _items = [];
      _page = 1;
      _hasMore = true;
      _error = null;
      if (widget.tabIndex == widget.currentIndex) {
        unawaited(_loadFirstPage());
      }
      return;
    }
    if (widget.tabIndex == widget.currentIndex &&
        oldWidget.currentIndex != widget.currentIndex &&
        _items.isEmpty &&
        !_loading) {
      unawaited(_loadFirstPage());
    }
  }

  bool get _isSelf => widget.userId == null;

  void _onScroll() {
    if (!_hasMore || _loadingMore || _loading) return;
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 320) {
      unawaited(_loadMore());
    }
  }

  Future<void> _loadFirstPage() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(profileRepoProvider);
      final userId = widget.userId;
      final data = userId != null
          ? await repo.getUserCollectionsPage(userId, 1, pageSize: _pageSize)
          : await repo.getMyCollectionsPage(1, pageSize: _pageSize);
      if (!mounted) return;
      setState(() {
        _items = List.from(data.list ?? []);
        _page = 1;
        _hasMore = (data.list?.length ?? 0) >= _pageSize;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final repo = ref.read(profileRepoProvider);
      final next = _page + 1;
      final userId = widget.userId;
      final data = userId != null
          ? await repo.getUserCollectionsPage(userId, next, pageSize: _pageSize)
          : await repo.getMyCollectionsPage(next, pageSize: _pageSize);
      final add = data.list ?? [];
      if (!mounted) return;
      setState(() {
        _items = [..._items, ...add];
        _page = next;
        _hasMore = add.length >= _pageSize;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  Future<void> _openCreateDialog() async {
    final created = await showCreateCollectionDialog(context, ref);
    if (created && mounted) {
      await _loadFirstPage();
    }
  }

  Widget _buildCollectionGrid(bool isWideScreen) {
    return RefreshIndicator(
      onRefresh: _loadFirstPage,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWideScreen ? 4 : 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.72,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final c = _items[index];
                final cover = (c.coverUrl != null && c.coverUrl!.isNotEmpty)
                    ? c.coverUrl!
                    : _placeholderCover;
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        showDragHandle: true,
                        builder: (ctx) => Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.name ?? '合集',
                                style: context.typo.sectionTitle,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                c.intro?.isNotEmpty == true
                                    ? c.intro!
                                    : '共 ${c.itemCount ?? 0} 个作品',
                                style: context.typo.body,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: cover,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Image.network(
                              _placeholderCover,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.typo.cardTitle,
                              ),
                              Text(
                                '${c.itemCount ?? 0} 个作品',
                                style: context.typo.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: _items.length,
            ),
          ),
          if (_loadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.tabIndex != widget.currentIndex) {
      return const SizedBox.shrink();
    }
    final isWideScreen = 1.sw > 800;

    Widget body;
    if (_loading && _items.isEmpty) {
      body = CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    } else if (_error != null && _items.isEmpty) {
      body = CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '加载失败: $_error',
                      textAlign: TextAlign.center,
                      style: context.typo.body,
                    ),
                  ),
                  TextButton(onPressed: _loadFirstPage, child: const Text('重试')),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (_items.isEmpty) {
      body = CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                _isSelf ? '暂无合集，点击右下角创建' : '暂无合集',
                style: context.typo.body,
              ),
            ),
          ),
        ],
      );
    } else {
      body = _buildCollectionGrid(isWideScreen);
    }

    if (!_isSelf) return body;

    return Stack(
      children: [
        body,
        Positioned(
          right: 16,
          bottom: 24,
          child: FloatingActionButton(
            onPressed: _openCreateDialog,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

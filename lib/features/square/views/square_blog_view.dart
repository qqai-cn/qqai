import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/auth_providers.dart';
import '../../../router/app_routes.dart';
import '../../../util/amap_launcher.dart';
import '../../../util/format_count.dart';
import '../../../util/media_url.dart';
import '../../chat/providers/chat_providers.dart';
import '../../blog/providers/blog_providers.dart';
import '../../blog/views/blog_img_item_view.dart';
import '../../blog/views/blog_video_item_view.dart';
import '../../my/data/models/area_models.dart';
import '../data/models/square_model.dart';
import '../data/repos/square_repo.dart';
import '../providers/square_blogs_provider.dart';
import '../providers/square_detail_provider.dart';
import 'edit_square_dialog.dart';

/// 广场详情：展示广场信息与该广场下公开博客流（头部随列表滚动）。
class SquareBlogView extends ConsumerStatefulWidget {
  const SquareBlogView({super.key, required this.squareId});

  final int squareId;

  @override
  ConsumerState<SquareBlogView> createState() => _SquareBlogViewState();
}

class _SquareBlogViewState extends ConsumerState<SquareBlogView> {
  bool _joiningChat = false;
  final ScrollController _scrollController = ScrollController();
  bool _loadingMoreGuard = false;
  static const double _masonryMinColumnWidth = 400;
  static const int _masonryMaxColumn = 2;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(squareBlogsProvider(widget.squareId).notifier).loadIfNeeded();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final blogsState = ref.read(squareBlogsProvider(widget.squareId));
    if (!blogsState.hasMore || blogsState.isLoadingMore || _loadingMoreGuard) {
      return;
    }
    final position = _scrollController.position;
    if (!position.hasContentDimensions || position.maxScrollExtent <= 0) {
      return;
    }
    if (position.maxScrollExtent - position.pixels > 200) return;
    _loadingMoreGuard = true;
    ref.read(squareBlogsProvider(widget.squareId).notifier).loadMore();
  }

  Future<void> _openGroupChat(int squareId) async {
    if (_joiningChat) return;
    setState(() => _joiningChat = true);
    try {
      final result = await ref
          .read(squareRepoProvider)
          .joinSquareConversation(squareId);
      final convId = result.chatConversationId;
      ref.invalidate(squareDetailProvider(squareId));
      if (!mounted) return;
      if (convId == null || convId <= 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('暂无法进入群聊')));
        return;
      }
      ref.invalidate(chatConversationsProvider);
      context.go('${Routes.messagePage}?conversationId=$convId');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _joiningChat = false);
    }
  }

  Future<void> _onRefresh() async {
    ref.invalidate(squareDetailProvider(widget.squareId));
    await ref.read(squareBlogsProvider(widget.squareId).notifier).refresh();
  }

  Future<void> _openPublish(int squareId) async {
    await context.push('${Routes.publishZuoPinPageUrl}?squareId=$squareId');
    if (!mounted) return;
    ref.invalidate(squareDetailProvider(squareId));
    await ref.read(squareBlogsProvider(squareId).notifier).refresh();
  }

  int _masonryColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width / _masonryMinColumnWidth).floor().clamp(1, _masonryMaxColumn);
  }

  List<Widget> _buildBlogSlivers({
    required BuildContext context,
    required BlogState blogsState,
    required SquareBlogsNotifier blogsNotifier,
  }) {
    final pageData = blogsState.blogPageData;
    final items = blogsState.allItems;

    if (pageData.isLoading && items.isEmpty) {
      return const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (pageData.hasError && items.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '加载作品失败：${pageData.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
                FilledButton(
                  onPressed: () => blogsNotifier.load(),
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    if (items.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('暂无作品', style: TextStyle(color: Colors.black54)),
                SizedBox(height: 12),
                TextButton(
                  onPressed: () => blogsNotifier.refresh(),
                  child: Text('点击刷新'),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    final columns = _masonryColumns(context);
    final slivers = <Widget>[
      SliverMasonryGrid.count(
        crossAxisCount: columns,
        childCount: items.length,
        itemBuilder: (context, index) {
          final blogItem = items[index];
          if (blogItem.blogType == 1) {
            return BlogImgItemView(3, blogItem, feedActions: blogsNotifier);
          }
          return BlogVideoItemView(3, blogItem, feedActions: blogsNotifier);
        },
      ),
    ];

    if (blogsState.isLoadingMore) {
      slivers.add(
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    } else if (!blogsState.hasMore) {
      slivers.add(
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text('没有更多了', style: TextStyle(color: Colors.black54)),
            ),
          ),
        ),
      );
    }

    return slivers;
  }

  @override
  Widget build(BuildContext context) {
    final squareId = widget.squareId;
    final detailAsync = ref.watch(squareDetailProvider(squareId));
    final authUserId = ref.watch(authProvider).userId;
    final blogsState = ref.watch(squareBlogsProvider(squareId));
    final blogsNotifier = ref.read(squareBlogsProvider(squareId).notifier);

    ref.listen(squareBlogsProvider(squareId), (prev, next) {
      if (!context.mounted) return;
      if (prev?.isLoadingMore == true && next.isLoadingMore == false) {
        _loadingMoreGuard = false;
      }
    });

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: detailAsync.maybeWhen(
          data: (s) => Text(
            (s.squareName?.trim().isNotEmpty ?? false)
                ? s.squareName!.trim()
                : '广场',
          ),
          orElse: () => const Text('广场'),
        ),
        actions: [
          IconButton(
            tooltip: '发布作品',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _openPublish(squareId),
          ),
          detailAsync.maybeWhen(
            data: (square) {
              if (!isSquareOwner(square, authUserId)) {
                return const SizedBox.shrink();
              }
              return IconButton(
                tooltip: '编辑广场',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () =>
                    showEditSquareDialog(context, ref, square: square),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ...detailAsync.when(
              loading: () => [
                const SliverToBoxAdapter(
                  child: LinearProgressIndicator(minHeight: 2),
                ),
              ],
              error: (e, _) => [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('加载广场信息失败：$e'),
                  ),
                ),
              ],
              data: (square) => [
                SliverToBoxAdapter(
                  child: _SquareDetailHeader(
                    square: square,
                    joiningChat: _joiningChat,
                    onJoinChat: () => _openGroupChat(squareId),
                  ),
                ),
              ],
            ),
            ..._buildBlogSlivers(
              context: context,
              blogsState: blogsState,
              blogsNotifier: blogsNotifier,
            ),
          ],
        ),
      ),
    );
  }
}

class _SquareDetailHeader extends StatelessWidget {
  const _SquareDetailHeader({
    required this.square,
    required this.joiningChat,
    required this.onJoinChat,
  });

  final SquareItem square;
  final bool joiningChat;
  final VoidCallback onJoinChat;

  @override
  Widget build(BuildContext context) {
    final iconUrl = resolveMediaUrl(square.squareImg);
    final title = (square.squareName?.trim().isNotEmpty ?? false)
        ? square.squareName!.trim()
        : '广场';
    final desc = square.squareDesc?.trim();
    final areaLabel = formatAddressForDisplay(square.areaName, empty: '');
    final blogCount = square.blogCount;
    final canChat =
        square.hasChatConversation == true ||
        (square.chatConversationId != null && square.chatConversationId! > 0);

    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: iconUrl != null
                          ? CachedNetworkImage(
                              imageUrl: iconUrl,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              errorWidget: (_, _, _) => Image.asset(
                                'imgs/img_default.png',
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'imgs/img_default.png',
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (desc != null && desc.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              desc,
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (areaLabel.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: Colors.black54,
                      ),
                      onPressed: () => _openAreaLocation(context, square),
                      icon: const Icon(Icons.location_on_outlined, size: 16),
                      label: Text(
                        areaLabel,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                      ),
                    ),
                  ),
                ],
                if (desc != null && desc.isNotEmpty || areaLabel.isNotEmpty)
                  const SizedBox(height: 8),
                Text(
                  '${formatCompactCount(blogCount?.toInt())} 篇公开作品',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
                if (canChat) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: joiningChat ? null : onJoinChat,
                      icon: joiningChat
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.forum_outlined),
                      label: Text(joiningChat ? '加入中…' : '进入广场群聊'),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Future<void> _openAreaLocation(
    BuildContext context,
    SquareItem square,
  ) async {
    final keyword = square.areaName?.trim();
    if (keyword == null || keyword.isEmpty) return;

    final ok = await openAmapLocation(name: keyword, keyword: keyword);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('无法打开高德地图')));
    }
  }
}

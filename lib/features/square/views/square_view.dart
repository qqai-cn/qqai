import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/in_page_search_bar.dart';
import '../../../components/refresh_status_badge.dart';
import '../providers/square_providers.dart';
import 'create_square_dialog.dart';
import 'square_grid_layout.dart';
import 'square_item_view.dart';

class SquareView extends ConsumerStatefulWidget {
  const SquareView({super.key});

  @override
  ConsumerState<SquareView> createState() => _SquareViewState();
}

class _SquareViewState extends ConsumerState<SquareView> {
  final ScrollController _scrollController = ScrollController();
  bool _loadingMoreGuard = false;
  bool _hideRefreshStatus = false;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final squareState = ref.read(squareProvider);
    if (!squareState.hasMore ||
        squareState.isLoadingMore ||
        _loadingMoreGuard) {
      return;
    }
    final position = _scrollController.position;
    if (!position.hasContentDimensions || position.maxScrollExtent <= 0) {
      return;
    }
    if (position.maxScrollExtent - position.pixels > 200) return;
    _loadingMoreGuard = true;
    ref.read(squareProvider.notifier).loadMore();
  }

  Future<void> _handlePullRefresh() async {
    setState(() {
      _hideRefreshStatus = true;
    });
    try {
      await ref.read(squareProvider.notifier).refresh();
    } finally {
      if (mounted) {
        setState(() {
          _hideRefreshStatus = false;
        });
      }
    }
  }

  Widget _createSquareRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 380;
        final title = Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                color: Color(0xFF3578E5),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '发现广场',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF202124),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '加入感兴趣的广场，浏览和发布作品',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
          ],
        );
        final createButton = FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF3578E5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            minimumSize: narrow ? const Size.fromHeight(42) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => showCreateSquareDialog(context, ref),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('创建'),
        );

        return Container(
          margin: const EdgeInsets.fromLTRB(14, 12, 14, 16),
          padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFECEEF2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: narrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [title, const SizedBox(height: 14), createButton],
                )
              : Row(
                  children: [
                    Expanded(child: title),
                    const SizedBox(width: 12),
                    createButton,
                  ],
                ),
        );
      },
    );
  }

  Widget _emptyState({required bool searching}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFECEEF2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.grid_view_rounded,
                color: Color(0xFF9CA3AF),
                size: 38,
              ),
              const SizedBox(height: 12),
              Text(
                searching ? '未找到相关广场' : '暂无广场',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchQuery(String query) {
    setState(() => _searching = query.isNotEmpty);
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    ref.read(squareProvider.notifier).search(query);
  }

  SliverGridDelegate _gridDelegate(double gridW) {
    final tileW = squareTileWidth(gridW);
    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: kSquareGridMaxCross,
      mainAxisSpacing: kSquareGridCrossGap,
      crossAxisSpacing: kSquareGridCrossGap,
      childAspectRatio: squareGridChildAspectRatio(tileW),
    );
  }

  List<Widget> _bodySlivers({
    required double gridW,
    required SquareListState squareState,
    required SquareNotifier notifier,
    required bool searching,
  }) {
    return squareState.pageData.when(
      loading: () => const [
        SliverFillRemaining(
          hasScrollBody: true,
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
      error: (e, _) => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _SquareError(
            message: e.toString(),
            onRetry: () => notifier.load(),
          ),
        ),
      ],
      data: (_) {
        final items = squareState.allItems;
        if (items.isEmpty) {
          return [
            SliverFillRemaining(
              hasScrollBody: false,
              child: _emptyState(searching: searching),
            ),
          ];
        }
        return [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            sliver: SliverGrid(
              gridDelegate: _gridDelegate(gridW),
              delegate: SliverChildBuilderDelegate(
                (context, index) => SizedBox.expand(
                  child: SquareItemView(square: items[index]),
                ),
                childCount: items.length,
              ),
            ),
          ),
          if (squareState.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final squareState = ref.watch(squareProvider);
    final notifier = ref.read(squareProvider.notifier);

    ref.listen(squareProvider, (prev, next) {
      if (prev?.isLoadingMore == true && !next.isLoadingMore) {
        _loadingMoreGuard = false;
      }
    });

    final topInset = InPageSearchBar.homeTabTopInset(context);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ColoredBox(
        color: const Color(0xFFF6F7F9),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kSquarePageMaxWidth),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final gridW = (constraints.maxWidth - 28).clamp(
                  1.0,
                  double.infinity,
                );
                return Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: _handlePullRefresh,
                      color: Colors.white,
                      backgroundColor: const Color(0xFFFF8C00),
                      displacement: 54,
                      strokeWidth: 3,
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: InPageSearchBar(
                              height: topInset,
                              hintText: '搜索广场名称',
                              onQueryChanged: _onSearchQuery,
                            ),
                          ),
                          SliverToBoxAdapter(child: _createSquareRow()),
                          ..._bodySlivers(
                            gridW: gridW,
                            squareState: squareState,
                            notifier: notifier,
                            searching: _searching,
                          ),
                          const SliverPadding(
                            padding: EdgeInsets.only(bottom: 24),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: kToolbarHeight,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: squareState.isRefreshing && !_hideRefreshStatus
                              ? const RefreshStatusBadge()
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SquareError extends StatelessWidget {
  const _SquareError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('重试')),
          ],
        ),
      ),
    );
  }
}

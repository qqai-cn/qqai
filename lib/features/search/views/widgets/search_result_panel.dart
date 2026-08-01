import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../../components/horizontal_deal_layout.dart';
import '../../../../router/app_routes.dart';
import '../../../../util/media_url.dart';
import '../../../blog/data/blog_route_extra.dart';
import '../../../blog/data/models/blog_page_model.dart';
import '../../../goods/data/models/mall_product_model.dart';
import '../../../goods/theme/goods_page_style.dart';
import '../../data/models/search_model.dart';
import '../../providers/search_providers.dart';
import '../../theme/search_layout.dart';
import '../../theme/search_ai_theme.dart';

/// 宽屏右侧空结果占位。
class SearchWideEmptyResult extends StatelessWidget {
  const SearchWideEmptyResult({super.key});

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return ColoredBox(
      color: ai.resultPanelBg,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ai.orbCyanGradient,
                  border: Border.all(color: ai.cardBorder),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: 28,
                  color: ai.accent,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                '等待你的灵感',
                style: context.typo.sectionTitle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ai.text,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '在左侧输入关键词，可搜索博客、视频或商品',
                textAlign: TextAlign.center,
                style: context.typo.pageSubtitle.copyWith(
                  fontSize: 13,
                  color: ai.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 搜索结果区：分类 Tab + 列表。
class SearchResultPanel extends StatelessWidget {
  const SearchResultPanel({
    super.key,
    required this.state,
    required this.onCategoryChanged,
    required this.onRetry,
    required this.onScrollNotification,
  });

  final SearchState state;
  final ValueChanged<SearchCategory> onCategoryChanged;
  final VoidCallback onRetry;
  final NotificationListenerCallback<ScrollNotification> onScrollNotification;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return ColoredBox(
      color: ai.resultPanelBg,
      child: NestedScrollView(
        key: ValueKey('search-result-${state.keyword}-${state.category}'),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: true,
                floating: false,
                primary: false,
                toolbarHeight: 0,
                elevation: 0,
                scrolledUnderElevation: 0,
                forceElevated: innerBoxIsScrolled,
                automaticallyImplyLeading: false,
                backgroundColor: ai.resultPanelBg,
                bottom: PreferredSize(
                  preferredSize:
                      const Size.fromHeight(kSearchResultCategoryBarHeight),
                  child: SizedBox(
                    height: kSearchResultCategoryBarHeight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 1),
                      child: SearchResultCategoryBar(
                        state: state,
                        compact: true,
                        onCategoryChanged: onCategoryChanged,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Builder(
          builder: (context) => NotificationListener<ScrollNotification>(
            onNotification: onScrollNotification,
            child: SearchResultList(
              nestedContext: context,
              state: state,
              onRetry: onRetry,
            ),
          ),
        ),
      ),
    );
  }
}

class SearchResultCategoryBar extends StatelessWidget {
  const SearchResultCategoryBar({
    super.key,
    required this.state,
    required this.onCategoryChanged,
    this.compact = false,
  });

  final SearchState state;
  final ValueChanged<SearchCategory> onCategoryChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return Container(
      margin: compact
          ? EdgeInsets.zero
          : EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 0),
      padding: EdgeInsets.all(compact ? 3.w : 4.w),
      decoration: BoxDecoration(
        color: ai.categoryTrack,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ai.cardBorder),
      ),
      child: Row(
        children: [
          _CategoryChip(
            label: SearchCategory.blog.label,
            count: state.blog.total,
            loading: state.blog.loading,
            selected: state.category == SearchCategory.blog,
            compact: compact,
            onTap: () => onCategoryChanged(SearchCategory.blog),
          ),
          SizedBox(width: 6.w),
          _CategoryChip(
            label: SearchCategory.video.label,
            count: state.video.total,
            loading: state.video.loading,
            selected: state.category == SearchCategory.video,
            compact: compact,
            onTap: () => onCategoryChanged(SearchCategory.video),
          ),
          SizedBox(width: 6.w),
          _CategoryChip(
            label: SearchCategory.goods.label,
            count: state.goods.total,
            loading: state.goods.loading,
            selected: state.category == SearchCategory.goods,
            compact: compact,
            onTap: () => onCategoryChanged(SearchCategory.goods),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.count,
    required this.loading,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool loading;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    final countLabel = loading ? '...' : '$count';
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected ? ai.categorySelectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(9.r),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: SearchAiTheme.brandRed.withValues(alpha: 0.12),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(9.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: compact ? 6 : 8.h),
              child: Text(
                '$label $countLabel',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typo.body.copyWith(
                  fontSize: compact ? 13 : 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? ai.selectedFg : ai.text,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchResultList extends StatelessWidget {
  const SearchResultList({
    super.key,
    required this.nestedContext,
    required this.state,
    required this.onRetry,
  });

  final BuildContext nestedContext;
  final SearchState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final loading = state.loadingCurrent;
    final loadingMore = state.loadingMoreCurrent;
    final error = state.currentError;
    final emptyLabel = state.category.label;
    final items = switch (state.category) {
      SearchCategory.goods => state.goods.items,
      SearchCategory.blog => state.blog.items,
      SearchCategory.video => state.video.items,
    };
    final ai = SearchAiTheme.of(context);
    final overlapHandle =
        NestedScrollView.sliverOverlapAbsorberHandleFor(nestedContext);

    if (loading && items.isEmpty) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverOverlapInjector(handle: overlapHandle),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator(
                color: ai.accent,
                strokeWidth: 2.5,
              ),
            ),
          ),
        ],
      );
    }

    if (error != null && items.isEmpty) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverOverlapInjector(handle: overlapHandle),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: ai.textSecondary,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '搜索失败',
                      style: context.typo.sectionTitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ai.text,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.typo.pageSubtitle.copyWith(
                        fontSize: 13,
                        color: ai.textSecondary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FilledButton(
                      onPressed: onRetry,
                      style: FilledButton.styleFrom(
                        backgroundColor: SearchAiTheme.brandRed,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (items.isEmpty) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverOverlapInjector(handle: overlapHandle),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_outlined,
                      size: 48,
                      color: ai.accent,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '暂无相关$emptyLabel',
                      style: context.typo.sectionTitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ai.text,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.keyword.isEmpty
                          ? '换个关键词试试'
                          : '未找到与「${state.keyword}」相关的$emptyLabel',
                      textAlign: TextAlign.center,
                      style: context.typo.pageSubtitle.copyWith(
                        fontSize: 13,
                        color: ai.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    final itemCount = items.length + (loadingMore ? 1 : 0);
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverOverlapInjector(handle: overlapHandle),
        SliverLayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount =
                searchResultGridCrossAxisCount(constraints.crossAxisExtent);
            // 双列时卡片更矮，略降宽高比给文字区更多高度。
            final aspectRatio = crossAxisCount >= 2
                ? 3.2
                : kHorizontalDealCardAspectRatio;
            return SliverPadding(
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 24.h),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: aspectRatio,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= items.length) {
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ai.accent,
                        ),
                      );
                    }
                    return switch (state.category) {
                      SearchCategory.goods => SearchGoodsResultCard(
                          item: state.goods.items[index],
                        ),
                      SearchCategory.blog => SearchBlogResultCard(
                          item: state.blog.items[index],
                        ),
                      SearchCategory.video => SearchBlogResultCard(
                          item: state.video.items[index],
                        ),
                    };
                  },
                  childCount: itemCount,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

HorizontalDealCardStyle searchDealCardStyle(BuildContext context) {
  final ai = SearchAiTheme.of(context);
  return HorizontalDealCardStyle(
    cardColor: ai.cardBg,
    accentColor: SearchAiTheme.brandRed,
    chevronColor: ai.textSecondary,
    tagBackgroundAlpha: 0.16,
    useScreenUtil: false,
  );
}

class SearchBlogResultCard extends StatelessWidget {
  const SearchBlogResultCard({super.key, required this.item});

  final BlogItem item;

  String get _title {
    final title = item.title?.trim();
    if (title != null && title.isNotEmpty) return title;
    final content = item.content?.trim();
    if (content != null && content.isNotEmpty) {
      return content.length > 40 ? '${content.substring(0, 40)}...' : content;
    }
    return item.blogType == 2 ? '视频' : '博客';
  }

  String get _meta {
    final creator = item.creatorName?.trim().isNotEmpty == true
        ? item.creatorName!.trim()
        : (item.creator?.trim().isNotEmpty == true
            ? item.creator!.trim()
            : null);
    final likes = item.zan ?? 0;
    final fallback = item.blogType == 2 ? '视频' : '博客';
    if (creator != null && likes > 0) return '$creator · $likes 赞';
    if (creator != null) return creator;
    if (likes > 0) return '$likes 赞';
    return fallback;
  }

  void _open(BuildContext context) {
    final id = item.id;
    if (id == null) return;
    if (item.blogType == 1) {
      context.push(
        Routes.blogImgDetailView,
        extra: blogDetailRouteExtra(item),
      );
    } else {
      context.push(
        Routes.blogVideoDetailView,
        extra: blogDetailRouteExtra(item),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = item.id;
    final coverUrl = resolveMediaUrl(item.coverUrl);
    final isVideo = item.blogType == 2;
    final cardStyle = searchDealCardStyle(context);

    return HorizontalDealCard(
      tag: isVideo ? '视频' : '图文',
      title: _title,
      priceText: _meta,
      style: cardStyle,
      onTap: id == null ? null : () => _open(context),
      image: coverUrl == null
          ? ColoredBox(
              color: GoodsPageStyle.imageBg(context),
              child: Icon(
                isVideo ? Icons.play_circle_outline : Icons.article_outlined,
                color: GoodsPageStyle.sub(context),
                size: 36,
              ),
            )
          : CachedNetworkImage(
              imageUrl: coverUrl,
              cacheKey: mediaCacheKey(coverUrl),
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => ColoredBox(
                color: GoodsPageStyle.imageBg(context),
                child: Icon(
                  isVideo ? Icons.play_circle_outline : Icons.article_outlined,
                  color: GoodsPageStyle.sub(context),
                  size: 36,
                ),
              ),
            ),
    );
  }
}

class SearchGoodsResultCard extends StatelessWidget {
  const SearchGoodsResultCard({super.key, required this.item});

  final MallProduct item;

  @override
  Widget build(BuildContext context) {
    final name = item.name?.trim().isNotEmpty == true ? item.name!.trim() : '商品';
    final coverUrl = resolveMediaUrl(item.coverUrl);
    final sales = item.salesCount ?? 0;
    final cardStyle = searchDealCardStyle(context);

    return HorizontalDealCard(
      tag: sales > 0 ? '$sales 已售' : '精选',
      title: name,
      priceText: '¥${item.priceYuan.toStringAsFixed(2)}',
      style: cardStyle,
      onTap: () {
        final id = item.id;
        if (id == null) return;
        context.push('${Routes.goodsDetailPageUrl}/$id');
      },
      image: coverUrl == null
          ? ColoredBox(
              color: GoodsPageStyle.imageBg(context),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: GoodsPageStyle.sub(context),
                size: 36,
              ),
            )
          : CachedNetworkImage(
              imageUrl: coverUrl,
              cacheKey: mediaCacheKey(coverUrl),
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => ColoredBox(
                color: GoodsPageStyle.imageBg(context),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: GoodsPageStyle.sub(context),
                  size: 36,
                ),
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../theme/search_layout.dart';
import '../../theme/search_ai_theme.dart';
import 'search_section_card.dart';

class SearchDiscoverItem {
  const SearchDiscoverItem(this.text, {this.promo = false});
  final String text;
  final bool promo;
}

class SearchRankRow {
  const SearchRankRow(this.rank, this.title, this.heat);
  final int rank;
  final String title;
  final String heat;
}

/// 搜索落地：Hero + 历史 + 灵感 + 热搜榜。
class SearchLandingBody extends StatelessWidget {
  const SearchLandingBody({
    super.key,
    required this.screenWidth,
    required this.rankTabController,
    required this.rankTabs,
    required this.rankRowsByTab,
    required this.historyItems,
    required this.historyExpanded,
    required this.discoverVisible,
    required this.discoverItems,
    required this.onClearHistory,
    required this.onExpandHistory,
    required this.onToggleDiscover,
    required this.onFillQuery,
  });

  final double screenWidth;
  final TabController rankTabController;
  final List<String> rankTabs;
  final List<List<SearchRankRow>> rankRowsByTab;
  final List<String> historyItems;
  final bool historyExpanded;
  final bool discoverVisible;
  final List<SearchDiscoverItem> discoverItems;
  final VoidCallback onClearHistory;
  final VoidCallback onExpandHistory;
  final VoidCallback onToggleDiscover;
  final ValueChanged<String> onFillQuery;

  List<String> get _historyShown {
    if (historyExpanded || historyItems.length <= 6) return historyItems;
    return historyItems.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(child: _HeroHint()),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(
            child: _HistorySection(
              items: _historyShown,
              hasMore: historyItems.length > 6 && !historyExpanded,
              isEmpty: historyItems.isEmpty,
              onClear: onClearHistory,
              onExpand: onExpandHistory,
              onTapItem: onFillQuery,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(
            child: _DiscoverSection(
              screenWidth: screenWidth,
              visible: discoverVisible,
              items: discoverItems,
              onToggleVisible: onToggleDiscover,
              onTapItem: onFillQuery,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
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
              backgroundColor: ai.appBarBg,
              bottom: TabBar(
                controller: rankTabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                labelPadding: EdgeInsets.only(right: 20.w),
                labelColor: SearchAiTheme.brandRed,
                unselectedLabelColor: ai.textSecondary,
                labelStyle: context.typo.sectionTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: context.typo.sectionTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                indicatorColor: SearchAiTheme.cyan,
                indicatorWeight: 2.5,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: ai.line,
                tabs: rankTabs.map((t) => Tab(text: t)).toList(),
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: rankTabController,
        children: rankRowsByTab.map(_RankTabScrollBody.new).toList(),
      ),
    );
  }
}

class _HeroHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    final w = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        searchPageHorizontalGap(w),
        8,
        searchPageHorizontalGap(w),
        0,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: ai.aiBadgeGradient,
              boxShadow: [
                BoxShadow(
                  color: SearchAiTheme.cyan.withValues(alpha: 0.35),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(Icons.auto_awesome, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (b) => ai.brandTitleGradient.createShader(b),
                  child: Text(
                    '千千 AI 搜索',
                    style: context.typo.sectionTitle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '博客 · 视频 · 商品，一键发现',
                  style: context.typo.caption.copyWith(
                    fontSize: 12,
                    color: ai.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({
    required this.items,
    required this.hasMore,
    required this.isEmpty,
    required this.onClear,
    required this.onExpand,
    required this.onTapItem,
  });

  final List<String> items;
  final bool hasMore;
  final bool isEmpty;
  final VoidCallback onClear;
  final VoidCallback onExpand;
  final ValueChanged<String> onTapItem;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return SearchSectionCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchSectionTitleRow(
            title: '搜索历史',
            icon: Icons.history_rounded,
            trailing: IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 20,
                color: ai.textSecondary,
              ),
              onPressed: onClear,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),
          ),
          if (!isEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                ...items.map((t) => _HistoryChip(text: t, onTap: () => onTapItem(t))),
                if (hasMore) _HistoryChipExpand(onTap: onExpand),
              ],
            ),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '暂无历史，试着搜点什么吧',
                style: context.typo.caption.copyWith(
                  fontSize: 12,
                  color: ai.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HistoryChip extends StatelessWidget {
  const _HistoryChip({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return Material(
      color: ai.chipBg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ai.chipBorder),
          ),
          child: Text(
            text,
            style: context.typo.body.copyWith(
              fontSize: 13,
              height: 1.15,
              color: ai.text,
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryChipExpand extends StatelessWidget {
  const _HistoryChipExpand({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return Material(
      color: ai.chipBg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ai.chipBorder),
          ),
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: ai.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _DiscoverSection extends StatelessWidget {
  const _DiscoverSection({
    required this.screenWidth,
    required this.visible,
    required this.items,
    required this.onToggleVisible,
    required this.onTapItem,
  });

  final double screenWidth;
  final bool visible;
  final List<SearchDiscoverItem> items;
  final VoidCallback onToggleVisible;
  final ValueChanged<String> onTapItem;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    final columns = screenWidth < 360 ? 1 : 2;
    return SearchSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchSectionTitleRow(
            title: 'AI 灵感',
            icon: Icons.lightbulb_outline_rounded,
            trailing: IconButton(
              icon: Icon(
                visible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: ai.textSecondary,
              ),
              onPressed: onToggleVisible,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          if (visible) ...[
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 8,
                crossAxisSpacing: 12,
                childAspectRatio: columns == 1 ? 16 : 8.8,
              ),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final item = items[i];
                return InkWell(
                  onTap: () => onTapItem(item.text),
                  borderRadius: BorderRadius.circular(8.r),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.promo) ...[
                          Container(
                            margin: const EdgeInsets.only(top: 2, right: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              gradient: ai.aiBadgeGradient,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'AI',
                              style: context.typo.label.copyWith(
                                fontSize: 9,
                                color: Colors.white,
                                height: 1,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                        Expanded(
                          child: Text(
                            item.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.typo.body.copyWith(
                              fontSize: 13,
                              height: 1.25,
                              color: ai.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _RankTabScrollBody extends StatelessWidget {
  const _RankTabScrollBody(this.rows);

  final List<SearchRankRow> rows;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(
              child: SearchSectionCard(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: _RankListContent(rows: rows),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }
}

class _RankListContent extends StatelessWidget {
  const _RankListContent({required this.rows});

  final List<SearchRankRow> rows;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        decoration: BoxDecoration(gradient: ai.rankPanelGradient),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: rows.asMap().entries.map((e) {
            final last = e.key == rows.length - 1;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _RankRowTile(row: e.value),
                if (!last)
                  Divider(
                    height: 1,
                    indent: 36.w,
                    color: ai.line,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _RankRowTile extends StatelessWidget {
  const _RankRowTile({required this.row});

  final SearchRankRow row;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RankBadge(rank: row.rank),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              row.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.typo.body.copyWith(
                fontSize: 14,
                color: ai.text,
                height: 1.25,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '热度 ${row.heat}万',
            style: context.typo.caption.copyWith(
              fontSize: 11,
              color: ai.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    if (rank <= 3) {
      final colors = [
        SearchAiTheme.brandRed,
        const Color(0xFFFFB300),
        const Color(0xFFFF8A65),
      ];
      return Container(
        width: 22.w,
        height: 22.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors[rank - 1],
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: [
            BoxShadow(
              color: colors[rank - 1].withValues(alpha: 0.35),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          '$rank',
          style: context.typo.bodyStrong.copyWith(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
      );
    }
    return SizedBox(
      width: 22.w,
      child: Text(
        '$rank',
        textAlign: TextAlign.center,
        style: context.typo.body.copyWith(
          fontSize: 14,
          color: ai.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

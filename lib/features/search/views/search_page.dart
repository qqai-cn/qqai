import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../util/my_shared_pref.dart';
import '../../../util/web_history_helper.dart';
import '../data/models/search_model.dart';
import '../providers/search_providers.dart';
import '../theme/search_layout.dart';
import '../theme/search_ai_theme.dart';
import 'widgets/search_ambient_orbs.dart';
import 'widgets/search_feedback_fab.dart';
import 'widgets/search_landing_body.dart';
import 'widgets/search_result_panel.dart';
import 'widgets/search_top_bar.dart';

/// 搜索落地页 + 结果页。
///
/// 支持博客（图文）/ 视频 / 商品三类关键词搜索；
/// 宽屏（≥1200）左右分栏，窄屏单列切换落地与结果。
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _showResult = false;
  bool _aiSearch = true;
  bool _historyExpanded = false;
  bool _discoverVisible = true;

  late final TabController _rankTabController;
  final List<String> _historyAll = [];

  final List<SearchDiscoverItem> _discoverItems = const [
    SearchDiscoverItem('一句话总结今日热点', promo: true),
    SearchDiscoverItem('短视频灵感选题'),
    SearchDiscoverItem('周末好物推荐清单'),
    SearchDiscoverItem('AI 写作开场白'),
    SearchDiscoverItem('居家收纳技巧'),
    SearchDiscoverItem('旅行 vlog 构图'),
  ];

  final List<String> _rankTabs = const [
    '综合热搜',
    '博客灵感',
    '视频趋势',
    '好物精选',
    '数码科技',
  ];

  late final List<List<SearchRankRow>> _rankRowsByTab;

  SearchState get _search => ref.read(searchProvider);
  SearchNotifier get _searchNotifier => ref.read(searchProvider.notifier);

  @override
  void initState() {
    super.initState();
    _historyAll.addAll(MySharedPref.getSearchHistory());
    _rankTabController = TabController(length: _rankTabs.length, vsync: this);
    _rankRowsByTab = const [
      [
        SearchRankRow(1, '抽纸的自我修养', '630.2'),
        SearchRankRow(2, '冬季羽绒服选购指南', '521.8'),
        SearchRankRow(3, '爱玛电动车配件', '410.0'),
        SearchRankRow(4, '洗衣液怎么选', '305.6'),
        SearchRankRow(5, '板栗红薯产地直发', '288.1'),
        SearchRankRow(6, '年货礼盒推荐', '201.3'),
      ],
      [
        SearchRankRow(1, 'iPhone 16 Pro', '902.1'),
        SearchRankRow(2, '小米 15', '780.4'),
        SearchRankRow(3, '华为 Mate 70', '655.0'),
        SearchRankRow(4, '荣耀 Magic7', '420.2'),
        SearchRankRow(5, '一加 13', '310.8'),
        SearchRankRow(6, 'vivo X200', '205.0'),
      ],
      [
        SearchRankRow(1, '口红礼盒套装', '540.0'),
        SearchRankRow(2, '面霜秋冬保湿', '480.3'),
        SearchRankRow(3, '粉底液持妆', '360.1'),
        SearchRankRow(4, '卸妆油温和', '290.6'),
        SearchRankRow(5, '面膜补水', '220.4'),
        SearchRankRow(6, '香水小样', '180.2'),
      ],
      [
        SearchRankRow(1, '车厘子 JJJ', '610.5'),
        SearchRankRow(2, '牛排原切', '500.0'),
        SearchRankRow(3, '三文鱼刺身', '430.8'),
        SearchRankRow(4, '有机蔬菜礼盒', '300.0'),
        SearchRankRow(5, '牛奶整箱', '250.3'),
        SearchRankRow(6, '坚果大礼包', '190.7'),
      ],
      [
        SearchRankRow(1, '轻薄本办公', '700.2'),
        SearchRankRow(2, '机械键盘', '520.6'),
        SearchRankRow(3, '显示器 4K', '450.0'),
        SearchRankRow(4, '无线鼠标', '330.4'),
        SearchRankRow(5, '移动固态硬盘', '280.9'),
        SearchRankRow(6, '路由器 WiFi7', '210.1'),
      ],
    ];
  }

  @override
  void dispose() {
    _rankTabController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool _onResultScrollNotification(ScrollNotification notification) {
    final s = _search;
    if (!_showResult || s.loadingCurrent || s.loadingMoreCurrent) {
      return false;
    }
    if (!s.hasMoreCurrent) return false;
    final metrics = notification.metrics;
    if (metrics.maxScrollExtent > 0 &&
        metrics.pixels >= metrics.maxScrollExtent - 480) {
      _searchNotifier.loadMore();
    }
    return false;
  }

  void _switchSearchCategory(SearchCategory category) {
    _searchNotifier.setCategory(category);
    _searchNotifier.retryCurrentIfNeeded();
  }

  Future<void> _persistSearchHistory(String query) async {
    _historyAll.remove(query);
    _historyAll.insert(0, query);
    if (_historyAll.length > 20) {
      _historyAll.removeRange(20, _historyAll.length);
    }
    await MySharedPref.setSearchHistory(_historyAll);
    if (mounted) setState(() {});
  }

  void _onSearch() {
    final q = _controller.text.trim();
    if (q.isEmpty) return;
    FocusScope.of(context).unfocus();
    final wideSplit = searchIsWideSplit(MediaQuery.sizeOf(context).width);
    setState(() => _showResult = true);
    if (kIsWeb && !wideSplit) {
      pushBrowserHistoryOverlay();
    }
    _persistSearchHistory(q);
    _searchNotifier.search(q);
  }

  void _fillQuery(String q) {
    _controller.text = q;
    _controller.selection = TextSelection.collapsed(offset: q.length);
    _onSearch();
  }

  Future<void> _clearHistory() async {
    _historyAll.clear();
    await MySharedPref.setSearchHistory(_historyAll);
    if (mounted) setState(() {});
  }

  void _handleBack() {
    final wideSplit = searchIsWideSplit(MediaQuery.sizeOf(context).width);
    if (_showResult && !wideSplit) {
      setState(() => _showResult = false);
      return;
    }
    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(searchProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final wideSplit = searchIsWideSplit(screenWidth);
    final guardResultView = _showResult && !wideSplit;
    final ai = SearchAiTheme.of(context);

    final appBarSearch = Padding(
      padding: EdgeInsets.only(right: wideSplit ? 8.w : 0),
      child: Row(
        children: [
          Expanded(
            child: SearchTopBar(
              controller: _controller,
              focusNode: _focusNode,
              aiSearch: _aiSearch,
              onAiSearchChanged: (v) => setState(() => _aiSearch = v),
              onSubmitted: _onSearch,
            ),
          ),
          SizedBox(width: 8.w),
          SearchActionButton(onPressed: _onSearch),
        ],
      ),
    );

    return PopScope(
      canPop: !guardResultView,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: ai.pageGradient.last,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _handleBack,
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: ai.appBarBg,
          foregroundColor: ai.text,
          systemOverlayStyle: ai.overlayStyle,
          title: wideSplit
              ? appBarSearch
              : searchNarrowContent(appBarSearch),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: ai.pageGradient,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final split = searchIsWideSplit(w);
              final hGap = searchPageHorizontalGap(w);

              final landing = SearchLandingBody(
                screenWidth: w,
                rankTabController: _rankTabController,
                rankTabs: _rankTabs,
                rankRowsByTab: _rankRowsByTab,
                historyItems: _historyAll,
                historyExpanded: _historyExpanded,
                discoverVisible: _discoverVisible,
                discoverItems: _discoverItems,
                onClearHistory: _clearHistory,
                onExpandHistory: () =>
                    setState(() => _historyExpanded = true),
                onToggleDiscover: () =>
                    setState(() => _discoverVisible = !_discoverVisible),
                onFillQuery: _fillQuery,
              );

              final result = SearchResultPanel(
                state: _search,
                onCategoryChanged: _switchSearchCategory,
                onRetry: () => _searchNotifier.search(_controller.text),
                onScrollNotification: _onResultScrollNotification,
              );

              final Widget mainContent;
              if (split) {
                mainContent = Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: hGap, right: hGap / 2),
                        child: searchWidePanelContent(
                          landing,
                          maxWidth: kSearchWideLandingPanelMaxWidth,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      color: ai.line,
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(left: hGap / 2, right: hGap),
                        child: searchWidePanelContent(
                          _showResult
                              ? result
                              : const SearchWideEmptyResult(),
                          maxWidth: kSearchWideResultPanelMaxWidth,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                mainContent = searchNarrowContent(
                  _showResult ? result : landing,
                );
              }

              final fabRight = MediaQuery.paddingOf(context).right + 12.w;

              return Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  if (split)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: constraints.maxWidth * 5 / 11,
                      child: const ClipRect(
                        child: SearchAmbientOrbs(landingOnly: true),
                      ),
                    )
                  else if (!_showResult)
                    const Positioned.fill(
                      child: SearchAmbientOrbs(landingOnly: true),
                    ),
                  Positioned.fill(child: mainContent),
                  Positioned(
                    right: fabRight,
                    bottom: MediaQuery.paddingOf(context).bottom + 80.h,
                    child: const SearchFeedbackFab(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

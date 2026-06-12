import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../components/horizontal_deal_layout.dart';
import '../../router/app_routes.dart';
import '../../util/media_url.dart';
import '../../util/my_shared_pref.dart';
import '../../util/web_history_helper.dart';
import '../blog/data/blog_route_extra.dart';
import '../blog/data/models/blog_page_model.dart';
import '../blog/data/repos/blog_repo.dart';
import '../goods/data/models/mall_product_model.dart';
import '../goods/data/repos/goods_repo.dart';
import '../goods/theme/goods_page_style.dart';
import '../goods/theme/jd_goods_theme.dart';
import 'package:qqai/config/theme/app_typography.dart';

enum _SearchCategory { goods, blog }

/// 窄屏单列时内容最大宽度（居中），避免超宽屏一条拉满。
const double _kNarrowContentMaxWidth = 600;

/// 大于等于此宽度时：左侧落地 + 右侧结果，贴边分栏。
const double _kWideSplitBreakpoint = 1200;

/// 宽屏分栏时单栏内容最大宽度（避免半屏过宽显得空）。
const double _kWidePanelMaxWidth = 640;

/// 搜索结果「商品 / 博客」吸顶栏高度（与内容一致，避免 PreferredSize 越界）。
const double _kResultCategoryBarHeight = 70;

/// 对齐京东搜索落地页：AI 搜索条、搜索历史、搜索发现（双列）、分类 Tab、热度榜单、反馈浮标。
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with TickerProviderStateMixin {
  static const _resultPageSize = 20;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _showResult = false;
  bool _aiSearch = true;
  bool _historyExpanded = false;
  bool _discoverVisible = true;

  late final TabController _rankTabController;

  final List<String> _historyAll = [];
  _SearchCategory _searchCategory = _SearchCategory.goods;

  final List<MallProduct> _goodsResults = [];
  final List<BlogItem> _blogResults = [];
  int _goodsPageNo = 1;
  int _blogPageNo = 1;
  int _goodsTotal = 0;
  int _blogTotal = 0;
  bool _loadingGoods = false;
  bool _loadingBlogs = false;
  bool _loadingMoreGoods = false;
  bool _loadingMoreBlogs = false;
  Object? _goodsError;
  Object? _blogsError;
  String _activeKeyword = '';

  final List<_DiscoverItem> _discoverItems = [
    _DiscoverItem('多巴胺发色限时88折', promo: true),
    _DiscoverItem('冬季保暖好物'),
    _DiscoverItem('抽纸的自我修养'),
    _DiscoverItem('爱玛电动车尾箱'),
    _DiscoverItem('京东超市满减'),
    _DiscoverItem('年货节主会场'),
  ];

  final List<String> _rankTabs = [
    '家庭洗护',
    '热门手机',
    '人气美妆',
    '生鲜',
    '电脑数码',
  ];

  late final List<List<_RankRow>> _rankRowsByTab;

  @override
  void initState() {
    super.initState();
    _historyAll.addAll(MySharedPref.getSearchHistory());
    _rankTabController = TabController(length: _rankTabs.length, vsync: this);
    _rankRowsByTab = [
      const [
        _RankRow(1, '抽纸的自我修养', '630.2'),
        _RankRow(2, '冬季羽绒服选购指南', '521.8'),
        _RankRow(3, '爱玛电动车配件', '410.0'),
        _RankRow(4, '洗衣液怎么选', '305.6'),
        _RankRow(5, '板栗红薯产地直发', '288.1'),
        _RankRow(6, '年货礼盒推荐', '201.3'),
      ],
      const [
        _RankRow(1, 'iPhone 16 Pro', '902.1'),
        _RankRow(2, '小米 15', '780.4'),
        _RankRow(3, '华为 Mate 70', '655.0'),
        _RankRow(4, '荣耀 Magic7', '420.2'),
        _RankRow(5, '一加 13', '310.8'),
        _RankRow(6, 'vivo X200', '205.0'),
      ],
      const [
        _RankRow(1, '口红礼盒套装', '540.0'),
        _RankRow(2, '面霜秋冬保湿', '480.3'),
        _RankRow(3, '粉底液持妆', '360.1'),
        _RankRow(4, '卸妆油温和', '290.6'),
        _RankRow(5, '面膜补水', '220.4'),
        _RankRow(6, '香水小样', '180.2'),
      ],
      const [
        _RankRow(1, '车厘子 JJJ', '610.5'),
        _RankRow(2, '牛排原切', '500.0'),
        _RankRow(3, '三文鱼刺身', '430.8'),
        _RankRow(4, '有机蔬菜礼盒', '300.0'),
        _RankRow(5, '牛奶整箱', '250.3'),
        _RankRow(6, '坚果大礼包', '190.7'),
      ],
      const [
        _RankRow(1, '轻薄本办公', '700.2'),
        _RankRow(2, '机械键盘', '520.6'),
        _RankRow(3, '显示器 4K', '450.0'),
        _RankRow(4, '无线鼠标', '330.4'),
        _RankRow(5, '移动固态硬盘', '280.9'),
        _RankRow(6, '路由器 WiFi7', '210.1'),
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

  bool get _isGoodsCategory => _searchCategory == _SearchCategory.goods;

  bool _hasMoreResultsFor(_SearchCategory category) {
    if (category == _SearchCategory.goods) {
      return _goodsResults.length < _goodsTotal ||
          (_goodsTotal == 0 && _goodsResults.isEmpty && !_loadingGoods);
    }
    return _blogResults.length < _blogTotal ||
        (_blogTotal == 0 && _blogResults.isEmpty && !_loadingBlogs);
  }

  bool get _loadingCurrentResults =>
      _isGoodsCategory ? _loadingGoods : _loadingBlogs;

  bool get _loadingMoreCurrentResults =>
      _isGoodsCategory ? _loadingMoreGoods : _loadingMoreBlogs;

  Object? get _currentResultsError =>
      _isGoodsCategory ? _goodsError : _blogsError;

  List<dynamic> get _currentResultItems =>
      _isGoodsCategory ? _goodsResults : _blogResults;

  bool _onResultScrollNotification(ScrollNotification notification) {
    if (!_showResult || _loadingCurrentResults || _loadingMoreCurrentResults) {
      return false;
    }
    if (!_hasMoreResultsFor(_searchCategory)) return false;
    final metrics = notification.metrics;
    if (metrics.maxScrollExtent > 0 &&
        metrics.pixels >= metrics.maxScrollExtent - 480) {
      _fetchSearchResults(loadMore: true);
    }
    return false;
  }

  void _switchSearchCategory(_SearchCategory category) {
    if (_searchCategory == category) return;
    setState(() => _searchCategory = category);
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

  Future<void> _fetchSearchResults({bool loadMore = false}) async {
    final keyword = _controller.text.trim();
    if (keyword.isEmpty) return;

    if (!loadMore) {
      setState(() {
        _loadingGoods = true;
        _loadingBlogs = true;
        _loadingMoreGoods = false;
        _loadingMoreBlogs = false;
        _goodsError = null;
        _blogsError = null;
        _activeKeyword = keyword;
        _goodsPageNo = 1;
        _blogPageNo = 1;
      });
      await Future.wait([
        _fetchGoodsResults(keyword: keyword),
        _fetchBlogResults(keyword: keyword),
      ]);
      return;
    }

    if (_isGoodsCategory) {
      await _fetchGoodsResults(keyword: keyword, loadMore: true);
    } else {
      await _fetchBlogResults(keyword: keyword, loadMore: true);
    }
  }

  Future<void> _fetchGoodsResults({
    required String keyword,
    bool loadMore = false,
  }) async {
    if (!loadMore) {
      setState(() {
        _loadingGoods = true;
        _loadingMoreGoods = false;
        if (_activeKeyword == keyword) _goodsError = null;
      });
    } else {
      setState(() => _loadingMoreGoods = true);
    }

    try {
      final pageNo = loadMore ? _goodsPageNo + 1 : 1;
      final page = await ref.read(goodsRepoProvider).getMallProductsPage(
            pageNo,
            pageSize: _resultPageSize,
            keyword: keyword,
          );
      if (!mounted || _activeKeyword != keyword) return;
      setState(() {
        if (loadMore) {
          _goodsResults.addAll(page.list);
          _goodsPageNo = pageNo;
        } else {
          _goodsResults
            ..clear()
            ..addAll(page.list);
          _goodsPageNo = 1;
        }
        _goodsTotal = page.total;
        _loadingGoods = false;
        _loadingMoreGoods = false;
        _goodsError = null;
      });
    } catch (e) {
      if (!mounted || _activeKeyword != keyword) return;
      setState(() {
        _loadingGoods = false;
        _loadingMoreGoods = false;
        if (!loadMore) _goodsError = e;
      });
    }
  }

  Future<void> _fetchBlogResults({
    required String keyword,
    bool loadMore = false,
  }) async {
    if (!loadMore) {
      setState(() {
        _loadingBlogs = true;
        _loadingMoreBlogs = false;
        if (_activeKeyword == keyword) _blogsError = null;
      });
    } else {
      setState(() => _loadingMoreBlogs = true);
    }

    try {
      final pageNo = loadMore ? _blogPageNo + 1 : 1;
      final page = await ref.read(blogRepoProvider).getBlogPageModelDataWithPage(
            pageNo,
            pageSize: _resultPageSize,
            keyword: keyword,
          );
      if (!mounted || _activeKeyword != keyword) return;
      final list = page.list ?? const <BlogItem>[];
      setState(() {
        if (loadMore) {
          _blogResults.addAll(list);
          _blogPageNo = pageNo;
        } else {
          _blogResults
            ..clear()
            ..addAll(list);
          _blogPageNo = 1;
        }
        _blogTotal = page.total ?? list.length;
        _loadingBlogs = false;
        _loadingMoreBlogs = false;
        _blogsError = null;
      });
    } catch (e) {
      if (!mounted || _activeKeyword != keyword) return;
      setState(() {
        _loadingBlogs = false;
        _loadingMoreBlogs = false;
        if (!loadMore) _blogsError = e;
      });
    }
  }

  void _onSearch() {
    final q = _controller.text.trim();
    if (q.isEmpty) return;
    FocusScope.of(context).unfocus();
    final wideSplit = _isWideSplit(MediaQuery.sizeOf(context).width);
    setState(() => _showResult = true);
    // Web 窄屏：结果层占一条 history，手势返回只关结果，不会连退搜索页。
    if (kIsWeb && !wideSplit) {
      pushBrowserHistoryOverlay();
    }
    _persistSearchHistory(q);
    _fetchSearchResults();
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

  /// 窄屏：先退出「仅结果」视图回到落地；宽屏或已在落地：关闭搜索页。
  void _handleBack() {
    final wideSplit = _isWideSplit(MediaQuery.sizeOf(context).width);
    if (_showResult && !wideSplit) {
      setState(() => _showResult = false);
      return;
    }
    if (context.canPop()) {
      context.pop();
    }
  }

  List<String> get _historyShown {
    if (_historyExpanded || _historyAll.length <= 6) return _historyAll;
    return _historyAll.take(6).toList();
  }

  bool _isWideSplit(double width) => width >= _kWideSplitBreakpoint;

  double _pageHorizontalGap(double width) {
    if (width >= _kWideSplitBreakpoint) return 16;
    return 10.w;
  }

  /// 窄屏：居中 + 限宽；宽屏分栏单栏：居中 + 限宽；宽屏 AppBar：横向铺满。
  Widget _narrowContent(Widget child, {bool centerPanel = true}) {
    if (!centerPanel) return child;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _kNarrowContentMaxWidth),
        child: child,
      ),
    );
  }

  Widget _widePanelContent(Widget child) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _kWidePanelMaxWidth),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final wideSplit = _isWideSplit(screenWidth);
    final guardResultView = _showResult && !wideSplit;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final appBarSearch = Padding(
      padding: EdgeInsets.only(right: wideSplit ? 8.w : 0),
      child: Row(
        children: [
          Expanded(child: _buildTopSearchBar()),
          SizedBox(width: 8.w),
          _buildRedSearchButton(),
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
        backgroundColor: JdGoodsTheme.pageBgColor(context),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: JdGoodsTheme.surfaceColor(context),
          foregroundColor: JdGoodsTheme.textColor(context),
          systemOverlayStyle: isDark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          title: wideSplit ? appBarSearch : _narrowContent(appBarSearch),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final split = _isWideSplit(w);
            final hGap = _pageHorizontalGap(w);

            final Widget mainContent;
            if (split) {
              mainContent = Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: hGap, right: hGap / 2),
                      child: _widePanelContent(_buildLandingBody(screenWidth: w)),
                    ),
                  ),
                  Container(width: 1, color: JdGoodsTheme.lineColor(context)),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: hGap / 2, right: hGap),
                      child: _widePanelContent(
                        _showResult ? _buildResultBody() : _buildWideEmptyResult(),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              mainContent = _narrowContent(
                _showResult ? _buildResultBody() : _buildLandingBody(screenWidth: w),
              );
            }

            final fabRight = MediaQuery.paddingOf(context).right + 12.w;

            return Stack(
              children: [
                Positioned.fill(child: mainContent),
                Positioned(
                  right: fabRight,
                  bottom: MediaQuery.paddingOf(context).bottom + 80.h,
                  child: _feedbackFab(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopSearchBar() {
    return Container(
      height: 38.h,
      padding: EdgeInsets.only(left: 8.w, right: 6.w),
      decoration: BoxDecoration(
        color: JdGoodsTheme.searchBarBgColor(context),
        borderRadius: BorderRadius.circular(19.r),
      ),
      child: Row(
        children: [
          Text(
            'AI搜索',
            style: context.typo.label.copyWith(
              fontSize: 11,
              color: JdGoodsTheme.subColor(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          Transform.scale(
            scale: 0.65,
            child: Switch.adaptive(
              value: _aiSearch,
              onChanged: (v) => setState(() => _aiSearch = v),
              activeTrackColor: JdGoodsTheme.red.withValues(alpha: 0.45),
              activeThumbColor: JdGoodsTheme.red,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _onSearch(),
              style: context.typo.body.copyWith(
                fontSize: 14,
                color: JdGoodsTheme.textColor(context),
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: '搜索商品或博客',
                hintStyle: context.typo.inputHint.copyWith(
                  fontSize: 14,
                  color: JdGoodsTheme.subColor(context),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(
                  Icons.photo_camera_outlined,
                  size: 22,
                  color: JdGoodsTheme.subColor(context),
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 36.w, minHeight: 36.h),
              ),
              Positioned(
                right: 2.w,
                top: 4.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: JdGoodsTheme.red,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Text(
                    'AI',
                    style: context.typo.label.copyWith(
                      fontSize: 8,
                      color: Colors.white,
                      height: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRedSearchButton() {
    return Material(
      color: JdGoodsTheme.red,
      borderRadius: BorderRadius.circular(6.r),
      child: InkWell(
        onTap: _onSearch,
        borderRadius: BorderRadius.circular(6.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
          child: Text(
            '搜索',
            style: context.typo.button.copyWith(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildLandingBody({required double screenWidth}) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(child: _buildHistorySection()),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          SliverToBoxAdapter(child: _buildDiscoverSection(screenWidth)),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
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
              backgroundColor: JdGoodsTheme.surfaceColor(context),
              bottom: TabBar(
                controller: _rankTabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                labelPadding: EdgeInsets.only(right: 20.w),
                labelColor: JdGoodsTheme.red,
                unselectedLabelColor: JdGoodsTheme.subColor(context),
                labelStyle: context.typo.sectionTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: context.typo.sectionTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                indicatorColor: JdGoodsTheme.red,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: JdGoodsTheme.lineColor(context),
                tabs: _rankTabs.map((t) => Tab(text: t)).toList(),
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _rankTabController,
        children: _rankRowsByTab.map(_buildRankTabScrollBody).toList(),
      ),
    );
  }

  Widget _buildHistorySection() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitleRow(
            title: '搜索历史',
            trailing: IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 22,
                color: JdGoodsTheme.subColor(context),
              ),
              onPressed: _clearHistory,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          if (_historyAll.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                ..._historyShown.map(_historyChip),
                if (_historyAll.length > 6 && !_historyExpanded)
                  Material(
                    color: JdGoodsTheme.chipBgColor(context),
                    borderRadius: BorderRadius.circular(4.r),
                    child: InkWell(
                      onTap: () => setState(() => _historyExpanded = true),
                      borderRadius: BorderRadius.circular(4.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 7.h,
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: JdGoodsTheme.subColor(context),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDiscoverSection(double screenWidth) {
    final discoverColumns = screenWidth < 360 ? 1 : 2;

    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitleRow(
            title: '搜索发现',
            trailing: IconButton(
              icon: Icon(
                _discoverVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 22,
                color: JdGoodsTheme.subColor(context),
              ),
              onPressed: () => setState(() => _discoverVisible = !_discoverVisible),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          if (_discoverVisible) ...[
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: discoverColumns,
                mainAxisSpacing: 6,
                crossAxisSpacing: 12,
                childAspectRatio: discoverColumns == 1 ? 16 : 8.8,
              ),
              itemCount: _discoverItems.length,
              itemBuilder: (context, i) {
                final item = _discoverItems[i];
                return InkWell(
                  onTap: () => _fillQuery(item.text),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.promo) ...[
                          Container(
                            margin: const EdgeInsets.only(top: 2, right: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: JdGoodsTheme.red,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                            child: Text(
                              '促',
                              style: context.typo.label.copyWith(
                                fontSize: 10,
                                color: Colors.white,
                                height: 1,
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
                              color: JdGoodsTheme.textColor(context),
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

  Widget _buildRankTabScrollBody(List<_RankRow> rows) {
    return Builder(
      builder: (context) {
        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(
              child: _sectionCard(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
                child: _buildRankListContent(rows),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
        );
      },
    );
  }

  Widget _sectionCard({required Widget child, EdgeInsetsGeometry? padding}) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: _pageHorizontalGap(w)),
      padding: padding ?? EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: JdGoodsTheme.surfaceColor(context),
        borderRadius: BorderRadius.circular(10.r),
        border: Theme.of(context).brightness == Brightness.dark
            ? Border.all(color: JdGoodsTheme.lineColor(context))
            : null,
      ),
      child: child,
    );
  }

  Widget _sectionTitleRow({required String title, required Widget trailing}) {
    return Row(
      children: [
        Text(
          title,
          style: context.typo.sectionTitle.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: JdGoodsTheme.textColor(context),
          ),
        ),
        const Spacer(),
        trailing,
      ],
    );
  }

  Widget _historyChip(String text) {
    return Material(
      color: JdGoodsTheme.chipBgColor(context),
      borderRadius: BorderRadius.circular(4.r),
      child: InkWell(
        onTap: () => _fillQuery(text),
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
          child: Text(
            text,
            style: context.typo.body.copyWith(
              fontSize: 13,
              color: JdGoodsTheme.textColor(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankListContent(List<_RankRow> rows) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              JdGoodsTheme.rankPanelGradientTop(context),
              JdGoodsTheme.surfaceColor(context),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: rows.asMap().entries.map((e) {
            final last = e.key == rows.length - 1;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _rankRow(e.value),
                if (!last)
                  Divider(
                    height: 1,
                    indent: 36.w,
                    color: JdGoodsTheme.lineColor(context),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _rankRow(_RankRow row) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rankBadge(row.rank),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              row.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.typo.body.copyWith(
                fontSize: 14,
                color: JdGoodsTheme.rankTitleColor(context),
                height: 1.25,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '热度 ${row.heat}万',
            style: context.typo.caption.copyWith(
              fontSize: 11,
              color: JdGoodsTheme.subColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rankBadge(int rank) {
    if (rank <= 3) {
      final colors = [
        JdGoodsTheme.red,
        const Color(0xFFFFC107),
        const Color(0xFFFF9800),
      ];
      return Container(
        width: 22.w,
        height: 22.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors[rank - 1],
          borderRadius: BorderRadius.circular(4.r),
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
          color: JdGoodsTheme.rankIndexMutedColor(context),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _feedbackFab() {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.feedback_outlined, size: 16, color: Colors.white),
              SizedBox(width: 4.w),
              Text(
                '反馈',
                style: context.typo.label.copyWith(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideEmptyResult() {
    return ColoredBox(
      color: JdGoodsTheme.surfaceColor(context),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.manage_search_outlined,
                size: 48,
                color: JdGoodsTheme.subColor(context),
              ),
              SizedBox(height: 12.h),
              Text(
                '搜索结果',
                style: context.typo.sectionTitle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: JdGoodsTheme.textColor(context),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '在左侧输入关键词并点击搜索',
                textAlign: TextAlign.center,
                style: context.typo.pageSubtitle.copyWith(
                  fontSize: 13,
                  color: JdGoodsTheme.subColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultBody() {
    return NestedScrollView(
      key: ValueKey('search-result-$_activeKeyword'),
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
              backgroundColor: JdGoodsTheme.pageBgColor(context),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(_kResultCategoryBarHeight),
                child: SizedBox(
                  height: _kResultCategoryBarHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
                    child: _buildResultCategoryBar(compact: true),
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: Builder(
        builder: (context) => NotificationListener<ScrollNotification>(
          onNotification: _onResultScrollNotification,
          child: _buildResultList(context),
        ),
      ),
    );
  }

  Widget _buildResultCategoryBar({bool compact = false}) {
    return Container(
      margin: compact ? EdgeInsets.zero : EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 0),
      padding: EdgeInsets.all(compact ? 3.w : 4.w),
      decoration: BoxDecoration(
        color: JdGoodsTheme.chipBgColor(context),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          _buildCategoryChip(
            label: '商品',
            category: _SearchCategory.goods,
            count: _goodsTotal,
            loading: _loadingGoods,
            compact: compact,
          ),
          SizedBox(width: 8.w),
          _buildCategoryChip(
            label: '博客',
            category: _SearchCategory.blog,
            count: _blogTotal,
            loading: _loadingBlogs,
            compact: compact,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required _SearchCategory category,
    required int count,
    required bool loading,
    bool compact = false,
  }) {
    final selected = _searchCategory == category;
    final countLabel = loading ? '...' : '$count';
    return Expanded(
      child: Material(
        color: selected
            ? JdGoodsTheme.surfaceColor(context)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6.r),
        child: InkWell(
          onTap: () => _switchSearchCategory(category),
          borderRadius: BorderRadius.circular(6.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: compact ? 5 : 8.h),
            child: Text(
              '$label $countLabel',
              textAlign: TextAlign.center,
              style: context.typo.body.copyWith(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected
                    ? JdGoodsTheme.red
                    : JdGoodsTheme.textColor(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultList(BuildContext nestedContext) {
    final items = _currentResultItems;
    final loading = _loadingCurrentResults;
    final loadingMore = _loadingMoreCurrentResults;
    final error = _currentResultsError;
    final emptyLabel = _isGoodsCategory ? '商品' : '博客';
    final overlapHandle =
        NestedScrollView.sliverOverlapAbsorberHandleFor(nestedContext);

    if (loading && items.isEmpty) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverOverlapInjector(handle: overlapHandle),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
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
                      Icons.error_outline,
                      size: 48,
                      color: JdGoodsTheme.subColor(context),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '搜索失败',
                      style: context.typo.sectionTitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: JdGoodsTheme.textColor(context),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.typo.pageSubtitle.copyWith(
                        fontSize: 13,
                        color: JdGoodsTheme.subColor(context),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FilledButton(
                      onPressed: _fetchSearchResults,
                      style: FilledButton.styleFrom(
                        backgroundColor: JdGoodsTheme.red,
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
                      Icons.search_off_outlined,
                      size: 48,
                      color: JdGoodsTheme.subColor(context),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '暂无相关$emptyLabel',
                      style: context.typo.sectionTitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: JdGoodsTheme.textColor(context),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      _activeKeyword.isEmpty
                          ? '换个关键词试试'
                          : '未找到与「$_activeKeyword」相关的$emptyLabel',
                      textAlign: TextAlign.center,
                      style: context.typo.pageSubtitle.copyWith(
                        fontSize: 13,
                        color: JdGoodsTheme.subColor(context),
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
        SliverPadding(
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 24.h),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: kHorizontalDealCardAspectRatio,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= items.length) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                if (_isGoodsCategory) {
                  return _buildGoodsResultCard(_goodsResults[index]);
                }
                return _buildBlogResultCard(_blogResults[index]);
              },
              childCount: itemCount,
            ),
          ),
        ),
      ],
    );
  }

  HorizontalDealCardStyle _searchDealCardStyle(BuildContext context) {
    return HorizontalDealCardStyle.douyin(
      context: context,
      card: JdGoodsTheme.surfaceColor,
      sub: JdGoodsTheme.subColor,
      accent: JdGoodsTheme.red,
    );
  }

  void _openBlog(BlogItem item) {
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

  String _blogDisplayTitle(BlogItem item) {
    final title = item.title?.trim();
    if (title != null && title.isNotEmpty) return title;
    final content = item.content?.trim();
    if (content != null && content.isNotEmpty) {
      return content.length > 40 ? '${content.substring(0, 40)}...' : content;
    }
    return '博客';
  }

  String _blogResultMeta(BlogItem item) {
    final creator = item.creatorName?.trim().isNotEmpty == true
        ? item.creatorName!.trim()
        : (item.creator?.trim().isNotEmpty == true ? item.creator!.trim() : null);
    final likes = item.zan ?? 0;
    if (creator != null && likes > 0) return '$creator · $likes 赞';
    if (creator != null) return creator;
    if (likes > 0) return '$likes 赞';
    return '博客';
  }

  Widget _buildBlogResultCard(BlogItem item) {
    final id = item.id;
    final title = _blogDisplayTitle(item);
    final coverUrl = resolveMediaUrl(item.coverUrl);
    final isVideo = item.blogType == 2;
    final cardStyle = _searchDealCardStyle(context);

    return HorizontalDealCard(
      tag: isVideo ? '视频' : '图文',
      title: title,
      priceText: _blogResultMeta(item),
      style: cardStyle,
      onTap: id == null ? null : () => _openBlog(item),
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

  void _openGoods(MallProduct item) {
    final id = item.id;
    if (id == null) return;
    context.push('${Routes.goodsDetailPageUrl}/$id');
  }

  Widget _buildGoodsResultCard(MallProduct item) {
    final name = item.name?.trim().isNotEmpty == true ? item.name!.trim() : '商品';
    final coverUrl = resolveMediaUrl(item.coverUrl);
    final sales = item.salesCount ?? 0;
    final cardStyle = _searchDealCardStyle(context);

    return HorizontalDealCard(
      tag: sales > 0 ? '$sales 已售' : '精选',
      title: name,
      priceText: '¥${item.priceYuan.toStringAsFixed(2)}',
      style: cardStyle,
      onTap: () => _openGoods(item),
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

class _DiscoverItem {
  const _DiscoverItem(this.text, {this.promo = false});
  final String text;
  final bool promo;
}

class _RankRow {
  const _RankRow(this.rank, this.title, this.heat);
  final int rank;
  final String title;
  final String heat;
}

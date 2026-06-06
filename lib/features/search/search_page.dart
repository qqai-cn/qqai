import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/my_fonts.dart';

import '../../router/app_routes.dart';
import '../../util/web_history_helper.dart';
import '../goods/theme/jd_goods_theme.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 窄屏单列时内容最大宽度（居中），避免超宽屏一条拉满。
const double _kNarrowContentMaxWidth = 600;

/// 大于等于此宽度时：左侧落地 + 右侧结果，贴边分栏。
const double _kWideSplitBreakpoint = 1200;

/// 宽屏分栏时单栏内容最大宽度（避免半屏过宽显得空）。
const double _kWidePanelMaxWidth = 640;

/// 对齐京东搜索落地页：AI 搜索条、搜索历史、搜索发现（双列）、分类 Tab、热度榜单、反馈浮标。
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _showResult = false;
  bool _aiSearch = true;
  bool _historyExpanded = false;
  bool _discoverVisible = true;

  late final TabController _rankTabController;

  final List<String> _historyAll = [
    '板栗红薯',
    '爱玛电动车后置车筐',
    '洗衣液',
    '年货礼盒',
    '牛奶',
    '蓝牙音箱',
    '空调',
    '手机壳',
  ];

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
  }

  void _fillQuery(String q) {
    _controller.text = q;
    _controller.selection = TextSelection.collapsed(offset: q.length);
    _onSearch();
  }

  void _clearHistory() {
    setState(() => _historyAll.clear());
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
                hintText: '爱玛电动车尾箱',
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
    final discoverColumns = screenWidth < 360 ? 1 : 2;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionCard(
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
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
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
          ),
          SizedBox(height: 10.h),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitleRow(
                  title: '搜索发现',
                  trailing: IconButton(
                    icon: Icon(
                      _discoverVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 22,
                      color: JdGoodsTheme.subColor(context),
                    ),
                    onPressed: () => setState(() => _discoverVisible = !_discoverVisible),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                if (_discoverVisible) ...[
                  SizedBox(height: 10),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: JdGoodsTheme.red,
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                  child: Text(
                                    '促',
                                    style: context.typo.label.copyWith(fontSize: 10, color: Colors.white, height: 1),
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
          ),
          SizedBox(height: 10.h),
          _sectionCard(
            padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  controller: _rankTabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  labelPadding: EdgeInsets.only(right: 20.w),
                  labelColor: JdGoodsTheme.red,
                  unselectedLabelColor: JdGoodsTheme.subColor(context),
                  labelStyle: context.typo.sectionTitle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: context.typo.sectionTitle.copyWith(fontSize: 14, fontWeight: FontWeight.normal),
                  indicatorColor: JdGoodsTheme.red,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerHeight: 0,
                  tabs: _rankTabs.map((t) => Tab(text: t)).toList(),
                ),
                Divider(height: 1, color: JdGoodsTheme.lineColor(context)),
                Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 12.h),
                  child: SizedBox(
                    height: 320.h,
                    child: TabBarView(
                      controller: _rankTabController,
                      children: _rankRowsByTab.map(_buildRankPanel).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildRankPanel(List<_RankRow> rows) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
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
    final q = _controller.text.trim();
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      itemCount: 12,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: JdGoodsTheme.lineColor(context)),
      itemBuilder: (context, index) {
        return ListTile(
          tileColor: JdGoodsTheme.surfaceColor(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          leading: Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: JdGoodsTheme.pageBgColor(context),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(
              Icons.image_outlined,
              color: JdGoodsTheme.subColor(context),
              size: 28,
            ),
          ),
          title: Text(
            '示例商品 ${index + 1} · 「$q」',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.typo.body.copyWith(
              fontSize: 14,
              color: JdGoodsTheme.textColor(context),
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Row(
              children: [
                Text(
                  '¥${(99 + index * 10).toStringAsFixed(2)}',
                  style: context.typo.bodyStrong.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: JdGoodsTheme.red,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '自营',
                  style: context.typo.caption.copyWith(
                    fontSize: 11,
                    color: JdGoodsTheme.subColor(context),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            context.push('${Routes.goodsDetailPageUrl}/$index');
          },
        );
      },
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_routes.dart';
import '../../goods/data/models/trade_models.dart';
import '../../goods/data/repos/trade_repo.dart';
import '../theme/douyin_theme.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/media_url.dart';

/// 我的订单（对接 `/app-api/trade/order/page`）
class DouyinMyOrdersPage extends ConsumerStatefulWidget {
  const DouyinMyOrdersPage({super.key});

  @override
  ConsumerState<DouyinMyOrdersPage> createState() => _DouyinMyOrdersPageState();
}

class _DouyinMyOrdersPageState extends ConsumerState<DouyinMyOrdersPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 4, vsync: this);

  static const _tabs = <_OrderTab>[
    _OrderTab(label: '全部', status: null),
    _OrderTab(label: '待付款', status: 0),
    _OrderTab(label: '待发货', status: 10),
    _OrderTab(label: '已完成', status: 30),
  ];

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DouyinTheme.bg,
      appBar: AppBar(
        backgroundColor: DouyinTheme.bg,
        foregroundColor: DouyinTheme.text,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          '我的订单',
          style: context.typo.appBarTitle.copyWith(color: DouyinTheme.text),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: DouyinTheme.text),
            onPressed: () => context.push(Routes.cartPageUrl),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          indicatorColor: DouyinTheme.accent,
          labelColor: DouyinTheme.text,
          unselectedLabelColor: DouyinTheme.sub,
          labelStyle: context.typo.tab.copyWith(color: DouyinTheme.text),
          unselectedLabelStyle: context.typo.tab.copyWith(
            color: DouyinTheme.sub,
            fontWeight: FontWeight.w400,
          ),
          tabs: [for (final t in _tabs) Tab(text: t.label)],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          for (final t in _tabs) _OrderListTab(tab: t),
        ],
      ),
    );
  }
}

class _OrderTab {
  const _OrderTab({required this.label, this.status});

  final String label;
  final int? status;
}

class _OrderListTab extends ConsumerStatefulWidget {
  const _OrderListTab({required this.tab});

  final _OrderTab tab;

  @override
  ConsumerState<_OrderListTab> createState() => _OrderListTabState();
}

class _OrderListTabState extends ConsumerState<_OrderListTab>
    with AutomaticKeepAliveClientMixin {
  final _orders = <TradeOrderSummary>[];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = false;
  int _page = 1;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _loading = true;
        _error = null;
        _page = 1;
      });
    }
    try {
      final page = await ref.read(tradeRepoProvider).getOrderPage(
            1,
            status: widget.tab.status,
          );
      if (!mounted) return;
      setState(() {
        _orders
          ..clear()
          ..addAll(page.list);
        _page = 1;
        _hasMore = page.list.length >= 10;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final next = _page + 1;
      final page = await ref.read(tradeRepoProvider).getOrderPage(
            next,
            status: widget.tab.status,
          );
      if (!mounted) return;
      setState(() {
        _orders.addAll(page.list);
        _page = next;
        _hasMore = page.list.length >= 10;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            SizedBox(height: 12.h),
            FilledButton(
              onPressed: () => _load(refresh: true),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }
    if (_orders.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long_outlined,
                  size: 64, color: DouyinTheme.sub),
              SizedBox(height: 16.h),
              Text(
                '暂无${widget.tab.label}订单',
                style: context.typo.bodyStrong.copyWith(
                  color: DouyinTheme.text,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '商城订单将展示在这里',
                textAlign: TextAlign.center,
                style: context.typo.caption.copyWith(
                  color: DouyinTheme.sub,
                ),
              ),
              SizedBox(height: 24.h),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: DouyinTheme.accent,
                  foregroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                onPressed: () => context.push(Routes.goodsPageUrl),
                child: Text(
                  '去逛逛',
                  style: context.typo.button.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _load(refresh: true),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        itemCount: _orders.length + (_hasMore ? 1 : 0),
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          if (index >= _orders.length) {
            if (!_loadingMore) _loadMore();
            return const Center(child: CircularProgressIndicator());
          }
          return _OrderCard(order: _orders[index]);
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final TradeOrderSummary order;

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    return '${time.year}-${_two(time.month)}-${_two(time.day)} '
        '${_two(time.hour)}:${_two(time.minute)}';
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final cover = resolveMediaUrl(firstItem?.picUrl) ?? '';
    final title = firstItem?.spuName ?? '订单商品';
    final extraCount = (order.productCount ?? order.items.length) - 1;

    return Material(
      color: DouyinTheme.card,
      borderRadius: BorderRadius.circular(12.r),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '订单号 ${order.no ?? order.id ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.caption.copyWith(color: DouyinTheme.sub),
                  ),
                ),
                Text(
                  order.statusLabel,
                  style: context.typo.bodyStrong.copyWith(
                    color: DouyinTheme.accent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: cover.isEmpty
                      ? Container(
                          width: 72.w,
                          height: 72.w,
                          color: DouyinTheme.chip,
                          child: Icon(Icons.image_outlined,
                              color: DouyinTheme.sub),
                        )
                      : CachedNetworkImage(
                          imageUrl: cover,
                          width: 72.w,
                          height: 72.w,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        extraCount > 0 ? '$title 等${extraCount + 1}件' : title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.typo.body.copyWith(
                          color: DouyinTheme.text,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        _formatTime(order.createTime),
                        style: context.typo.caption.copyWith(
                          color: DouyinTheme.sub,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                const Spacer(),
                Text(
                  '实付 ',
                  style: context.typo.caption.copyWith(color: DouyinTheme.sub),
                ),
                Text(
                  '¥${order.payPriceYuan.toStringAsFixed(2)}',
                  style: context.typo.price.copyWith(
                    color: DouyinTheme.text,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

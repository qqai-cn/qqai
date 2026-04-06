import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_routes.dart';
import '../theme/douyin_theme.dart';

/// 我的订单（Tab + 列表占位，可对接真实订单接口）
class DouyinMyOrdersPage extends StatefulWidget {
  const DouyinMyOrdersPage({super.key});

  @override
  State<DouyinMyOrdersPage> createState() => _DouyinMyOrdersPageState();
}

class _DouyinMyOrdersPageState extends State<DouyinMyOrdersPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 4, vsync: this);

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
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
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
          tabs: const [
            Tab(text: '全部'),
            Tab(text: '待付款'),
            Tab(text: '待发货'),
            Tab(text: '已完成'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _OrderList(kind: '全部'),
          _OrderList(kind: '待付款'),
          _OrderList(kind: '待发货'),
          _OrderList(kind: '已完成'),
        ],
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.kind});

  final String kind;

  @override
  Widget build(BuildContext context) {
    // 占位：无后端时展示空态 + 去逛逛
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64.sp, color: DouyinTheme.sub),
            SizedBox(height: 16.h),
            Text(
              '暂无$kind订单',
              style: TextStyle(color: DouyinTheme.text, fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              '商城订单将展示在这里',
              textAlign: TextAlign.center,
              style: TextStyle(color: DouyinTheme.sub, fontSize: 13.sp),
            ),
            SizedBox(height: 24.h),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: DouyinTheme.accent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              onPressed: () => context.push(Routes.goodsPageUrl),
              child: const Text('去逛逛'),
            ),
          ],
        ),
      ),
    );
  }
}

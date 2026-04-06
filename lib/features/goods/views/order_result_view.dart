import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_routes.dart';
import '../theme/jd_goods_theme.dart';

/// 下单结果（京东风格）
class OrderResultView extends StatelessWidget {
  const OrderResultView({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JdGoodsTheme.pageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 48.h),
              Container(
                padding: EdgeInsets.all(28.w),
                decoration: BoxDecoration(
                  color: JdGoodsTheme.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 72.sp,
                      color: const Color(0xFF07C160),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      '订单提交成功',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: JdGoodsTheme.text,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '我们会尽快为您安排发货',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: JdGoodsTheme.sub,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: JdGoodsTheme.pageBg,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: SelectableText(
                        '订单编号：$orderId',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: JdGoodsTheme.text,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              OutlinedButton(
                onPressed: () => context.go(Routes.cartPageUrl),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48.h),
                  foregroundColor: JdGoodsTheme.text,
                  side: const BorderSide(color: JdGoodsTheme.line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Text(
                  '查看购物车',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 12.h),
              FilledButton(
                onPressed: () => context.go(Routes.HOME),
                style: FilledButton.styleFrom(
                  backgroundColor: JdGoodsTheme.red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Text(
                  '返回首页',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

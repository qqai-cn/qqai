import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../router/app_routes.dart';
import '../goods_tab_navigator.dart';
import '../theme/goods_page_style.dart';

/// 下单结果（固定上下结构）
class OrderResultView extends StatelessWidget {
  const OrderResultView({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GoodsPageStyle.pageBg(context),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: GoodsPageStyle.cardBg(context),
        foregroundColor: GoodsPageStyle.text(context),
        automaticallyImplyLeading: false,
        title: Text(
          '下单结果',
          style: context.typo.appBarTitle.copyWith(color: GoodsPageStyle.text(context)),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 24, 14, 32),
              child: Column(
                children: [
                  _SuccessCard(orderId: orderId),
                  const SizedBox(height: 24),
                  const _ResultActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return _GoodsPanel(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF3),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 48,
              color: Color(0xFF16A34A),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '订单提交成功',
            style: context.typo.sectionTitle.copyWith(
              color: GoodsPageStyle.text(context),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '我们会尽快为您安排发货',
            textAlign: TextAlign.center,
            style: context.typo.body.copyWith(
              color: GoodsPageStyle.sub(context),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: GoodsPageStyle.pageBg(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GoodsPageStyle.border(context)),
            ),
            child: SelectableText(
              '订单编号：$orderId',
              style: context.typo.body.copyWith(
                color: GoodsPageStyle.text(context),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultActions extends StatelessWidget {
  const _ResultActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton(
          onPressed: () => context.openGoodsCartFromRoot(),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            foregroundColor: GoodsPageStyle.text(context),
            side: BorderSide(color: GoodsPageStyle.border(context)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text('查看购物车', style: context.typo.buttonSecondary),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => context.go(Routes.HOME),
          style: FilledButton.styleFrom(
            backgroundColor: GoodsPageStyle.accent,
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text('返回首页', style: context.typo.button),
        ),
      ],
    );
  }
}

class _GoodsPanel extends StatelessWidget {
  const _GoodsPanel({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: GoodsPageStyle.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GoodsPageStyle.border(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../router/app_routes.dart';
import '../models/cart_line.dart';
import '../providers/cart_session.dart';
import '../theme/jd_goods_theme.dart';

class CartView extends ConsumerStatefulWidget {
  const CartView({super.key});

  @override
  ConsumerState<CartView> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
  void _goCheckout() {
    final snapshot = ref.read(cartSessionProvider.notifier).selectedSnapshot();
    if (snapshot.isEmpty) return;
    context.push(Routes.checkoutPageUrl, extra: snapshot);
  }

  bool _allSelected(List<CartLine> lines) =>
      lines.isNotEmpty && lines.every((e) => e.selected);

  @override
  Widget build(BuildContext context) {
    final lines = ref.watch(cartSessionProvider);
    final notifier = ref.read(cartSessionProvider.notifier);
    final selectedTotal = notifier.selectedTotal();
    final selectedCount = notifier.selectedCount();
    final allSel = _allSelected(lines);

    return Scaffold(
      backgroundColor: JdGoodsTheme.pageBg,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: JdGoodsTheme.white,
        foregroundColor: JdGoodsTheme.text,
        title: Text(
          '购物车',
          style: context.typo.appBarTitle.copyWith(
            fontSize: 18.sp,
            color: JdGoodsTheme.text,
          ),
        ),
        centerTitle: true,
      ),
      body: lines.isEmpty
          ? _EmptyCart()
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 100.h),
              itemCount: lines.length,
              itemBuilder: (context, index) {
                final line = lines[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _JdCartItemCard(
                    line: line,
                    onToggle: (v) => notifier.toggleSelect(line, v),
                    onDec: () => notifier.setQty(line, line.quantity - 1),
                    onInc: () => notifier.setQty(line, line.quantity + 1),
                    onDelete: () => notifier.remove(line),
                  ),
                );
              },
            ),
      bottomNavigationBar: lines.isEmpty
          ? null
          : SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: JdGoodsTheme.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(8.w, 10.h, 12.w, 10.h),
                child: Row(
                  children: [
                    Checkbox(
                      value: allSel,
                      activeColor: JdGoodsTheme.red,
                      onChanged: (v) => notifier.selectAll(v ?? false),
                    ),
                    Text(
                      '全选',
                      style: context.typo.body.copyWith(
                        fontSize: 14.sp,
                        color: JdGoodsTheme.text,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '合计：',
                                style: context.typo.caption.copyWith(
                                  fontSize: 13.sp,
                                  color: JdGoodsTheme.sub,
                                ),
                              ),
                              Text(
                                '¥',
                                style: context.typo.price.copyWith(
                                  fontSize: 12.sp,
                                  color: JdGoodsTheme.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                selectedTotal.toStringAsFixed(2),
                                style: context.typo.price.copyWith(
                                  fontSize: 20.sp,
                                  color: JdGoodsTheme.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          if (selectedCount > 0)
                            Text(
                              '已选 $selectedCount 件',
                              style: context.typo.caption.copyWith(
                                fontSize: 11.sp,
                                color: JdGoodsTheme.sub,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    FilledButton(
                      onPressed: selectedCount == 0 ? null : _goCheckout,
                      style: FilledButton.styleFrom(
                        backgroundColor: JdGoodsTheme.red,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: JdGoodsTheme.sub.withValues(alpha: 0.4),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                      ),
                      child: Text(
                        selectedCount > 0 ? '去结算($selectedCount)' : '去结算',
                        style: context.typo.button.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 88.sp,
            color: JdGoodsTheme.line,
          ),
          SizedBox(height: 16.h),
          Text(
            '购物车空空如也～',
            style: context.typo.sectionTitle.copyWith(
              fontSize: 16.sp,
              color: JdGoodsTheme.sub,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '快去挑选心仪商品吧',
            style: context.typo.caption.copyWith(
              fontSize: 13.sp,
              color: JdGoodsTheme.sub,
            ),
          ),
        ],
      ),
    );
  }
}

class _JdCartItemCard extends StatelessWidget {
  const _JdCartItemCard({
    required this.line,
    required this.onToggle,
    required this.onDec,
    required this.onInc,
    required this.onDelete,
  });

  final CartLine line;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onDec;
  final VoidCallback onInc;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: JdGoodsTheme.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(4.w, 10.h, 10.w, 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: line.selected,
            activeColor: JdGoodsTheme.red,
            onChanged: onToggle,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Image.asset(
              line.coverAsset,
              width: 96.w,
              height: 96.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.cardTitle.copyWith(
                    fontSize: 14.sp,
                    height: 1.35,
                    color: JdGoodsTheme.text,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '¥',
                      style: context.typo.price.copyWith(
                        fontSize: 12.sp,
                        color: JdGoodsTheme.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      line.price.toStringAsFixed(2),
                      style: context.typo.price.copyWith(
                        fontSize: 18.sp,
                        color: JdGoodsTheme.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    _JdStepper(
                      qty: line.quantity,
                      onDec: onDec,
                      onInc: onInc,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete_outline, size: 18.sp, color: JdGoodsTheme.sub),
                    label: Text(
                      '删除',
                      style: context.typo.caption.copyWith(
                        fontSize: 13.sp,
                        color: JdGoodsTheme.sub,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.only(top: 4.h),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
}

class _JdStepper extends StatelessWidget {
  const _JdStepper({
    required this.qty,
    required this.onDec,
    required this.onInc,
  });

  final int qty;
  final VoidCallback onDec;
  final VoidCallback onInc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: JdGoodsTheme.line),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: qty > 1 ? onDec : null,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              child: Icon(
                Icons.remove,
                size: 16.sp,
                color: qty > 1 ? JdGoodsTheme.text : JdGoodsTheme.sub,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(minWidth: 28.w),
            alignment: Alignment.center,
            child: Text(
              '$qty',
              style: context.typo.bodyStrong.copyWith(
                fontSize: 14.sp,
                color: JdGoodsTheme.text,
              ),
            ),
          ),
          InkWell(
            onTap: onInc,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              child: Icon(Icons.add, size: 16.sp, color: JdGoodsTheme.text),
            ),
          ),
        ],
      ),
    );
  }
}

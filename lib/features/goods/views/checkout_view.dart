import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_routes.dart';
import '../models/cart_line.dart';
import '../providers/cart_session.dart';
import '../theme/jd_goods_theme.dart';

/// 确认订单（京东风格）
class CheckoutView extends ConsumerStatefulWidget {
  const CheckoutView({super.key, required this.lines});

  final List<CartLine> lines;

  @override
  ConsumerState<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends ConsumerState<CheckoutView> {
  final _addressController = TextEditingController(
    text: '北京市朝阳区某某街道 1 号楼（示例地址）',
  );
  final _nameController = TextEditingController(text: '张三');
  final _phoneController = TextEditingController(text: '13800138000');
  int _payIndex = 0;
  bool _submitting = false;
  static const _freight = 6.0;

  @override
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  double get _goodsTotal =>
      widget.lines.fold<double>(0, (s, e) => s + e.subtotal);

  double get _payTotal => _goodsTotal + _freight;

  Future<void> _submit() async {
    if (widget.lines.isEmpty || _submitting) return;
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final addr = _addressController.text.trim();
    if (name.isEmpty || phone.isEmpty || addr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('请填写完整收货信息'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
    final ids = widget.lines.map((e) => e.id).toSet();
    ref.read(cartSessionProvider.notifier).removeByIds(ids);

    if (!mounted) return;
    context.pushReplacement(
      Routes.orderResultPageUrl,
      extra: orderId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final payLabels = ['微信支付', '支付宝', '货到付款（示例）'];

    return Scaffold(
      backgroundColor: JdGoodsTheme.pageBg,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: JdGoodsTheme.white,
        foregroundColor: JdGoodsTheme.text,
        title: Text(
          '确认订单',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: JdGoodsTheme.text,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 16.h),
        children: [
          _SectionTitle(title: '收货地址'),
          SizedBox(height: 8.h),
          _WhiteCard(
            child: Column(
              children: [
                _JdTextField(
                  controller: _nameController,
                  label: '收货人',
                  icon: Icons.person_outline,
                ),
                Divider(height: 1, color: JdGoodsTheme.line),
                _JdTextField(
                  controller: _phoneController,
                  label: '手机号',
                  icon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                ),
                Divider(height: 1, color: JdGoodsTheme.line),
                _JdTextField(
                  controller: _addressController,
                  label: '详细地址',
                  icon: Icons.location_on_outlined,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          _SectionTitle(title: '支付方式'),
          SizedBox(height: 8.h),
          _WhiteCard(
            child: Column(
              children: List.generate(payLabels.length, (i) {
                final last = i == payLabels.length - 1;
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                      title: Text(
                        payLabels[i],
                        style: TextStyle(fontSize: 15.sp, color: JdGoodsTheme.text),
                      ),
                      trailing: _payIndex == i
                          ? Icon(Icons.check_circle, color: JdGoodsTheme.red, size: 22.sp)
                          : Icon(Icons.radio_button_unchecked, color: JdGoodsTheme.line, size: 22.sp),
                      onTap: () => setState(() => _payIndex = i),
                    ),
                    if (!last) Divider(height: 1, color: JdGoodsTheme.line),
                  ],
                );
              }),
            ),
          ),
          SizedBox(height: 14.h),
          _SectionTitle(title: '商品清单'),
          SizedBox(height: 8.h),
          ...widget.lines.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _WhiteCard(
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: Image.asset(
                          e.coverAsset,
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
                              e.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                height: 1.3,
                                color: JdGoodsTheme.text,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              '¥${e.price.toStringAsFixed(2)} × ${e.quantity}',
                              style: TextStyle(fontSize: 12.sp, color: JdGoodsTheme.sub),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '¥${e.subtotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: JdGoodsTheme.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          _WhiteCard(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Column(
                children: [
                  _PriceLine(label: '商品合计', value: '¥${_goodsTotal.toStringAsFixed(2)}'),
                  SizedBox(height: 10.h),
                  _PriceLine(label: '运费', value: '¥${_freight.toStringAsFixed(2)}'),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Divider(height: 1, color: JdGoodsTheme.line),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '实付款',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: JdGoodsTheme.text,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '¥',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: JdGoodsTheme.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _payTotal.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: JdGoodsTheme.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 88.h),
        ],
      ),
      bottomNavigationBar: SafeArea(
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
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: FilledButton(
            onPressed: widget.lines.isEmpty || _submitting ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: JdGoodsTheme.red,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: Size(double.infinity, 50.h),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: _submitting
                ? SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    '提交订单 ¥${_payTotal.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: JdGoodsTheme.text,
        ),
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _JdTextField extends StatelessWidget {
  const _JdTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 14.sp, color: JdGoodsTheme.text),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon, size: 20.sp, color: JdGoodsTheme.sub),
          labelText: label,
          labelStyle: TextStyle(fontSize: 13.sp, color: JdGoodsTheme.sub),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: JdGoodsTheme.sub),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, color: JdGoodsTheme.text),
        ),
      ],
    );
  }
}

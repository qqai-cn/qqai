import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/media_url.dart';

import '../../my/data/models/member_address_models.dart';
import '../../my/data/repos/member_address_repo.dart';
import '../goods_tab_navigator.dart';
import '../models/cart_line.dart';
import '../providers/cart_session.dart';
import '../theme/goods_page_style.dart';
import '../widgets/checkout_address_picker_sheet.dart';

/// 确认订单
class CheckoutView extends ConsumerStatefulWidget {
  const CheckoutView({super.key, required this.lines});

  final List<CartLine> lines;

  @override
  ConsumerState<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends ConsumerState<CheckoutView> {
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  MemberAddress? _selectedAddress;
  int _payIndex = 0;
  bool _submitting = false;
  static const _freight = 6.0;
  static const _payLabels = ['微信支付', '支付宝', '货到付款（示例）'];

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadDefaultAddress);
  }

  Future<void> _loadDefaultAddress() async {
    try {
      final list = await ref.read(memberAddressRepoProvider).getList();
      if (!mounted || list.isEmpty) return;
      final defaultAddr = list.firstWhere(
        (a) => a.defaultStatus,
        orElse: () => list.first,
      );
      _applyAddress(defaultAddr);
      setState(() => _selectedAddress = defaultAddr);
    } catch (_) {
      // 未登录或无地址时允许手动填写
    }
  }

  void _applyAddress(MemberAddress address) {
    _nameController.text = address.name?.trim() ?? '';
    _phoneController.text = address.mobile?.trim() ?? '';
    _addressController.text = address.fullAddress;
  }

  Future<void> _pickAddress() async {
    final picked = await showCheckoutAddressPickerSheet(
      context,
      ref,
      selected: _selectedAddress,
    );
    if (picked == null || !mounted) return;
    _applyAddress(picked);
    setState(() => _selectedAddress = picked);
  }

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

  bool _isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= GoodsPageStyle.wideBreakpoint;

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
    context.pushGoodsOrderResult(orderId);
  }

  @override
  Widget build(BuildContext context) {
    final wide = _isWide(context);

    return Scaffold(
      backgroundColor: GoodsPageStyle.pageBg,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: GoodsPageStyle.cardBg,
        foregroundColor: GoodsPageStyle.text,
        title: Text(
          '确认订单',
          style: context.typo.appBarTitle.copyWith(color: GoodsPageStyle.text),
        ),
        centerTitle: true,
      ),
      body: wide
          ? _WideCheckoutBody(
              lines: widget.lines,
              nameController: _nameController,
              phoneController: _phoneController,
              addressController: _addressController,
              selectedAddress: _selectedAddress,
              onPickAddress: _pickAddress,
              payIndex: _payIndex,
              payLabels: _payLabels,
              goodsTotal: _goodsTotal,
              payTotal: _payTotal,
              freight: _freight,
              submitting: _submitting,
              onPayChanged: (i) => setState(() => _payIndex = i),
              onSubmit: _submit,
            )
          : _CheckoutFormContent(
              lines: widget.lines,
              nameController: _nameController,
              phoneController: _phoneController,
              addressController: _addressController,
              selectedAddress: _selectedAddress,
              onPickAddress: _pickAddress,
              payIndex: _payIndex,
              payLabels: _payLabels,
              goodsTotal: _goodsTotal,
              payTotal: _payTotal,
              freight: _freight,
              onPayChanged: (i) => setState(() => _payIndex = i),
              showPriceSummary: true,
            ),
      bottomNavigationBar: wide
          ? null
          : _CheckoutSubmitBar(
              payTotal: _payTotal,
              submitting: _submitting,
              enabled: widget.lines.isNotEmpty,
              onSubmit: _submit,
            ),
    );
  }
}

class _WideCheckoutBody extends StatelessWidget {
  const _WideCheckoutBody({
    required this.lines,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.selectedAddress,
    required this.onPickAddress,
    required this.payIndex,
    required this.payLabels,
    required this.goodsTotal,
    required this.payTotal,
    required this.freight,
    required this.submitting,
    required this.onPayChanged,
    required this.onSubmit,
  });

  final List<CartLine> lines;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final MemberAddress? selectedAddress;
  final VoidCallback onPickAddress;
  final int payIndex;
  final List<String> payLabels;
  final double goodsTotal;
  final double payTotal;
  final double freight;
  final bool submitting;
  final ValueChanged<int> onPayChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth:
              GoodsPageStyle.pageMaxWidth +
                  GoodsPageStyle.sidePanelWidth +
                  GoodsPageStyle.gutter,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _CheckoutFormContent(
                  lines: lines,
                  nameController: nameController,
                  phoneController: phoneController,
                  addressController: addressController,
                  selectedAddress: selectedAddress,
                  onPickAddress: onPickAddress,
                  payIndex: payIndex,
                  payLabels: payLabels,
                  goodsTotal: goodsTotal,
                  payTotal: payTotal,
                  freight: freight,
                  onPayChanged: onPayChanged,
                  showPriceSummary: false,
                ),
              ),
              const SizedBox(width: GoodsPageStyle.gutter),
              SizedBox(
                width: GoodsPageStyle.sidePanelWidth,
                child: _CheckoutSidePanel(
                  goodsTotal: goodsTotal,
                  payTotal: payTotal,
                  freight: freight,
                  submitting: submitting,
                  enabled: lines.isNotEmpty,
                  onSubmit: onSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutFormContent extends StatelessWidget {
  const _CheckoutFormContent({
    required this.lines,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.selectedAddress,
    required this.onPickAddress,
    required this.payIndex,
    required this.payLabels,
    required this.goodsTotal,
    required this.payTotal,
    required this.freight,
    required this.onPayChanged,
    required this.showPriceSummary,
  });

  final List<CartLine> lines;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final MemberAddress? selectedAddress;
  final VoidCallback onPickAddress;
  final int payIndex;
  final List<String> payLabels;
  final double goodsTotal;
  final double payTotal;
  final double freight;
  final ValueChanged<int> onPayChanged;
  final bool showPriceSummary;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(14, 12, 14, showPriceSummary ? 100 : 24),
      children: [
        const _SectionTitle(title: '收货地址'),
        const SizedBox(height: 8),
        _GoodsPanel(
          child: Column(
            children: [
              _CheckoutAddressPickRow(
                selectedAddress: selectedAddress,
                onTap: onPickAddress,
              ),
              const Divider(height: 1, color: GoodsPageStyle.border),
              _CheckoutTextField(
                controller: nameController,
                label: '收货人',
                icon: Icons.person_outline,
              ),
              const Divider(height: 1, color: GoodsPageStyle.border),
              _CheckoutTextField(
                controller: phoneController,
                label: '手机号',
                icon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
              ),
              const Divider(height: 1, color: GoodsPageStyle.border),
              _CheckoutTextField(
                controller: addressController,
                label: '详细地址',
                icon: Icons.location_on_outlined,
                maxLines: 3,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _SectionTitle(title: '支付方式'),
        const SizedBox(height: 8),
        _GoodsPanel(
          child: Column(
            children: List.generate(payLabels.length, (i) {
              final last = i == payLabels.length - 1;
              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    title: Text(
                      payLabels[i],
                      style: context.typo.body.copyWith(
                        color: GoodsPageStyle.text,
                      ),
                    ),
                    trailing: payIndex == i
                        ? const Icon(
                            Icons.check_circle,
                            color: GoodsPageStyle.accent,
                            size: 22,
                          )
                        : const Icon(
                            Icons.radio_button_unchecked,
                            color: GoodsPageStyle.border,
                            size: 22,
                          ),
                    onTap: () => onPayChanged(i),
                  ),
                  if (!last)
                    const Divider(height: 1, color: GoodsPageStyle.border),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 14),
        const _SectionTitle(title: '商品清单'),
        const SizedBox(height: 8),
        ...lines.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CheckoutGoodsRow(line: e),
          ),
        ),
        if (showPriceSummary) ...[
          const SizedBox(height: 6),
          _PriceSummaryCard(
            goodsTotal: goodsTotal,
            payTotal: payTotal,
            freight: freight,
          ),
        ],
      ],
    );
  }
}

class _CheckoutSidePanel extends StatelessWidget {
  const _CheckoutSidePanel({
    required this.goodsTotal,
    required this.payTotal,
    required this.freight,
    required this.submitting,
    required this.enabled,
    required this.onSubmit,
  });

  final double goodsTotal;
  final double payTotal;
  final double freight;
  final bool submitting;
  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return _GoodsPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '订单金额',
            style: context.typo.sectionTitle.copyWith(
              color: GoodsPageStyle.text,
            ),
          ),
          const SizedBox(height: 16),
          _PriceLine(
            label: '商品合计',
            value: '¥${goodsTotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _PriceLine(
            label: '运费',
            value: '¥${freight.toStringAsFixed(2)}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: GoodsPageStyle.border),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '实付款',
                style: context.typo.bodyStrong.copyWith(
                  color: GoodsPageStyle.text,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '¥',
                    style: TextStyle(
                      color: GoodsPageStyle.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    payTotal.toStringAsFixed(2),
                    style: context.typo.price.copyWith(
                      color: GoodsPageStyle.accent,
                      fontSize: 26,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: !enabled || submitting ? null : onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: GoodsPageStyle.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    GoodsPageStyle.sub.withValues(alpha: 0.35),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      '提交订单 ¥${payTotal.toStringAsFixed(2)}',
                      style: context.typo.button,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutSubmitBar extends StatelessWidget {
  const _CheckoutSubmitBar({
    required this.payTotal,
    required this.submitting,
    required this.enabled,
    required this.onSubmit,
  });

  final double payTotal;
  final bool submitting;
  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Material(
        color: GoodsPageStyle.cardBg,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '实付款：',
                    style: context.typo.caption.copyWith(
                      color: GoodsPageStyle.sub,
                    ),
                  ),
                  const Text(
                    '¥',
                    style: TextStyle(
                      color: GoodsPageStyle.accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    payTotal.toStringAsFixed(2),
                    style: context.typo.price.copyWith(
                      color: GoodsPageStyle.accent,
                      fontSize: 22,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: FilledButton(
                  onPressed: !enabled || submitting ? null : onSubmit,
                  style: FilledButton.styleFrom(
                    backgroundColor: GoodsPageStyle.accent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        GoodsPageStyle.sub.withValues(alpha: 0.35),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          '提交订单 ¥${payTotal.toStringAsFixed(2)}',
                          style: context.typo.button,
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

class _PriceSummaryCard extends StatelessWidget {
  const _PriceSummaryCard({
    required this.goodsTotal,
    required this.payTotal,
    required this.freight,
  });

  final double goodsTotal;
  final double payTotal;
  final double freight;

  @override
  Widget build(BuildContext context) {
    return _GoodsPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          _PriceLine(
            label: '商品合计',
            value: '¥${goodsTotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _PriceLine(label: '运费', value: '¥${freight.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: GoodsPageStyle.border),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '实付款',
                style: context.typo.bodyStrong.copyWith(
                  color: GoodsPageStyle.text,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '¥',
                    style: TextStyle(
                      color: GoodsPageStyle.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    payTotal.toStringAsFixed(2),
                    style: context.typo.price.copyWith(
                      color: GoodsPageStyle.accent,
                      fontSize: 22,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CheckoutGoodsRow extends StatelessWidget {
  const _CheckoutGoodsRow({required this.line});

  final CartLine line;

  @override
  Widget build(BuildContext context) {
    return _GoodsPanel(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildCover(line),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.cardTitle2.copyWith(
                    color: GoodsPageStyle.text,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '¥${line.price.toStringAsFixed(2)} × ${line.quantity}',
                  style: context.typo.caption.copyWith(color: GoodsPageStyle.sub),
                ),
              ],
            ),
          ),
          Text(
            '¥${line.subtotal.toStringAsFixed(2)}',
            style: context.typo.price.copyWith(
              color: GoodsPageStyle.accent,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover(CartLine line) {
    final url = resolveMediaUrl(line.coverUrl) ?? '';
    if (url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorWidget: (_, _, _) => const _CoverFallback(size: 72),
      );
    }
    final asset = line.coverAsset;
    if (asset != null && asset.isNotEmpty) {
      return Image.asset(
        asset,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const _CoverFallback(size: 72),
      );
    }
    return const _CoverFallback(size: 72);
  }
}

class _CoverFallback extends StatelessWidget {
  const _CoverFallback({this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: GoodsPageStyle.imageBg,
      child: SizedBox(
        width: size,
        height: size,
        child: const Icon(
          Icons.shopping_bag_outlined,
          size: 28,
          color: Color(0xFF9CA3AF),
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
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: context.typo.sectionTitle.copyWith(color: GoodsPageStyle.text),
      ),
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
        color: GoodsPageStyle.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GoodsPageStyle.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _CheckoutAddressPickRow extends StatelessWidget {
  const _CheckoutAddressPickRow({
    required this.selectedAddress,
    required this.onTap,
  });

  final MemberAddress? selectedAddress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = selectedAddress;
    final subtitle = selected == null
        ? '点击从已保存地址中选择'
        : '${selected.name ?? ''} ${selected.mobile ?? ''}'.trim();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            const Icon(
              Icons.contact_page_outlined,
              size: 20,
              color: GoodsPageStyle.accent,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '从我的地址选择',
                    style: context.typo.bodyStrong.copyWith(
                      color: GoodsPageStyle.text,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.typo.caption.copyWith(
                        color: GoodsPageStyle.sub,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 22,
              color: GoodsPageStyle.sub,
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutTextField extends StatelessWidget {
  const _CheckoutTextField({
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: context.typo.body.copyWith(color: GoodsPageStyle.text),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon, size: 20, color: GoodsPageStyle.sub),
          labelText: label,
          labelStyle: context.typo.caption.copyWith(color: GoodsPageStyle.sub),
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
          style: context.typo.caption.copyWith(color: GoodsPageStyle.sub),
        ),
        Text(
          value,
          style: context.typo.body.copyWith(color: GoodsPageStyle.text),
        ),
      ],
    );
  }
}

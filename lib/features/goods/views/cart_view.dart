import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/config/theme/app_typography.dart';
import '../goods_tab_navigator.dart';
import '../models/cart_line.dart';
import '../providers/cart_session.dart';
import '../theme/goods_page_style.dart';

class CartView extends ConsumerStatefulWidget {
  const CartView({super.key});

  @override
  ConsumerState<CartView> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
  void _goCheckout() {
    final snapshot = ref.read(cartSessionProvider.notifier).selectedSnapshot();
    if (snapshot.isEmpty) return;
    context.pushGoodsCheckout(snapshot);
  }

  bool _allSelected(List<CartLine> lines) =>
      lines.isNotEmpty && lines.every((e) => e.selected);

  bool _isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= GoodsPageStyle.wideBreakpoint;

  @override
  Widget build(BuildContext context) {
    final lines = ref.watch(cartSessionProvider);
    final notifier = ref.read(cartSessionProvider.notifier);
    final selectedTotal = notifier.selectedTotal();
    final selectedCount = notifier.selectedCount();
    final allSel = _allSelected(lines);
    final wide = _isWide(context);

    return Scaffold(
      backgroundColor: GoodsPageStyle.pageBg,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: GoodsPageStyle.cardBg,
        foregroundColor: GoodsPageStyle.text,
        title: Text(
          '购物车',
          style: context.typo.appBarTitle.copyWith(color: GoodsPageStyle.text),
        ),
        centerTitle: true,
      ),
      body: lines.isEmpty
          ? const _EmptyCart()
          : wide
          ? _WideCartBody(
              lines: lines,
              notifier: notifier,
              allSelected: allSel,
              selectedTotal: selectedTotal,
              selectedCount: selectedCount,
              onCheckout: _goCheckout,
            )
          : _NarrowCartBody(
              lines: lines,
              notifier: notifier,
            ),
      bottomNavigationBar: lines.isEmpty || wide
          ? null
          : _CartCheckoutBar(
              allSelected: allSel,
              selectedTotal: selectedTotal,
              selectedCount: selectedCount,
              onSelectAll: notifier.selectAll,
              onCheckout: _goCheckout,
            ),
    );
  }
}

class _NarrowCartBody extends StatelessWidget {
  const _NarrowCartBody({
    required this.lines,
    required this.notifier,
  });

  final List<CartLine> lines;
  final CartSession notifier;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final line = lines[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: GoodsPageStyle.pageMaxWidth),
              child: _CartItemCard(
                line: line,
                onToggle: (v) => notifier.toggleSelect(line, v),
                onDec: () => notifier.setQty(line, line.quantity - 1),
                onInc: () => notifier.setQty(line, line.quantity + 1),
                onDelete: () => notifier.remove(line),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WideCartBody extends StatelessWidget {
  const _WideCartBody({
    required this.lines,
    required this.notifier,
    required this.allSelected,
    required this.selectedTotal,
    required this.selectedCount,
    required this.onCheckout,
  });

  final List<CartLine> lines;
  final CartSession notifier;
  final bool allSelected;
  final double selectedTotal;
  final int selectedCount;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: GoodsPageStyle.pageMaxWidth + GoodsPageStyle.sidePanelWidth + 32,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: lines.length,
                  itemBuilder: (context, index) {
                    final line = lines[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CartItemCard(
                        line: line,
                        onToggle: (v) => notifier.toggleSelect(line, v),
                        onDec: () => notifier.setQty(line, line.quantity - 1),
                        onInc: () =>
                            notifier.setQty(line, line.quantity + 1),
                        onDelete: () => notifier.remove(line),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: GoodsPageStyle.sidePanelWidth,
                child: _CartSummaryPanel(
                  allSelected: allSelected,
                  selectedTotal: selectedTotal,
                  selectedCount: selectedCount,
                  onSelectAll: notifier.selectAll,
                  onCheckout: onCheckout,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartSummaryPanel extends StatelessWidget {
  const _CartSummaryPanel({
    required this.allSelected,
    required this.selectedTotal,
    required this.selectedCount,
    required this.onSelectAll,
    required this.onCheckout,
  });

  final bool allSelected;
  final double selectedTotal;
  final int selectedCount;
  final void Function(bool) onSelectAll;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return _CartPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '结算明细',
            style: context.typo.sectionTitle.copyWith(color: GoodsPageStyle.text),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: allSelected,
                activeColor: GoodsPageStyle.accent,
                onChanged: (v) => onSelectAll(v ?? false),
              ),
              Text(
                '全选',
                style: context.typo.body.copyWith(color: GoodsPageStyle.text),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '已选商品',
                style: context.typo.caption.copyWith(color: GoodsPageStyle.sub),
              ),
              Text(
                '$selectedCount 件',
                style: context.typo.bodyStrong.copyWith(color: GoodsPageStyle.text),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '合计',
                style: context.typo.caption.copyWith(color: GoodsPageStyle.sub),
              ),
              const Spacer(),
              const Text(
                '¥',
                style: TextStyle(
                  color: GoodsPageStyle.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                selectedTotal.toStringAsFixed(2),
                style: context.typo.price.copyWith(
                  color: GoodsPageStyle.accent,
                  fontSize: 26,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: selectedCount == 0 ? null : onCheckout,
              style: FilledButton.styleFrom(
                backgroundColor: GoodsPageStyle.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    GoodsPageStyle.sub.withValues(alpha: 0.35),
                elevation: 0,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                selectedCount > 0 ? '去结算($selectedCount)' : '去结算',
                style: context.typo.button,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartCheckoutBar extends StatelessWidget {
  const _CartCheckoutBar({
    required this.allSelected,
    required this.selectedTotal,
    required this.selectedCount,
    required this.onSelectAll,
    required this.onCheckout,
  });

  final bool allSelected;
  final double selectedTotal;
  final int selectedCount;
  final void Function(bool) onSelectAll;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final checkoutLabel =
        selectedCount > 0 ? '去结算($selectedCount)' : '去结算';

    return SafeArea(
      top: false,
      child: Material(
        color: GoodsPageStyle.cardBg,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: allSelected,
                    activeColor: GoodsPageStyle.accent,
                    visualDensity: VisualDensity.compact,
                    onChanged: (v) => onSelectAll(v ?? false),
                  ),
                  Text(
                    '全选',
                    style: context.typo.body.copyWith(color: GoodsPageStyle.text),
                  ),
                  const Spacer(),
                  Text(
                    '合计：',
                    style: context.typo.caption.copyWith(color: GoodsPageStyle.sub),
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
                    selectedTotal.toStringAsFixed(2),
                    style: context.typo.price.copyWith(
                      color: GoodsPageStyle.accent,
                      fontSize: 22,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              if (selectedCount > 0) ...[
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '已选 $selectedCount 件',
                    style: context.typo.caption.copyWith(
                      color: GoodsPageStyle.sub,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: FilledButton(
                  onPressed: selectedCount == 0 ? null : onCheckout,
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
                  child: Text(checkoutLabel, style: context.typo.button),
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
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: GoodsPageStyle.pageMaxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: GoodsPageStyle.imageBg,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 44,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '购物车空空如也',
              style: context.typo.sectionTitle.copyWith(color: GoodsPageStyle.text),
            ),
            const SizedBox(height: 8),
            Text(
              '快去挑选心仪商品吧',
              style: context.typo.caption.copyWith(color: GoodsPageStyle.sub),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: GoodsPageStyle.accent,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('去逛逛'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartPanel extends StatelessWidget {
  const _CartPanel({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(14),
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
      child: child,
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
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
    return _CartPanel(
      padding: const EdgeInsets.fromLTRB(4, 12, 14, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: line.selected,
            activeColor: GoodsPageStyle.accent,
            onChanged: onToggle,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              line.coverAsset,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const _CoverFallback(),
            ),
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
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '¥',
                      style: TextStyle(
                        color: GoodsPageStyle.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      line.price.toStringAsFixed(2),
                      style: context.typo.price.copyWith(
                        color: GoodsPageStyle.accent,
                        fontSize: 20,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    _QtyStepper(
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
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: GoodsPageStyle.sub,
                    ),
                    label: Text(
                      '删除',
                      style: context.typo.caption.copyWith(
                        color: GoodsPageStyle.sub,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(top: 4),
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

class _CoverFallback extends StatelessWidget {
  const _CoverFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: GoodsPageStyle.imageBg,
      child: Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          size: 32,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
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
        border: Border.all(color: GoodsPageStyle.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: qty > 1 ? onDec : null,
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Icon(Icons.remove, size: 16, color: GoodsPageStyle.text),
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 32),
            alignment: Alignment.center,
            child: Text(
              '$qty',
              style: context.typo.bodyStrong.copyWith(color: GoodsPageStyle.text),
            ),
          ),
          InkWell(
            onTap: onInc,
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(8)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Icon(Icons.add, size: 16, color: GoodsPageStyle.text),
            ),
          ),
        ],
      ),
    );
  }
}

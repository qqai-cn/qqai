import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../my/data/models/member_address_models.dart';
import '../../my/data/repos/member_address_repo.dart';
import '../theme/goods_page_style.dart';

Future<MemberAddress?> showCheckoutAddressPickerSheet(
  BuildContext context,
  WidgetRef ref, {
  MemberAddress? selected,
}) {
  return showModalBottomSheet<MemberAddress>(
    context: context,
    isScrollControlled: true,
    backgroundColor: GoodsPageStyle.cardBg(context),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _CheckoutAddressPickerSheet(selected: selected),
  );
}

class _CheckoutAddressPickerSheet extends ConsumerStatefulWidget {
  const _CheckoutAddressPickerSheet({this.selected});

  final MemberAddress? selected;

  @override
  ConsumerState<_CheckoutAddressPickerSheet> createState() =>
      _CheckoutAddressPickerSheetState();
}

class _CheckoutAddressPickerSheetState
    extends ConsumerState<_CheckoutAddressPickerSheet> {
  final _addresses = <MemberAddress>[];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await ref.read(memberAddressRepoProvider).getList();
      if (!mounted) return;
      setState(() {
        _addresses
          ..clear()
          ..addAll(list);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.65;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: GoodsPageStyle.border(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '选择收货地址',
                      style: context.typo.sectionTitle.copyWith(
                        color: GoodsPageStyle.text(context),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: GoodsPageStyle.sub(context)),
                  ),
                ],
              ),
            ),
            Flexible(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: GoodsPageStyle.sub(context)),
            const SizedBox(height: 12),
            Text(
              '地址加载失败',
              style: context.typo.bodyStrong.copyWith(color: GoodsPageStyle.text(context)),
            ),
            const SizedBox(height: 6),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: context.typo.caption.copyWith(color: GoodsPageStyle.sub(context)),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: _load, child: const Text('重试')),
          ],
        ),
      );
    }
    if (_addresses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 40,
              color: GoodsPageStyle.sub(context),
            ),
            const SizedBox(height: 12),
            Text(
              '还没有保存的地址',
              style: context.typo.bodyStrong.copyWith(color: GoodsPageStyle.text(context)),
            ),
            const SizedBox(height: 6),
            Text(
              '请先在「我的地址」中添加，或手动填写下方收货信息',
              textAlign: TextAlign.center,
              style: context.typo.caption.copyWith(color: GoodsPageStyle.sub(context)),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
      itemCount: _addresses.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final address = _addresses[index];
        final isSelected = widget.selected?.id != null &&
            widget.selected!.id == address.id;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pop(context, address),
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              decoration: BoxDecoration(
                color: isSelected
                    ? GoodsPageStyle.accent.withValues(alpha: 0.06)
                    : GoodsPageStyle.pageBg(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? GoodsPageStyle.accent
                      : GoodsPageStyle.border(context),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                address.name ?? '收货人',
                                style: context.typo.bodyStrong.copyWith(
                                  color: GoodsPageStyle.text(context),
                                ),
                              ),
                              Text(
                                address.mobile ?? '',
                                style: context.typo.body.copyWith(
                                  color: GoodsPageStyle.text(context),
                                ),
                              ),
                              if (address.defaultStatus)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: GoodsPageStyle.accent
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '默认',
                                    style: context.typo.caption.copyWith(
                                      color: GoodsPageStyle.accent,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            address.fullAddress,
                            style: context.typo.caption.copyWith(
                              color: GoodsPageStyle.sub(context),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? GoodsPageStyle.accent
                          : GoodsPageStyle.border(context),
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

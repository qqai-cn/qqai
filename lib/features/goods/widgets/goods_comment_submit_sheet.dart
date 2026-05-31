import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/goods_comments.dart';

Future<void> showGoodsCommentSubmitSheet(
  BuildContext context,
  WidgetRef ref, {
  required String goodsId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: _GoodsCommentSubmitSheet(goodsId: goodsId),
    ),
  );
}

class _GoodsCommentSubmitSheet extends ConsumerStatefulWidget {
  const _GoodsCommentSubmitSheet({required this.goodsId});

  final String goodsId;

  @override
  ConsumerState<_GoodsCommentSubmitSheet> createState() =>
      _GoodsCommentSubmitSheetState();
}

class _GoodsCommentSubmitSheetState
    extends ConsumerState<_GoodsCommentSubmitSheet> {
  final _contentController = TextEditingController();
  int _stars = 5;
  bool _anonymous = false;
  bool _submitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    final error = await ref
        .read(goodsCommentsProvider(widget.goodsId).notifier)
        .submitComment(
          stars: _stars,
          content: _contentController.text,
          anonymous: _anonymous,
        );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('评价已提交，感谢您的反馈')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pending =
        ref.watch(pendingGoodsCommentOrderItemProvider(widget.goodsId));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '发表评价',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            pending.when(
              data: (item) {
                if (item == null) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      '购买并完成订单后可评价该商品',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    '订单商品：${item.spuName ?? '商品'}'
                    '${item.skuLabel != null ? ' · ${item.skuLabel}' : ''}',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                    ),
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: LinearProgressIndicator(minHeight: 2),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const Text(
              '商品满意度',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) {
                final n = i + 1;
                final selected = n <= _stars;
                return IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => setState(() => _stars = n),
                  icon: Icon(
                    selected ? Icons.star_rounded : Icons.star_border_rounded,
                    color: selected
                        ? const Color(0xFFFF9A14)
                        : const Color(0xFFE0E0E0),
                    size: 28,
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '说说商品使用感受，帮助其他买家参考～',
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('匿名评价'),
              value: _anonymous,
              onChanged: (v) => setState(() => _anonymous = v),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE6462D),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('提交评价'),
            ),
          ],
        ),
      ),
    );
  }
}

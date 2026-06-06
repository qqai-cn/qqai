import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../models/goods_comment_item.dart';
import '../providers/goods_comments.dart';
import '../theme/goods_page_style.dart';
import '../theme/jd_goods_theme.dart';
import 'goods_comment_submit_sheet.dart';

/// 商品详情页：评价（京东风格）
class GoodsCommentsSection extends ConsumerWidget {
  const GoodsCommentsSection({super.key, required this.goodsId});

  final String goodsId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsync = ref.watch(goodsCommentsProvider(goodsId));

    return commentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          children: [
            Text(error.toString(), style: context.typo.caption),
            TextButton(
              onPressed: () => ref.invalidate(goodsCommentsProvider(goodsId)),
              child: const Text('重试'),
            ),
          ],
        ),
      ),
      data: (state) => _GoodsCommentsBody(
        goodsId: goodsId,
        state: state,
      ),
    );
  }
}

class _GoodsCommentsBody extends ConsumerStatefulWidget {
  const _GoodsCommentsBody({required this.goodsId, required this.state});

  final String goodsId;
  final GoodsCommentsState state;

  @override
  ConsumerState<_GoodsCommentsBody> createState() => _GoodsCommentsBodyState();
}

class _GoodsCommentsBodyState extends ConsumerState<_GoodsCommentsBody> {
  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final d = now.difference(t);
    if (d.inDays >= 7) {
      return '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
    }
    if (d.inDays >= 1) return '${d.inDays}天前';
    if (d.inHours >= 1) return '${d.inHours}小时前';
    if (d.inMinutes >= 1) return '${d.inMinutes}分钟前';
    return '刚刚';
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.state.items;
    final pageBg = GoodsPageStyle.pageBg(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: pageBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
            child: Row(
              children: [
                Text(
                  '评价',
                  style: context.typo.sectionTitle.copyWith(
                    color: GoodsPageStyle.text(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '${widget.state.total}条',
                  style: context.typo.caption.copyWith(
                    color: GoodsPageStyle.sub(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '好评度 ',
                  style: context.typo.caption.copyWith(
                    color: GoodsPageStyle.sub(context),
                  ),
                ),
                Text(
                  widget.state.goodRateLabel,
                  style: context.typo.caption.copyWith(
                    color: JdGoodsTheme.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                decoration: BoxDecoration(
                  color: GoodsPageStyle.cardBg(context),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    '暂无评价，购买后发表第一条吧～',
                    style: context.typo.body.copyWith(
                      color: GoodsPageStyle.sub(context),
                    ),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length > 3 ? 3 : items.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  return _JdCommentCard(
                    item: items[index],
                    timeLabel: _formatTime(items[index].createdAt),
                  );
                },
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 14.h),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => showGoodsCommentSubmitSheet(
                  context,
                  ref,
                  goodsId: widget.goodsId,
                ),
                child: const Text('发表评价'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 单条评价卡片（京东样式）
class _JdCommentCard extends StatelessWidget {
  const _JdCommentCard({
    required this.item,
    required this.timeLabel,
  });

  final GoodsCommentItem item;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBg = theme.brightness == Brightness.dark
        ? theme.colorScheme.surface
        : Colors.white;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE8E8E8),
                child: Text(
                  item.author.isNotEmpty ? item.author[0] : '?',
                  style: context.typo.caption.copyWith(
                    color: JdGoodsTheme.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.typo.caption.copyWith(
                              color: JdGoodsTheme.sub,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          timeLabel,
                          style: context.typo.caption.copyWith(
                            color: JdGoodsTheme.sub,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _StarRow(stars: item.stars, size: 14),
                    if (item.skuLabel != null && item.skuLabel!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        item.skuLabel!,
                        style: context.typo.caption.copyWith(
                          color: JdGoodsTheme.sub,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            item.content,
            style: context.typo.body.copyWith(color: JdGoodsTheme.text),
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.stars, this.size = 14});

  final int stars;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < stars;
        return Padding(
          padding: EdgeInsets.only(right: i < 4 ? 2.w : 0),
          child: Icon(
            filled ? Icons.star_rounded : Icons.star_border_rounded,
            size: size,
            color: filled ? const Color(0xFFFF9A14) : const Color(0xFFE0E0E0),
          ),
        );
      }),
    );
  }
}

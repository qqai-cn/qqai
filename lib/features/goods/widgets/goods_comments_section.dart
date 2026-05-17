import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../models/goods_comment_item.dart';
import '../providers/goods_comments.dart';
import '../theme/jd_goods_theme.dart';

/// 商品详情页：评价（京东风格）
class GoodsCommentsSection extends ConsumerStatefulWidget {
  const GoodsCommentsSection({super.key, required this.goodsId});

  final String goodsId;

  @override
  ConsumerState<GoodsCommentsSection> createState() =>
      _GoodsCommentsSectionState();
}

class _GoodsCommentsSectionState extends ConsumerState<GoodsCommentsSection> {
  final _authorController = TextEditingController(text: 'j***新用户');
  final _contentController = TextEditingController();
  int _draftStars = 5;

  @override
  void dispose() {
    _authorController.dispose();
    _contentController.dispose();
    super.dispose();
  }

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

  /// 模拟好评度（与列表星级均值接近）
  String _goodRateLabel(List<GoodsCommentItem> items) {
    if (items.isEmpty) return '—';
    final avg = items.fold<double>(0, (a, e) => a + e.stars) / items.length;
    final pct = (avg / 5.0 * 100).clamp(0, 100).round();
    return '$pct%';
  }

  void _submit() {
    final notifier = ref.read(
      goodsCommentsProvider(widget.goodsId).notifier,
    );
    notifier.add(
      _authorController.text,
      _contentController.text,
      stars: _draftStars,
    );
    _contentController.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('评价已提交，感谢您的反馈'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = ref.watch(goodsCommentsProvider(widget.goodsId));
    final isDark = theme.brightness == Brightness.dark;
    final pageBg = isDark ? theme.colorScheme.surfaceContainerHighest : JdGoodsTheme.pageBg;

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
          // 头部：评价 + 好评度 + 条数
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
            child: Row(
              children: [
                Text(
                  '评价',
                  style: context.typo.sectionTitle.copyWith(
                    color: JdGoodsTheme.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '${items.length}条',
                  style: context.typo.caption.copyWith(
                    color: JdGoodsTheme.sub,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '好评度 ',
                  style: context.typo.caption.copyWith(color: JdGoodsTheme.sub),
                ),
                Text(
                  _goodRateLabel(items),
                  style: context.typo.caption.copyWith(
                    color: JdGoodsTheme.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(Icons.chevron_right, size: 16, color: JdGoodsTheme.sub),
              ],
            ),
          ),
          // 评价列表（白卡片）
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                decoration: BoxDecoration(
                  color: isDark ? theme.colorScheme.surface : Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    '暂无评价，购买后发表第一条吧～',
                    style: context.typo.body.copyWith(color: JdGoodsTheme.sub),
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
                itemCount: items.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  return _JdCommentCard(
                    item: items[index],
                    timeLabel: _formatTime(items[index].createdAt),
                  );
                },
              ),
            ),
          SizedBox(height: 10.h),
          // 发表评价
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 14.h),
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: isDark ? theme.colorScheme.surface : Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '发表评价',
                    style: context.typo.sectionTitle.copyWith(
                      color: JdGoodsTheme.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    '商品满意度',
                    style: context.typo.caption.copyWith(color: JdGoodsTheme.sub),
                  ),
                  SizedBox(height: 6.h),
                  _StarRatingInput(
                    value: _draftStars,
                    onChanged: (v) => setState(() => _draftStars = v),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _authorController,
                    style: context.typo.body.copyWith(color: JdGoodsTheme.text),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: const Color(0xFFF7F7F7),
                      hintText: '昵称（展示为 j***x 样式也可）',
                      hintStyle: context.typo.caption.copyWith(
                        color: JdGoodsTheme.sub,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: _contentController,
                    maxLines: 4,
                    style: context.typo.body.copyWith(
                      color: JdGoodsTheme.text,
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF7F7F7),
                      hintText: '宝贝满足你的期待吗？说说你的使用心得，给大家参考吧～',
                      hintStyle: context.typo.caption.copyWith(
                        color: JdGoodsTheme.sub,
                      ),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(12.w),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: JdGoodsTheme.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: Size(double.infinity, 50.h),
                        padding: EdgeInsets.symmetric(
                          vertical: 14.h,
                          horizontal: 20.w,
                        ),
                        tapTargetSize: MaterialTapTargetSize.padded,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Text(
                        '发表评价',
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        style: context.typo.button,
                      ),
                    ),
                  ),
                ],
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
                        if (item.isPlusMember) ...[
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF333333), Color(0xFF666666)],
                              ),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                            child: Text(
                              'PLUS',
                              style: context.typo.caption.copyWith(
                                fontSize: 10,
                                color: const Color(0xFFFFD700),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
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
          SizedBox(height: 10.h),
          Row(
            children: [
              _GhostAction(
                icon: Icons.thumb_up_outlined,
                label: '有用(${item.helpfulCount})',
              ),
              SizedBox(width: 20.w),
              _GhostAction(
                icon: Icons.chat_bubble_outline,
                label: '回复',
              ),
            ],
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

class _StarRatingInput extends StatelessWidget {
  const _StarRatingInput({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final n = i + 1;
        final selected = n <= value;
        return GestureDetector(
          onTap: () => onChanged(n),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Icon(
              selected ? Icons.star_rounded : Icons.star_border_rounded,
              size: 22,
              color: selected ? const Color(0xFFFF9A14) : const Color(0xFFE0E0E0),
            ),
          ),
        );
      }),
    );
  }
}

class _GhostAction extends StatelessWidget {
  const _GhostAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(4.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: JdGoodsTheme.sub),
            const SizedBox(width: 4),
            Text(
              label,
              style: context.typo.caption.copyWith(color: JdGoodsTheme.sub),
            ),
          ],
        ),
      ),
    );
  }
}

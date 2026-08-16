// 足迹 / 日常等内容的时间线分组：近 30 天按天，更早按自然月。
import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';

class FootprintTimelineSection<T> {
  const FootprintTimelineSection({required this.title, required this.items});

  final String title;
  final List<T> items;
}

List<FootprintTimelineSection<T>> groupFootprintByTimeline<T>({
  required List<T> items,
  required DateTime? Function(T item) readTime,
  DateTime? clock,
}) {
  if (items.isEmpty) return const [];

  final now = (clock ?? DateTime.now()).toLocal();
  final todayStart = DateTime(now.year, now.month, now.day);
  final cutoff = todayStart.subtract(const Duration(days: 30));

  final dayGroups = <DateTime, List<T>>{};
  final monthGroups = <DateTime, List<T>>{};
  final unknown = <T>[];

  for (final item in items) {
    final time = readTime(item)?.toLocal();
    if (time == null) {
      unknown.add(item);
      continue;
    }
    final dayStart = DateTime(time.year, time.month, time.day);
    if (!dayStart.isBefore(cutoff)) {
      dayGroups.putIfAbsent(dayStart, () => []).add(item);
    } else {
      final monthStart = DateTime(time.year, time.month);
      monthGroups.putIfAbsent(monthStart, () => []).add(item);
    }
  }

  final sections = <FootprintTimelineSection<T>>[];

  final sortedDays = dayGroups.keys.toList()..sort((a, b) => b.compareTo(a));
  for (final day in sortedDays) {
    sections.add(
      FootprintTimelineSection(
        title: formatFootprintDayTitle(day, todayStart),
        items: dayGroups[day]!,
      ),
    );
  }

  final sortedMonths = monthGroups.keys.toList()
    ..sort((a, b) => b.compareTo(a));
  for (final month in sortedMonths) {
    sections.add(
      FootprintTimelineSection(
        title: formatFootprintMonthTitle(month),
        items: monthGroups[month]!,
      ),
    );
  }

  if (unknown.isNotEmpty) {
    sections.add(FootprintTimelineSection(title: '更早', items: unknown));
  }

  return sections;
}

String formatFootprintDayTitle(DateTime dayStart, DateTime todayStart) {
  final dayDiff = todayStart.difference(dayStart).inDays;
  if (dayDiff == 0) return '今天';
  if (dayDiff == 1) return '昨天';
  if (dayStart.year == todayStart.year) {
    return '${dayStart.month}月${dayStart.day}日';
  }
  return '${dayStart.year}年${dayStart.month}月${dayStart.day}日';
}

String formatFootprintMonthTitle(DateTime monthStart) {
  return '${monthStart.year}年${monthStart.month}月';
}

DateTime? parseContentCreateTime(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  return DateTime.tryParse(raw.trim());
}

class ContentTimelineSectionHeader extends StatelessWidget {
  const ContentTimelineSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: context.typo.bodyStrong.copyWith(
          fontSize: 16,
          color: AppActionColors.strong(context),
        ),
      ),
    );
  }
}

class ContentTimelineSectionFrame extends StatelessWidget {
  static const EdgeInsets defaultPadding = EdgeInsets.fromLTRB(16, 10, 16, 10);

  const ContentTimelineSectionFrame({
    super.key,
    required this.title,
    required this.child,
    this.padding = defaultPadding,
    this.labelWidth = 88,
    this.titleGap = 10,
    this.railInset = 18,
  });

  final String title;
  final Widget child;
  final EdgeInsets padding;
  final double labelWidth;
  final double titleGap;
  final double railInset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppActionColors.strong(context),
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(width: titleGap),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  left: railInset,
                  top: 4,
                  bottom: 8,
                  child: Container(
                    width: 1,
                    color: AppActionColors.borderSubtle(context),
                  ),
                ),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContentTimelineRecordTile extends StatelessWidget {
  const ContentTimelineRecordTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.positive,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final color = positive ? const Color(0xFF109B8F) : const Color(0xFFE45C3A);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppActionColors.surface(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.36)),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: AppActionColors.borderSubtle(context),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppActionColors.borderSubtle(context)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppActionColors.strong(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppActionColors.muted(context),
                            fontSize: 12,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    trailing,
                    style: TextStyle(color: color, fontWeight: FontWeight.w900),
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

class ContentTimelineLoadMoreFooter extends StatefulWidget {
  const ContentTimelineLoadMoreFooter({
    super.key,
    required this.loading,
    required this.onLoadMore,
  });

  final bool loading;
  final VoidCallback onLoadMore;

  @override
  State<ContentTimelineLoadMoreFooter> createState() =>
      _ContentTimelineLoadMoreFooterState();
}

class _ContentTimelineLoadMoreFooterState
    extends State<ContentTimelineLoadMoreFooter> {
  @override
  void initState() {
    super.initState();
    if (!widget.loading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onLoadMore();
      });
    }
  }

  @override
  void didUpdateWidget(covariant ContentTimelineLoadMoreFooter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.loading && oldWidget.loading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onLoadMore();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: widget.loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

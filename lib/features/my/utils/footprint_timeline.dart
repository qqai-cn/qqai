// 足迹 / 日常等内容的时间线分组：近 30 天按天，更早按自然月。
import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';

class FootprintTimelineSection<T> {
  const FootprintTimelineSection({
    required this.title,
    required this.items,
  });

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

  final sortedMonths = monthGroups.keys.toList()..sort((a, b) => b.compareTo(a));
  for (final month in sortedMonths) {
    sections.add(
      FootprintTimelineSection(
        title: formatFootprintMonthTitle(month),
        items: monthGroups[month]!,
      ),
    );
  }

  if (unknown.isNotEmpty) {
    sections.add(
      FootprintTimelineSection(title: '更早', items: unknown),
    );
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
          color: Colors.black87,
        ),
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

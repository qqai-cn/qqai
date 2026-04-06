import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/watch_history_provider.dart';
import '../theme/douyin_theme.dart';

/// 观看历史（本地持久化）
class DouyinWatchHistoryPage extends ConsumerWidget {
  const DouyinWatchHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(watchHistoryProvider);
    final notifier = ref.read(watchHistoryProvider.notifier);

    return Scaffold(
      backgroundColor: DouyinTheme.bg,
      appBar: AppBar(
        backgroundColor: DouyinTheme.bg,
        foregroundColor: DouyinTheme.text,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          '观看历史',
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    backgroundColor: DouyinTheme.card,
                    title: Text('清空观看历史', style: TextStyle(color: DouyinTheme.text)),
                    content: Text(
                      '确定清空全部记录？',
                      style: TextStyle(color: DouyinTheme.sub),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: Text('取消', style: TextStyle(color: DouyinTheme.sub)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: Text('清空', style: TextStyle(color: DouyinTheme.accent)),
                      ),
                    ],
                  ),
                );
                if (ok == true && context.mounted) await notifier.clear();
              },
              child: Text('清空', style: TextStyle(color: DouyinTheme.accent, fontSize: 14.sp)),
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 56.sp, color: DouyinTheme.sub),
                  SizedBox(height: 12.h),
                  Text(
                    '暂无观看记录',
                    style: TextStyle(color: DouyinTheme.text, fontSize: 15.sp),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '刷视频时会自动记录（可接入播放页埋点）',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: DouyinTheme.sub, fontSize: 12.sp),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: items.length,
              separatorBuilder: (context, index) => SizedBox(height: 10.h),
              itemBuilder: (context, i) {
                final e = items[i];
                return Dismissible(
                  key: ValueKey(e.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.w),
                    color: DouyinTheme.accent,
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  onDismissed: (_) => notifier.remove(e.id),
                  child: Material(
                    color: DouyinTheme.card,
                    borderRadius: BorderRadius.circular(12.r),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10.w),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: e.coverUrl.isEmpty
                            ? Container(
                                width: 56.w,
                                height: 56.w,
                                color: DouyinTheme.chip,
                                child: Icon(Icons.play_circle_outline,
                                    color: DouyinTheme.sub),
                              )
                            : Image.network(
                                e.coverUrl,
                                width: 56.w,
                                height: 56.w,
                                fit: BoxFit.cover,
                              ),
                      ),
                      title: Text(
                        e.title.isEmpty ? '未命名视频' : e.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: DouyinTheme.text, fontSize: 14.sp),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          _format(e.watchedAt),
                          style: TextStyle(color: DouyinTheme.sub, fontSize: 12.sp),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _format(DateTime d) {
    final now = DateTime.now();
    final sameDay =
        d.year == now.year && d.month == now.month && d.day == now.day;
    if (sameDay) return '今天 ${_two(d.hour)}:${_two(d.minute)}';
    return '${d.year}-${_two(d.month)}-${_two(d.day)} ${_two(d.hour)}:${_two(d.minute)}';
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}

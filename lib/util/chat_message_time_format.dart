import 'package:intl/intl.dart';

const _weekdayLabels = [
  '星期一',
  '星期二',
  '星期三',
  '星期四',
  '星期五',
  '星期六',
  '星期日',
];

/// 聊天消息气泡时间展示规则（相对「今天」的本地日历日）：
/// - 当天 → `HH:mm`
/// - 昨天 → `昨天 HH:mm`
/// - 7 天内（不含当天、昨天）→ `星期 HH:mm`
/// - 当年更早 → `M月d日 HH:mm`
/// - 更早年份 → `yyyy年M月d日 HH:mm`
String formatChatMessageTime(DateTime time, {DateTime? clock}) {
  final now = (clock ?? DateTime.now()).toLocal();
  final t = time.toLocal();

  final todayStart = DateTime(now.year, now.month, now.day);
  final msgDayStart = DateTime(t.year, t.month, t.day);
  final dayDiff = todayStart.difference(msgDayStart).inDays;

  final h = t.hour.toString().padLeft(2, '0');
  final min = t.minute.toString().padLeft(2, '0');
  final hm = '$h:$min';

  if (dayDiff == 0) {
    return hm;
  }
  if (dayDiff == 1) {
    return '昨天 $hm';
  }
  if (dayDiff >= 2 && dayDiff < 7) {
    return '${_weekdayLabels[t.weekday - 1]} $hm';
  }
  if (t.year == now.year) {
    return '${t.month}月${t.day}日 $hm';
  }
  return '${t.year}年${t.month}月${t.day}日 $hm';
}

/// 供 [flutter_chat_ui] / Flyer Chat 消息组件通过 Provider 使用的动态时间格式。
class ChatMessageTimeFormat extends DateFormat {
  ChatMessageTimeFormat({DateTime? clock}) : _clock = clock, super('HH:mm');

  final DateTime? _clock;

  @override
  String format(DateTime date) =>
      formatChatMessageTime(date, clock: _clock);
}

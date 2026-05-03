/// 会话列表右侧时间展示规则（相对「今天」的本地日历日）：
/// - 当天 → `H:mm`
/// - 昨天 → `昨天 H:mm`
/// - 当年更早 → `M月d日`
/// - 更早年份 → `yyyy年M月d日`
String formatConversationListTime(String? raw, {DateTime? clock}) {
  if (raw == null || raw.trim().isEmpty) return '';
  final parsed = DateTime.tryParse(raw.trim());
  if (parsed == null) return raw;

  final now = (clock ?? DateTime.now()).toLocal();
  final t = parsed.toLocal();

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
  if (t.year == now.year) {
    return '${t.month}月${t.day}日';
  }
  return '${t.year}年${t.month}月${t.day}日';
}

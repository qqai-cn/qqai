import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/my_shared_pref.dart';
import '../models/watch_history_item.dart';

part 'watch_history_provider.g.dart';

@riverpod
class WatchHistory extends _$WatchHistory {
  @override
  List<WatchHistoryItem> build() => _read();

  List<WatchHistoryItem> _read() {
    final raw = MySharedPref.getWatchHistoryJson();
    try {
      final list = jsonDecode(raw) as List<dynamic>?;
      if (list == null) return [];
      return list
          .map(
            (e) => WatchHistoryItem.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> add(WatchHistoryItem item) async {
    final items = [...state];
    items.removeWhere((e) => e.id == item.id);
    items.insert(0, item);
    if (items.length > 50) items.removeRange(50, items.length);
    await _persist(items);
    state = items;
  }

  Future<void> clear() async {
    await _persist([]);
    state = [];
  }

  Future<void> remove(String id) async {
    final items = state.where((e) => e.id != id).toList();
    await _persist(items);
    state = items;
  }

  Future<void> _persist(List<WatchHistoryItem> items) async {
    final json = jsonEncode(items.map((e) => e.toJson()).toList());
    await MySharedPref.setWatchHistoryJson(json);
  }
}

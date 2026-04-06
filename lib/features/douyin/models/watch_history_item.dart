class WatchHistoryItem {
  const WatchHistoryItem({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.watchedAt,
  });

  final String id;
  final String title;
  final String coverUrl;
  final DateTime watchedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'coverUrl': coverUrl,
        'watchedAt': watchedAt.toIso8601String(),
      };

  factory WatchHistoryItem.fromJson(Map<String, dynamic> j) => WatchHistoryItem(
        id: j['id'] as String,
        title: j['title'] as String? ?? '',
        coverUrl: j['coverUrl'] as String? ?? '',
        watchedAt: DateTime.tryParse(j['watchedAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

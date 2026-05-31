class GoodsCommentItem {
  const GoodsCommentItem({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    this.stars = 5,
    this.skuLabel,
    this.helpfulCount = 0,
    this.isPlusMember = false,
    this.avatarUrl,
    this.picUrls = const [],
    this.replyContent,
  });

  final String id;
  final String author;
  final String content;
  final DateTime createdAt;

  /// 1–5 星
  final int stars;

  /// 如「规格：2kg×1瓶」
  final String? skuLabel;

  final int helpfulCount;

  /// 是否展示 PLUS 标（样式用）
  final bool isPlusMember;

  final String? avatarUrl;
  final List<String> picUrls;
  final String? replyContent;

  factory GoodsCommentItem.fromApiJson(Map<String, dynamic> json) {
    final anonymous = json['anonymous'] == true;
    final nickname = json['userNickname']?.toString().trim();
    final author = anonymous
        ? '匿名用户'
        : (nickname == null || nickname.isEmpty ? '买家' : nickname);

    final pics = (json['picUrls'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .toList();

    return GoodsCommentItem(
      id: '${json['id'] ?? json['orderItemId'] ?? ''}',
      author: author,
      content: json['content']?.toString() ?? '',
      createdAt: _parseDateTime(json['createTime']) ?? DateTime.now(),
      stars: ((json['scores'] as num?)?.toInt() ?? 5).clamp(1, 5),
      skuLabel: _skuLabelFromProperties(json['skuProperties']),
      avatarUrl: json['userAvatar']?.toString(),
      picUrls: pics,
      replyContent: json['replyContent']?.toString(),
    );
  }

  static String? _skuLabelFromProperties(dynamic raw) {
    if (raw is! List<dynamic> || raw.isEmpty) return null;
    final parts = raw
        .whereType<Map<String, dynamic>>()
        .map((e) => e['valueName']?.toString())
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return null;
    return '规格：${parts.join(' / ')}';
  }

  static DateTime? _parseDateTime(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
    return null;
  }
}

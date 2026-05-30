class BrowseHistoryItem {
  const BrowseHistoryItem({
    this.id,
    this.spuId,
    this.spuName,
    this.picUrl,
    this.price,
    this.salesCount,
    this.stock,
    this.createTime,
  });

  final int? id;
  final int? spuId;
  final String? spuName;
  final String? picUrl;
  final int? price;
  final int? salesCount;
  final int? stock;
  final DateTime? createTime;

  double get priceYuan => (price ?? 0) / 100.0;

  factory BrowseHistoryItem.fromJson(Map<String, dynamic> json) {
    return BrowseHistoryItem(
      id: (json['id'] as num?)?.toInt(),
      spuId: (json['spuId'] as num?)?.toInt(),
      spuName: json['spuName'] as String?,
      picUrl: json['picUrl'] as String?,
      price: (json['price'] as num?)?.toInt(),
      salesCount: (json['salesCount'] as num?)?.toInt(),
      stock: (json['stock'] as num?)?.toInt(),
      createTime: _parseDateTime(json['createTime']),
    );
  }
}

class BrowseHistoryPageData {
  const BrowseHistoryPageData({required this.list, required this.total});

  final List<BrowseHistoryItem> list;
  final int total;

  factory BrowseHistoryPageData.fromJson(Map<String, dynamic> json) {
    final raw = json['list'] as List<dynamic>? ?? const [];
    return BrowseHistoryPageData(
      total: (json['total'] as num?)?.toInt() ?? raw.length,
      list: raw
          .whereType<Map<String, dynamic>>()
          .map(BrowseHistoryItem.fromJson)
          .toList(),
    );
  }
}

class BlogBrowseHistoryItem {
  const BlogBrowseHistoryItem({
    this.id,
    this.blogId,
    this.blogType,
    this.title,
    this.content,
    this.coverUrl,
    this.creatorName,
    this.zan,
    this.createTime,
  });

  final int? id;
  final int? blogId;
  final int? blogType;
  final String? title;
  final String? content;
  final String? coverUrl;
  final String? creatorName;
  final int? zan;
  final DateTime? createTime;

  String get displayTitle {
    final t = title?.trim();
    if (t != null && t.isNotEmpty) return t;
    final c = content?.trim();
    if (c != null && c.isNotEmpty) return c;
    return creatorName ?? '博客';
  }

  factory BlogBrowseHistoryItem.fromJson(Map<String, dynamic> json) {
    return BlogBrowseHistoryItem(
      id: (json['id'] as num?)?.toInt(),
      blogId: (json['blogId'] as num?)?.toInt(),
      blogType: (json['blogType'] as num?)?.toInt(),
      title: json['title'] as String?,
      content: json['content'] as String?,
      coverUrl: json['coverUrl'] as String?,
      creatorName: json['creatorName'] as String?,
      zan: (json['zan'] as num?)?.toInt(),
      createTime: _parseDateTime(json['createTime']),
    );
  }
}

class BlogBrowseHistoryPageData {
  const BlogBrowseHistoryPageData({required this.list, required this.total});

  final List<BlogBrowseHistoryItem> list;
  final int total;

  factory BlogBrowseHistoryPageData.fromJson(Map<String, dynamic> json) {
    final raw = json['list'] as List<dynamic>? ?? const [];
    return BlogBrowseHistoryPageData(
      total: (json['total'] as num?)?.toInt() ?? raw.length,
      list: raw
          .whereType<Map<String, dynamic>>()
          .map(BlogBrowseHistoryItem.fromJson)
          .toList(),
    );
  }
}

class TradeCartItem {
  const TradeCartItem({
    this.id,
    this.count,
    this.selected,
    this.spuId,
    this.spuName,
    this.spuPicUrl,
    this.skuId,
    this.skuPicUrl,
    this.skuPrice,
    this.skuStock,
    this.skuLabel,
  });

  final int? id;
  final int? count;
  final bool? selected;
  final int? spuId;
  final String? spuName;
  final String? spuPicUrl;
  final int? skuId;
  final String? skuPicUrl;
  final int? skuPrice;
  final int? skuStock;
  final String? skuLabel;

  double get priceYuan => (skuPrice ?? 0) / 100.0;

  String get coverUrl => skuPicUrl ?? spuPicUrl ?? '';

  String get title {
    final name = spuName ?? '商品';
    final spec = skuLabel?.trim();
    if (spec == null || spec.isEmpty) return name;
    return '$name · $spec';
  }

  factory TradeCartItem.fromJson(Map<String, dynamic> json) {
    final spu = json['spu'] as Map<String, dynamic>?;
    final sku = json['sku'] as Map<String, dynamic>?;
    return TradeCartItem(
      id: (json['id'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
      selected: json['selected'] as bool?,
      spuId: (spu?['id'] as num?)?.toInt(),
      spuName: spu?['name'] as String?,
      spuPicUrl: spu?['picUrl'] as String?,
      skuId: (sku?['id'] as num?)?.toInt(),
      skuPicUrl: sku?['picUrl'] as String?,
      skuPrice: (sku?['price'] as num?)?.toInt(),
      skuStock: (sku?['stock'] as num?)?.toInt(),
      skuLabel: _skuLabelFromProperties(sku?['properties']),
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
    return parts.join(' / ');
  }
}

class TradeCartListData {
  const TradeCartListData({
    this.validList = const [],
    this.invalidList = const [],
  });

  final List<TradeCartItem> validList;
  final List<TradeCartItem> invalidList;

  factory TradeCartListData.fromJson(Map<String, dynamic> json) {
    List<TradeCartItem> parseList(dynamic raw) {
      if (raw is! List<dynamic>) return const [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map(TradeCartItem.fromJson)
          .toList();
    }

    return TradeCartListData(
      validList: parseList(json['validList']),
      invalidList: parseList(json['invalidList']),
    );
  }
}

class TradeOrderItem {
  const TradeOrderItem({
    this.id,
    this.spuId,
    this.spuName,
    this.picUrl,
    this.count,
    this.payPrice,
  });

  final int? id;
  final int? spuId;
  final String? spuName;
  final String? picUrl;
  final int? count;
  final int? payPrice;

  double get payPriceYuan => (payPrice ?? 0) / 100.0;

  factory TradeOrderItem.fromJson(Map<String, dynamic> json) {
    return TradeOrderItem(
      id: (json['id'] as num?)?.toInt(),
      spuId: (json['spuId'] as num?)?.toInt(),
      spuName: json['spuName'] as String?,
      picUrl: json['picUrl'] as String?,
      count: (json['count'] as num?)?.toInt(),
      payPrice: (json['payPrice'] as num?)?.toInt(),
    );
  }
}

class TradeOrderSummary {
  const TradeOrderSummary({
    this.id,
    this.no,
    this.status,
    this.productCount,
    this.payPrice,
    this.createTime,
    this.items = const [],
  });

  final int? id;
  final String? no;
  final int? status;
  final int? productCount;
  final int? payPrice;
  final DateTime? createTime;
  final List<TradeOrderItem> items;

  double get payPriceYuan => (payPrice ?? 0) / 100.0;

  String get statusLabel => tradeOrderStatusLabel(status);

  factory TradeOrderSummary.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];
    return TradeOrderSummary(
      id: (json['id'] as num?)?.toInt(),
      no: json['no'] as String?,
      status: (json['status'] as num?)?.toInt(),
      productCount: (json['productCount'] as num?)?.toInt(),
      payPrice: (json['payPrice'] as num?)?.toInt(),
      createTime: _parseDateTime(json['createTime']),
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(TradeOrderItem.fromJson)
          .toList(),
    );
  }
}

class TradeOrderPageData {
  const TradeOrderPageData({required this.list, required this.total});

  final List<TradeOrderSummary> list;
  final int total;

  factory TradeOrderPageData.fromJson(Map<String, dynamic> json) {
    final raw = json['list'] as List<dynamic>? ?? const [];
    return TradeOrderPageData(
      total: (json['total'] as num?)?.toInt() ?? raw.length,
      list: raw
          .whereType<Map<String, dynamic>>()
          .map(TradeOrderSummary.fromJson)
          .toList(),
    );
  }
}

String tradeOrderStatusLabel(int? status) {
  return switch (status) {
    0 => '待付款',
    10 => '待发货',
    20 => '已发货',
    30 => '已完成',
    40 => '已取消',
    _ => '未知状态',
  };
}

DateTime? _parseDateTime(dynamic raw) {
  if (raw == null) return null;
  if (raw is DateTime) return raw;
  if (raw is String && raw.isNotEmpty) {
    return DateTime.tryParse(raw);
  }
  if (raw is int) {
    return DateTime.fromMillisecondsSinceEpoch(raw);
  }
  return null;
}

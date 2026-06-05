class MallProduct {
  const MallProduct({
    this.id,
    this.name,
    this.introduction,
    this.description,
    this.categoryId,
    this.serviceMemberUserId,
    this.picUrl,
    this.sliderPicUrls = const [],
    this.specType,
    this.price,
    this.marketPrice,
    this.stock,
    this.salesCount,
    this.status,
    this.deliveryTypes = const [],
    this.skus = const [],
  });

  final int? id;
  final String? name;
  final String? introduction;
  final String? description;
  final int? categoryId;
  final int? serviceMemberUserId;
  final String? picUrl;
  final List<String> sliderPicUrls;
  final bool? specType;
  final int? price;
  final int? marketPrice;
  final int? stock;
  final int? salesCount;
  final int? status;
  final List<int> deliveryTypes;
  final List<MallProductSku> skus;

  String? get coverUrl => picUrl;

  double get priceYuan => (price ?? 0) / 100.0;

  double get marketPriceYuan => (marketPrice ?? 0) / 100.0;

  factory MallProduct.fromJson(Map<String, dynamic> json) {
    return MallProduct(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      introduction: json['introduction'] as String?,
      description: json['description'] as String?,
      categoryId: (json['categoryId'] as num?)?.toInt(),
      serviceMemberUserId: (json['serviceMemberUserId'] as num?)?.toInt(),
      picUrl: json['picUrl'] as String?,
      sliderPicUrls: (json['sliderPicUrls'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      specType: json['specType'] as bool?,
      price: (json['price'] as num?)?.toInt(),
      marketPrice: (json['marketPrice'] as num?)?.toInt(),
      stock: (json['stock'] as num?)?.toInt(),
      salesCount: (json['salesCount'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      deliveryTypes: (json['deliveryTypes'] as List<dynamic>? ?? const [])
          .whereType<num>()
          .map((e) => e.toInt())
          .toList(),
      skus: (json['skus'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(MallProductSku.fromJson)
          .toList(),
    );
  }
}

class MallProductSku {
  const MallProductSku({
    this.id,
    this.properties = const [],
    this.price,
    this.marketPrice,
    this.vipPrice,
    this.picUrl,
    this.stock,
    this.weight,
    this.volume,
  });

  final int? id;
  final List<MallProductSkuProperty> properties;
  final int? price;
  final int? marketPrice;
  final int? vipPrice;
  final String? picUrl;
  final int? stock;
  final double? weight;
  final double? volume;

  String get label {
    if (properties.isEmpty) return '默认规格';
    return properties
        .map((e) => '${e.propertyName}:${e.valueName}')
        .join(' / ');
  }

  double get priceYuan => (price ?? 0) / 100.0;

  double get marketPriceYuan => (marketPrice ?? 0) / 100.0;

  factory MallProductSku.fromJson(Map<String, dynamic> json) {
    return MallProductSku(
      id: (json['id'] as num?)?.toInt(),
      properties: (json['properties'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(MallProductSkuProperty.fromJson)
          .toList(),
      price: (json['price'] as num?)?.toInt(),
      marketPrice: (json['marketPrice'] as num?)?.toInt(),
      vipPrice: (json['vipPrice'] as num?)?.toInt(),
      picUrl: json['picUrl'] as String?,
      stock: (json['stock'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      volume: (json['volume'] as num?)?.toDouble(),
    );
  }
}

class MallProductSkuProperty {
  const MallProductSkuProperty({
    this.propertyId,
    this.propertyName,
    this.valueId,
    this.valueName,
  });

  final int? propertyId;
  final String? propertyName;
  final int? valueId;
  final String? valueName;

  factory MallProductSkuProperty.fromJson(Map<String, dynamic> json) {
    return MallProductSkuProperty(
      propertyId: (json['propertyId'] as num?)?.toInt(),
      propertyName: json['propertyName'] as String?,
      valueId: (json['valueId'] as num?)?.toInt(),
      valueName: json['valueName'] as String?,
    );
  }
}

class MallProductPageData {
  const MallProductPageData({required this.list, required this.total});

  final List<MallProduct> list;
  final int total;

  factory MallProductPageData.fromJson(Map<String, dynamic> json) {
    final raw = json['list'] as List<dynamic>? ?? const [];
    return MallProductPageData(
      total: (json['total'] as num?)?.toInt() ?? raw.length,
      list: raw
          .whereType<Map<String, dynamic>>()
          .map(MallProduct.fromJson)
          .toList(),
    );
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'blog_page_model.freezed.dart';
part 'blog_page_model.g.dart';

class BlogItemCollection {
  const BlogItemCollection({
    this.id,
    this.name,
    this.coverUrl,
    this.intro,
    this.itemCount,
  });

  final int? id;
  final String? name;
  final String? coverUrl;
  final String? intro;
  final int? itemCount;

  factory BlogItemCollection.fromJson(Map<String, dynamic> json) {
    return BlogItemCollection(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      coverUrl: json['coverUrl'] as String?,
      intro: json['intro'] as String?,
      itemCount: (json['itemCount'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'coverUrl': coverUrl,
    'intro': intro,
    'itemCount': itemCount,
  };
}

class BlogItemShopProduct {
  const BlogItemShopProduct({
    this.id,
    this.shopId,
    this.name,
    this.coverUrl,
    this.price,
    this.externalUrl,
    this.sort,
    this.status,
  });

  final int? id;
  final int? shopId;
  final String? name;
  final String? coverUrl;

  /// 售价（分）
  final int? price;
  final String? externalUrl;
  final int? sort;
  final int? status;

  factory BlogItemShopProduct.fromJson(Map<String, dynamic> json) {
    return BlogItemShopProduct(
      id: (json['id'] as num?)?.toInt(),
      shopId: (json['shopId'] as num?)?.toInt(),
      name: json['name'] as String?,
      coverUrl: json['coverUrl'] as String?,
      price: (json['price'] as num?)?.toInt(),
      externalUrl: json['externalUrl'] as String?,
      sort: (json['sort'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'shopId': shopId,
    'name': name,
    'coverUrl': coverUrl,
    'price': price,
    'externalUrl': externalUrl,
    'sort': sort,
    'status': status,
  };
}

@freezed
sealed class BlogItem with _$BlogItem {
  const factory BlogItem({
    int? id,
    int? userId,
    int? squareId,
    String? topicIds,
    int? categary,
    int? blogType,
    String? title,
    String? content,
    String? resources,
    String? coverUrl,
    int? videoWidth,
    int? videoHeight,
    double? videoAspectRatio,
    String? backgroundMusicUrl,
    String? backgroundMusicName,
    int? soundMode,
    int? addressId,
    String? address,
    double? latitude,
    double? longitude,

    /// 与当前位置距离（千米，附近列表时有值）
    double? distance,
    int? shareType,

    /// 点赞数
    int? zan,

    /// 评论数（含回复）
    int? commentCount,

    /// 收藏数
    int? collectCount,

    /// 转发/分享数
    int? shareCount,

    /// 当前登录用户是否已关注作者：1 是，0 否
    int? care,

    /// 作者粉丝数
    int? followerCount,
    String? creator,
    String? creatorName,
    String? creatorAvatar,

    /// 作者等级（用于等级图标，一般 1–6）
    int? creatorLevel,
    String? creatorLevelName,
    String? updater,
    String? createTime,
    String? updateTime,

    /// 当前登录用户是否已点赞：1 是，0 否（若接口未返回则视为未赞）
    int? liked,

    /// 当前登录用户是否已收藏：1 是，0 否
    int? collect,

    /// 视频所属合集。后端可返回 collections/collectionList 等字段，解析层会归一到这里。
    List<BlogItemCollection>? collections,

    /// 挂载的店铺商品（团购带货）
    List<BlogItemShopProduct>? shopProducts,
  }) = _BlogItem;

  factory BlogItem.fromJson(Map<String, dynamic> json) =>
      _$BlogItemFromJson(json);
}

@freezed
sealed class BlogPageModelData with _$BlogPageModelData {
  const factory BlogPageModelData({List<BlogItem>? list, int? total}) =
      _BlogPageModelData;

  factory BlogPageModelData.fromJson(Map<String, dynamic> json) =>
      _$BlogPageModelDataFromJson(json);
}

@freezed
sealed class BlogPageModel with _$BlogPageModel {
  const factory BlogPageModel({
    int? code,
    BlogPageModelData? data,
    String? msg,
  }) = _BlogPageModel;

  factory BlogPageModel.fromJson(Map<String, dynamic> json) =>
      _$BlogPageModelFromJson(json);
}

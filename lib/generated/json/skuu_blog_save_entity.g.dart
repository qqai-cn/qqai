import 'package:qqai/generated/json/base/json_convert_content.dart';
import 'package:qqai/app/data/models/skuu_blog_save_entity.dart';

SkuuBlogSaveEntity $SkuuBlogSaveEntityFromJson(Map<String, dynamic> json) {
  final SkuuBlogSaveEntity skuuBlogSaveEntity = SkuuBlogSaveEntity();
  final int? addressId = jsonConvert.convert<int>(json['addressId']);
  if (addressId != null) {
    skuuBlogSaveEntity.addressId = addressId;
  }
  final int? blogType = jsonConvert.convert<int>(json['blogType']);
  if (blogType != null) {
    skuuBlogSaveEntity.blogType = blogType;
  }
  final int? categary = jsonConvert.convert<int>(json['categary']);
  if (categary != null) {
    skuuBlogSaveEntity.categary = categary;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    skuuBlogSaveEntity.content = content;
  }
  final String? resources = jsonConvert.convert<String>(json['resources']);
  if (resources != null) {
    skuuBlogSaveEntity.resources = resources;
  }
  final int? shareType = jsonConvert.convert<int>(json['shareType']);
  if (shareType != null) {
    skuuBlogSaveEntity.shareType = shareType;
  }
  final int? squareId = jsonConvert.convert<int>(json['squareId']);
  if (squareId != null) {
    skuuBlogSaveEntity.squareId = squareId;
  }
  final String? topicIds = jsonConvert.convert<String>(json['topicIds']);
  if (topicIds != null) {
    skuuBlogSaveEntity.topicIds = topicIds;
  }
  return skuuBlogSaveEntity;
}

Map<String, dynamic> $SkuuBlogSaveEntityToJson(SkuuBlogSaveEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['addressId'] = entity.addressId;
  data['blogType'] = entity.blogType;
  data['categary'] = entity.categary;
  data['content'] = entity.content;
  data['resources'] = entity.resources;
  data['shareType'] = entity.shareType;
  data['squareId'] = entity.squareId;
  data['topicIds'] = entity.topicIds;
  return data;
}

extension SkuuBlogSaveEntityExtension on SkuuBlogSaveEntity {
  SkuuBlogSaveEntity copyWith({
    int? addressId,
    int? blogType,
    int? categary,
    String? content,
    String? resources,
    int? shareType,
    int? squareId,
    String? topicIds,
  }) {
    return SkuuBlogSaveEntity()
      ..addressId = addressId ?? this.addressId
      ..blogType = blogType ?? this.blogType
      ..categary = categary ?? this.categary
      ..content = content ?? this.content
      ..resources = resources ?? this.resources
      ..shareType = shareType ?? this.shareType
      ..squareId = squareId ?? this.squareId
      ..topicIds = topicIds ?? this.topicIds;
  }
}
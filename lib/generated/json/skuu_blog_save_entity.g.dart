import 'package:qqai/generated/json/base/json_convert_content.dart';
import '../../../features/data/models/skuu_blog_save_entity.dart';

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
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    skuuBlogSaveEntity.title = title;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    skuuBlogSaveEntity.content = content;
  }
  final String? resources = jsonConvert.convert<String>(json['resources']);
  if (resources != null) {
    skuuBlogSaveEntity.resources = resources;
  }
  final String? backgroundMusicUrl = jsonConvert.convert<String>(
    json['backgroundMusicUrl'],
  );
  if (backgroundMusicUrl != null) {
    skuuBlogSaveEntity.backgroundMusicUrl = backgroundMusicUrl;
  }
  final String? backgroundMusicName = jsonConvert.convert<String>(
    json['backgroundMusicName'],
  );
  if (backgroundMusicName != null) {
    skuuBlogSaveEntity.backgroundMusicName = backgroundMusicName;
  }
  final int? soundMode = jsonConvert.convert<int>(json['soundMode']);
  if (soundMode != null) {
    skuuBlogSaveEntity.soundMode = soundMode;
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
  data['title'] = entity.title;
  data['content'] = entity.content;
  data['resources'] = entity.resources;
  data['backgroundMusicUrl'] = entity.backgroundMusicUrl;
  data['backgroundMusicName'] = entity.backgroundMusicName;
  data['soundMode'] = entity.soundMode;
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
    String? title,
    String? content,
    String? resources,
    String? backgroundMusicUrl,
    String? backgroundMusicName,
    int? soundMode,
    int? shareType,
    int? squareId,
    String? topicIds,
  }) {
    return SkuuBlogSaveEntity()
      ..addressId = addressId ?? this.addressId
      ..blogType = blogType ?? this.blogType
      ..categary = categary ?? this.categary
      ..title = title ?? this.title
      ..content = content ?? this.content
      ..resources = resources ?? this.resources
      ..backgroundMusicUrl = backgroundMusicUrl ?? this.backgroundMusicUrl
      ..backgroundMusicName = backgroundMusicName ?? this.backgroundMusicName
      ..soundMode = soundMode ?? this.soundMode
      ..shareType = shareType ?? this.shareType
      ..squareId = squareId ?? this.squareId
      ..topicIds = topicIds ?? this.topicIds;
  }
}

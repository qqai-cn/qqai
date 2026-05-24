// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_save_req_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlogSaveReqVO _$BlogSaveReqVOFromJson(Map<String, dynamic> json) =>
    _BlogSaveReqVO(
      id: (json['id'] as num?)?.toInt(),
      squareId: (json['squareId'] as num?)?.toInt(),
      topicIds: json['topicIds'] as String?,
      categary: (json['categary'] as num?)?.toInt(),
      blogType: (json['blogType'] as num?)?.toInt(),
      content: json['content'] as String?,
      resources: json['resources'] as String?,
      coverUrl: json['coverUrl'] as String?,
      addressId: (json['addressId'] as num?)?.toInt(),
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      shareType: (json['shareType'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BlogSaveReqVOToJson(_BlogSaveReqVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'squareId': instance.squareId,
      'topicIds': instance.topicIds,
      'categary': instance.categary,
      'blogType': instance.blogType,
      'content': instance.content,
      'resources': instance.resources,
      'coverUrl': instance.coverUrl,
      'addressId': instance.addressId,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'shareType': instance.shareType,
    };

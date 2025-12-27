// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview_img.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PreviewImg _$PreviewImgFromJson(Map<String, dynamic> json) => _PreviewImg(
  id: (json['id'] as num?)?.toInt(),
  url: json['url'] as String?,
  heroTag: json['heroTag'] as String?,
  index: (json['index'] as num?)?.toInt(),
  allUris:
      (json['allUris'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$PreviewImgToJson(_PreviewImg instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'heroTag': instance.heroTag,
      'index': instance.index,
      'allUris': instance.allUris,
    };

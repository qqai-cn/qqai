// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShareItem _$ShareItemFromJson(Map<String, dynamic> json) => _ShareItem(
  blogType: (json['blogType'] as num?)?.toInt(),
  care: (json['care'] as num?)?.toInt(),
  categary: (json['categary'] as num?)?.toInt(),
  content: json['content'] as String?,
  creatorName: json['creatorName'] as String?,
  id: (json['id'] as num?)?.toInt(),
  resources: json['resources'] as String?,
  shareType: (json['shareType'] as num?)?.toInt(),
  squareId: (json['squareId'] as num?)?.toInt(),
  topicIds: json['topicIds'] as String?,
  updateTime: json['updateTime'] as String?,
  zan: (json['zan'] as num?)?.toInt(),
);

Map<String, dynamic> _$ShareItemToJson(_ShareItem instance) =>
    <String, dynamic>{
      'blogType': instance.blogType,
      'care': instance.care,
      'categary': instance.categary,
      'content': instance.content,
      'creatorName': instance.creatorName,
      'id': instance.id,
      'resources': instance.resources,
      'shareType': instance.shareType,
      'squareId': instance.squareId,
      'topicIds': instance.topicIds,
      'updateTime': instance.updateTime,
      'zan': instance.zan,
    };

_SharePageModelData _$SharePageModelDataFromJson(Map<String, dynamic> json) =>
    _SharePageModelData(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => ShareItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SharePageModelDataToJson(_SharePageModelData instance) =>
    <String, dynamic>{'list': instance.list, 'total': instance.total};

_SharePageModel _$SharePageModelFromJson(Map<String, dynamic> json) =>
    _SharePageModel(
      code: (json['code'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : SharePageModelData.fromJson(json['data'] as Map<String, dynamic>),
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$SharePageModelToJson(_SharePageModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlogItem _$BlogItemFromJson(Map<String, dynamic> json) => _BlogItem(
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

Map<String, dynamic> _$BlogItemToJson(_BlogItem instance) => <String, dynamic>{
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

_BlogPageModelData _$BlogPageModelDataFromJson(Map<String, dynamic> json) =>
    _BlogPageModelData(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => BlogItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BlogPageModelDataToJson(_BlogPageModelData instance) =>
    <String, dynamic>{'list': instance.list, 'total': instance.total};

_BlogPageModel _$BlogPageModelFromJson(Map<String, dynamic> json) =>
    _BlogPageModel(
      code: (json['code'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : BlogPageModelData.fromJson(json['data'] as Map<String, dynamic>),
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$BlogPageModelToJson(_BlogPageModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
    };

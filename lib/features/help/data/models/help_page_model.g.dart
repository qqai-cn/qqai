// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HelpItem _$HelpItemFromJson(Map<String, dynamic> json) => _HelpItem(
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

Map<String, dynamic> _$HelpItemToJson(_HelpItem instance) => <String, dynamic>{
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

_HelpPageModelData _$HelpPageModelDataFromJson(Map<String, dynamic> json) =>
    _HelpPageModelData(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => HelpItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HelpPageModelDataToJson(_HelpPageModelData instance) =>
    <String, dynamic>{'list': instance.list, 'total': instance.total};

_HelpPageModel _$HelpPageModelFromJson(Map<String, dynamic> json) =>
    _HelpPageModel(
      code: (json['code'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : HelpPageModelData.fromJson(json['data'] as Map<String, dynamic>),
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$HelpPageModelToJson(_HelpPageModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
    };

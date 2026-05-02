// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SkuuTopicResVO _$SkuuTopicResVOFromJson(Map<String, dynamic> json) =>
    _SkuuTopicResVO(
      id: (json['id'] as num?)?.toInt(),
      topicName: json['topicName'] as String?,
      creator: json['creator'] as String?,
      updater: json['updater'] as String?,
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
    );

Map<String, dynamic> _$SkuuTopicResVOToJson(_SkuuTopicResVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topicName': instance.topicName,
      'creator': instance.creator,
      'updater': instance.updater,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };

_TopicPageResult _$TopicPageResultFromJson(Map<String, dynamic> json) =>
    _TopicPageResult(
      total: (json['total'] as num?)?.toInt(),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => SkuuTopicResVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TopicPageResultToJson(_TopicPageResult instance) =>
    <String, dynamic>{'total': instance.total, 'list': instance.list};

_TopicPageResponse _$TopicPageResponseFromJson(Map<String, dynamic> json) =>
    _TopicPageResponse(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      data: json['data'] == null
          ? null
          : TopicPageResult.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TopicPageResponseToJson(_TopicPageResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };

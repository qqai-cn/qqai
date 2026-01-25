// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShareModel _$ShareModelFromJson(Map<String, dynamic> json) => _ShareModel(
  id: json['id'] as String,
  title: json['title'] as String,
  isDone: json['isDone'] as bool? ?? false,
);

Map<String, dynamic> _$ShareModelToJson(_ShareModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isDone': instance.isDone,
    };

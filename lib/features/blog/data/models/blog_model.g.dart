// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlogModel _$BlogModelFromJson(Map<String, dynamic> json) => _BlogModel(
  id: json['id'] as String,
  title: json['title'] as String,
  isDone: json['isDone'] as bool? ?? false,
);

Map<String, dynamic> _$BlogModelToJson(_BlogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isDone': instance.isDone,
    };

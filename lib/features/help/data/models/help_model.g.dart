// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HelpModel _$HelpModelFromJson(Map<String, dynamic> json) => _HelpModel(
  id: json['id'] as String,
  title: json['title'] as String,
  isDone: json['isDone'] as bool? ?? false,
);

Map<String, dynamic> _$HelpModelToJson(_HelpModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isDone': instance.isDone,
    };

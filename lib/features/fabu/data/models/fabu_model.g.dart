// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fabu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FabuModel _$FabuModelFromJson(Map<String, dynamic> json) => _FabuModel(
  id: json['id'] as String,
  title: json['title'] as String,
  isDone: json['isDone'] as bool? ?? false,
);

Map<String, dynamic> _$FabuModelToJson(_FabuModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isDone': instance.isDone,
    };

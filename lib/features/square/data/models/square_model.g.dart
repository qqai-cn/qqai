// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'square_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SquareModel _$SquareModelFromJson(Map<String, dynamic> json) => _SquareModel(
  id: json['id'] as String,
  title: json['title'] as String,
  isDone: json['isDone'] as bool? ?? false,
);

Map<String, dynamic> _$SquareModelToJson(_SquareModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isDone': instance.isDone,
    };

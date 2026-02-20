// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyModel _$MyModelFromJson(Map<String, dynamic> json) => _MyModel(
  id: json['id'] as String,
  title: json['title'] as String,
  isDone: json['isDone'] as bool? ?? false,
);

Map<String, dynamic> _$MyModelToJson(_MyModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'isDone': instance.isDone,
};

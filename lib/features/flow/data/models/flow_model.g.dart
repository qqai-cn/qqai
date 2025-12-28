// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FlowModel _$FlowModelFromJson(Map<String, dynamic> json) => _FlowModel(
  id: json['id'] as String,
  title: json['title'] as String,
  isDone: json['isDone'] as bool? ?? false,
);

Map<String, dynamic> _$FlowModelToJson(_FlowModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isDone': instance.isDone,
    };

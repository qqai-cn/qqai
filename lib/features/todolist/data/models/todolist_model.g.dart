// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todolist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoListModel _$TodoListModelFromJson(Map<String, dynamic> json) =>
    _TodoListModel(
      id: json['id'] as String,
      title: json['title'] as String,
      isDone: json['isDone'] as bool? ?? false,
    );

Map<String, dynamic> _$TodoListModelToJson(_TodoListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isDone': instance.isDone,
    };

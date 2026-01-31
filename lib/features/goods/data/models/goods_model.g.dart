// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoodsModel _$GoodsModelFromJson(Map<String, dynamic> json) => _GoodsModel(
  id: json['id'] as String,
  title: json['title'] as String,
  isDone: json['isDone'] as bool? ?? false,
);

Map<String, dynamic> _$GoodsModelToJson(_GoodsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isDone': instance.isDone,
    };

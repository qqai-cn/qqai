// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'square_create_req_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SquareCreateReqVO _$SquareCreateReqVOFromJson(Map<String, dynamic> json) =>
    _SquareCreateReqVO(
      squareName: json['squareName'] as String,
      squareImg: json['squareImg'] as String?,
      squareDesc: json['squareDesc'] as String?,
    );

Map<String, dynamic> _$SquareCreateReqVOToJson(_SquareCreateReqVO instance) =>
    <String, dynamic>{
      'squareName': instance.squareName,
      'squareImg': instance.squareImg,
      'squareDesc': instance.squareDesc,
    };

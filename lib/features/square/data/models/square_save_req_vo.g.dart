// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'square_save_req_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SquareSaveReqVO _$SquareSaveReqVOFromJson(Map<String, dynamic> json) =>
    _SquareSaveReqVO(
      id: (json['id'] as num).toInt(),
      squareName: json['squareName'] as String,
      userId: (json['userId'] as num?)?.toInt(),
      squareImg: json['squareImg'] as String?,
      squareDesc: json['squareDesc'] as String?,
      chatConversationId: (json['chatConversationId'] as num?)?.toInt(),
      groupCreatorUserId: (json['groupCreatorUserId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SquareSaveReqVOToJson(_SquareSaveReqVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'squareName': instance.squareName,
      'userId': instance.userId,
      'squareImg': instance.squareImg,
      'squareDesc': instance.squareDesc,
      'chatConversationId': instance.chatConversationId,
      'groupCreatorUserId': instance.groupCreatorUserId,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'square_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SquareItem _$SquareItemFromJson(Map<String, dynamic> json) => _SquareItem(
  id: (json['id'] as num?)?.toInt(),
  squareName: json['squareName'] as String?,
  userId: (json['userId'] as num?)?.toInt(),
  userAvatar: json['userAvatar'] as String?,
  squareImg: json['squareImg'] as String?,
  squareDesc: json['squareDesc'] as String?,
  chatConversationId: (json['chatConversationId'] as num?)?.toInt(),
  hasChatConversation: json['hasChatConversation'] as bool?,
  blogCount: (json['blogCount'] as num?)?.toInt(),
  createTime: json['createTime'] as String?,
);

Map<String, dynamic> _$SquareItemToJson(_SquareItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'squareName': instance.squareName,
      'userId': instance.userId,
      'userAvatar': instance.userAvatar,
      'squareImg': instance.squareImg,
      'squareDesc': instance.squareDesc,
      'chatConversationId': instance.chatConversationId,
      'hasChatConversation': instance.hasChatConversation,
      'blogCount': instance.blogCount,
      'createTime': instance.createTime,
    };

_SquarePageData _$SquarePageDataFromJson(Map<String, dynamic> json) =>
    _SquarePageData(
      total: (json['total'] as num?)?.toInt(),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => SquareItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SquarePageDataToJson(_SquarePageData instance) =>
    <String, dynamic>{'total': instance.total, 'list': instance.list};

_SquareConversationJoinResult _$SquareConversationJoinResultFromJson(
  Map<String, dynamic> json,
) => _SquareConversationJoinResult(
  squareId: (json['squareId'] as num?)?.toInt(),
  chatConversationId: (json['chatConversationId'] as num?)?.toInt(),
);

Map<String, dynamic> _$SquareConversationJoinResultToJson(
  _SquareConversationJoinResult instance,
) => <String, dynamic>{
  'squareId': instance.squareId,
  'chatConversationId': instance.chatConversationId,
};

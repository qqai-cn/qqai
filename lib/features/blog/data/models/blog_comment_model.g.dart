// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlogComment _$BlogCommentFromJson(Map<String, dynamic> json) => _BlogComment(
  id: (json['id'] as num?)?.toInt(),
  blogId: (json['blogId'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  nickname: json['nickname'] as String?,
  avatar: json['avatar'] as String?,
  content: json['content'] as String?,
  parentId: (json['parentId'] as num?)?.toInt(),
  rootId: (json['rootId'] as num?)?.toInt(),
  replyUserId: (json['replyUserId'] as num?)?.toInt(),
  replyNickname: json['replyNickname'] as String?,
  likeCount: (json['likeCount'] as num?)?.toInt(),
  liked: json['liked'] as bool?,
  replyCount: (json['replyCount'] as num?)?.toInt(),
  pinned: json['pinned'] as bool?,
  pinTime: json['pinTime'] as String?,
  previewReplies: json['previewReplies'] == null
      ? const []
      : previewRepliesFromJson(json['previewReplies']),
  createTime: json['createTime'] as String?,
);

Map<String, dynamic> _$BlogCommentToJson(_BlogComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'blogId': instance.blogId,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'content': instance.content,
      'parentId': instance.parentId,
      'rootId': instance.rootId,
      'replyUserId': instance.replyUserId,
      'replyNickname': instance.replyNickname,
      'likeCount': instance.likeCount,
      'liked': instance.liked,
      'replyCount': instance.replyCount,
      'pinned': instance.pinned,
      'pinTime': instance.pinTime,
      'previewReplies': previewRepliesToJson(instance.previewReplies),
      'createTime': instance.createTime,
    };

_BlogCommentPageData _$BlogCommentPageDataFromJson(Map<String, dynamic> json) =>
    _BlogCommentPageData(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => BlogComment.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BlogCommentPageDataToJson(
  _BlogCommentPageData instance,
) => <String, dynamic>{'list': instance.list, 'total': instance.total};

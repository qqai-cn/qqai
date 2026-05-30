// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlogItem _$BlogItemFromJson(Map<String, dynamic> json) => _BlogItem(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  squareId: (json['squareId'] as num?)?.toInt(),
  topicIds: json['topicIds'] as String?,
  categary: (json['categary'] as num?)?.toInt(),
  blogType: (json['blogType'] as num?)?.toInt(),
  title: json['title'] as String?,
  content: json['content'] as String?,
  resources: json['resources'] as String?,
  coverUrl: json['coverUrl'] as String?,
  addressId: (json['addressId'] as num?)?.toInt(),
  address: json['address'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  distance: (json['distance'] as num?)?.toDouble(),
  shareType: (json['shareType'] as num?)?.toInt(),
  zan: (json['zan'] as num?)?.toInt(),
  commentCount: (json['commentCount'] as num?)?.toInt(),
  collectCount: (json['collectCount'] as num?)?.toInt(),
  shareCount: (json['shareCount'] as num?)?.toInt(),
  care: (json['care'] as num?)?.toInt(),
  followerCount: (json['followerCount'] as num?)?.toInt(),
  creator: json['creator'] as String?,
  creatorName: json['creatorName'] as String?,
  creatorAvatar: json['creatorAvatar'] as String?,
  creatorLevel: (json['creatorLevel'] as num?)?.toInt(),
  creatorLevelName: json['creatorLevelName'] as String?,
  updater: json['updater'] as String?,
  createTime: json['createTime'] as String?,
  updateTime: json['updateTime'] as String?,
  liked: (json['liked'] as num?)?.toInt(),
  collect: (json['collect'] as num?)?.toInt(),
  collections: (json['collections'] as List<dynamic>?)
      ?.map((e) => BlogItemCollection.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BlogItemToJson(_BlogItem instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'squareId': instance.squareId,
  'topicIds': instance.topicIds,
  'categary': instance.categary,
  'blogType': instance.blogType,
  'title': instance.title,
  'content': instance.content,
  'resources': instance.resources,
  'coverUrl': instance.coverUrl,
  'addressId': instance.addressId,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'distance': instance.distance,
  'shareType': instance.shareType,
  'zan': instance.zan,
  'commentCount': instance.commentCount,
  'collectCount': instance.collectCount,
  'shareCount': instance.shareCount,
  'care': instance.care,
  'followerCount': instance.followerCount,
  'creator': instance.creator,
  'creatorName': instance.creatorName,
  'creatorAvatar': instance.creatorAvatar,
  'creatorLevel': instance.creatorLevel,
  'creatorLevelName': instance.creatorLevelName,
  'updater': instance.updater,
  'createTime': instance.createTime,
  'updateTime': instance.updateTime,
  'liked': instance.liked,
  'collect': instance.collect,
  'collections': instance.collections,
};

_BlogPageModelData _$BlogPageModelDataFromJson(Map<String, dynamic> json) =>
    _BlogPageModelData(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => BlogItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BlogPageModelDataToJson(_BlogPageModelData instance) =>
    <String, dynamic>{'list': instance.list, 'total': instance.total};

_BlogPageModel _$BlogPageModelFromJson(Map<String, dynamic> json) =>
    _BlogPageModel(
      code: (json['code'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : BlogPageModelData.fromJson(json['data'] as Map<String, dynamic>),
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$BlogPageModelToJson(_BlogPageModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
    };

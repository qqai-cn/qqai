// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blog_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlogItem {

 int? get id; int? get userId; int? get squareId; String? get topicIds; int? get categary; int? get blogType; String? get title; String? get content; String? get resources; String? get coverUrl; int? get videoWidth; int? get videoHeight; double? get videoAspectRatio; int? get addressId; String? get address; double? get latitude; double? get longitude;/// 与当前位置距离（千米，附近列表时有值）
 double? get distance; int? get shareType;/// 点赞数
 int? get zan;/// 评论数（含回复）
 int? get commentCount;/// 收藏数
 int? get collectCount;/// 转发/分享数
 int? get shareCount;/// 当前登录用户是否已关注作者：1 是，0 否
 int? get care;/// 作者粉丝数
 int? get followerCount; String? get creator; String? get creatorName; String? get creatorAvatar;/// 作者等级（用于等级图标，一般 1–6）
 int? get creatorLevel; String? get creatorLevelName; String? get updater; String? get createTime; String? get updateTime;/// 当前登录用户是否已点赞：1 是，0 否（若接口未返回则视为未赞）
 int? get liked;/// 当前登录用户是否已收藏：1 是，0 否
 int? get collect;/// 视频所属合集。后端可返回 collections/collectionList 等字段，解析层会归一到这里。
 List<BlogItemCollection>? get collections;
/// Create a copy of BlogItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogItemCopyWith<BlogItem> get copyWith => _$BlogItemCopyWithImpl<BlogItem>(this as BlogItem, _$identity);

  /// Serializes this BlogItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.topicIds, topicIds) || other.topicIds == topicIds)&&(identical(other.categary, categary) || other.categary == categary)&&(identical(other.blogType, blogType) || other.blogType == blogType)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.resources, resources) || other.resources == resources)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.videoWidth, videoWidth) || other.videoWidth == videoWidth)&&(identical(other.videoHeight, videoHeight) || other.videoHeight == videoHeight)&&(identical(other.videoAspectRatio, videoAspectRatio) || other.videoAspectRatio == videoAspectRatio)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.zan, zan) || other.zan == zan)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.collectCount, collectCount) || other.collectCount == collectCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.care, care) || other.care == care)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&(identical(other.creatorAvatar, creatorAvatar) || other.creatorAvatar == creatorAvatar)&&(identical(other.creatorLevel, creatorLevel) || other.creatorLevel == creatorLevel)&&(identical(other.creatorLevelName, creatorLevelName) || other.creatorLevelName == creatorLevelName)&&(identical(other.updater, updater) || other.updater == updater)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.collect, collect) || other.collect == collect)&&const DeepCollectionEquality().equals(other.collections, collections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,squareId,topicIds,categary,blogType,title,content,resources,coverUrl,videoWidth,videoHeight,videoAspectRatio,addressId,address,latitude,longitude,distance,shareType,zan,commentCount,collectCount,shareCount,care,followerCount,creator,creatorName,creatorAvatar,creatorLevel,creatorLevelName,updater,createTime,updateTime,liked,collect,const DeepCollectionEquality().hash(collections)]);

@override
String toString() {
  return 'BlogItem(id: $id, userId: $userId, squareId: $squareId, topicIds: $topicIds, categary: $categary, blogType: $blogType, title: $title, content: $content, resources: $resources, coverUrl: $coverUrl, videoWidth: $videoWidth, videoHeight: $videoHeight, videoAspectRatio: $videoAspectRatio, addressId: $addressId, address: $address, latitude: $latitude, longitude: $longitude, distance: $distance, shareType: $shareType, zan: $zan, commentCount: $commentCount, collectCount: $collectCount, shareCount: $shareCount, care: $care, followerCount: $followerCount, creator: $creator, creatorName: $creatorName, creatorAvatar: $creatorAvatar, creatorLevel: $creatorLevel, creatorLevelName: $creatorLevelName, updater: $updater, createTime: $createTime, updateTime: $updateTime, liked: $liked, collect: $collect, collections: $collections)';
}


}

/// @nodoc
abstract mixin class $BlogItemCopyWith<$Res>  {
  factory $BlogItemCopyWith(BlogItem value, $Res Function(BlogItem) _then) = _$BlogItemCopyWithImpl;
@useResult
$Res call({
 int? id, int? userId, int? squareId, String? topicIds, int? categary, int? blogType, String? title, String? content, String? resources, String? coverUrl, int? videoWidth, int? videoHeight, double? videoAspectRatio, int? addressId, String? address, double? latitude, double? longitude, double? distance, int? shareType, int? zan, int? commentCount, int? collectCount, int? shareCount, int? care, int? followerCount, String? creator, String? creatorName, String? creatorAvatar, int? creatorLevel, String? creatorLevelName, String? updater, String? createTime, String? updateTime, int? liked, int? collect, List<BlogItemCollection>? collections
});




}
/// @nodoc
class _$BlogItemCopyWithImpl<$Res>
    implements $BlogItemCopyWith<$Res> {
  _$BlogItemCopyWithImpl(this._self, this._then);

  final BlogItem _self;
  final $Res Function(BlogItem) _then;

/// Create a copy of BlogItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? squareId = freezed,Object? topicIds = freezed,Object? categary = freezed,Object? blogType = freezed,Object? title = freezed,Object? content = freezed,Object? resources = freezed,Object? coverUrl = freezed,Object? videoWidth = freezed,Object? videoHeight = freezed,Object? videoAspectRatio = freezed,Object? addressId = freezed,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? distance = freezed,Object? shareType = freezed,Object? zan = freezed,Object? commentCount = freezed,Object? collectCount = freezed,Object? shareCount = freezed,Object? care = freezed,Object? followerCount = freezed,Object? creator = freezed,Object? creatorName = freezed,Object? creatorAvatar = freezed,Object? creatorLevel = freezed,Object? creatorLevelName = freezed,Object? updater = freezed,Object? createTime = freezed,Object? updateTime = freezed,Object? liked = freezed,Object? collect = freezed,Object? collections = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,squareId: freezed == squareId ? _self.squareId : squareId // ignore: cast_nullable_to_non_nullable
as int?,topicIds: freezed == topicIds ? _self.topicIds : topicIds // ignore: cast_nullable_to_non_nullable
as String?,categary: freezed == categary ? _self.categary : categary // ignore: cast_nullable_to_non_nullable
as int?,blogType: freezed == blogType ? _self.blogType : blogType // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,resources: freezed == resources ? _self.resources : resources // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,videoWidth: freezed == videoWidth ? _self.videoWidth : videoWidth // ignore: cast_nullable_to_non_nullable
as int?,videoHeight: freezed == videoHeight ? _self.videoHeight : videoHeight // ignore: cast_nullable_to_non_nullable
as int?,videoAspectRatio: freezed == videoAspectRatio ? _self.videoAspectRatio : videoAspectRatio // ignore: cast_nullable_to_non_nullable
as double?,addressId: freezed == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as int?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,shareType: freezed == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as int?,zan: freezed == zan ? _self.zan : zan // ignore: cast_nullable_to_non_nullable
as int?,commentCount: freezed == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int?,collectCount: freezed == collectCount ? _self.collectCount : collectCount // ignore: cast_nullable_to_non_nullable
as int?,shareCount: freezed == shareCount ? _self.shareCount : shareCount // ignore: cast_nullable_to_non_nullable
as int?,care: freezed == care ? _self.care : care // ignore: cast_nullable_to_non_nullable
as int?,followerCount: freezed == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as int?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as String?,creatorName: freezed == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String?,creatorAvatar: freezed == creatorAvatar ? _self.creatorAvatar : creatorAvatar // ignore: cast_nullable_to_non_nullable
as String?,creatorLevel: freezed == creatorLevel ? _self.creatorLevel : creatorLevel // ignore: cast_nullable_to_non_nullable
as int?,creatorLevelName: freezed == creatorLevelName ? _self.creatorLevelName : creatorLevelName // ignore: cast_nullable_to_non_nullable
as String?,updater: freezed == updater ? _self.updater : updater // ignore: cast_nullable_to_non_nullable
as String?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,liked: freezed == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as int?,collect: freezed == collect ? _self.collect : collect // ignore: cast_nullable_to_non_nullable
as int?,collections: freezed == collections ? _self.collections : collections // ignore: cast_nullable_to_non_nullable
as List<BlogItemCollection>?,
  ));
}

}


/// Adds pattern-matching-related methods to [BlogItem].
extension BlogItemPatterns on BlogItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlogItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlogItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlogItem value)  $default,){
final _that = this;
switch (_that) {
case _BlogItem():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlogItem value)?  $default,){
final _that = this;
switch (_that) {
case _BlogItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? userId,  int? squareId,  String? topicIds,  int? categary,  int? blogType,  String? title,  String? content,  String? resources,  String? coverUrl,  int? videoWidth,  int? videoHeight,  double? videoAspectRatio,  int? addressId,  String? address,  double? latitude,  double? longitude,  double? distance,  int? shareType,  int? zan,  int? commentCount,  int? collectCount,  int? shareCount,  int? care,  int? followerCount,  String? creator,  String? creatorName,  String? creatorAvatar,  int? creatorLevel,  String? creatorLevelName,  String? updater,  String? createTime,  String? updateTime,  int? liked,  int? collect,  List<BlogItemCollection>? collections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogItem() when $default != null:
return $default(_that.id,_that.userId,_that.squareId,_that.topicIds,_that.categary,_that.blogType,_that.title,_that.content,_that.resources,_that.coverUrl,_that.videoWidth,_that.videoHeight,_that.videoAspectRatio,_that.addressId,_that.address,_that.latitude,_that.longitude,_that.distance,_that.shareType,_that.zan,_that.commentCount,_that.collectCount,_that.shareCount,_that.care,_that.followerCount,_that.creator,_that.creatorName,_that.creatorAvatar,_that.creatorLevel,_that.creatorLevelName,_that.updater,_that.createTime,_that.updateTime,_that.liked,_that.collect,_that.collections);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? userId,  int? squareId,  String? topicIds,  int? categary,  int? blogType,  String? title,  String? content,  String? resources,  String? coverUrl,  int? videoWidth,  int? videoHeight,  double? videoAspectRatio,  int? addressId,  String? address,  double? latitude,  double? longitude,  double? distance,  int? shareType,  int? zan,  int? commentCount,  int? collectCount,  int? shareCount,  int? care,  int? followerCount,  String? creator,  String? creatorName,  String? creatorAvatar,  int? creatorLevel,  String? creatorLevelName,  String? updater,  String? createTime,  String? updateTime,  int? liked,  int? collect,  List<BlogItemCollection>? collections)  $default,) {final _that = this;
switch (_that) {
case _BlogItem():
return $default(_that.id,_that.userId,_that.squareId,_that.topicIds,_that.categary,_that.blogType,_that.title,_that.content,_that.resources,_that.coverUrl,_that.videoWidth,_that.videoHeight,_that.videoAspectRatio,_that.addressId,_that.address,_that.latitude,_that.longitude,_that.distance,_that.shareType,_that.zan,_that.commentCount,_that.collectCount,_that.shareCount,_that.care,_that.followerCount,_that.creator,_that.creatorName,_that.creatorAvatar,_that.creatorLevel,_that.creatorLevelName,_that.updater,_that.createTime,_that.updateTime,_that.liked,_that.collect,_that.collections);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? userId,  int? squareId,  String? topicIds,  int? categary,  int? blogType,  String? title,  String? content,  String? resources,  String? coverUrl,  int? videoWidth,  int? videoHeight,  double? videoAspectRatio,  int? addressId,  String? address,  double? latitude,  double? longitude,  double? distance,  int? shareType,  int? zan,  int? commentCount,  int? collectCount,  int? shareCount,  int? care,  int? followerCount,  String? creator,  String? creatorName,  String? creatorAvatar,  int? creatorLevel,  String? creatorLevelName,  String? updater,  String? createTime,  String? updateTime,  int? liked,  int? collect,  List<BlogItemCollection>? collections)?  $default,) {final _that = this;
switch (_that) {
case _BlogItem() when $default != null:
return $default(_that.id,_that.userId,_that.squareId,_that.topicIds,_that.categary,_that.blogType,_that.title,_that.content,_that.resources,_that.coverUrl,_that.videoWidth,_that.videoHeight,_that.videoAspectRatio,_that.addressId,_that.address,_that.latitude,_that.longitude,_that.distance,_that.shareType,_that.zan,_that.commentCount,_that.collectCount,_that.shareCount,_that.care,_that.followerCount,_that.creator,_that.creatorName,_that.creatorAvatar,_that.creatorLevel,_that.creatorLevelName,_that.updater,_that.createTime,_that.updateTime,_that.liked,_that.collect,_that.collections);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlogItem implements BlogItem {
  const _BlogItem({this.id, this.userId, this.squareId, this.topicIds, this.categary, this.blogType, this.title, this.content, this.resources, this.coverUrl, this.videoWidth, this.videoHeight, this.videoAspectRatio, this.addressId, this.address, this.latitude, this.longitude, this.distance, this.shareType, this.zan, this.commentCount, this.collectCount, this.shareCount, this.care, this.followerCount, this.creator, this.creatorName, this.creatorAvatar, this.creatorLevel, this.creatorLevelName, this.updater, this.createTime, this.updateTime, this.liked, this.collect, final  List<BlogItemCollection>? collections}): _collections = collections;
  factory _BlogItem.fromJson(Map<String, dynamic> json) => _$BlogItemFromJson(json);

@override final  int? id;
@override final  int? userId;
@override final  int? squareId;
@override final  String? topicIds;
@override final  int? categary;
@override final  int? blogType;
@override final  String? title;
@override final  String? content;
@override final  String? resources;
@override final  String? coverUrl;
@override final  int? videoWidth;
@override final  int? videoHeight;
@override final  double? videoAspectRatio;
@override final  int? addressId;
@override final  String? address;
@override final  double? latitude;
@override final  double? longitude;
/// 与当前位置距离（千米，附近列表时有值）
@override final  double? distance;
@override final  int? shareType;
/// 点赞数
@override final  int? zan;
/// 评论数（含回复）
@override final  int? commentCount;
/// 收藏数
@override final  int? collectCount;
/// 转发/分享数
@override final  int? shareCount;
/// 当前登录用户是否已关注作者：1 是，0 否
@override final  int? care;
/// 作者粉丝数
@override final  int? followerCount;
@override final  String? creator;
@override final  String? creatorName;
@override final  String? creatorAvatar;
/// 作者等级（用于等级图标，一般 1–6）
@override final  int? creatorLevel;
@override final  String? creatorLevelName;
@override final  String? updater;
@override final  String? createTime;
@override final  String? updateTime;
/// 当前登录用户是否已点赞：1 是，0 否（若接口未返回则视为未赞）
@override final  int? liked;
/// 当前登录用户是否已收藏：1 是，0 否
@override final  int? collect;
/// 视频所属合集。后端可返回 collections/collectionList 等字段，解析层会归一到这里。
 final  List<BlogItemCollection>? _collections;
/// 视频所属合集。后端可返回 collections/collectionList 等字段，解析层会归一到这里。
@override List<BlogItemCollection>? get collections {
  final value = _collections;
  if (value == null) return null;
  if (_collections is EqualUnmodifiableListView) return _collections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of BlogItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlogItemCopyWith<_BlogItem> get copyWith => __$BlogItemCopyWithImpl<_BlogItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlogItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.topicIds, topicIds) || other.topicIds == topicIds)&&(identical(other.categary, categary) || other.categary == categary)&&(identical(other.blogType, blogType) || other.blogType == blogType)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.resources, resources) || other.resources == resources)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.videoWidth, videoWidth) || other.videoWidth == videoWidth)&&(identical(other.videoHeight, videoHeight) || other.videoHeight == videoHeight)&&(identical(other.videoAspectRatio, videoAspectRatio) || other.videoAspectRatio == videoAspectRatio)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.zan, zan) || other.zan == zan)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.collectCount, collectCount) || other.collectCount == collectCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.care, care) || other.care == care)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&(identical(other.creatorAvatar, creatorAvatar) || other.creatorAvatar == creatorAvatar)&&(identical(other.creatorLevel, creatorLevel) || other.creatorLevel == creatorLevel)&&(identical(other.creatorLevelName, creatorLevelName) || other.creatorLevelName == creatorLevelName)&&(identical(other.updater, updater) || other.updater == updater)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.collect, collect) || other.collect == collect)&&const DeepCollectionEquality().equals(other._collections, _collections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,squareId,topicIds,categary,blogType,title,content,resources,coverUrl,videoWidth,videoHeight,videoAspectRatio,addressId,address,latitude,longitude,distance,shareType,zan,commentCount,collectCount,shareCount,care,followerCount,creator,creatorName,creatorAvatar,creatorLevel,creatorLevelName,updater,createTime,updateTime,liked,collect,const DeepCollectionEquality().hash(_collections)]);

@override
String toString() {
  return 'BlogItem(id: $id, userId: $userId, squareId: $squareId, topicIds: $topicIds, categary: $categary, blogType: $blogType, title: $title, content: $content, resources: $resources, coverUrl: $coverUrl, videoWidth: $videoWidth, videoHeight: $videoHeight, videoAspectRatio: $videoAspectRatio, addressId: $addressId, address: $address, latitude: $latitude, longitude: $longitude, distance: $distance, shareType: $shareType, zan: $zan, commentCount: $commentCount, collectCount: $collectCount, shareCount: $shareCount, care: $care, followerCount: $followerCount, creator: $creator, creatorName: $creatorName, creatorAvatar: $creatorAvatar, creatorLevel: $creatorLevel, creatorLevelName: $creatorLevelName, updater: $updater, createTime: $createTime, updateTime: $updateTime, liked: $liked, collect: $collect, collections: $collections)';
}


}

/// @nodoc
abstract mixin class _$BlogItemCopyWith<$Res> implements $BlogItemCopyWith<$Res> {
  factory _$BlogItemCopyWith(_BlogItem value, $Res Function(_BlogItem) _then) = __$BlogItemCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? userId, int? squareId, String? topicIds, int? categary, int? blogType, String? title, String? content, String? resources, String? coverUrl, int? videoWidth, int? videoHeight, double? videoAspectRatio, int? addressId, String? address, double? latitude, double? longitude, double? distance, int? shareType, int? zan, int? commentCount, int? collectCount, int? shareCount, int? care, int? followerCount, String? creator, String? creatorName, String? creatorAvatar, int? creatorLevel, String? creatorLevelName, String? updater, String? createTime, String? updateTime, int? liked, int? collect, List<BlogItemCollection>? collections
});




}
/// @nodoc
class __$BlogItemCopyWithImpl<$Res>
    implements _$BlogItemCopyWith<$Res> {
  __$BlogItemCopyWithImpl(this._self, this._then);

  final _BlogItem _self;
  final $Res Function(_BlogItem) _then;

/// Create a copy of BlogItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? squareId = freezed,Object? topicIds = freezed,Object? categary = freezed,Object? blogType = freezed,Object? title = freezed,Object? content = freezed,Object? resources = freezed,Object? coverUrl = freezed,Object? videoWidth = freezed,Object? videoHeight = freezed,Object? videoAspectRatio = freezed,Object? addressId = freezed,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? distance = freezed,Object? shareType = freezed,Object? zan = freezed,Object? commentCount = freezed,Object? collectCount = freezed,Object? shareCount = freezed,Object? care = freezed,Object? followerCount = freezed,Object? creator = freezed,Object? creatorName = freezed,Object? creatorAvatar = freezed,Object? creatorLevel = freezed,Object? creatorLevelName = freezed,Object? updater = freezed,Object? createTime = freezed,Object? updateTime = freezed,Object? liked = freezed,Object? collect = freezed,Object? collections = freezed,}) {
  return _then(_BlogItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,squareId: freezed == squareId ? _self.squareId : squareId // ignore: cast_nullable_to_non_nullable
as int?,topicIds: freezed == topicIds ? _self.topicIds : topicIds // ignore: cast_nullable_to_non_nullable
as String?,categary: freezed == categary ? _self.categary : categary // ignore: cast_nullable_to_non_nullable
as int?,blogType: freezed == blogType ? _self.blogType : blogType // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,resources: freezed == resources ? _self.resources : resources // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,videoWidth: freezed == videoWidth ? _self.videoWidth : videoWidth // ignore: cast_nullable_to_non_nullable
as int?,videoHeight: freezed == videoHeight ? _self.videoHeight : videoHeight // ignore: cast_nullable_to_non_nullable
as int?,videoAspectRatio: freezed == videoAspectRatio ? _self.videoAspectRatio : videoAspectRatio // ignore: cast_nullable_to_non_nullable
as double?,addressId: freezed == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as int?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,shareType: freezed == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as int?,zan: freezed == zan ? _self.zan : zan // ignore: cast_nullable_to_non_nullable
as int?,commentCount: freezed == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int?,collectCount: freezed == collectCount ? _self.collectCount : collectCount // ignore: cast_nullable_to_non_nullable
as int?,shareCount: freezed == shareCount ? _self.shareCount : shareCount // ignore: cast_nullable_to_non_nullable
as int?,care: freezed == care ? _self.care : care // ignore: cast_nullable_to_non_nullable
as int?,followerCount: freezed == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as int?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as String?,creatorName: freezed == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String?,creatorAvatar: freezed == creatorAvatar ? _self.creatorAvatar : creatorAvatar // ignore: cast_nullable_to_non_nullable
as String?,creatorLevel: freezed == creatorLevel ? _self.creatorLevel : creatorLevel // ignore: cast_nullable_to_non_nullable
as int?,creatorLevelName: freezed == creatorLevelName ? _self.creatorLevelName : creatorLevelName // ignore: cast_nullable_to_non_nullable
as String?,updater: freezed == updater ? _self.updater : updater // ignore: cast_nullable_to_non_nullable
as String?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,liked: freezed == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as int?,collect: freezed == collect ? _self.collect : collect // ignore: cast_nullable_to_non_nullable
as int?,collections: freezed == collections ? _self._collections : collections // ignore: cast_nullable_to_non_nullable
as List<BlogItemCollection>?,
  ));
}


}


/// @nodoc
mixin _$BlogPageModelData {

 List<BlogItem>? get list; int? get total;
/// Create a copy of BlogPageModelData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogPageModelDataCopyWith<BlogPageModelData> get copyWith => _$BlogPageModelDataCopyWithImpl<BlogPageModelData>(this as BlogPageModelData, _$identity);

  /// Serializes this BlogPageModelData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogPageModelData&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),total);

@override
String toString() {
  return 'BlogPageModelData(list: $list, total: $total)';
}


}

/// @nodoc
abstract mixin class $BlogPageModelDataCopyWith<$Res>  {
  factory $BlogPageModelDataCopyWith(BlogPageModelData value, $Res Function(BlogPageModelData) _then) = _$BlogPageModelDataCopyWithImpl;
@useResult
$Res call({
 List<BlogItem>? list, int? total
});




}
/// @nodoc
class _$BlogPageModelDataCopyWithImpl<$Res>
    implements $BlogPageModelDataCopyWith<$Res> {
  _$BlogPageModelDataCopyWithImpl(this._self, this._then);

  final BlogPageModelData _self;
  final $Res Function(BlogPageModelData) _then;

/// Create a copy of BlogPageModelData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = freezed,Object? total = freezed,}) {
  return _then(_self.copyWith(
list: freezed == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<BlogItem>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BlogPageModelData].
extension BlogPageModelDataPatterns on BlogPageModelData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlogPageModelData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlogPageModelData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlogPageModelData value)  $default,){
final _that = this;
switch (_that) {
case _BlogPageModelData():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlogPageModelData value)?  $default,){
final _that = this;
switch (_that) {
case _BlogPageModelData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BlogItem>? list,  int? total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogPageModelData() when $default != null:
return $default(_that.list,_that.total);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BlogItem>? list,  int? total)  $default,) {final _that = this;
switch (_that) {
case _BlogPageModelData():
return $default(_that.list,_that.total);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BlogItem>? list,  int? total)?  $default,) {final _that = this;
switch (_that) {
case _BlogPageModelData() when $default != null:
return $default(_that.list,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlogPageModelData implements BlogPageModelData {
  const _BlogPageModelData({final  List<BlogItem>? list, this.total}): _list = list;
  factory _BlogPageModelData.fromJson(Map<String, dynamic> json) => _$BlogPageModelDataFromJson(json);

 final  List<BlogItem>? _list;
@override List<BlogItem>? get list {
  final value = _list;
  if (value == null) return null;
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? total;

/// Create a copy of BlogPageModelData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlogPageModelDataCopyWith<_BlogPageModelData> get copyWith => __$BlogPageModelDataCopyWithImpl<_BlogPageModelData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlogPageModelDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogPageModelData&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),total);

@override
String toString() {
  return 'BlogPageModelData(list: $list, total: $total)';
}


}

/// @nodoc
abstract mixin class _$BlogPageModelDataCopyWith<$Res> implements $BlogPageModelDataCopyWith<$Res> {
  factory _$BlogPageModelDataCopyWith(_BlogPageModelData value, $Res Function(_BlogPageModelData) _then) = __$BlogPageModelDataCopyWithImpl;
@override @useResult
$Res call({
 List<BlogItem>? list, int? total
});




}
/// @nodoc
class __$BlogPageModelDataCopyWithImpl<$Res>
    implements _$BlogPageModelDataCopyWith<$Res> {
  __$BlogPageModelDataCopyWithImpl(this._self, this._then);

  final _BlogPageModelData _self;
  final $Res Function(_BlogPageModelData) _then;

/// Create a copy of BlogPageModelData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = freezed,Object? total = freezed,}) {
  return _then(_BlogPageModelData(
list: freezed == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<BlogItem>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$BlogPageModel {

 int? get code; BlogPageModelData? get data; String? get msg;
/// Create a copy of BlogPageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogPageModelCopyWith<BlogPageModel> get copyWith => _$BlogPageModelCopyWithImpl<BlogPageModel>(this as BlogPageModel, _$identity);

  /// Serializes this BlogPageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogPageModel&&(identical(other.code, code) || other.code == code)&&(identical(other.data, data) || other.data == data)&&(identical(other.msg, msg) || other.msg == msg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,data,msg);

@override
String toString() {
  return 'BlogPageModel(code: $code, data: $data, msg: $msg)';
}


}

/// @nodoc
abstract mixin class $BlogPageModelCopyWith<$Res>  {
  factory $BlogPageModelCopyWith(BlogPageModel value, $Res Function(BlogPageModel) _then) = _$BlogPageModelCopyWithImpl;
@useResult
$Res call({
 int? code, BlogPageModelData? data, String? msg
});


$BlogPageModelDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$BlogPageModelCopyWithImpl<$Res>
    implements $BlogPageModelCopyWith<$Res> {
  _$BlogPageModelCopyWithImpl(this._self, this._then);

  final BlogPageModel _self;
  final $Res Function(BlogPageModel) _then;

/// Create a copy of BlogPageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? data = freezed,Object? msg = freezed,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BlogPageModelData?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BlogPageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlogPageModelDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $BlogPageModelDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [BlogPageModel].
extension BlogPageModelPatterns on BlogPageModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlogPageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlogPageModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlogPageModel value)  $default,){
final _that = this;
switch (_that) {
case _BlogPageModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlogPageModel value)?  $default,){
final _that = this;
switch (_that) {
case _BlogPageModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? code,  BlogPageModelData? data,  String? msg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogPageModel() when $default != null:
return $default(_that.code,_that.data,_that.msg);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? code,  BlogPageModelData? data,  String? msg)  $default,) {final _that = this;
switch (_that) {
case _BlogPageModel():
return $default(_that.code,_that.data,_that.msg);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? code,  BlogPageModelData? data,  String? msg)?  $default,) {final _that = this;
switch (_that) {
case _BlogPageModel() when $default != null:
return $default(_that.code,_that.data,_that.msg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlogPageModel implements BlogPageModel {
  const _BlogPageModel({this.code, this.data, this.msg});
  factory _BlogPageModel.fromJson(Map<String, dynamic> json) => _$BlogPageModelFromJson(json);

@override final  int? code;
@override final  BlogPageModelData? data;
@override final  String? msg;

/// Create a copy of BlogPageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlogPageModelCopyWith<_BlogPageModel> get copyWith => __$BlogPageModelCopyWithImpl<_BlogPageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlogPageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogPageModel&&(identical(other.code, code) || other.code == code)&&(identical(other.data, data) || other.data == data)&&(identical(other.msg, msg) || other.msg == msg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,data,msg);

@override
String toString() {
  return 'BlogPageModel(code: $code, data: $data, msg: $msg)';
}


}

/// @nodoc
abstract mixin class _$BlogPageModelCopyWith<$Res> implements $BlogPageModelCopyWith<$Res> {
  factory _$BlogPageModelCopyWith(_BlogPageModel value, $Res Function(_BlogPageModel) _then) = __$BlogPageModelCopyWithImpl;
@override @useResult
$Res call({
 int? code, BlogPageModelData? data, String? msg
});


@override $BlogPageModelDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$BlogPageModelCopyWithImpl<$Res>
    implements _$BlogPageModelCopyWith<$Res> {
  __$BlogPageModelCopyWithImpl(this._self, this._then);

  final _BlogPageModel _self;
  final $Res Function(_BlogPageModel) _then;

/// Create a copy of BlogPageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? data = freezed,Object? msg = freezed,}) {
  return _then(_BlogPageModel(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BlogPageModelData?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BlogPageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlogPageModelDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $BlogPageModelDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on

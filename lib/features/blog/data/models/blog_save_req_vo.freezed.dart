// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blog_save_req_vo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlogSaveReqVO {

 int? get id; int? get squareId; String? get topicIds; int? get categary; int? get blogType; String? get title; String? get content; String? get resources; String? get coverUrl; int? get videoWidth; int? get videoHeight; double? get videoAspectRatio; int? get addressId; String? get address; double? get latitude; double? get longitude; int? get shareType; List<int>? get collectionIds;
/// Create a copy of BlogSaveReqVO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogSaveReqVOCopyWith<BlogSaveReqVO> get copyWith => _$BlogSaveReqVOCopyWithImpl<BlogSaveReqVO>(this as BlogSaveReqVO, _$identity);

  /// Serializes this BlogSaveReqVO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogSaveReqVO&&(identical(other.id, id) || other.id == id)&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.topicIds, topicIds) || other.topicIds == topicIds)&&(identical(other.categary, categary) || other.categary == categary)&&(identical(other.blogType, blogType) || other.blogType == blogType)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.resources, resources) || other.resources == resources)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.videoWidth, videoWidth) || other.videoWidth == videoWidth)&&(identical(other.videoHeight, videoHeight) || other.videoHeight == videoHeight)&&(identical(other.videoAspectRatio, videoAspectRatio) || other.videoAspectRatio == videoAspectRatio)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&const DeepCollectionEquality().equals(other.collectionIds, collectionIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,squareId,topicIds,categary,blogType,title,content,resources,coverUrl,videoWidth,videoHeight,videoAspectRatio,addressId,address,latitude,longitude,shareType,const DeepCollectionEquality().hash(collectionIds));

@override
String toString() {
  return 'BlogSaveReqVO(id: $id, squareId: $squareId, topicIds: $topicIds, categary: $categary, blogType: $blogType, title: $title, content: $content, resources: $resources, coverUrl: $coverUrl, videoWidth: $videoWidth, videoHeight: $videoHeight, videoAspectRatio: $videoAspectRatio, addressId: $addressId, address: $address, latitude: $latitude, longitude: $longitude, shareType: $shareType, collectionIds: $collectionIds)';
}


}

/// @nodoc
abstract mixin class $BlogSaveReqVOCopyWith<$Res>  {
  factory $BlogSaveReqVOCopyWith(BlogSaveReqVO value, $Res Function(BlogSaveReqVO) _then) = _$BlogSaveReqVOCopyWithImpl;
@useResult
$Res call({
 int? id, int? squareId, String? topicIds, int? categary, int? blogType, String? title, String? content, String? resources, String? coverUrl, int? videoWidth, int? videoHeight, double? videoAspectRatio, int? addressId, String? address, double? latitude, double? longitude, int? shareType, List<int>? collectionIds
});




}
/// @nodoc
class _$BlogSaveReqVOCopyWithImpl<$Res>
    implements $BlogSaveReqVOCopyWith<$Res> {
  _$BlogSaveReqVOCopyWithImpl(this._self, this._then);

  final BlogSaveReqVO _self;
  final $Res Function(BlogSaveReqVO) _then;

/// Create a copy of BlogSaveReqVO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? squareId = freezed,Object? topicIds = freezed,Object? categary = freezed,Object? blogType = freezed,Object? title = freezed,Object? content = freezed,Object? resources = freezed,Object? coverUrl = freezed,Object? videoWidth = freezed,Object? videoHeight = freezed,Object? videoAspectRatio = freezed,Object? addressId = freezed,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? shareType = freezed,Object? collectionIds = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
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
as double?,shareType: freezed == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as int?,collectionIds: freezed == collectionIds ? _self.collectionIds : collectionIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}

}


/// Adds pattern-matching-related methods to [BlogSaveReqVO].
extension BlogSaveReqVOPatterns on BlogSaveReqVO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlogSaveReqVO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlogSaveReqVO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlogSaveReqVO value)  $default,){
final _that = this;
switch (_that) {
case _BlogSaveReqVO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlogSaveReqVO value)?  $default,){
final _that = this;
switch (_that) {
case _BlogSaveReqVO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? squareId,  String? topicIds,  int? categary,  int? blogType,  String? title,  String? content,  String? resources,  String? coverUrl,  int? videoWidth,  int? videoHeight,  double? videoAspectRatio,  int? addressId,  String? address,  double? latitude,  double? longitude,  int? shareType,  List<int>? collectionIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogSaveReqVO() when $default != null:
return $default(_that.id,_that.squareId,_that.topicIds,_that.categary,_that.blogType,_that.title,_that.content,_that.resources,_that.coverUrl,_that.videoWidth,_that.videoHeight,_that.videoAspectRatio,_that.addressId,_that.address,_that.latitude,_that.longitude,_that.shareType,_that.collectionIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? squareId,  String? topicIds,  int? categary,  int? blogType,  String? title,  String? content,  String? resources,  String? coverUrl,  int? videoWidth,  int? videoHeight,  double? videoAspectRatio,  int? addressId,  String? address,  double? latitude,  double? longitude,  int? shareType,  List<int>? collectionIds)  $default,) {final _that = this;
switch (_that) {
case _BlogSaveReqVO():
return $default(_that.id,_that.squareId,_that.topicIds,_that.categary,_that.blogType,_that.title,_that.content,_that.resources,_that.coverUrl,_that.videoWidth,_that.videoHeight,_that.videoAspectRatio,_that.addressId,_that.address,_that.latitude,_that.longitude,_that.shareType,_that.collectionIds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? squareId,  String? topicIds,  int? categary,  int? blogType,  String? title,  String? content,  String? resources,  String? coverUrl,  int? videoWidth,  int? videoHeight,  double? videoAspectRatio,  int? addressId,  String? address,  double? latitude,  double? longitude,  int? shareType,  List<int>? collectionIds)?  $default,) {final _that = this;
switch (_that) {
case _BlogSaveReqVO() when $default != null:
return $default(_that.id,_that.squareId,_that.topicIds,_that.categary,_that.blogType,_that.title,_that.content,_that.resources,_that.coverUrl,_that.videoWidth,_that.videoHeight,_that.videoAspectRatio,_that.addressId,_that.address,_that.latitude,_that.longitude,_that.shareType,_that.collectionIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlogSaveReqVO implements BlogSaveReqVO {
  const _BlogSaveReqVO({this.id, this.squareId, this.topicIds, this.categary, this.blogType, this.title, this.content, this.resources, this.coverUrl, this.videoWidth, this.videoHeight, this.videoAspectRatio, this.addressId, this.address, this.latitude, this.longitude, this.shareType, final  List<int>? collectionIds}): _collectionIds = collectionIds;
  factory _BlogSaveReqVO.fromJson(Map<String, dynamic> json) => _$BlogSaveReqVOFromJson(json);

@override final  int? id;
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
@override final  int? shareType;
 final  List<int>? _collectionIds;
@override List<int>? get collectionIds {
  final value = _collectionIds;
  if (value == null) return null;
  if (_collectionIds is EqualUnmodifiableListView) return _collectionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of BlogSaveReqVO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlogSaveReqVOCopyWith<_BlogSaveReqVO> get copyWith => __$BlogSaveReqVOCopyWithImpl<_BlogSaveReqVO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlogSaveReqVOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogSaveReqVO&&(identical(other.id, id) || other.id == id)&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.topicIds, topicIds) || other.topicIds == topicIds)&&(identical(other.categary, categary) || other.categary == categary)&&(identical(other.blogType, blogType) || other.blogType == blogType)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.resources, resources) || other.resources == resources)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.videoWidth, videoWidth) || other.videoWidth == videoWidth)&&(identical(other.videoHeight, videoHeight) || other.videoHeight == videoHeight)&&(identical(other.videoAspectRatio, videoAspectRatio) || other.videoAspectRatio == videoAspectRatio)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&const DeepCollectionEquality().equals(other._collectionIds, _collectionIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,squareId,topicIds,categary,blogType,title,content,resources,coverUrl,videoWidth,videoHeight,videoAspectRatio,addressId,address,latitude,longitude,shareType,const DeepCollectionEquality().hash(_collectionIds));

@override
String toString() {
  return 'BlogSaveReqVO(id: $id, squareId: $squareId, topicIds: $topicIds, categary: $categary, blogType: $blogType, title: $title, content: $content, resources: $resources, coverUrl: $coverUrl, videoWidth: $videoWidth, videoHeight: $videoHeight, videoAspectRatio: $videoAspectRatio, addressId: $addressId, address: $address, latitude: $latitude, longitude: $longitude, shareType: $shareType, collectionIds: $collectionIds)';
}


}

/// @nodoc
abstract mixin class _$BlogSaveReqVOCopyWith<$Res> implements $BlogSaveReqVOCopyWith<$Res> {
  factory _$BlogSaveReqVOCopyWith(_BlogSaveReqVO value, $Res Function(_BlogSaveReqVO) _then) = __$BlogSaveReqVOCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? squareId, String? topicIds, int? categary, int? blogType, String? title, String? content, String? resources, String? coverUrl, int? videoWidth, int? videoHeight, double? videoAspectRatio, int? addressId, String? address, double? latitude, double? longitude, int? shareType, List<int>? collectionIds
});




}
/// @nodoc
class __$BlogSaveReqVOCopyWithImpl<$Res>
    implements _$BlogSaveReqVOCopyWith<$Res> {
  __$BlogSaveReqVOCopyWithImpl(this._self, this._then);

  final _BlogSaveReqVO _self;
  final $Res Function(_BlogSaveReqVO) _then;

/// Create a copy of BlogSaveReqVO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? squareId = freezed,Object? topicIds = freezed,Object? categary = freezed,Object? blogType = freezed,Object? title = freezed,Object? content = freezed,Object? resources = freezed,Object? coverUrl = freezed,Object? videoWidth = freezed,Object? videoHeight = freezed,Object? videoAspectRatio = freezed,Object? addressId = freezed,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? shareType = freezed,Object? collectionIds = freezed,}) {
  return _then(_BlogSaveReqVO(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
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
as double?,shareType: freezed == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as int?,collectionIds: freezed == collectionIds ? _self._collectionIds : collectionIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}


}

// dart format on

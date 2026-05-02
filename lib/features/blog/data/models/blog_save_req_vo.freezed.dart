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

 int? get id; int? get squareId; String? get topicIds; int? get categary; int? get blogType; String? get content; String? get resources; int? get addressId; int? get shareType;
/// Create a copy of BlogSaveReqVO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogSaveReqVOCopyWith<BlogSaveReqVO> get copyWith => _$BlogSaveReqVOCopyWithImpl<BlogSaveReqVO>(this as BlogSaveReqVO, _$identity);

  /// Serializes this BlogSaveReqVO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogSaveReqVO&&(identical(other.id, id) || other.id == id)&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.topicIds, topicIds) || other.topicIds == topicIds)&&(identical(other.categary, categary) || other.categary == categary)&&(identical(other.blogType, blogType) || other.blogType == blogType)&&(identical(other.content, content) || other.content == content)&&(identical(other.resources, resources) || other.resources == resources)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.shareType, shareType) || other.shareType == shareType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,squareId,topicIds,categary,blogType,content,resources,addressId,shareType);

@override
String toString() {
  return 'BlogSaveReqVO(id: $id, squareId: $squareId, topicIds: $topicIds, categary: $categary, blogType: $blogType, content: $content, resources: $resources, addressId: $addressId, shareType: $shareType)';
}


}

/// @nodoc
abstract mixin class $BlogSaveReqVOCopyWith<$Res>  {
  factory $BlogSaveReqVOCopyWith(BlogSaveReqVO value, $Res Function(BlogSaveReqVO) _then) = _$BlogSaveReqVOCopyWithImpl;
@useResult
$Res call({
 int? id, int? squareId, String? topicIds, int? categary, int? blogType, String? content, String? resources, int? addressId, int? shareType
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? squareId = freezed,Object? topicIds = freezed,Object? categary = freezed,Object? blogType = freezed,Object? content = freezed,Object? resources = freezed,Object? addressId = freezed,Object? shareType = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,squareId: freezed == squareId ? _self.squareId : squareId // ignore: cast_nullable_to_non_nullable
as int?,topicIds: freezed == topicIds ? _self.topicIds : topicIds // ignore: cast_nullable_to_non_nullable
as String?,categary: freezed == categary ? _self.categary : categary // ignore: cast_nullable_to_non_nullable
as int?,blogType: freezed == blogType ? _self.blogType : blogType // ignore: cast_nullable_to_non_nullable
as int?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,resources: freezed == resources ? _self.resources : resources // ignore: cast_nullable_to_non_nullable
as String?,addressId: freezed == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as int?,shareType: freezed == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as int?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? squareId,  String? topicIds,  int? categary,  int? blogType,  String? content,  String? resources,  int? addressId,  int? shareType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogSaveReqVO() when $default != null:
return $default(_that.id,_that.squareId,_that.topicIds,_that.categary,_that.blogType,_that.content,_that.resources,_that.addressId,_that.shareType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? squareId,  String? topicIds,  int? categary,  int? blogType,  String? content,  String? resources,  int? addressId,  int? shareType)  $default,) {final _that = this;
switch (_that) {
case _BlogSaveReqVO():
return $default(_that.id,_that.squareId,_that.topicIds,_that.categary,_that.blogType,_that.content,_that.resources,_that.addressId,_that.shareType);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? squareId,  String? topicIds,  int? categary,  int? blogType,  String? content,  String? resources,  int? addressId,  int? shareType)?  $default,) {final _that = this;
switch (_that) {
case _BlogSaveReqVO() when $default != null:
return $default(_that.id,_that.squareId,_that.topicIds,_that.categary,_that.blogType,_that.content,_that.resources,_that.addressId,_that.shareType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlogSaveReqVO implements BlogSaveReqVO {
  const _BlogSaveReqVO({this.id, this.squareId, this.topicIds, this.categary, this.blogType, this.content, this.resources, this.addressId, this.shareType});
  factory _BlogSaveReqVO.fromJson(Map<String, dynamic> json) => _$BlogSaveReqVOFromJson(json);

@override final  int? id;
@override final  int? squareId;
@override final  String? topicIds;
@override final  int? categary;
@override final  int? blogType;
@override final  String? content;
@override final  String? resources;
@override final  int? addressId;
@override final  int? shareType;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogSaveReqVO&&(identical(other.id, id) || other.id == id)&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.topicIds, topicIds) || other.topicIds == topicIds)&&(identical(other.categary, categary) || other.categary == categary)&&(identical(other.blogType, blogType) || other.blogType == blogType)&&(identical(other.content, content) || other.content == content)&&(identical(other.resources, resources) || other.resources == resources)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.shareType, shareType) || other.shareType == shareType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,squareId,topicIds,categary,blogType,content,resources,addressId,shareType);

@override
String toString() {
  return 'BlogSaveReqVO(id: $id, squareId: $squareId, topicIds: $topicIds, categary: $categary, blogType: $blogType, content: $content, resources: $resources, addressId: $addressId, shareType: $shareType)';
}


}

/// @nodoc
abstract mixin class _$BlogSaveReqVOCopyWith<$Res> implements $BlogSaveReqVOCopyWith<$Res> {
  factory _$BlogSaveReqVOCopyWith(_BlogSaveReqVO value, $Res Function(_BlogSaveReqVO) _then) = __$BlogSaveReqVOCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? squareId, String? topicIds, int? categary, int? blogType, String? content, String? resources, int? addressId, int? shareType
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? squareId = freezed,Object? topicIds = freezed,Object? categary = freezed,Object? blogType = freezed,Object? content = freezed,Object? resources = freezed,Object? addressId = freezed,Object? shareType = freezed,}) {
  return _then(_BlogSaveReqVO(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,squareId: freezed == squareId ? _self.squareId : squareId // ignore: cast_nullable_to_non_nullable
as int?,topicIds: freezed == topicIds ? _self.topicIds : topicIds // ignore: cast_nullable_to_non_nullable
as String?,categary: freezed == categary ? _self.categary : categary // ignore: cast_nullable_to_non_nullable
as int?,blogType: freezed == blogType ? _self.blogType : blogType // ignore: cast_nullable_to_non_nullable
as int?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,resources: freezed == resources ? _self.resources : resources // ignore: cast_nullable_to_non_nullable
as String?,addressId: freezed == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as int?,shareType: freezed == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'square_save_req_vo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SquareSaveReqVO {

 int get id; String get squareName; int? get userId; String? get squareImg; String? get squareDesc; int? get chatConversationId; int? get groupCreatorUserId;
/// Create a copy of SquareSaveReqVO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SquareSaveReqVOCopyWith<SquareSaveReqVO> get copyWith => _$SquareSaveReqVOCopyWithImpl<SquareSaveReqVO>(this as SquareSaveReqVO, _$identity);

  /// Serializes this SquareSaveReqVO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SquareSaveReqVO&&(identical(other.id, id) || other.id == id)&&(identical(other.squareName, squareName) || other.squareName == squareName)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.squareImg, squareImg) || other.squareImg == squareImg)&&(identical(other.squareDesc, squareDesc) || other.squareDesc == squareDesc)&&(identical(other.chatConversationId, chatConversationId) || other.chatConversationId == chatConversationId)&&(identical(other.groupCreatorUserId, groupCreatorUserId) || other.groupCreatorUserId == groupCreatorUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,squareName,userId,squareImg,squareDesc,chatConversationId,groupCreatorUserId);

@override
String toString() {
  return 'SquareSaveReqVO(id: $id, squareName: $squareName, userId: $userId, squareImg: $squareImg, squareDesc: $squareDesc, chatConversationId: $chatConversationId, groupCreatorUserId: $groupCreatorUserId)';
}


}

/// @nodoc
abstract mixin class $SquareSaveReqVOCopyWith<$Res>  {
  factory $SquareSaveReqVOCopyWith(SquareSaveReqVO value, $Res Function(SquareSaveReqVO) _then) = _$SquareSaveReqVOCopyWithImpl;
@useResult
$Res call({
 int id, String squareName, int? userId, String? squareImg, String? squareDesc, int? chatConversationId, int? groupCreatorUserId
});




}
/// @nodoc
class _$SquareSaveReqVOCopyWithImpl<$Res>
    implements $SquareSaveReqVOCopyWith<$Res> {
  _$SquareSaveReqVOCopyWithImpl(this._self, this._then);

  final SquareSaveReqVO _self;
  final $Res Function(SquareSaveReqVO) _then;

/// Create a copy of SquareSaveReqVO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? squareName = null,Object? userId = freezed,Object? squareImg = freezed,Object? squareDesc = freezed,Object? chatConversationId = freezed,Object? groupCreatorUserId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,squareName: null == squareName ? _self.squareName : squareName // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,squareImg: freezed == squareImg ? _self.squareImg : squareImg // ignore: cast_nullable_to_non_nullable
as String?,squareDesc: freezed == squareDesc ? _self.squareDesc : squareDesc // ignore: cast_nullable_to_non_nullable
as String?,chatConversationId: freezed == chatConversationId ? _self.chatConversationId : chatConversationId // ignore: cast_nullable_to_non_nullable
as int?,groupCreatorUserId: freezed == groupCreatorUserId ? _self.groupCreatorUserId : groupCreatorUserId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SquareSaveReqVO].
extension SquareSaveReqVOPatterns on SquareSaveReqVO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SquareSaveReqVO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SquareSaveReqVO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SquareSaveReqVO value)  $default,){
final _that = this;
switch (_that) {
case _SquareSaveReqVO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SquareSaveReqVO value)?  $default,){
final _that = this;
switch (_that) {
case _SquareSaveReqVO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String squareName,  int? userId,  String? squareImg,  String? squareDesc,  int? chatConversationId,  int? groupCreatorUserId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SquareSaveReqVO() when $default != null:
return $default(_that.id,_that.squareName,_that.userId,_that.squareImg,_that.squareDesc,_that.chatConversationId,_that.groupCreatorUserId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String squareName,  int? userId,  String? squareImg,  String? squareDesc,  int? chatConversationId,  int? groupCreatorUserId)  $default,) {final _that = this;
switch (_that) {
case _SquareSaveReqVO():
return $default(_that.id,_that.squareName,_that.userId,_that.squareImg,_that.squareDesc,_that.chatConversationId,_that.groupCreatorUserId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String squareName,  int? userId,  String? squareImg,  String? squareDesc,  int? chatConversationId,  int? groupCreatorUserId)?  $default,) {final _that = this;
switch (_that) {
case _SquareSaveReqVO() when $default != null:
return $default(_that.id,_that.squareName,_that.userId,_that.squareImg,_that.squareDesc,_that.chatConversationId,_that.groupCreatorUserId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SquareSaveReqVO implements SquareSaveReqVO {
  const _SquareSaveReqVO({required this.id, required this.squareName, this.userId, this.squareImg, this.squareDesc, this.chatConversationId, this.groupCreatorUserId});
  factory _SquareSaveReqVO.fromJson(Map<String, dynamic> json) => _$SquareSaveReqVOFromJson(json);

@override final  int id;
@override final  String squareName;
@override final  int? userId;
@override final  String? squareImg;
@override final  String? squareDesc;
@override final  int? chatConversationId;
@override final  int? groupCreatorUserId;

/// Create a copy of SquareSaveReqVO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SquareSaveReqVOCopyWith<_SquareSaveReqVO> get copyWith => __$SquareSaveReqVOCopyWithImpl<_SquareSaveReqVO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SquareSaveReqVOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SquareSaveReqVO&&(identical(other.id, id) || other.id == id)&&(identical(other.squareName, squareName) || other.squareName == squareName)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.squareImg, squareImg) || other.squareImg == squareImg)&&(identical(other.squareDesc, squareDesc) || other.squareDesc == squareDesc)&&(identical(other.chatConversationId, chatConversationId) || other.chatConversationId == chatConversationId)&&(identical(other.groupCreatorUserId, groupCreatorUserId) || other.groupCreatorUserId == groupCreatorUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,squareName,userId,squareImg,squareDesc,chatConversationId,groupCreatorUserId);

@override
String toString() {
  return 'SquareSaveReqVO(id: $id, squareName: $squareName, userId: $userId, squareImg: $squareImg, squareDesc: $squareDesc, chatConversationId: $chatConversationId, groupCreatorUserId: $groupCreatorUserId)';
}


}

/// @nodoc
abstract mixin class _$SquareSaveReqVOCopyWith<$Res> implements $SquareSaveReqVOCopyWith<$Res> {
  factory _$SquareSaveReqVOCopyWith(_SquareSaveReqVO value, $Res Function(_SquareSaveReqVO) _then) = __$SquareSaveReqVOCopyWithImpl;
@override @useResult
$Res call({
 int id, String squareName, int? userId, String? squareImg, String? squareDesc, int? chatConversationId, int? groupCreatorUserId
});




}
/// @nodoc
class __$SquareSaveReqVOCopyWithImpl<$Res>
    implements _$SquareSaveReqVOCopyWith<$Res> {
  __$SquareSaveReqVOCopyWithImpl(this._self, this._then);

  final _SquareSaveReqVO _self;
  final $Res Function(_SquareSaveReqVO) _then;

/// Create a copy of SquareSaveReqVO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? squareName = null,Object? userId = freezed,Object? squareImg = freezed,Object? squareDesc = freezed,Object? chatConversationId = freezed,Object? groupCreatorUserId = freezed,}) {
  return _then(_SquareSaveReqVO(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,squareName: null == squareName ? _self.squareName : squareName // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,squareImg: freezed == squareImg ? _self.squareImg : squareImg // ignore: cast_nullable_to_non_nullable
as String?,squareDesc: freezed == squareDesc ? _self.squareDesc : squareDesc // ignore: cast_nullable_to_non_nullable
as String?,chatConversationId: freezed == chatConversationId ? _self.chatConversationId : chatConversationId // ignore: cast_nullable_to_non_nullable
as int?,groupCreatorUserId: freezed == groupCreatorUserId ? _self.groupCreatorUserId : groupCreatorUserId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'square_create_req_vo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SquareCreateReqVO {

 String get squareName; String? get squareImg; String? get squareDesc;
/// Create a copy of SquareCreateReqVO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SquareCreateReqVOCopyWith<SquareCreateReqVO> get copyWith => _$SquareCreateReqVOCopyWithImpl<SquareCreateReqVO>(this as SquareCreateReqVO, _$identity);

  /// Serializes this SquareCreateReqVO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SquareCreateReqVO&&(identical(other.squareName, squareName) || other.squareName == squareName)&&(identical(other.squareImg, squareImg) || other.squareImg == squareImg)&&(identical(other.squareDesc, squareDesc) || other.squareDesc == squareDesc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,squareName,squareImg,squareDesc);

@override
String toString() {
  return 'SquareCreateReqVO(squareName: $squareName, squareImg: $squareImg, squareDesc: $squareDesc)';
}


}

/// @nodoc
abstract mixin class $SquareCreateReqVOCopyWith<$Res>  {
  factory $SquareCreateReqVOCopyWith(SquareCreateReqVO value, $Res Function(SquareCreateReqVO) _then) = _$SquareCreateReqVOCopyWithImpl;
@useResult
$Res call({
 String squareName, String? squareImg, String? squareDesc
});




}
/// @nodoc
class _$SquareCreateReqVOCopyWithImpl<$Res>
    implements $SquareCreateReqVOCopyWith<$Res> {
  _$SquareCreateReqVOCopyWithImpl(this._self, this._then);

  final SquareCreateReqVO _self;
  final $Res Function(SquareCreateReqVO) _then;

/// Create a copy of SquareCreateReqVO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? squareName = null,Object? squareImg = freezed,Object? squareDesc = freezed,}) {
  return _then(_self.copyWith(
squareName: null == squareName ? _self.squareName : squareName // ignore: cast_nullable_to_non_nullable
as String,squareImg: freezed == squareImg ? _self.squareImg : squareImg // ignore: cast_nullable_to_non_nullable
as String?,squareDesc: freezed == squareDesc ? _self.squareDesc : squareDesc // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SquareCreateReqVO].
extension SquareCreateReqVOPatterns on SquareCreateReqVO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SquareCreateReqVO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SquareCreateReqVO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SquareCreateReqVO value)  $default,){
final _that = this;
switch (_that) {
case _SquareCreateReqVO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SquareCreateReqVO value)?  $default,){
final _that = this;
switch (_that) {
case _SquareCreateReqVO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String squareName,  String? squareImg,  String? squareDesc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SquareCreateReqVO() when $default != null:
return $default(_that.squareName,_that.squareImg,_that.squareDesc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String squareName,  String? squareImg,  String? squareDesc)  $default,) {final _that = this;
switch (_that) {
case _SquareCreateReqVO():
return $default(_that.squareName,_that.squareImg,_that.squareDesc);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String squareName,  String? squareImg,  String? squareDesc)?  $default,) {final _that = this;
switch (_that) {
case _SquareCreateReqVO() when $default != null:
return $default(_that.squareName,_that.squareImg,_that.squareDesc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SquareCreateReqVO implements SquareCreateReqVO {
  const _SquareCreateReqVO({required this.squareName, this.squareImg, this.squareDesc});
  factory _SquareCreateReqVO.fromJson(Map<String, dynamic> json) => _$SquareCreateReqVOFromJson(json);

@override final  String squareName;
@override final  String? squareImg;
@override final  String? squareDesc;

/// Create a copy of SquareCreateReqVO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SquareCreateReqVOCopyWith<_SquareCreateReqVO> get copyWith => __$SquareCreateReqVOCopyWithImpl<_SquareCreateReqVO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SquareCreateReqVOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SquareCreateReqVO&&(identical(other.squareName, squareName) || other.squareName == squareName)&&(identical(other.squareImg, squareImg) || other.squareImg == squareImg)&&(identical(other.squareDesc, squareDesc) || other.squareDesc == squareDesc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,squareName,squareImg,squareDesc);

@override
String toString() {
  return 'SquareCreateReqVO(squareName: $squareName, squareImg: $squareImg, squareDesc: $squareDesc)';
}


}

/// @nodoc
abstract mixin class _$SquareCreateReqVOCopyWith<$Res> implements $SquareCreateReqVOCopyWith<$Res> {
  factory _$SquareCreateReqVOCopyWith(_SquareCreateReqVO value, $Res Function(_SquareCreateReqVO) _then) = __$SquareCreateReqVOCopyWithImpl;
@override @useResult
$Res call({
 String squareName, String? squareImg, String? squareDesc
});




}
/// @nodoc
class __$SquareCreateReqVOCopyWithImpl<$Res>
    implements _$SquareCreateReqVOCopyWith<$Res> {
  __$SquareCreateReqVOCopyWithImpl(this._self, this._then);

  final _SquareCreateReqVO _self;
  final $Res Function(_SquareCreateReqVO) _then;

/// Create a copy of SquareCreateReqVO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? squareName = null,Object? squareImg = freezed,Object? squareDesc = freezed,}) {
  return _then(_SquareCreateReqVO(
squareName: null == squareName ? _self.squareName : squareName // ignore: cast_nullable_to_non_nullable
as String,squareImg: freezed == squareImg ? _self.squareImg : squareImg // ignore: cast_nullable_to_non_nullable
as String?,squareDesc: freezed == squareDesc ? _self.squareDesc : squareDesc // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

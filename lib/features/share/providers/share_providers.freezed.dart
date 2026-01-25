// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShareState {

// freezed 的 @Default 必须是 const
 AsyncValue<SharePageModelData> get sharePageModelData; String? get error;
/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareStateCopyWith<ShareState> get copyWith => _$ShareStateCopyWithImpl<ShareState>(this as ShareState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareState&&(identical(other.sharePageModelData, sharePageModelData) || other.sharePageModelData == sharePageModelData)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,sharePageModelData,error);

@override
String toString() {
  return 'ShareState(sharePageModelData: $sharePageModelData, error: $error)';
}


}

/// @nodoc
abstract mixin class $ShareStateCopyWith<$Res>  {
  factory $ShareStateCopyWith(ShareState value, $Res Function(ShareState) _then) = _$ShareStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<SharePageModelData> sharePageModelData, String? error
});




}
/// @nodoc
class _$ShareStateCopyWithImpl<$Res>
    implements $ShareStateCopyWith<$Res> {
  _$ShareStateCopyWithImpl(this._self, this._then);

  final ShareState _self;
  final $Res Function(ShareState) _then;

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sharePageModelData = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
sharePageModelData: null == sharePageModelData ? _self.sharePageModelData : sharePageModelData // ignore: cast_nullable_to_non_nullable
as AsyncValue<SharePageModelData>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShareState].
extension ShareStatePatterns on ShareState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShareState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShareState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShareState value)  $default,){
final _that = this;
switch (_that) {
case _ShareState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShareState value)?  $default,){
final _that = this;
switch (_that) {
case _ShareState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<SharePageModelData> sharePageModelData,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShareState() when $default != null:
return $default(_that.sharePageModelData,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<SharePageModelData> sharePageModelData,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ShareState():
return $default(_that.sharePageModelData,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<SharePageModelData> sharePageModelData,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ShareState() when $default != null:
return $default(_that.sharePageModelData,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ShareState implements ShareState {
  const _ShareState({this.sharePageModelData = const AsyncLoading(), this.error});
  

// freezed 的 @Default 必须是 const
@override@JsonKey() final  AsyncValue<SharePageModelData> sharePageModelData;
@override final  String? error;

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShareStateCopyWith<_ShareState> get copyWith => __$ShareStateCopyWithImpl<_ShareState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShareState&&(identical(other.sharePageModelData, sharePageModelData) || other.sharePageModelData == sharePageModelData)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,sharePageModelData,error);

@override
String toString() {
  return 'ShareState(sharePageModelData: $sharePageModelData, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ShareStateCopyWith<$Res> implements $ShareStateCopyWith<$Res> {
  factory _$ShareStateCopyWith(_ShareState value, $Res Function(_ShareState) _then) = __$ShareStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<SharePageModelData> sharePageModelData, String? error
});




}
/// @nodoc
class __$ShareStateCopyWithImpl<$Res>
    implements _$ShareStateCopyWith<$Res> {
  __$ShareStateCopyWithImpl(this._self, this._then);

  final _ShareState _self;
  final $Res Function(_ShareState) _then;

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sharePageModelData = null,Object? error = freezed,}) {
  return _then(_ShareState(
sharePageModelData: null == sharePageModelData ? _self.sharePageModelData : sharePageModelData // ignore: cast_nullable_to_non_nullable
as AsyncValue<SharePageModelData>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'square_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SquareState {

// freezed 的 @Default 必须是 const
 AsyncValue<List<SquareModel>> get items; String? get error;
/// Create a copy of SquareState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SquareStateCopyWith<SquareState> get copyWith => _$SquareStateCopyWithImpl<SquareState>(this as SquareState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SquareState&&(identical(other.items, items) || other.items == items)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,items,error);

@override
String toString() {
  return 'SquareState(items: $items, error: $error)';
}


}

/// @nodoc
abstract mixin class $SquareStateCopyWith<$Res>  {
  factory $SquareStateCopyWith(SquareState value, $Res Function(SquareState) _then) = _$SquareStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<List<SquareModel>> items, String? error
});




}
/// @nodoc
class _$SquareStateCopyWithImpl<$Res>
    implements $SquareStateCopyWith<$Res> {
  _$SquareStateCopyWithImpl(this._self, this._then);

  final SquareState _self;
  final $Res Function(SquareState) _then;

/// Create a copy of SquareState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<SquareModel>>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SquareState].
extension SquareStatePatterns on SquareState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SquareState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SquareState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SquareState value)  $default,){
final _that = this;
switch (_that) {
case _SquareState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SquareState value)?  $default,){
final _that = this;
switch (_that) {
case _SquareState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<List<SquareModel>> items,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SquareState() when $default != null:
return $default(_that.items,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<List<SquareModel>> items,  String? error)  $default,) {final _that = this;
switch (_that) {
case _SquareState():
return $default(_that.items,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<List<SquareModel>> items,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _SquareState() when $default != null:
return $default(_that.items,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _SquareState implements SquareState {
  const _SquareState({this.items = const AsyncLoading(), this.error});
  

// freezed 的 @Default 必须是 const
@override@JsonKey() final  AsyncValue<List<SquareModel>> items;
@override final  String? error;

/// Create a copy of SquareState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SquareStateCopyWith<_SquareState> get copyWith => __$SquareStateCopyWithImpl<_SquareState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SquareState&&(identical(other.items, items) || other.items == items)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,items,error);

@override
String toString() {
  return 'SquareState(items: $items, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SquareStateCopyWith<$Res> implements $SquareStateCopyWith<$Res> {
  factory _$SquareStateCopyWith(_SquareState value, $Res Function(_SquareState) _then) = __$SquareStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<List<SquareModel>> items, String? error
});




}
/// @nodoc
class __$SquareStateCopyWithImpl<$Res>
    implements _$SquareStateCopyWith<$Res> {
  __$SquareStateCopyWithImpl(this._self, this._then);

  final _SquareState _self;
  final $Res Function(_SquareState) _then;

/// Create a copy of SquareState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? error = freezed,}) {
  return _then(_SquareState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<SquareModel>>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

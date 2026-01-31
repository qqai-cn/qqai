// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goods_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoodsState {

// freezed 的 @Default 必须是 const
 AsyncValue<List<GoodsModel>> get items; String? get error;
/// Create a copy of GoodsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoodsStateCopyWith<GoodsState> get copyWith => _$GoodsStateCopyWithImpl<GoodsState>(this as GoodsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoodsState&&(identical(other.items, items) || other.items == items)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,items,error);

@override
String toString() {
  return 'GoodsState(items: $items, error: $error)';
}


}

/// @nodoc
abstract mixin class $GoodsStateCopyWith<$Res>  {
  factory $GoodsStateCopyWith(GoodsState value, $Res Function(GoodsState) _then) = _$GoodsStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<List<GoodsModel>> items, String? error
});




}
/// @nodoc
class _$GoodsStateCopyWithImpl<$Res>
    implements $GoodsStateCopyWith<$Res> {
  _$GoodsStateCopyWithImpl(this._self, this._then);

  final GoodsState _self;
  final $Res Function(GoodsState) _then;

/// Create a copy of GoodsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<GoodsModel>>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GoodsState].
extension GoodsStatePatterns on GoodsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoodsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoodsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoodsState value)  $default,){
final _that = this;
switch (_that) {
case _GoodsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoodsState value)?  $default,){
final _that = this;
switch (_that) {
case _GoodsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<List<GoodsModel>> items,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoodsState() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<List<GoodsModel>> items,  String? error)  $default,) {final _that = this;
switch (_that) {
case _GoodsState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<List<GoodsModel>> items,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _GoodsState() when $default != null:
return $default(_that.items,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _GoodsState implements GoodsState {
  const _GoodsState({this.items = const AsyncLoading(), this.error});
  

// freezed 的 @Default 必须是 const
@override@JsonKey() final  AsyncValue<List<GoodsModel>> items;
@override final  String? error;

/// Create a copy of GoodsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoodsStateCopyWith<_GoodsState> get copyWith => __$GoodsStateCopyWithImpl<_GoodsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoodsState&&(identical(other.items, items) || other.items == items)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,items,error);

@override
String toString() {
  return 'GoodsState(items: $items, error: $error)';
}


}

/// @nodoc
abstract mixin class _$GoodsStateCopyWith<$Res> implements $GoodsStateCopyWith<$Res> {
  factory _$GoodsStateCopyWith(_GoodsState value, $Res Function(_GoodsState) _then) = __$GoodsStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<List<GoodsModel>> items, String? error
});




}
/// @nodoc
class __$GoodsStateCopyWithImpl<$Res>
    implements _$GoodsStateCopyWith<$Res> {
  __$GoodsStateCopyWithImpl(this._self, this._then);

  final _GoodsState _self;
  final $Res Function(_GoodsState) _then;

/// Create a copy of GoodsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? error = freezed,}) {
  return _then(_GoodsState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<GoodsModel>>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

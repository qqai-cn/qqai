// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flow_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FlowState {

 AsyncValue<List<FlowModel>> get items; String? get error;
/// Create a copy of FlowState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlowStateCopyWith<FlowState> get copyWith => _$FlowStateCopyWithImpl<FlowState>(this as FlowState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlowState&&(identical(other.items, items) || other.items == items)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,items,error);

@override
String toString() {
  return 'FlowState(items: $items, error: $error)';
}


}

/// @nodoc
abstract mixin class $FlowStateCopyWith<$Res>  {
  factory $FlowStateCopyWith(FlowState value, $Res Function(FlowState) _then) = _$FlowStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<List<FlowModel>> items, String? error
});




}
/// @nodoc
class _$FlowStateCopyWithImpl<$Res>
    implements $FlowStateCopyWith<$Res> {
  _$FlowStateCopyWithImpl(this._self, this._then);

  final FlowState _self;
  final $Res Function(FlowState) _then;

/// Create a copy of FlowState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<FlowModel>>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FlowState].
extension FlowStatePatterns on FlowState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlowState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlowState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlowState value)  $default,){
final _that = this;
switch (_that) {
case _FlowState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlowState value)?  $default,){
final _that = this;
switch (_that) {
case _FlowState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<List<FlowModel>> items,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlowState() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<List<FlowModel>> items,  String? error)  $default,) {final _that = this;
switch (_that) {
case _FlowState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<List<FlowModel>> items,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _FlowState() when $default != null:
return $default(_that.items,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _FlowState implements FlowState {
  const _FlowState({this.items = const AsyncLoading(), this.error});
  

@override@JsonKey() final  AsyncValue<List<FlowModel>> items;
@override final  String? error;

/// Create a copy of FlowState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlowStateCopyWith<_FlowState> get copyWith => __$FlowStateCopyWithImpl<_FlowState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlowState&&(identical(other.items, items) || other.items == items)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,items,error);

@override
String toString() {
  return 'FlowState(items: $items, error: $error)';
}


}

/// @nodoc
abstract mixin class _$FlowStateCopyWith<$Res> implements $FlowStateCopyWith<$Res> {
  factory _$FlowStateCopyWith(_FlowState value, $Res Function(_FlowState) _then) = __$FlowStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<List<FlowModel>> items, String? error
});




}
/// @nodoc
class __$FlowStateCopyWithImpl<$Res>
    implements _$FlowStateCopyWith<$Res> {
  __$FlowStateCopyWithImpl(this._self, this._then);

  final _FlowState _self;
  final $Res Function(_FlowState) _then;

/// Create a copy of FlowState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? error = freezed,}) {
  return _then(_FlowState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<FlowModel>>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

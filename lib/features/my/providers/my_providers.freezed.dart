// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyState {

// freezed 的 @Default 必须是 const
 AsyncValue<BlogPageModelData> get blogPageData; String? get error;
/// Create a copy of MyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyStateCopyWith<MyState> get copyWith => _$MyStateCopyWithImpl<MyState>(this as MyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyState&&(identical(other.blogPageData, blogPageData) || other.blogPageData == blogPageData)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,blogPageData,error);

@override
String toString() {
  return 'MyState(blogPageData: $blogPageData, error: $error)';
}


}

/// @nodoc
abstract mixin class $MyStateCopyWith<$Res>  {
  factory $MyStateCopyWith(MyState value, $Res Function(MyState) _then) = _$MyStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<BlogPageModelData> blogPageData, String? error
});




}
/// @nodoc
class _$MyStateCopyWithImpl<$Res>
    implements $MyStateCopyWith<$Res> {
  _$MyStateCopyWithImpl(this._self, this._then);

  final MyState _self;
  final $Res Function(MyState) _then;

/// Create a copy of MyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? blogPageData = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
blogPageData: null == blogPageData ? _self.blogPageData : blogPageData // ignore: cast_nullable_to_non_nullable
as AsyncValue<BlogPageModelData>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MyState].
extension MyStatePatterns on MyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyState value)  $default,){
final _that = this;
switch (_that) {
case _MyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyState value)?  $default,){
final _that = this;
switch (_that) {
case _MyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<BlogPageModelData> blogPageData,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyState() when $default != null:
return $default(_that.blogPageData,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<BlogPageModelData> blogPageData,  String? error)  $default,) {final _that = this;
switch (_that) {
case _MyState():
return $default(_that.blogPageData,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<BlogPageModelData> blogPageData,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _MyState() when $default != null:
return $default(_that.blogPageData,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _MyState implements MyState {
  const _MyState({this.blogPageData = const AsyncLoading(), this.error});
  

// freezed 的 @Default 必须是 const
@override@JsonKey() final  AsyncValue<BlogPageModelData> blogPageData;
@override final  String? error;

/// Create a copy of MyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyStateCopyWith<_MyState> get copyWith => __$MyStateCopyWithImpl<_MyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyState&&(identical(other.blogPageData, blogPageData) || other.blogPageData == blogPageData)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,blogPageData,error);

@override
String toString() {
  return 'MyState(blogPageData: $blogPageData, error: $error)';
}


}

/// @nodoc
abstract mixin class _$MyStateCopyWith<$Res> implements $MyStateCopyWith<$Res> {
  factory _$MyStateCopyWith(_MyState value, $Res Function(_MyState) _then) = __$MyStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<BlogPageModelData> blogPageData, String? error
});




}
/// @nodoc
class __$MyStateCopyWithImpl<$Res>
    implements _$MyStateCopyWith<$Res> {
  __$MyStateCopyWithImpl(this._self, this._then);

  final _MyState _self;
  final $Res Function(_MyState) _then;

/// Create a copy of MyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? blogPageData = null,Object? error = freezed,}) {
  return _then(_MyState(
blogPageData: null == blogPageData ? _self.blogPageData : blogPageData // ignore: cast_nullable_to_non_nullable
as AsyncValue<BlogPageModelData>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

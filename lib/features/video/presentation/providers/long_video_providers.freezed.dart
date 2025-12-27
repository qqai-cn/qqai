// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'long_video_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LongVideoState {

 List<String> get videoItems;
/// Create a copy of LongVideoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LongVideoStateCopyWith<LongVideoState> get copyWith => _$LongVideoStateCopyWithImpl<LongVideoState>(this as LongVideoState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LongVideoState&&const DeepCollectionEquality().equals(other.videoItems, videoItems));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(videoItems));

@override
String toString() {
  return 'LongVideoState(videoItems: $videoItems)';
}


}

/// @nodoc
abstract mixin class $LongVideoStateCopyWith<$Res>  {
  factory $LongVideoStateCopyWith(LongVideoState value, $Res Function(LongVideoState) _then) = _$LongVideoStateCopyWithImpl;
@useResult
$Res call({
 List<String> videoItems
});




}
/// @nodoc
class _$LongVideoStateCopyWithImpl<$Res>
    implements $LongVideoStateCopyWith<$Res> {
  _$LongVideoStateCopyWithImpl(this._self, this._then);

  final LongVideoState _self;
  final $Res Function(LongVideoState) _then;

/// Create a copy of LongVideoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? videoItems = null,}) {
  return _then(_self.copyWith(
videoItems: null == videoItems ? _self.videoItems : videoItems // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [LongVideoState].
extension LongVideoStatePatterns on LongVideoState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LongVideoState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LongVideoState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LongVideoState value)  $default,){
final _that = this;
switch (_that) {
case _LongVideoState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LongVideoState value)?  $default,){
final _that = this;
switch (_that) {
case _LongVideoState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> videoItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LongVideoState() when $default != null:
return $default(_that.videoItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> videoItems)  $default,) {final _that = this;
switch (_that) {
case _LongVideoState():
return $default(_that.videoItems);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> videoItems)?  $default,) {final _that = this;
switch (_that) {
case _LongVideoState() when $default != null:
return $default(_that.videoItems);case _:
  return null;

}
}

}

/// @nodoc


class _LongVideoState implements LongVideoState {
  const _LongVideoState({final  List<String> videoItems = const []}): _videoItems = videoItems;
  

 final  List<String> _videoItems;
@override@JsonKey() List<String> get videoItems {
  if (_videoItems is EqualUnmodifiableListView) return _videoItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videoItems);
}


/// Create a copy of LongVideoState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LongVideoStateCopyWith<_LongVideoState> get copyWith => __$LongVideoStateCopyWithImpl<_LongVideoState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LongVideoState&&const DeepCollectionEquality().equals(other._videoItems, _videoItems));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_videoItems));

@override
String toString() {
  return 'LongVideoState(videoItems: $videoItems)';
}


}

/// @nodoc
abstract mixin class _$LongVideoStateCopyWith<$Res> implements $LongVideoStateCopyWith<$Res> {
  factory _$LongVideoStateCopyWith(_LongVideoState value, $Res Function(_LongVideoState) _then) = __$LongVideoStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> videoItems
});




}
/// @nodoc
class __$LongVideoStateCopyWithImpl<$Res>
    implements _$LongVideoStateCopyWith<$Res> {
  __$LongVideoStateCopyWithImpl(this._self, this._then);

  final _LongVideoState _self;
  final $Res Function(_LongVideoState) _then;

/// Create a copy of LongVideoState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? videoItems = null,}) {
  return _then(_LongVideoState(
videoItems: null == videoItems ? _self._videoItems : videoItems // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on

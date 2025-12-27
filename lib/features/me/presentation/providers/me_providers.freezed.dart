// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'me_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MeState {

 int get name; List<dynamic>? get data; TextEditingController get controller; List<SkuuBlogPageDataRecords> get skuuBlogPageDataRecords;
/// Create a copy of MeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeStateCopyWith<MeState> get copyWith => _$MeStateCopyWithImpl<MeState>(this as MeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeState&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.controller, controller) || other.controller == controller)&&const DeepCollectionEquality().equals(other.skuuBlogPageDataRecords, skuuBlogPageDataRecords));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(data),controller,const DeepCollectionEquality().hash(skuuBlogPageDataRecords));

@override
String toString() {
  return 'MeState(name: $name, data: $data, controller: $controller, skuuBlogPageDataRecords: $skuuBlogPageDataRecords)';
}


}

/// @nodoc
abstract mixin class $MeStateCopyWith<$Res>  {
  factory $MeStateCopyWith(MeState value, $Res Function(MeState) _then) = _$MeStateCopyWithImpl;
@useResult
$Res call({
 int name, List<dynamic>? data, TextEditingController controller, List<SkuuBlogPageDataRecords> skuuBlogPageDataRecords
});




}
/// @nodoc
class _$MeStateCopyWithImpl<$Res>
    implements $MeStateCopyWith<$Res> {
  _$MeStateCopyWithImpl(this._self, this._then);

  final MeState _self;
  final $Res Function(MeState) _then;

/// Create a copy of MeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? data = freezed,Object? controller = null,Object? skuuBlogPageDataRecords = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as int,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,controller: null == controller ? _self.controller : controller // ignore: cast_nullable_to_non_nullable
as TextEditingController,skuuBlogPageDataRecords: null == skuuBlogPageDataRecords ? _self.skuuBlogPageDataRecords : skuuBlogPageDataRecords // ignore: cast_nullable_to_non_nullable
as List<SkuuBlogPageDataRecords>,
  ));
}

}


/// Adds pattern-matching-related methods to [MeState].
extension MeStatePatterns on MeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeState value)  $default,){
final _that = this;
switch (_that) {
case _MeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeState value)?  $default,){
final _that = this;
switch (_that) {
case _MeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int name,  List<dynamic>? data,  TextEditingController controller,  List<SkuuBlogPageDataRecords> skuuBlogPageDataRecords)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeState() when $default != null:
return $default(_that.name,_that.data,_that.controller,_that.skuuBlogPageDataRecords);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int name,  List<dynamic>? data,  TextEditingController controller,  List<SkuuBlogPageDataRecords> skuuBlogPageDataRecords)  $default,) {final _that = this;
switch (_that) {
case _MeState():
return $default(_that.name,_that.data,_that.controller,_that.skuuBlogPageDataRecords);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int name,  List<dynamic>? data,  TextEditingController controller,  List<SkuuBlogPageDataRecords> skuuBlogPageDataRecords)?  $default,) {final _that = this;
switch (_that) {
case _MeState() when $default != null:
return $default(_that.name,_that.data,_that.controller,_that.skuuBlogPageDataRecords);case _:
  return null;

}
}

}

/// @nodoc


class _MeState implements MeState {
  const _MeState({this.name = 1, final  List<dynamic>? data, required this.controller, final  List<SkuuBlogPageDataRecords> skuuBlogPageDataRecords = const []}): _data = data,_skuuBlogPageDataRecords = skuuBlogPageDataRecords;
  

@override@JsonKey() final  int name;
 final  List<dynamic>? _data;
@override List<dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  TextEditingController controller;
 final  List<SkuuBlogPageDataRecords> _skuuBlogPageDataRecords;
@override@JsonKey() List<SkuuBlogPageDataRecords> get skuuBlogPageDataRecords {
  if (_skuuBlogPageDataRecords is EqualUnmodifiableListView) return _skuuBlogPageDataRecords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skuuBlogPageDataRecords);
}


/// Create a copy of MeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeStateCopyWith<_MeState> get copyWith => __$MeStateCopyWithImpl<_MeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeState&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.controller, controller) || other.controller == controller)&&const DeepCollectionEquality().equals(other._skuuBlogPageDataRecords, _skuuBlogPageDataRecords));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_data),controller,const DeepCollectionEquality().hash(_skuuBlogPageDataRecords));

@override
String toString() {
  return 'MeState(name: $name, data: $data, controller: $controller, skuuBlogPageDataRecords: $skuuBlogPageDataRecords)';
}


}

/// @nodoc
abstract mixin class _$MeStateCopyWith<$Res> implements $MeStateCopyWith<$Res> {
  factory _$MeStateCopyWith(_MeState value, $Res Function(_MeState) _then) = __$MeStateCopyWithImpl;
@override @useResult
$Res call({
 int name, List<dynamic>? data, TextEditingController controller, List<SkuuBlogPageDataRecords> skuuBlogPageDataRecords
});




}
/// @nodoc
class __$MeStateCopyWithImpl<$Res>
    implements _$MeStateCopyWith<$Res> {
  __$MeStateCopyWithImpl(this._self, this._then);

  final _MeState _self;
  final $Res Function(_MeState) _then;

/// Create a copy of MeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? data = freezed,Object? controller = null,Object? skuuBlogPageDataRecords = null,}) {
  return _then(_MeState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as int,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,controller: null == controller ? _self.controller : controller // ignore: cast_nullable_to_non_nullable
as TextEditingController,skuuBlogPageDataRecords: null == skuuBlogPageDataRecords ? _self._skuuBlogPageDataRecords : skuuBlogPageDataRecords // ignore: cast_nullable_to_non_nullable
as List<SkuuBlogPageDataRecords>,
  ));
}


}

// dart format on

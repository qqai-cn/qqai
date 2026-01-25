// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'square_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SquareModel {

 String get id; String get title; bool get isDone;
/// Create a copy of SquareModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SquareModelCopyWith<SquareModel> get copyWith => _$SquareModelCopyWithImpl<SquareModel>(this as SquareModel, _$identity);

  /// Serializes this SquareModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SquareModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.isDone, isDone) || other.isDone == isDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,isDone);

@override
String toString() {
  return 'SquareModel(id: $id, title: $title, isDone: $isDone)';
}


}

/// @nodoc
abstract mixin class $SquareModelCopyWith<$Res>  {
  factory $SquareModelCopyWith(SquareModel value, $Res Function(SquareModel) _then) = _$SquareModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, bool isDone
});




}
/// @nodoc
class _$SquareModelCopyWithImpl<$Res>
    implements $SquareModelCopyWith<$Res> {
  _$SquareModelCopyWithImpl(this._self, this._then);

  final SquareModel _self;
  final $Res Function(SquareModel) _then;

/// Create a copy of SquareModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? isDone = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SquareModel].
extension SquareModelPatterns on SquareModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SquareModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SquareModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SquareModel value)  $default,){
final _that = this;
switch (_that) {
case _SquareModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SquareModel value)?  $default,){
final _that = this;
switch (_that) {
case _SquareModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  bool isDone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SquareModel() when $default != null:
return $default(_that.id,_that.title,_that.isDone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  bool isDone)  $default,) {final _that = this;
switch (_that) {
case _SquareModel():
return $default(_that.id,_that.title,_that.isDone);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  bool isDone)?  $default,) {final _that = this;
switch (_that) {
case _SquareModel() when $default != null:
return $default(_that.id,_that.title,_that.isDone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SquareModel implements SquareModel {
  const _SquareModel({required this.id, required this.title, this.isDone = false});
  factory _SquareModel.fromJson(Map<String, dynamic> json) => _$SquareModelFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  bool isDone;

/// Create a copy of SquareModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SquareModelCopyWith<_SquareModel> get copyWith => __$SquareModelCopyWithImpl<_SquareModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SquareModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SquareModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.isDone, isDone) || other.isDone == isDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,isDone);

@override
String toString() {
  return 'SquareModel(id: $id, title: $title, isDone: $isDone)';
}


}

/// @nodoc
abstract mixin class _$SquareModelCopyWith<$Res> implements $SquareModelCopyWith<$Res> {
  factory _$SquareModelCopyWith(_SquareModel value, $Res Function(_SquareModel) _then) = __$SquareModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, bool isDone
});




}
/// @nodoc
class __$SquareModelCopyWithImpl<$Res>
    implements _$SquareModelCopyWith<$Res> {
  __$SquareModelCopyWithImpl(this._self, this._then);

  final _SquareModel _self;
  final $Res Function(_SquareModel) _then;

/// Create a copy of SquareModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? isDone = null,}) {
  return _then(_SquareModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

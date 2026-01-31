// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fabu_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FabuModel {

 String get id; String get title; bool get isDone;
/// Create a copy of FabuModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FabuModelCopyWith<FabuModel> get copyWith => _$FabuModelCopyWithImpl<FabuModel>(this as FabuModel, _$identity);

  /// Serializes this FabuModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FabuModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.isDone, isDone) || other.isDone == isDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,isDone);

@override
String toString() {
  return 'FabuModel(id: $id, title: $title, isDone: $isDone)';
}


}

/// @nodoc
abstract mixin class $FabuModelCopyWith<$Res>  {
  factory $FabuModelCopyWith(FabuModel value, $Res Function(FabuModel) _then) = _$FabuModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, bool isDone
});




}
/// @nodoc
class _$FabuModelCopyWithImpl<$Res>
    implements $FabuModelCopyWith<$Res> {
  _$FabuModelCopyWithImpl(this._self, this._then);

  final FabuModel _self;
  final $Res Function(FabuModel) _then;

/// Create a copy of FabuModel
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


/// Adds pattern-matching-related methods to [FabuModel].
extension FabuModelPatterns on FabuModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FabuModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FabuModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FabuModel value)  $default,){
final _that = this;
switch (_that) {
case _FabuModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FabuModel value)?  $default,){
final _that = this;
switch (_that) {
case _FabuModel() when $default != null:
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
case _FabuModel() when $default != null:
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
case _FabuModel():
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
case _FabuModel() when $default != null:
return $default(_that.id,_that.title,_that.isDone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FabuModel implements FabuModel {
  const _FabuModel({required this.id, required this.title, this.isDone = false});
  factory _FabuModel.fromJson(Map<String, dynamic> json) => _$FabuModelFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  bool isDone;

/// Create a copy of FabuModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FabuModelCopyWith<_FabuModel> get copyWith => __$FabuModelCopyWithImpl<_FabuModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FabuModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FabuModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.isDone, isDone) || other.isDone == isDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,isDone);

@override
String toString() {
  return 'FabuModel(id: $id, title: $title, isDone: $isDone)';
}


}

/// @nodoc
abstract mixin class _$FabuModelCopyWith<$Res> implements $FabuModelCopyWith<$Res> {
  factory _$FabuModelCopyWith(_FabuModel value, $Res Function(_FabuModel) _then) = __$FabuModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, bool isDone
});




}
/// @nodoc
class __$FabuModelCopyWithImpl<$Res>
    implements _$FabuModelCopyWith<$Res> {
  __$FabuModelCopyWithImpl(this._self, this._then);

  final _FabuModel _self;
  final $Res Function(_FabuModel) _then;

/// Create a copy of FabuModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? isDone = null,}) {
  return _then(_FabuModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

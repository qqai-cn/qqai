// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShareModel {

 String get id; String get title; bool get isDone;
/// Create a copy of ShareModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareModelCopyWith<ShareModel> get copyWith => _$ShareModelCopyWithImpl<ShareModel>(this as ShareModel, _$identity);

  /// Serializes this ShareModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.isDone, isDone) || other.isDone == isDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,isDone);

@override
String toString() {
  return 'ShareModel(id: $id, title: $title, isDone: $isDone)';
}


}

/// @nodoc
abstract mixin class $ShareModelCopyWith<$Res>  {
  factory $ShareModelCopyWith(ShareModel value, $Res Function(ShareModel) _then) = _$ShareModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, bool isDone
});




}
/// @nodoc
class _$ShareModelCopyWithImpl<$Res>
    implements $ShareModelCopyWith<$Res> {
  _$ShareModelCopyWithImpl(this._self, this._then);

  final ShareModel _self;
  final $Res Function(ShareModel) _then;

/// Create a copy of ShareModel
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


/// Adds pattern-matching-related methods to [ShareModel].
extension ShareModelPatterns on ShareModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShareModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShareModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShareModel value)  $default,){
final _that = this;
switch (_that) {
case _ShareModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShareModel value)?  $default,){
final _that = this;
switch (_that) {
case _ShareModel() when $default != null:
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
case _ShareModel() when $default != null:
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
case _ShareModel():
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
case _ShareModel() when $default != null:
return $default(_that.id,_that.title,_that.isDone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShareModel implements ShareModel {
  const _ShareModel({required this.id, required this.title, this.isDone = false});
  factory _ShareModel.fromJson(Map<String, dynamic> json) => _$ShareModelFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  bool isDone;

/// Create a copy of ShareModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShareModelCopyWith<_ShareModel> get copyWith => __$ShareModelCopyWithImpl<_ShareModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShareModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShareModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.isDone, isDone) || other.isDone == isDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,isDone);

@override
String toString() {
  return 'ShareModel(id: $id, title: $title, isDone: $isDone)';
}


}

/// @nodoc
abstract mixin class _$ShareModelCopyWith<$Res> implements $ShareModelCopyWith<$Res> {
  factory _$ShareModelCopyWith(_ShareModel value, $Res Function(_ShareModel) _then) = __$ShareModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, bool isDone
});




}
/// @nodoc
class __$ShareModelCopyWithImpl<$Res>
    implements _$ShareModelCopyWith<$Res> {
  __$ShareModelCopyWithImpl(this._self, this._then);

  final _ShareModel _self;
  final $Res Function(_ShareModel) _then;

/// Create a copy of ShareModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? isDone = null,}) {
  return _then(_ShareModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

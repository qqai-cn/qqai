// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preview_img.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PreviewImg {

 int? get id; String? get url; String? get heroTag; int? get index; List<String> get allUris;
/// Create a copy of PreviewImg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreviewImgCopyWith<PreviewImg> get copyWith => _$PreviewImgCopyWithImpl<PreviewImg>(this as PreviewImg, _$identity);

  /// Serializes this PreviewImg to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreviewImg&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.heroTag, heroTag) || other.heroTag == heroTag)&&(identical(other.index, index) || other.index == index)&&const DeepCollectionEquality().equals(other.allUris, allUris));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,heroTag,index,const DeepCollectionEquality().hash(allUris));

@override
String toString() {
  return 'PreviewImg(id: $id, url: $url, heroTag: $heroTag, index: $index, allUris: $allUris)';
}


}

/// @nodoc
abstract mixin class $PreviewImgCopyWith<$Res>  {
  factory $PreviewImgCopyWith(PreviewImg value, $Res Function(PreviewImg) _then) = _$PreviewImgCopyWithImpl;
@useResult
$Res call({
 int? id, String? url, String? heroTag, int? index, List<String> allUris
});




}
/// @nodoc
class _$PreviewImgCopyWithImpl<$Res>
    implements $PreviewImgCopyWith<$Res> {
  _$PreviewImgCopyWithImpl(this._self, this._then);

  final PreviewImg _self;
  final $Res Function(PreviewImg) _then;

/// Create a copy of PreviewImg
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? url = freezed,Object? heroTag = freezed,Object? index = freezed,Object? allUris = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,heroTag: freezed == heroTag ? _self.heroTag : heroTag // ignore: cast_nullable_to_non_nullable
as String?,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,allUris: null == allUris ? _self.allUris : allUris // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PreviewImg].
extension PreviewImgPatterns on PreviewImg {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreviewImg value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreviewImg() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreviewImg value)  $default,){
final _that = this;
switch (_that) {
case _PreviewImg():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreviewImg value)?  $default,){
final _that = this;
switch (_that) {
case _PreviewImg() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? url,  String? heroTag,  int? index,  List<String> allUris)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreviewImg() when $default != null:
return $default(_that.id,_that.url,_that.heroTag,_that.index,_that.allUris);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? url,  String? heroTag,  int? index,  List<String> allUris)  $default,) {final _that = this;
switch (_that) {
case _PreviewImg():
return $default(_that.id,_that.url,_that.heroTag,_that.index,_that.allUris);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? url,  String? heroTag,  int? index,  List<String> allUris)?  $default,) {final _that = this;
switch (_that) {
case _PreviewImg() when $default != null:
return $default(_that.id,_that.url,_that.heroTag,_that.index,_that.allUris);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreviewImg implements PreviewImg {
  const _PreviewImg({this.id, this.url, this.heroTag, this.index, final  List<String> allUris = const []}): _allUris = allUris;
  factory _PreviewImg.fromJson(Map<String, dynamic> json) => _$PreviewImgFromJson(json);

@override final  int? id;
@override final  String? url;
@override final  String? heroTag;
@override final  int? index;
 final  List<String> _allUris;
@override@JsonKey() List<String> get allUris {
  if (_allUris is EqualUnmodifiableListView) return _allUris;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allUris);
}


/// Create a copy of PreviewImg
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreviewImgCopyWith<_PreviewImg> get copyWith => __$PreviewImgCopyWithImpl<_PreviewImg>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreviewImgToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviewImg&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.heroTag, heroTag) || other.heroTag == heroTag)&&(identical(other.index, index) || other.index == index)&&const DeepCollectionEquality().equals(other._allUris, _allUris));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,heroTag,index,const DeepCollectionEquality().hash(_allUris));

@override
String toString() {
  return 'PreviewImg(id: $id, url: $url, heroTag: $heroTag, index: $index, allUris: $allUris)';
}


}

/// @nodoc
abstract mixin class _$PreviewImgCopyWith<$Res> implements $PreviewImgCopyWith<$Res> {
  factory _$PreviewImgCopyWith(_PreviewImg value, $Res Function(_PreviewImg) _then) = __$PreviewImgCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? url, String? heroTag, int? index, List<String> allUris
});




}
/// @nodoc
class __$PreviewImgCopyWithImpl<$Res>
    implements _$PreviewImgCopyWith<$Res> {
  __$PreviewImgCopyWithImpl(this._self, this._then);

  final _PreviewImg _self;
  final $Res Function(_PreviewImg) _then;

/// Create a copy of PreviewImg
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? url = freezed,Object? heroTag = freezed,Object? index = freezed,Object? allUris = null,}) {
  return _then(_PreviewImg(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,heroTag: freezed == heroTag ? _self.heroTag : heroTag // ignore: cast_nullable_to_non_nullable
as String?,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,allUris: null == allUris ? _self._allUris : allUris // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on

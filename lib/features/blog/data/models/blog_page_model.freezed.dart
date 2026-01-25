// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blog_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlogItem {

 int? get blogType; int? get care; int? get categary; String? get content; String? get creatorName; int? get id; String? get resources; int? get shareType; int? get squareId; String? get topicIds; String? get updateTime; int? get zan;
/// Create a copy of BlogItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogItemCopyWith<BlogItem> get copyWith => _$BlogItemCopyWithImpl<BlogItem>(this as BlogItem, _$identity);

  /// Serializes this BlogItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogItem&&(identical(other.blogType, blogType) || other.blogType == blogType)&&(identical(other.care, care) || other.care == care)&&(identical(other.categary, categary) || other.categary == categary)&&(identical(other.content, content) || other.content == content)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&(identical(other.id, id) || other.id == id)&&(identical(other.resources, resources) || other.resources == resources)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.topicIds, topicIds) || other.topicIds == topicIds)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.zan, zan) || other.zan == zan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,blogType,care,categary,content,creatorName,id,resources,shareType,squareId,topicIds,updateTime,zan);

@override
String toString() {
  return 'BlogItem(blogType: $blogType, care: $care, categary: $categary, content: $content, creatorName: $creatorName, id: $id, resources: $resources, shareType: $shareType, squareId: $squareId, topicIds: $topicIds, updateTime: $updateTime, zan: $zan)';
}


}

/// @nodoc
abstract mixin class $BlogItemCopyWith<$Res>  {
  factory $BlogItemCopyWith(BlogItem value, $Res Function(BlogItem) _then) = _$BlogItemCopyWithImpl;
@useResult
$Res call({
 int? blogType, int? care, int? categary, String? content, String? creatorName, int? id, String? resources, int? shareType, int? squareId, String? topicIds, String? updateTime, int? zan
});




}
/// @nodoc
class _$BlogItemCopyWithImpl<$Res>
    implements $BlogItemCopyWith<$Res> {
  _$BlogItemCopyWithImpl(this._self, this._then);

  final BlogItem _self;
  final $Res Function(BlogItem) _then;

/// Create a copy of BlogItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? blogType = freezed,Object? care = freezed,Object? categary = freezed,Object? content = freezed,Object? creatorName = freezed,Object? id = freezed,Object? resources = freezed,Object? shareType = freezed,Object? squareId = freezed,Object? topicIds = freezed,Object? updateTime = freezed,Object? zan = freezed,}) {
  return _then(_self.copyWith(
blogType: freezed == blogType ? _self.blogType : blogType // ignore: cast_nullable_to_non_nullable
as int?,care: freezed == care ? _self.care : care // ignore: cast_nullable_to_non_nullable
as int?,categary: freezed == categary ? _self.categary : categary // ignore: cast_nullable_to_non_nullable
as int?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,creatorName: freezed == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,resources: freezed == resources ? _self.resources : resources // ignore: cast_nullable_to_non_nullable
as String?,shareType: freezed == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as int?,squareId: freezed == squareId ? _self.squareId : squareId // ignore: cast_nullable_to_non_nullable
as int?,topicIds: freezed == topicIds ? _self.topicIds : topicIds // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,zan: freezed == zan ? _self.zan : zan // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BlogItem].
extension BlogItemPatterns on BlogItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlogItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlogItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlogItem value)  $default,){
final _that = this;
switch (_that) {
case _BlogItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlogItem value)?  $default,){
final _that = this;
switch (_that) {
case _BlogItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? blogType,  int? care,  int? categary,  String? content,  String? creatorName,  int? id,  String? resources,  int? shareType,  int? squareId,  String? topicIds,  String? updateTime,  int? zan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogItem() when $default != null:
return $default(_that.blogType,_that.care,_that.categary,_that.content,_that.creatorName,_that.id,_that.resources,_that.shareType,_that.squareId,_that.topicIds,_that.updateTime,_that.zan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? blogType,  int? care,  int? categary,  String? content,  String? creatorName,  int? id,  String? resources,  int? shareType,  int? squareId,  String? topicIds,  String? updateTime,  int? zan)  $default,) {final _that = this;
switch (_that) {
case _BlogItem():
return $default(_that.blogType,_that.care,_that.categary,_that.content,_that.creatorName,_that.id,_that.resources,_that.shareType,_that.squareId,_that.topicIds,_that.updateTime,_that.zan);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? blogType,  int? care,  int? categary,  String? content,  String? creatorName,  int? id,  String? resources,  int? shareType,  int? squareId,  String? topicIds,  String? updateTime,  int? zan)?  $default,) {final _that = this;
switch (_that) {
case _BlogItem() when $default != null:
return $default(_that.blogType,_that.care,_that.categary,_that.content,_that.creatorName,_that.id,_that.resources,_that.shareType,_that.squareId,_that.topicIds,_that.updateTime,_that.zan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlogItem implements BlogItem {
  const _BlogItem({this.blogType, this.care, this.categary, this.content, this.creatorName, this.id, this.resources, this.shareType, this.squareId, this.topicIds, this.updateTime, this.zan});
  factory _BlogItem.fromJson(Map<String, dynamic> json) => _$BlogItemFromJson(json);

@override final  int? blogType;
@override final  int? care;
@override final  int? categary;
@override final  String? content;
@override final  String? creatorName;
@override final  int? id;
@override final  String? resources;
@override final  int? shareType;
@override final  int? squareId;
@override final  String? topicIds;
@override final  String? updateTime;
@override final  int? zan;

/// Create a copy of BlogItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlogItemCopyWith<_BlogItem> get copyWith => __$BlogItemCopyWithImpl<_BlogItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlogItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogItem&&(identical(other.blogType, blogType) || other.blogType == blogType)&&(identical(other.care, care) || other.care == care)&&(identical(other.categary, categary) || other.categary == categary)&&(identical(other.content, content) || other.content == content)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&(identical(other.id, id) || other.id == id)&&(identical(other.resources, resources) || other.resources == resources)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.topicIds, topicIds) || other.topicIds == topicIds)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.zan, zan) || other.zan == zan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,blogType,care,categary,content,creatorName,id,resources,shareType,squareId,topicIds,updateTime,zan);

@override
String toString() {
  return 'BlogItem(blogType: $blogType, care: $care, categary: $categary, content: $content, creatorName: $creatorName, id: $id, resources: $resources, shareType: $shareType, squareId: $squareId, topicIds: $topicIds, updateTime: $updateTime, zan: $zan)';
}


}

/// @nodoc
abstract mixin class _$BlogItemCopyWith<$Res> implements $BlogItemCopyWith<$Res> {
  factory _$BlogItemCopyWith(_BlogItem value, $Res Function(_BlogItem) _then) = __$BlogItemCopyWithImpl;
@override @useResult
$Res call({
 int? blogType, int? care, int? categary, String? content, String? creatorName, int? id, String? resources, int? shareType, int? squareId, String? topicIds, String? updateTime, int? zan
});




}
/// @nodoc
class __$BlogItemCopyWithImpl<$Res>
    implements _$BlogItemCopyWith<$Res> {
  __$BlogItemCopyWithImpl(this._self, this._then);

  final _BlogItem _self;
  final $Res Function(_BlogItem) _then;

/// Create a copy of BlogItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? blogType = freezed,Object? care = freezed,Object? categary = freezed,Object? content = freezed,Object? creatorName = freezed,Object? id = freezed,Object? resources = freezed,Object? shareType = freezed,Object? squareId = freezed,Object? topicIds = freezed,Object? updateTime = freezed,Object? zan = freezed,}) {
  return _then(_BlogItem(
blogType: freezed == blogType ? _self.blogType : blogType // ignore: cast_nullable_to_non_nullable
as int?,care: freezed == care ? _self.care : care // ignore: cast_nullable_to_non_nullable
as int?,categary: freezed == categary ? _self.categary : categary // ignore: cast_nullable_to_non_nullable
as int?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,creatorName: freezed == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,resources: freezed == resources ? _self.resources : resources // ignore: cast_nullable_to_non_nullable
as String?,shareType: freezed == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as int?,squareId: freezed == squareId ? _self.squareId : squareId // ignore: cast_nullable_to_non_nullable
as int?,topicIds: freezed == topicIds ? _self.topicIds : topicIds // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,zan: freezed == zan ? _self.zan : zan // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$BlogPageModelData {

 List<BlogItem>? get list; int? get total;
/// Create a copy of BlogPageModelData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogPageModelDataCopyWith<BlogPageModelData> get copyWith => _$BlogPageModelDataCopyWithImpl<BlogPageModelData>(this as BlogPageModelData, _$identity);

  /// Serializes this BlogPageModelData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogPageModelData&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),total);

@override
String toString() {
  return 'BlogPageModelData(list: $list, total: $total)';
}


}

/// @nodoc
abstract mixin class $BlogPageModelDataCopyWith<$Res>  {
  factory $BlogPageModelDataCopyWith(BlogPageModelData value, $Res Function(BlogPageModelData) _then) = _$BlogPageModelDataCopyWithImpl;
@useResult
$Res call({
 List<BlogItem>? list, int? total
});




}
/// @nodoc
class _$BlogPageModelDataCopyWithImpl<$Res>
    implements $BlogPageModelDataCopyWith<$Res> {
  _$BlogPageModelDataCopyWithImpl(this._self, this._then);

  final BlogPageModelData _self;
  final $Res Function(BlogPageModelData) _then;

/// Create a copy of BlogPageModelData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = freezed,Object? total = freezed,}) {
  return _then(_self.copyWith(
list: freezed == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<BlogItem>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BlogPageModelData].
extension BlogPageModelDataPatterns on BlogPageModelData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlogPageModelData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlogPageModelData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlogPageModelData value)  $default,){
final _that = this;
switch (_that) {
case _BlogPageModelData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlogPageModelData value)?  $default,){
final _that = this;
switch (_that) {
case _BlogPageModelData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BlogItem>? list,  int? total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogPageModelData() when $default != null:
return $default(_that.list,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BlogItem>? list,  int? total)  $default,) {final _that = this;
switch (_that) {
case _BlogPageModelData():
return $default(_that.list,_that.total);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BlogItem>? list,  int? total)?  $default,) {final _that = this;
switch (_that) {
case _BlogPageModelData() when $default != null:
return $default(_that.list,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlogPageModelData implements BlogPageModelData {
  const _BlogPageModelData({final  List<BlogItem>? list, this.total}): _list = list;
  factory _BlogPageModelData.fromJson(Map<String, dynamic> json) => _$BlogPageModelDataFromJson(json);

 final  List<BlogItem>? _list;
@override List<BlogItem>? get list {
  final value = _list;
  if (value == null) return null;
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? total;

/// Create a copy of BlogPageModelData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlogPageModelDataCopyWith<_BlogPageModelData> get copyWith => __$BlogPageModelDataCopyWithImpl<_BlogPageModelData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlogPageModelDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogPageModelData&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),total);

@override
String toString() {
  return 'BlogPageModelData(list: $list, total: $total)';
}


}

/// @nodoc
abstract mixin class _$BlogPageModelDataCopyWith<$Res> implements $BlogPageModelDataCopyWith<$Res> {
  factory _$BlogPageModelDataCopyWith(_BlogPageModelData value, $Res Function(_BlogPageModelData) _then) = __$BlogPageModelDataCopyWithImpl;
@override @useResult
$Res call({
 List<BlogItem>? list, int? total
});




}
/// @nodoc
class __$BlogPageModelDataCopyWithImpl<$Res>
    implements _$BlogPageModelDataCopyWith<$Res> {
  __$BlogPageModelDataCopyWithImpl(this._self, this._then);

  final _BlogPageModelData _self;
  final $Res Function(_BlogPageModelData) _then;

/// Create a copy of BlogPageModelData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = freezed,Object? total = freezed,}) {
  return _then(_BlogPageModelData(
list: freezed == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<BlogItem>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$BlogPageModel {

 int? get code; BlogPageModelData? get data; String? get msg;
/// Create a copy of BlogPageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogPageModelCopyWith<BlogPageModel> get copyWith => _$BlogPageModelCopyWithImpl<BlogPageModel>(this as BlogPageModel, _$identity);

  /// Serializes this BlogPageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogPageModel&&(identical(other.code, code) || other.code == code)&&(identical(other.data, data) || other.data == data)&&(identical(other.msg, msg) || other.msg == msg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,data,msg);

@override
String toString() {
  return 'BlogPageModel(code: $code, data: $data, msg: $msg)';
}


}

/// @nodoc
abstract mixin class $BlogPageModelCopyWith<$Res>  {
  factory $BlogPageModelCopyWith(BlogPageModel value, $Res Function(BlogPageModel) _then) = _$BlogPageModelCopyWithImpl;
@useResult
$Res call({
 int? code, BlogPageModelData? data, String? msg
});


$BlogPageModelDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$BlogPageModelCopyWithImpl<$Res>
    implements $BlogPageModelCopyWith<$Res> {
  _$BlogPageModelCopyWithImpl(this._self, this._then);

  final BlogPageModel _self;
  final $Res Function(BlogPageModel) _then;

/// Create a copy of BlogPageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? data = freezed,Object? msg = freezed,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BlogPageModelData?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BlogPageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlogPageModelDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $BlogPageModelDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [BlogPageModel].
extension BlogPageModelPatterns on BlogPageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlogPageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlogPageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlogPageModel value)  $default,){
final _that = this;
switch (_that) {
case _BlogPageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlogPageModel value)?  $default,){
final _that = this;
switch (_that) {
case _BlogPageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? code,  BlogPageModelData? data,  String? msg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogPageModel() when $default != null:
return $default(_that.code,_that.data,_that.msg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? code,  BlogPageModelData? data,  String? msg)  $default,) {final _that = this;
switch (_that) {
case _BlogPageModel():
return $default(_that.code,_that.data,_that.msg);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? code,  BlogPageModelData? data,  String? msg)?  $default,) {final _that = this;
switch (_that) {
case _BlogPageModel() when $default != null:
return $default(_that.code,_that.data,_that.msg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlogPageModel implements BlogPageModel {
  const _BlogPageModel({this.code, this.data, this.msg});
  factory _BlogPageModel.fromJson(Map<String, dynamic> json) => _$BlogPageModelFromJson(json);

@override final  int? code;
@override final  BlogPageModelData? data;
@override final  String? msg;

/// Create a copy of BlogPageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlogPageModelCopyWith<_BlogPageModel> get copyWith => __$BlogPageModelCopyWithImpl<_BlogPageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlogPageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogPageModel&&(identical(other.code, code) || other.code == code)&&(identical(other.data, data) || other.data == data)&&(identical(other.msg, msg) || other.msg == msg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,data,msg);

@override
String toString() {
  return 'BlogPageModel(code: $code, data: $data, msg: $msg)';
}


}

/// @nodoc
abstract mixin class _$BlogPageModelCopyWith<$Res> implements $BlogPageModelCopyWith<$Res> {
  factory _$BlogPageModelCopyWith(_BlogPageModel value, $Res Function(_BlogPageModel) _then) = __$BlogPageModelCopyWithImpl;
@override @useResult
$Res call({
 int? code, BlogPageModelData? data, String? msg
});


@override $BlogPageModelDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$BlogPageModelCopyWithImpl<$Res>
    implements _$BlogPageModelCopyWith<$Res> {
  __$BlogPageModelCopyWithImpl(this._self, this._then);

  final _BlogPageModel _self;
  final $Res Function(_BlogPageModel) _then;

/// Create a copy of BlogPageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? data = freezed,Object? msg = freezed,}) {
  return _then(_BlogPageModel(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BlogPageModelData?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BlogPageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlogPageModelDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $BlogPageModelDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShareItem {

 int? get blogType; int? get care; int? get categary; String? get content; String? get creatorName; int? get id; String? get resources; int? get shareType; int? get squareId; String? get topicIds; String? get updateTime; int? get zan;
/// Create a copy of ShareItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareItemCopyWith<ShareItem> get copyWith => _$ShareItemCopyWithImpl<ShareItem>(this as ShareItem, _$identity);

  /// Serializes this ShareItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareItem&&(identical(other.blogType, blogType) || other.blogType == blogType)&&(identical(other.care, care) || other.care == care)&&(identical(other.categary, categary) || other.categary == categary)&&(identical(other.content, content) || other.content == content)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&(identical(other.id, id) || other.id == id)&&(identical(other.resources, resources) || other.resources == resources)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.topicIds, topicIds) || other.topicIds == topicIds)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.zan, zan) || other.zan == zan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,blogType,care,categary,content,creatorName,id,resources,shareType,squareId,topicIds,updateTime,zan);

@override
String toString() {
  return 'ShareItem(blogType: $blogType, care: $care, categary: $categary, content: $content, creatorName: $creatorName, id: $id, resources: $resources, shareType: $shareType, squareId: $squareId, topicIds: $topicIds, updateTime: $updateTime, zan: $zan)';
}


}

/// @nodoc
abstract mixin class $ShareItemCopyWith<$Res>  {
  factory $ShareItemCopyWith(ShareItem value, $Res Function(ShareItem) _then) = _$ShareItemCopyWithImpl;
@useResult
$Res call({
 int? blogType, int? care, int? categary, String? content, String? creatorName, int? id, String? resources, int? shareType, int? squareId, String? topicIds, String? updateTime, int? zan
});




}
/// @nodoc
class _$ShareItemCopyWithImpl<$Res>
    implements $ShareItemCopyWith<$Res> {
  _$ShareItemCopyWithImpl(this._self, this._then);

  final ShareItem _self;
  final $Res Function(ShareItem) _then;

/// Create a copy of ShareItem
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


/// Adds pattern-matching-related methods to [ShareItem].
extension ShareItemPatterns on ShareItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShareItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShareItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShareItem value)  $default,){
final _that = this;
switch (_that) {
case _ShareItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShareItem value)?  $default,){
final _that = this;
switch (_that) {
case _ShareItem() when $default != null:
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
case _ShareItem() when $default != null:
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
case _ShareItem():
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
case _ShareItem() when $default != null:
return $default(_that.blogType,_that.care,_that.categary,_that.content,_that.creatorName,_that.id,_that.resources,_that.shareType,_that.squareId,_that.topicIds,_that.updateTime,_that.zan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShareItem implements ShareItem {
  const _ShareItem({this.blogType, this.care, this.categary, this.content, this.creatorName, this.id, this.resources, this.shareType, this.squareId, this.topicIds, this.updateTime, this.zan});
  factory _ShareItem.fromJson(Map<String, dynamic> json) => _$ShareItemFromJson(json);

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

/// Create a copy of ShareItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShareItemCopyWith<_ShareItem> get copyWith => __$ShareItemCopyWithImpl<_ShareItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShareItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShareItem&&(identical(other.blogType, blogType) || other.blogType == blogType)&&(identical(other.care, care) || other.care == care)&&(identical(other.categary, categary) || other.categary == categary)&&(identical(other.content, content) || other.content == content)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&(identical(other.id, id) || other.id == id)&&(identical(other.resources, resources) || other.resources == resources)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.topicIds, topicIds) || other.topicIds == topicIds)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.zan, zan) || other.zan == zan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,blogType,care,categary,content,creatorName,id,resources,shareType,squareId,topicIds,updateTime,zan);

@override
String toString() {
  return 'ShareItem(blogType: $blogType, care: $care, categary: $categary, content: $content, creatorName: $creatorName, id: $id, resources: $resources, shareType: $shareType, squareId: $squareId, topicIds: $topicIds, updateTime: $updateTime, zan: $zan)';
}


}

/// @nodoc
abstract mixin class _$ShareItemCopyWith<$Res> implements $ShareItemCopyWith<$Res> {
  factory _$ShareItemCopyWith(_ShareItem value, $Res Function(_ShareItem) _then) = __$ShareItemCopyWithImpl;
@override @useResult
$Res call({
 int? blogType, int? care, int? categary, String? content, String? creatorName, int? id, String? resources, int? shareType, int? squareId, String? topicIds, String? updateTime, int? zan
});




}
/// @nodoc
class __$ShareItemCopyWithImpl<$Res>
    implements _$ShareItemCopyWith<$Res> {
  __$ShareItemCopyWithImpl(this._self, this._then);

  final _ShareItem _self;
  final $Res Function(_ShareItem) _then;

/// Create a copy of ShareItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? blogType = freezed,Object? care = freezed,Object? categary = freezed,Object? content = freezed,Object? creatorName = freezed,Object? id = freezed,Object? resources = freezed,Object? shareType = freezed,Object? squareId = freezed,Object? topicIds = freezed,Object? updateTime = freezed,Object? zan = freezed,}) {
  return _then(_ShareItem(
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
mixin _$SharePageModelData {

 List<ShareItem>? get list; int? get total;
/// Create a copy of SharePageModelData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharePageModelDataCopyWith<SharePageModelData> get copyWith => _$SharePageModelDataCopyWithImpl<SharePageModelData>(this as SharePageModelData, _$identity);

  /// Serializes this SharePageModelData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharePageModelData&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),total);

@override
String toString() {
  return 'SharePageModelData(list: $list, total: $total)';
}


}

/// @nodoc
abstract mixin class $SharePageModelDataCopyWith<$Res>  {
  factory $SharePageModelDataCopyWith(SharePageModelData value, $Res Function(SharePageModelData) _then) = _$SharePageModelDataCopyWithImpl;
@useResult
$Res call({
 List<ShareItem>? list, int? total
});




}
/// @nodoc
class _$SharePageModelDataCopyWithImpl<$Res>
    implements $SharePageModelDataCopyWith<$Res> {
  _$SharePageModelDataCopyWithImpl(this._self, this._then);

  final SharePageModelData _self;
  final $Res Function(SharePageModelData) _then;

/// Create a copy of SharePageModelData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = freezed,Object? total = freezed,}) {
  return _then(_self.copyWith(
list: freezed == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<ShareItem>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SharePageModelData].
extension SharePageModelDataPatterns on SharePageModelData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharePageModelData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharePageModelData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharePageModelData value)  $default,){
final _that = this;
switch (_that) {
case _SharePageModelData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharePageModelData value)?  $default,){
final _that = this;
switch (_that) {
case _SharePageModelData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ShareItem>? list,  int? total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharePageModelData() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ShareItem>? list,  int? total)  $default,) {final _that = this;
switch (_that) {
case _SharePageModelData():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ShareItem>? list,  int? total)?  $default,) {final _that = this;
switch (_that) {
case _SharePageModelData() when $default != null:
return $default(_that.list,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SharePageModelData implements SharePageModelData {
  const _SharePageModelData({final  List<ShareItem>? list, this.total}): _list = list;
  factory _SharePageModelData.fromJson(Map<String, dynamic> json) => _$SharePageModelDataFromJson(json);

 final  List<ShareItem>? _list;
@override List<ShareItem>? get list {
  final value = _list;
  if (value == null) return null;
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? total;

/// Create a copy of SharePageModelData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharePageModelDataCopyWith<_SharePageModelData> get copyWith => __$SharePageModelDataCopyWithImpl<_SharePageModelData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharePageModelDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharePageModelData&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),total);

@override
String toString() {
  return 'SharePageModelData(list: $list, total: $total)';
}


}

/// @nodoc
abstract mixin class _$SharePageModelDataCopyWith<$Res> implements $SharePageModelDataCopyWith<$Res> {
  factory _$SharePageModelDataCopyWith(_SharePageModelData value, $Res Function(_SharePageModelData) _then) = __$SharePageModelDataCopyWithImpl;
@override @useResult
$Res call({
 List<ShareItem>? list, int? total
});




}
/// @nodoc
class __$SharePageModelDataCopyWithImpl<$Res>
    implements _$SharePageModelDataCopyWith<$Res> {
  __$SharePageModelDataCopyWithImpl(this._self, this._then);

  final _SharePageModelData _self;
  final $Res Function(_SharePageModelData) _then;

/// Create a copy of SharePageModelData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = freezed,Object? total = freezed,}) {
  return _then(_SharePageModelData(
list: freezed == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<ShareItem>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$SharePageModel {

 int? get code; SharePageModelData? get data; String? get msg;
/// Create a copy of SharePageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharePageModelCopyWith<SharePageModel> get copyWith => _$SharePageModelCopyWithImpl<SharePageModel>(this as SharePageModel, _$identity);

  /// Serializes this SharePageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharePageModel&&(identical(other.code, code) || other.code == code)&&(identical(other.data, data) || other.data == data)&&(identical(other.msg, msg) || other.msg == msg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,data,msg);

@override
String toString() {
  return 'SharePageModel(code: $code, data: $data, msg: $msg)';
}


}

/// @nodoc
abstract mixin class $SharePageModelCopyWith<$Res>  {
  factory $SharePageModelCopyWith(SharePageModel value, $Res Function(SharePageModel) _then) = _$SharePageModelCopyWithImpl;
@useResult
$Res call({
 int? code, SharePageModelData? data, String? msg
});


$SharePageModelDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$SharePageModelCopyWithImpl<$Res>
    implements $SharePageModelCopyWith<$Res> {
  _$SharePageModelCopyWithImpl(this._self, this._then);

  final SharePageModel _self;
  final $Res Function(SharePageModel) _then;

/// Create a copy of SharePageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? data = freezed,Object? msg = freezed,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SharePageModelData?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SharePageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SharePageModelDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $SharePageModelDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [SharePageModel].
extension SharePageModelPatterns on SharePageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharePageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharePageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharePageModel value)  $default,){
final _that = this;
switch (_that) {
case _SharePageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharePageModel value)?  $default,){
final _that = this;
switch (_that) {
case _SharePageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? code,  SharePageModelData? data,  String? msg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharePageModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? code,  SharePageModelData? data,  String? msg)  $default,) {final _that = this;
switch (_that) {
case _SharePageModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? code,  SharePageModelData? data,  String? msg)?  $default,) {final _that = this;
switch (_that) {
case _SharePageModel() when $default != null:
return $default(_that.code,_that.data,_that.msg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SharePageModel implements SharePageModel {
  const _SharePageModel({this.code, this.data, this.msg});
  factory _SharePageModel.fromJson(Map<String, dynamic> json) => _$SharePageModelFromJson(json);

@override final  int? code;
@override final  SharePageModelData? data;
@override final  String? msg;

/// Create a copy of SharePageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharePageModelCopyWith<_SharePageModel> get copyWith => __$SharePageModelCopyWithImpl<_SharePageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharePageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharePageModel&&(identical(other.code, code) || other.code == code)&&(identical(other.data, data) || other.data == data)&&(identical(other.msg, msg) || other.msg == msg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,data,msg);

@override
String toString() {
  return 'SharePageModel(code: $code, data: $data, msg: $msg)';
}


}

/// @nodoc
abstract mixin class _$SharePageModelCopyWith<$Res> implements $SharePageModelCopyWith<$Res> {
  factory _$SharePageModelCopyWith(_SharePageModel value, $Res Function(_SharePageModel) _then) = __$SharePageModelCopyWithImpl;
@override @useResult
$Res call({
 int? code, SharePageModelData? data, String? msg
});


@override $SharePageModelDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$SharePageModelCopyWithImpl<$Res>
    implements _$SharePageModelCopyWith<$Res> {
  __$SharePageModelCopyWithImpl(this._self, this._then);

  final _SharePageModel _self;
  final $Res Function(_SharePageModel) _then;

/// Create a copy of SharePageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? data = freezed,Object? msg = freezed,}) {
  return _then(_SharePageModel(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SharePageModelData?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SharePageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SharePageModelDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $SharePageModelDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on

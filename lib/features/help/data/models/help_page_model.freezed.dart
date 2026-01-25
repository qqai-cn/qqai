// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'help_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HelpItem {

 int? get blogType; int? get care; int? get categary; String? get content; String? get creatorName; int? get id; String? get resources; int? get shareType; int? get squareId; String? get topicIds; String? get updateTime; int? get zan;
/// Create a copy of HelpItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpItemCopyWith<HelpItem> get copyWith => _$HelpItemCopyWithImpl<HelpItem>(this as HelpItem, _$identity);

  /// Serializes this HelpItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpItem&&(identical(other.blogType, blogType) || other.blogType == blogType)&&(identical(other.care, care) || other.care == care)&&(identical(other.categary, categary) || other.categary == categary)&&(identical(other.content, content) || other.content == content)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&(identical(other.id, id) || other.id == id)&&(identical(other.resources, resources) || other.resources == resources)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.topicIds, topicIds) || other.topicIds == topicIds)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.zan, zan) || other.zan == zan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,blogType,care,categary,content,creatorName,id,resources,shareType,squareId,topicIds,updateTime,zan);

@override
String toString() {
  return 'HelpItem(blogType: $blogType, care: $care, categary: $categary, content: $content, creatorName: $creatorName, id: $id, resources: $resources, shareType: $shareType, squareId: $squareId, topicIds: $topicIds, updateTime: $updateTime, zan: $zan)';
}


}

/// @nodoc
abstract mixin class $HelpItemCopyWith<$Res>  {
  factory $HelpItemCopyWith(HelpItem value, $Res Function(HelpItem) _then) = _$HelpItemCopyWithImpl;
@useResult
$Res call({
 int? blogType, int? care, int? categary, String? content, String? creatorName, int? id, String? resources, int? shareType, int? squareId, String? topicIds, String? updateTime, int? zan
});




}
/// @nodoc
class _$HelpItemCopyWithImpl<$Res>
    implements $HelpItemCopyWith<$Res> {
  _$HelpItemCopyWithImpl(this._self, this._then);

  final HelpItem _self;
  final $Res Function(HelpItem) _then;

/// Create a copy of HelpItem
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


/// Adds pattern-matching-related methods to [HelpItem].
extension HelpItemPatterns on HelpItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpItem value)  $default,){
final _that = this;
switch (_that) {
case _HelpItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpItem value)?  $default,){
final _that = this;
switch (_that) {
case _HelpItem() when $default != null:
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
case _HelpItem() when $default != null:
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
case _HelpItem():
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
case _HelpItem() when $default != null:
return $default(_that.blogType,_that.care,_that.categary,_that.content,_that.creatorName,_that.id,_that.resources,_that.shareType,_that.squareId,_that.topicIds,_that.updateTime,_that.zan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HelpItem implements HelpItem {
  const _HelpItem({this.blogType, this.care, this.categary, this.content, this.creatorName, this.id, this.resources, this.shareType, this.squareId, this.topicIds, this.updateTime, this.zan});
  factory _HelpItem.fromJson(Map<String, dynamic> json) => _$HelpItemFromJson(json);

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

/// Create a copy of HelpItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpItemCopyWith<_HelpItem> get copyWith => __$HelpItemCopyWithImpl<_HelpItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HelpItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpItem&&(identical(other.blogType, blogType) || other.blogType == blogType)&&(identical(other.care, care) || other.care == care)&&(identical(other.categary, categary) || other.categary == categary)&&(identical(other.content, content) || other.content == content)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&(identical(other.id, id) || other.id == id)&&(identical(other.resources, resources) || other.resources == resources)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.topicIds, topicIds) || other.topicIds == topicIds)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.zan, zan) || other.zan == zan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,blogType,care,categary,content,creatorName,id,resources,shareType,squareId,topicIds,updateTime,zan);

@override
String toString() {
  return 'HelpItem(blogType: $blogType, care: $care, categary: $categary, content: $content, creatorName: $creatorName, id: $id, resources: $resources, shareType: $shareType, squareId: $squareId, topicIds: $topicIds, updateTime: $updateTime, zan: $zan)';
}


}

/// @nodoc
abstract mixin class _$HelpItemCopyWith<$Res> implements $HelpItemCopyWith<$Res> {
  factory _$HelpItemCopyWith(_HelpItem value, $Res Function(_HelpItem) _then) = __$HelpItemCopyWithImpl;
@override @useResult
$Res call({
 int? blogType, int? care, int? categary, String? content, String? creatorName, int? id, String? resources, int? shareType, int? squareId, String? topicIds, String? updateTime, int? zan
});




}
/// @nodoc
class __$HelpItemCopyWithImpl<$Res>
    implements _$HelpItemCopyWith<$Res> {
  __$HelpItemCopyWithImpl(this._self, this._then);

  final _HelpItem _self;
  final $Res Function(_HelpItem) _then;

/// Create a copy of HelpItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? blogType = freezed,Object? care = freezed,Object? categary = freezed,Object? content = freezed,Object? creatorName = freezed,Object? id = freezed,Object? resources = freezed,Object? shareType = freezed,Object? squareId = freezed,Object? topicIds = freezed,Object? updateTime = freezed,Object? zan = freezed,}) {
  return _then(_HelpItem(
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
mixin _$HelpPageModelData {

 List<HelpItem>? get list; int? get total;
/// Create a copy of HelpPageModelData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpPageModelDataCopyWith<HelpPageModelData> get copyWith => _$HelpPageModelDataCopyWithImpl<HelpPageModelData>(this as HelpPageModelData, _$identity);

  /// Serializes this HelpPageModelData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpPageModelData&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),total);

@override
String toString() {
  return 'HelpPageModelData(list: $list, total: $total)';
}


}

/// @nodoc
abstract mixin class $HelpPageModelDataCopyWith<$Res>  {
  factory $HelpPageModelDataCopyWith(HelpPageModelData value, $Res Function(HelpPageModelData) _then) = _$HelpPageModelDataCopyWithImpl;
@useResult
$Res call({
 List<HelpItem>? list, int? total
});




}
/// @nodoc
class _$HelpPageModelDataCopyWithImpl<$Res>
    implements $HelpPageModelDataCopyWith<$Res> {
  _$HelpPageModelDataCopyWithImpl(this._self, this._then);

  final HelpPageModelData _self;
  final $Res Function(HelpPageModelData) _then;

/// Create a copy of HelpPageModelData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = freezed,Object? total = freezed,}) {
  return _then(_self.copyWith(
list: freezed == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<HelpItem>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [HelpPageModelData].
extension HelpPageModelDataPatterns on HelpPageModelData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpPageModelData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpPageModelData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpPageModelData value)  $default,){
final _that = this;
switch (_that) {
case _HelpPageModelData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpPageModelData value)?  $default,){
final _that = this;
switch (_that) {
case _HelpPageModelData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HelpItem>? list,  int? total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HelpPageModelData() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HelpItem>? list,  int? total)  $default,) {final _that = this;
switch (_that) {
case _HelpPageModelData():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HelpItem>? list,  int? total)?  $default,) {final _that = this;
switch (_that) {
case _HelpPageModelData() when $default != null:
return $default(_that.list,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HelpPageModelData implements HelpPageModelData {
  const _HelpPageModelData({final  List<HelpItem>? list, this.total}): _list = list;
  factory _HelpPageModelData.fromJson(Map<String, dynamic> json) => _$HelpPageModelDataFromJson(json);

 final  List<HelpItem>? _list;
@override List<HelpItem>? get list {
  final value = _list;
  if (value == null) return null;
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? total;

/// Create a copy of HelpPageModelData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpPageModelDataCopyWith<_HelpPageModelData> get copyWith => __$HelpPageModelDataCopyWithImpl<_HelpPageModelData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HelpPageModelDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpPageModelData&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),total);

@override
String toString() {
  return 'HelpPageModelData(list: $list, total: $total)';
}


}

/// @nodoc
abstract mixin class _$HelpPageModelDataCopyWith<$Res> implements $HelpPageModelDataCopyWith<$Res> {
  factory _$HelpPageModelDataCopyWith(_HelpPageModelData value, $Res Function(_HelpPageModelData) _then) = __$HelpPageModelDataCopyWithImpl;
@override @useResult
$Res call({
 List<HelpItem>? list, int? total
});




}
/// @nodoc
class __$HelpPageModelDataCopyWithImpl<$Res>
    implements _$HelpPageModelDataCopyWith<$Res> {
  __$HelpPageModelDataCopyWithImpl(this._self, this._then);

  final _HelpPageModelData _self;
  final $Res Function(_HelpPageModelData) _then;

/// Create a copy of HelpPageModelData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = freezed,Object? total = freezed,}) {
  return _then(_HelpPageModelData(
list: freezed == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<HelpItem>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$HelpPageModel {

 int? get code; HelpPageModelData? get data; String? get msg;
/// Create a copy of HelpPageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpPageModelCopyWith<HelpPageModel> get copyWith => _$HelpPageModelCopyWithImpl<HelpPageModel>(this as HelpPageModel, _$identity);

  /// Serializes this HelpPageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpPageModel&&(identical(other.code, code) || other.code == code)&&(identical(other.data, data) || other.data == data)&&(identical(other.msg, msg) || other.msg == msg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,data,msg);

@override
String toString() {
  return 'HelpPageModel(code: $code, data: $data, msg: $msg)';
}


}

/// @nodoc
abstract mixin class $HelpPageModelCopyWith<$Res>  {
  factory $HelpPageModelCopyWith(HelpPageModel value, $Res Function(HelpPageModel) _then) = _$HelpPageModelCopyWithImpl;
@useResult
$Res call({
 int? code, HelpPageModelData? data, String? msg
});


$HelpPageModelDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$HelpPageModelCopyWithImpl<$Res>
    implements $HelpPageModelCopyWith<$Res> {
  _$HelpPageModelCopyWithImpl(this._self, this._then);

  final HelpPageModel _self;
  final $Res Function(HelpPageModel) _then;

/// Create a copy of HelpPageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? data = freezed,Object? msg = freezed,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as HelpPageModelData?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of HelpPageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HelpPageModelDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $HelpPageModelDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [HelpPageModel].
extension HelpPageModelPatterns on HelpPageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpPageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpPageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpPageModel value)  $default,){
final _that = this;
switch (_that) {
case _HelpPageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpPageModel value)?  $default,){
final _that = this;
switch (_that) {
case _HelpPageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? code,  HelpPageModelData? data,  String? msg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HelpPageModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? code,  HelpPageModelData? data,  String? msg)  $default,) {final _that = this;
switch (_that) {
case _HelpPageModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? code,  HelpPageModelData? data,  String? msg)?  $default,) {final _that = this;
switch (_that) {
case _HelpPageModel() when $default != null:
return $default(_that.code,_that.data,_that.msg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HelpPageModel implements HelpPageModel {
  const _HelpPageModel({this.code, this.data, this.msg});
  factory _HelpPageModel.fromJson(Map<String, dynamic> json) => _$HelpPageModelFromJson(json);

@override final  int? code;
@override final  HelpPageModelData? data;
@override final  String? msg;

/// Create a copy of HelpPageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpPageModelCopyWith<_HelpPageModel> get copyWith => __$HelpPageModelCopyWithImpl<_HelpPageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HelpPageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpPageModel&&(identical(other.code, code) || other.code == code)&&(identical(other.data, data) || other.data == data)&&(identical(other.msg, msg) || other.msg == msg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,data,msg);

@override
String toString() {
  return 'HelpPageModel(code: $code, data: $data, msg: $msg)';
}


}

/// @nodoc
abstract mixin class _$HelpPageModelCopyWith<$Res> implements $HelpPageModelCopyWith<$Res> {
  factory _$HelpPageModelCopyWith(_HelpPageModel value, $Res Function(_HelpPageModel) _then) = __$HelpPageModelCopyWithImpl;
@override @useResult
$Res call({
 int? code, HelpPageModelData? data, String? msg
});


@override $HelpPageModelDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$HelpPageModelCopyWithImpl<$Res>
    implements _$HelpPageModelCopyWith<$Res> {
  __$HelpPageModelCopyWithImpl(this._self, this._then);

  final _HelpPageModel _self;
  final $Res Function(_HelpPageModel) _then;

/// Create a copy of HelpPageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? data = freezed,Object? msg = freezed,}) {
  return _then(_HelpPageModel(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as HelpPageModelData?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of HelpPageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HelpPageModelDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $HelpPageModelDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on

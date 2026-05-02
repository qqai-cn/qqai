// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SkuuTopicResVO {

 int? get id; String? get topicName; String? get creator; String? get updater; String? get createTime; String? get updateTime;
/// Create a copy of SkuuTopicResVO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkuuTopicResVOCopyWith<SkuuTopicResVO> get copyWith => _$SkuuTopicResVOCopyWithImpl<SkuuTopicResVO>(this as SkuuTopicResVO, _$identity);

  /// Serializes this SkuuTopicResVO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkuuTopicResVO&&(identical(other.id, id) || other.id == id)&&(identical(other.topicName, topicName) || other.topicName == topicName)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.updater, updater) || other.updater == updater)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,topicName,creator,updater,createTime,updateTime);

@override
String toString() {
  return 'SkuuTopicResVO(id: $id, topicName: $topicName, creator: $creator, updater: $updater, createTime: $createTime, updateTime: $updateTime)';
}


}

/// @nodoc
abstract mixin class $SkuuTopicResVOCopyWith<$Res>  {
  factory $SkuuTopicResVOCopyWith(SkuuTopicResVO value, $Res Function(SkuuTopicResVO) _then) = _$SkuuTopicResVOCopyWithImpl;
@useResult
$Res call({
 int? id, String? topicName, String? creator, String? updater, String? createTime, String? updateTime
});




}
/// @nodoc
class _$SkuuTopicResVOCopyWithImpl<$Res>
    implements $SkuuTopicResVOCopyWith<$Res> {
  _$SkuuTopicResVOCopyWithImpl(this._self, this._then);

  final SkuuTopicResVO _self;
  final $Res Function(SkuuTopicResVO) _then;

/// Create a copy of SkuuTopicResVO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? topicName = freezed,Object? creator = freezed,Object? updater = freezed,Object? createTime = freezed,Object? updateTime = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,topicName: freezed == topicName ? _self.topicName : topicName // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as String?,updater: freezed == updater ? _self.updater : updater // ignore: cast_nullable_to_non_nullable
as String?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SkuuTopicResVO].
extension SkuuTopicResVOPatterns on SkuuTopicResVO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkuuTopicResVO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkuuTopicResVO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkuuTopicResVO value)  $default,){
final _that = this;
switch (_that) {
case _SkuuTopicResVO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkuuTopicResVO value)?  $default,){
final _that = this;
switch (_that) {
case _SkuuTopicResVO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? topicName,  String? creator,  String? updater,  String? createTime,  String? updateTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkuuTopicResVO() when $default != null:
return $default(_that.id,_that.topicName,_that.creator,_that.updater,_that.createTime,_that.updateTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? topicName,  String? creator,  String? updater,  String? createTime,  String? updateTime)  $default,) {final _that = this;
switch (_that) {
case _SkuuTopicResVO():
return $default(_that.id,_that.topicName,_that.creator,_that.updater,_that.createTime,_that.updateTime);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? topicName,  String? creator,  String? updater,  String? createTime,  String? updateTime)?  $default,) {final _that = this;
switch (_that) {
case _SkuuTopicResVO() when $default != null:
return $default(_that.id,_that.topicName,_that.creator,_that.updater,_that.createTime,_that.updateTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SkuuTopicResVO implements SkuuTopicResVO {
  const _SkuuTopicResVO({this.id, this.topicName, this.creator, this.updater, this.createTime, this.updateTime});
  factory _SkuuTopicResVO.fromJson(Map<String, dynamic> json) => _$SkuuTopicResVOFromJson(json);

@override final  int? id;
@override final  String? topicName;
@override final  String? creator;
@override final  String? updater;
@override final  String? createTime;
@override final  String? updateTime;

/// Create a copy of SkuuTopicResVO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkuuTopicResVOCopyWith<_SkuuTopicResVO> get copyWith => __$SkuuTopicResVOCopyWithImpl<_SkuuTopicResVO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkuuTopicResVOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkuuTopicResVO&&(identical(other.id, id) || other.id == id)&&(identical(other.topicName, topicName) || other.topicName == topicName)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.updater, updater) || other.updater == updater)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,topicName,creator,updater,createTime,updateTime);

@override
String toString() {
  return 'SkuuTopicResVO(id: $id, topicName: $topicName, creator: $creator, updater: $updater, createTime: $createTime, updateTime: $updateTime)';
}


}

/// @nodoc
abstract mixin class _$SkuuTopicResVOCopyWith<$Res> implements $SkuuTopicResVOCopyWith<$Res> {
  factory _$SkuuTopicResVOCopyWith(_SkuuTopicResVO value, $Res Function(_SkuuTopicResVO) _then) = __$SkuuTopicResVOCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? topicName, String? creator, String? updater, String? createTime, String? updateTime
});




}
/// @nodoc
class __$SkuuTopicResVOCopyWithImpl<$Res>
    implements _$SkuuTopicResVOCopyWith<$Res> {
  __$SkuuTopicResVOCopyWithImpl(this._self, this._then);

  final _SkuuTopicResVO _self;
  final $Res Function(_SkuuTopicResVO) _then;

/// Create a copy of SkuuTopicResVO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? topicName = freezed,Object? creator = freezed,Object? updater = freezed,Object? createTime = freezed,Object? updateTime = freezed,}) {
  return _then(_SkuuTopicResVO(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,topicName: freezed == topicName ? _self.topicName : topicName // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as String?,updater: freezed == updater ? _self.updater : updater // ignore: cast_nullable_to_non_nullable
as String?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TopicPageResult {

 int? get total; List<SkuuTopicResVO>? get list;
/// Create a copy of TopicPageResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicPageResultCopyWith<TopicPageResult> get copyWith => _$TopicPageResultCopyWithImpl<TopicPageResult>(this as TopicPageResult, _$identity);

  /// Serializes this TopicPageResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopicPageResult&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.list, list));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(list));

@override
String toString() {
  return 'TopicPageResult(total: $total, list: $list)';
}


}

/// @nodoc
abstract mixin class $TopicPageResultCopyWith<$Res>  {
  factory $TopicPageResultCopyWith(TopicPageResult value, $Res Function(TopicPageResult) _then) = _$TopicPageResultCopyWithImpl;
@useResult
$Res call({
 int? total, List<SkuuTopicResVO>? list
});




}
/// @nodoc
class _$TopicPageResultCopyWithImpl<$Res>
    implements $TopicPageResultCopyWith<$Res> {
  _$TopicPageResultCopyWithImpl(this._self, this._then);

  final TopicPageResult _self;
  final $Res Function(TopicPageResult) _then;

/// Create a copy of TopicPageResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = freezed,Object? list = freezed,}) {
  return _then(_self.copyWith(
total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,list: freezed == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<SkuuTopicResVO>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TopicPageResult].
extension TopicPageResultPatterns on TopicPageResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopicPageResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopicPageResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopicPageResult value)  $default,){
final _that = this;
switch (_that) {
case _TopicPageResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopicPageResult value)?  $default,){
final _that = this;
switch (_that) {
case _TopicPageResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? total,  List<SkuuTopicResVO>? list)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopicPageResult() when $default != null:
return $default(_that.total,_that.list);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? total,  List<SkuuTopicResVO>? list)  $default,) {final _that = this;
switch (_that) {
case _TopicPageResult():
return $default(_that.total,_that.list);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? total,  List<SkuuTopicResVO>? list)?  $default,) {final _that = this;
switch (_that) {
case _TopicPageResult() when $default != null:
return $default(_that.total,_that.list);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopicPageResult implements TopicPageResult {
  const _TopicPageResult({this.total, final  List<SkuuTopicResVO>? list}): _list = list;
  factory _TopicPageResult.fromJson(Map<String, dynamic> json) => _$TopicPageResultFromJson(json);

@override final  int? total;
 final  List<SkuuTopicResVO>? _list;
@override List<SkuuTopicResVO>? get list {
  final value = _list;
  if (value == null) return null;
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of TopicPageResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicPageResultCopyWith<_TopicPageResult> get copyWith => __$TopicPageResultCopyWithImpl<_TopicPageResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopicPageResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopicPageResult&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._list, _list));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(_list));

@override
String toString() {
  return 'TopicPageResult(total: $total, list: $list)';
}


}

/// @nodoc
abstract mixin class _$TopicPageResultCopyWith<$Res> implements $TopicPageResultCopyWith<$Res> {
  factory _$TopicPageResultCopyWith(_TopicPageResult value, $Res Function(_TopicPageResult) _then) = __$TopicPageResultCopyWithImpl;
@override @useResult
$Res call({
 int? total, List<SkuuTopicResVO>? list
});




}
/// @nodoc
class __$TopicPageResultCopyWithImpl<$Res>
    implements _$TopicPageResultCopyWith<$Res> {
  __$TopicPageResultCopyWithImpl(this._self, this._then);

  final _TopicPageResult _self;
  final $Res Function(_TopicPageResult) _then;

/// Create a copy of TopicPageResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = freezed,Object? list = freezed,}) {
  return _then(_TopicPageResult(
total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,list: freezed == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<SkuuTopicResVO>?,
  ));
}


}


/// @nodoc
mixin _$TopicPageResponse {

 int? get code; String? get msg; TopicPageResult? get data;
/// Create a copy of TopicPageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicPageResponseCopyWith<TopicPageResponse> get copyWith => _$TopicPageResponseCopyWithImpl<TopicPageResponse>(this as TopicPageResponse, _$identity);

  /// Serializes this TopicPageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopicPageResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,msg,data);

@override
String toString() {
  return 'TopicPageResponse(code: $code, msg: $msg, data: $data)';
}


}

/// @nodoc
abstract mixin class $TopicPageResponseCopyWith<$Res>  {
  factory $TopicPageResponseCopyWith(TopicPageResponse value, $Res Function(TopicPageResponse) _then) = _$TopicPageResponseCopyWithImpl;
@useResult
$Res call({
 int? code, String? msg, TopicPageResult? data
});


$TopicPageResultCopyWith<$Res>? get data;

}
/// @nodoc
class _$TopicPageResponseCopyWithImpl<$Res>
    implements $TopicPageResponseCopyWith<$Res> {
  _$TopicPageResponseCopyWithImpl(this._self, this._then);

  final TopicPageResponse _self;
  final $Res Function(TopicPageResponse) _then;

/// Create a copy of TopicPageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? msg = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TopicPageResult?,
  ));
}
/// Create a copy of TopicPageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TopicPageResultCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $TopicPageResultCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [TopicPageResponse].
extension TopicPageResponsePatterns on TopicPageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopicPageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopicPageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopicPageResponse value)  $default,){
final _that = this;
switch (_that) {
case _TopicPageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopicPageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TopicPageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? code,  String? msg,  TopicPageResult? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopicPageResponse() when $default != null:
return $default(_that.code,_that.msg,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? code,  String? msg,  TopicPageResult? data)  $default,) {final _that = this;
switch (_that) {
case _TopicPageResponse():
return $default(_that.code,_that.msg,_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? code,  String? msg,  TopicPageResult? data)?  $default,) {final _that = this;
switch (_that) {
case _TopicPageResponse() when $default != null:
return $default(_that.code,_that.msg,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopicPageResponse implements TopicPageResponse {
  const _TopicPageResponse({this.code, this.msg, this.data});
  factory _TopicPageResponse.fromJson(Map<String, dynamic> json) => _$TopicPageResponseFromJson(json);

@override final  int? code;
@override final  String? msg;
@override final  TopicPageResult? data;

/// Create a copy of TopicPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicPageResponseCopyWith<_TopicPageResponse> get copyWith => __$TopicPageResponseCopyWithImpl<_TopicPageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopicPageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopicPageResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,msg,data);

@override
String toString() {
  return 'TopicPageResponse(code: $code, msg: $msg, data: $data)';
}


}

/// @nodoc
abstract mixin class _$TopicPageResponseCopyWith<$Res> implements $TopicPageResponseCopyWith<$Res> {
  factory _$TopicPageResponseCopyWith(_TopicPageResponse value, $Res Function(_TopicPageResponse) _then) = __$TopicPageResponseCopyWithImpl;
@override @useResult
$Res call({
 int? code, String? msg, TopicPageResult? data
});


@override $TopicPageResultCopyWith<$Res>? get data;

}
/// @nodoc
class __$TopicPageResponseCopyWithImpl<$Res>
    implements _$TopicPageResponseCopyWith<$Res> {
  __$TopicPageResponseCopyWithImpl(this._self, this._then);

  final _TopicPageResponse _self;
  final $Res Function(_TopicPageResponse) _then;

/// Create a copy of TopicPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? msg = freezed,Object? data = freezed,}) {
  return _then(_TopicPageResponse(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TopicPageResult?,
  ));
}

/// Create a copy of TopicPageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TopicPageResultCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $TopicPageResultCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on

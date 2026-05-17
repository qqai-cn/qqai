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
mixin _$SquareItem {

 int? get id; String? get squareName; int? get userId; String? get userAvatar; String? get squareImg; String? get squareDesc; int? get chatConversationId; bool? get hasChatConversation; int? get blogCount; bool? get followedByMe; String? get createTime;
/// Create a copy of SquareItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SquareItemCopyWith<SquareItem> get copyWith => _$SquareItemCopyWithImpl<SquareItem>(this as SquareItem, _$identity);

  /// Serializes this SquareItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SquareItem&&(identical(other.id, id) || other.id == id)&&(identical(other.squareName, squareName) || other.squareName == squareName)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&(identical(other.squareImg, squareImg) || other.squareImg == squareImg)&&(identical(other.squareDesc, squareDesc) || other.squareDesc == squareDesc)&&(identical(other.chatConversationId, chatConversationId) || other.chatConversationId == chatConversationId)&&(identical(other.hasChatConversation, hasChatConversation) || other.hasChatConversation == hasChatConversation)&&(identical(other.blogCount, blogCount) || other.blogCount == blogCount)&&(identical(other.followedByMe, followedByMe) || other.followedByMe == followedByMe)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,squareName,userId,userAvatar,squareImg,squareDesc,chatConversationId,hasChatConversation,blogCount,followedByMe,createTime);

@override
String toString() {
  return 'SquareItem(id: $id, squareName: $squareName, userId: $userId, userAvatar: $userAvatar, squareImg: $squareImg, squareDesc: $squareDesc, chatConversationId: $chatConversationId, hasChatConversation: $hasChatConversation, blogCount: $blogCount, followedByMe: $followedByMe, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class $SquareItemCopyWith<$Res>  {
  factory $SquareItemCopyWith(SquareItem value, $Res Function(SquareItem) _then) = _$SquareItemCopyWithImpl;
@useResult
$Res call({
 int? id, String? squareName, int? userId, String? userAvatar, String? squareImg, String? squareDesc, int? chatConversationId, bool? hasChatConversation, int? blogCount, bool? followedByMe, String? createTime
});




}
/// @nodoc
class _$SquareItemCopyWithImpl<$Res>
    implements $SquareItemCopyWith<$Res> {
  _$SquareItemCopyWithImpl(this._self, this._then);

  final SquareItem _self;
  final $Res Function(SquareItem) _then;

/// Create a copy of SquareItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? squareName = freezed,Object? userId = freezed,Object? userAvatar = freezed,Object? squareImg = freezed,Object? squareDesc = freezed,Object? chatConversationId = freezed,Object? hasChatConversation = freezed,Object? blogCount = freezed,Object? followedByMe = freezed,Object? createTime = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,squareName: freezed == squareName ? _self.squareName : squareName // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,userAvatar: freezed == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String?,squareImg: freezed == squareImg ? _self.squareImg : squareImg // ignore: cast_nullable_to_non_nullable
as String?,squareDesc: freezed == squareDesc ? _self.squareDesc : squareDesc // ignore: cast_nullable_to_non_nullable
as String?,chatConversationId: freezed == chatConversationId ? _self.chatConversationId : chatConversationId // ignore: cast_nullable_to_non_nullable
as int?,hasChatConversation: freezed == hasChatConversation ? _self.hasChatConversation : hasChatConversation // ignore: cast_nullable_to_non_nullable
as bool?,blogCount: freezed == blogCount ? _self.blogCount : blogCount // ignore: cast_nullable_to_non_nullable
as int?,followedByMe: freezed == followedByMe ? _self.followedByMe : followedByMe // ignore: cast_nullable_to_non_nullable
as bool?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SquareItem].
extension SquareItemPatterns on SquareItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SquareItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SquareItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SquareItem value)  $default,){
final _that = this;
switch (_that) {
case _SquareItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SquareItem value)?  $default,){
final _that = this;
switch (_that) {
case _SquareItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? squareName,  int? userId,  String? userAvatar,  String? squareImg,  String? squareDesc,  int? chatConversationId,  bool? hasChatConversation,  int? blogCount,  bool? followedByMe,  String? createTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SquareItem() when $default != null:
return $default(_that.id,_that.squareName,_that.userId,_that.userAvatar,_that.squareImg,_that.squareDesc,_that.chatConversationId,_that.hasChatConversation,_that.blogCount,_that.followedByMe,_that.createTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? squareName,  int? userId,  String? userAvatar,  String? squareImg,  String? squareDesc,  int? chatConversationId,  bool? hasChatConversation,  int? blogCount,  bool? followedByMe,  String? createTime)  $default,) {final _that = this;
switch (_that) {
case _SquareItem():
return $default(_that.id,_that.squareName,_that.userId,_that.userAvatar,_that.squareImg,_that.squareDesc,_that.chatConversationId,_that.hasChatConversation,_that.blogCount,_that.followedByMe,_that.createTime);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? squareName,  int? userId,  String? userAvatar,  String? squareImg,  String? squareDesc,  int? chatConversationId,  bool? hasChatConversation,  int? blogCount,  bool? followedByMe,  String? createTime)?  $default,) {final _that = this;
switch (_that) {
case _SquareItem() when $default != null:
return $default(_that.id,_that.squareName,_that.userId,_that.userAvatar,_that.squareImg,_that.squareDesc,_that.chatConversationId,_that.hasChatConversation,_that.blogCount,_that.followedByMe,_that.createTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SquareItem implements SquareItem {
  const _SquareItem({this.id, this.squareName, this.userId, this.userAvatar, this.squareImg, this.squareDesc, this.chatConversationId, this.hasChatConversation, this.blogCount, this.followedByMe, this.createTime});
  factory _SquareItem.fromJson(Map<String, dynamic> json) => _$SquareItemFromJson(json);

@override final  int? id;
@override final  String? squareName;
@override final  int? userId;
@override final  String? userAvatar;
@override final  String? squareImg;
@override final  String? squareDesc;
@override final  int? chatConversationId;
@override final  bool? hasChatConversation;
@override final  int? blogCount;
@override final  bool? followedByMe;
@override final  String? createTime;

/// Create a copy of SquareItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SquareItemCopyWith<_SquareItem> get copyWith => __$SquareItemCopyWithImpl<_SquareItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SquareItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SquareItem&&(identical(other.id, id) || other.id == id)&&(identical(other.squareName, squareName) || other.squareName == squareName)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&(identical(other.squareImg, squareImg) || other.squareImg == squareImg)&&(identical(other.squareDesc, squareDesc) || other.squareDesc == squareDesc)&&(identical(other.chatConversationId, chatConversationId) || other.chatConversationId == chatConversationId)&&(identical(other.hasChatConversation, hasChatConversation) || other.hasChatConversation == hasChatConversation)&&(identical(other.blogCount, blogCount) || other.blogCount == blogCount)&&(identical(other.followedByMe, followedByMe) || other.followedByMe == followedByMe)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,squareName,userId,userAvatar,squareImg,squareDesc,chatConversationId,hasChatConversation,blogCount,followedByMe,createTime);

@override
String toString() {
  return 'SquareItem(id: $id, squareName: $squareName, userId: $userId, userAvatar: $userAvatar, squareImg: $squareImg, squareDesc: $squareDesc, chatConversationId: $chatConversationId, hasChatConversation: $hasChatConversation, blogCount: $blogCount, followedByMe: $followedByMe, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class _$SquareItemCopyWith<$Res> implements $SquareItemCopyWith<$Res> {
  factory _$SquareItemCopyWith(_SquareItem value, $Res Function(_SquareItem) _then) = __$SquareItemCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? squareName, int? userId, String? userAvatar, String? squareImg, String? squareDesc, int? chatConversationId, bool? hasChatConversation, int? blogCount, bool? followedByMe, String? createTime
});




}
/// @nodoc
class __$SquareItemCopyWithImpl<$Res>
    implements _$SquareItemCopyWith<$Res> {
  __$SquareItemCopyWithImpl(this._self, this._then);

  final _SquareItem _self;
  final $Res Function(_SquareItem) _then;

/// Create a copy of SquareItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? squareName = freezed,Object? userId = freezed,Object? userAvatar = freezed,Object? squareImg = freezed,Object? squareDesc = freezed,Object? chatConversationId = freezed,Object? hasChatConversation = freezed,Object? blogCount = freezed,Object? followedByMe = freezed,Object? createTime = freezed,}) {
  return _then(_SquareItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,squareName: freezed == squareName ? _self.squareName : squareName // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,userAvatar: freezed == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String?,squareImg: freezed == squareImg ? _self.squareImg : squareImg // ignore: cast_nullable_to_non_nullable
as String?,squareDesc: freezed == squareDesc ? _self.squareDesc : squareDesc // ignore: cast_nullable_to_non_nullable
as String?,chatConversationId: freezed == chatConversationId ? _self.chatConversationId : chatConversationId // ignore: cast_nullable_to_non_nullable
as int?,hasChatConversation: freezed == hasChatConversation ? _self.hasChatConversation : hasChatConversation // ignore: cast_nullable_to_non_nullable
as bool?,blogCount: freezed == blogCount ? _self.blogCount : blogCount // ignore: cast_nullable_to_non_nullable
as int?,followedByMe: freezed == followedByMe ? _self.followedByMe : followedByMe // ignore: cast_nullable_to_non_nullable
as bool?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SquarePageData {

 int? get total; List<SquareItem>? get list;
/// Create a copy of SquarePageData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SquarePageDataCopyWith<SquarePageData> get copyWith => _$SquarePageDataCopyWithImpl<SquarePageData>(this as SquarePageData, _$identity);

  /// Serializes this SquarePageData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SquarePageData&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.list, list));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(list));

@override
String toString() {
  return 'SquarePageData(total: $total, list: $list)';
}


}

/// @nodoc
abstract mixin class $SquarePageDataCopyWith<$Res>  {
  factory $SquarePageDataCopyWith(SquarePageData value, $Res Function(SquarePageData) _then) = _$SquarePageDataCopyWithImpl;
@useResult
$Res call({
 int? total, List<SquareItem>? list
});




}
/// @nodoc
class _$SquarePageDataCopyWithImpl<$Res>
    implements $SquarePageDataCopyWith<$Res> {
  _$SquarePageDataCopyWithImpl(this._self, this._then);

  final SquarePageData _self;
  final $Res Function(SquarePageData) _then;

/// Create a copy of SquarePageData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = freezed,Object? list = freezed,}) {
  return _then(_self.copyWith(
total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,list: freezed == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<SquareItem>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SquarePageData].
extension SquarePageDataPatterns on SquarePageData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SquarePageData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SquarePageData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SquarePageData value)  $default,){
final _that = this;
switch (_that) {
case _SquarePageData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SquarePageData value)?  $default,){
final _that = this;
switch (_that) {
case _SquarePageData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? total,  List<SquareItem>? list)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SquarePageData() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? total,  List<SquareItem>? list)  $default,) {final _that = this;
switch (_that) {
case _SquarePageData():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? total,  List<SquareItem>? list)?  $default,) {final _that = this;
switch (_that) {
case _SquarePageData() when $default != null:
return $default(_that.total,_that.list);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SquarePageData implements SquarePageData {
  const _SquarePageData({this.total, final  List<SquareItem>? list}): _list = list;
  factory _SquarePageData.fromJson(Map<String, dynamic> json) => _$SquarePageDataFromJson(json);

@override final  int? total;
 final  List<SquareItem>? _list;
@override List<SquareItem>? get list {
  final value = _list;
  if (value == null) return null;
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SquarePageData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SquarePageDataCopyWith<_SquarePageData> get copyWith => __$SquarePageDataCopyWithImpl<_SquarePageData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SquarePageDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SquarePageData&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._list, _list));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(_list));

@override
String toString() {
  return 'SquarePageData(total: $total, list: $list)';
}


}

/// @nodoc
abstract mixin class _$SquarePageDataCopyWith<$Res> implements $SquarePageDataCopyWith<$Res> {
  factory _$SquarePageDataCopyWith(_SquarePageData value, $Res Function(_SquarePageData) _then) = __$SquarePageDataCopyWithImpl;
@override @useResult
$Res call({
 int? total, List<SquareItem>? list
});




}
/// @nodoc
class __$SquarePageDataCopyWithImpl<$Res>
    implements _$SquarePageDataCopyWith<$Res> {
  __$SquarePageDataCopyWithImpl(this._self, this._then);

  final _SquarePageData _self;
  final $Res Function(_SquarePageData) _then;

/// Create a copy of SquarePageData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = freezed,Object? list = freezed,}) {
  return _then(_SquarePageData(
total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,list: freezed == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<SquareItem>?,
  ));
}


}


/// @nodoc
mixin _$SquareConversationJoinResult {

 int? get squareId; int? get chatConversationId;
/// Create a copy of SquareConversationJoinResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SquareConversationJoinResultCopyWith<SquareConversationJoinResult> get copyWith => _$SquareConversationJoinResultCopyWithImpl<SquareConversationJoinResult>(this as SquareConversationJoinResult, _$identity);

  /// Serializes this SquareConversationJoinResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SquareConversationJoinResult&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.chatConversationId, chatConversationId) || other.chatConversationId == chatConversationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,squareId,chatConversationId);

@override
String toString() {
  return 'SquareConversationJoinResult(squareId: $squareId, chatConversationId: $chatConversationId)';
}


}

/// @nodoc
abstract mixin class $SquareConversationJoinResultCopyWith<$Res>  {
  factory $SquareConversationJoinResultCopyWith(SquareConversationJoinResult value, $Res Function(SquareConversationJoinResult) _then) = _$SquareConversationJoinResultCopyWithImpl;
@useResult
$Res call({
 int? squareId, int? chatConversationId
});




}
/// @nodoc
class _$SquareConversationJoinResultCopyWithImpl<$Res>
    implements $SquareConversationJoinResultCopyWith<$Res> {
  _$SquareConversationJoinResultCopyWithImpl(this._self, this._then);

  final SquareConversationJoinResult _self;
  final $Res Function(SquareConversationJoinResult) _then;

/// Create a copy of SquareConversationJoinResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? squareId = freezed,Object? chatConversationId = freezed,}) {
  return _then(_self.copyWith(
squareId: freezed == squareId ? _self.squareId : squareId // ignore: cast_nullable_to_non_nullable
as int?,chatConversationId: freezed == chatConversationId ? _self.chatConversationId : chatConversationId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SquareConversationJoinResult].
extension SquareConversationJoinResultPatterns on SquareConversationJoinResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SquareConversationJoinResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SquareConversationJoinResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SquareConversationJoinResult value)  $default,){
final _that = this;
switch (_that) {
case _SquareConversationJoinResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SquareConversationJoinResult value)?  $default,){
final _that = this;
switch (_that) {
case _SquareConversationJoinResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? squareId,  int? chatConversationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SquareConversationJoinResult() when $default != null:
return $default(_that.squareId,_that.chatConversationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? squareId,  int? chatConversationId)  $default,) {final _that = this;
switch (_that) {
case _SquareConversationJoinResult():
return $default(_that.squareId,_that.chatConversationId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? squareId,  int? chatConversationId)?  $default,) {final _that = this;
switch (_that) {
case _SquareConversationJoinResult() when $default != null:
return $default(_that.squareId,_that.chatConversationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SquareConversationJoinResult implements SquareConversationJoinResult {
  const _SquareConversationJoinResult({this.squareId, this.chatConversationId});
  factory _SquareConversationJoinResult.fromJson(Map<String, dynamic> json) => _$SquareConversationJoinResultFromJson(json);

@override final  int? squareId;
@override final  int? chatConversationId;

/// Create a copy of SquareConversationJoinResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SquareConversationJoinResultCopyWith<_SquareConversationJoinResult> get copyWith => __$SquareConversationJoinResultCopyWithImpl<_SquareConversationJoinResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SquareConversationJoinResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SquareConversationJoinResult&&(identical(other.squareId, squareId) || other.squareId == squareId)&&(identical(other.chatConversationId, chatConversationId) || other.chatConversationId == chatConversationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,squareId,chatConversationId);

@override
String toString() {
  return 'SquareConversationJoinResult(squareId: $squareId, chatConversationId: $chatConversationId)';
}


}

/// @nodoc
abstract mixin class _$SquareConversationJoinResultCopyWith<$Res> implements $SquareConversationJoinResultCopyWith<$Res> {
  factory _$SquareConversationJoinResultCopyWith(_SquareConversationJoinResult value, $Res Function(_SquareConversationJoinResult) _then) = __$SquareConversationJoinResultCopyWithImpl;
@override @useResult
$Res call({
 int? squareId, int? chatConversationId
});




}
/// @nodoc
class __$SquareConversationJoinResultCopyWithImpl<$Res>
    implements _$SquareConversationJoinResultCopyWith<$Res> {
  __$SquareConversationJoinResultCopyWithImpl(this._self, this._then);

  final _SquareConversationJoinResult _self;
  final $Res Function(_SquareConversationJoinResult) _then;

/// Create a copy of SquareConversationJoinResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? squareId = freezed,Object? chatConversationId = freezed,}) {
  return _then(_SquareConversationJoinResult(
squareId: freezed == squareId ? _self.squareId : squareId // ignore: cast_nullable_to_non_nullable
as int?,chatConversationId: freezed == chatConversationId ? _self.chatConversationId : chatConversationId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

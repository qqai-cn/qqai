// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blog_comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlogComment {

 int? get id; int? get blogId; int? get userId; String? get nickname; String? get avatar; String? get content; int? get parentId; int? get rootId; int? get replyUserId; String? get replyNickname; int? get likeCount; bool? get liked; int? get replyCount; bool? get pinned; String? get pinTime;@JsonKey(fromJson: previewRepliesFromJson, toJson: previewRepliesToJson) List<BlogComment> get previewReplies; String? get createTime;
/// Create a copy of BlogComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogCommentCopyWith<BlogComment> get copyWith => _$BlogCommentCopyWithImpl<BlogComment>(this as BlogComment, _$identity);

  /// Serializes this BlogComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogComment&&(identical(other.id, id) || other.id == id)&&(identical(other.blogId, blogId) || other.blogId == blogId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.content, content) || other.content == content)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.rootId, rootId) || other.rootId == rootId)&&(identical(other.replyUserId, replyUserId) || other.replyUserId == replyUserId)&&(identical(other.replyNickname, replyNickname) || other.replyNickname == replyNickname)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.pinned, pinned) || other.pinned == pinned)&&(identical(other.pinTime, pinTime) || other.pinTime == pinTime)&&const DeepCollectionEquality().equals(other.previewReplies, previewReplies)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,blogId,userId,nickname,avatar,content,parentId,rootId,replyUserId,replyNickname,likeCount,liked,replyCount,pinned,pinTime,const DeepCollectionEquality().hash(previewReplies),createTime);

@override
String toString() {
  return 'BlogComment(id: $id, blogId: $blogId, userId: $userId, nickname: $nickname, avatar: $avatar, content: $content, parentId: $parentId, rootId: $rootId, replyUserId: $replyUserId, replyNickname: $replyNickname, likeCount: $likeCount, liked: $liked, replyCount: $replyCount, pinned: $pinned, pinTime: $pinTime, previewReplies: $previewReplies, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class $BlogCommentCopyWith<$Res>  {
  factory $BlogCommentCopyWith(BlogComment value, $Res Function(BlogComment) _then) = _$BlogCommentCopyWithImpl;
@useResult
$Res call({
 int? id, int? blogId, int? userId, String? nickname, String? avatar, String? content, int? parentId, int? rootId, int? replyUserId, String? replyNickname, int? likeCount, bool? liked, int? replyCount, bool? pinned, String? pinTime,@JsonKey(fromJson: previewRepliesFromJson, toJson: previewRepliesToJson) List<BlogComment> previewReplies, String? createTime
});




}
/// @nodoc
class _$BlogCommentCopyWithImpl<$Res>
    implements $BlogCommentCopyWith<$Res> {
  _$BlogCommentCopyWithImpl(this._self, this._then);

  final BlogComment _self;
  final $Res Function(BlogComment) _then;

/// Create a copy of BlogComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? blogId = freezed,Object? userId = freezed,Object? nickname = freezed,Object? avatar = freezed,Object? content = freezed,Object? parentId = freezed,Object? rootId = freezed,Object? replyUserId = freezed,Object? replyNickname = freezed,Object? likeCount = freezed,Object? liked = freezed,Object? replyCount = freezed,Object? pinned = freezed,Object? pinTime = freezed,Object? previewReplies = null,Object? createTime = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,blogId: freezed == blogId ? _self.blogId : blogId // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,rootId: freezed == rootId ? _self.rootId : rootId // ignore: cast_nullable_to_non_nullable
as int?,replyUserId: freezed == replyUserId ? _self.replyUserId : replyUserId // ignore: cast_nullable_to_non_nullable
as int?,replyNickname: freezed == replyNickname ? _self.replyNickname : replyNickname // ignore: cast_nullable_to_non_nullable
as String?,likeCount: freezed == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int?,liked: freezed == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool?,replyCount: freezed == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int?,pinned: freezed == pinned ? _self.pinned : pinned // ignore: cast_nullable_to_non_nullable
as bool?,pinTime: freezed == pinTime ? _self.pinTime : pinTime // ignore: cast_nullable_to_non_nullable
as String?,previewReplies: null == previewReplies ? _self.previewReplies : previewReplies // ignore: cast_nullable_to_non_nullable
as List<BlogComment>,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BlogComment].
extension BlogCommentPatterns on BlogComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlogComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlogComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlogComment value)  $default,){
final _that = this;
switch (_that) {
case _BlogComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlogComment value)?  $default,){
final _that = this;
switch (_that) {
case _BlogComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? blogId,  int? userId,  String? nickname,  String? avatar,  String? content,  int? parentId,  int? rootId,  int? replyUserId,  String? replyNickname,  int? likeCount,  bool? liked,  int? replyCount,  bool? pinned,  String? pinTime, @JsonKey(fromJson: previewRepliesFromJson, toJson: previewRepliesToJson)  List<BlogComment> previewReplies,  String? createTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogComment() when $default != null:
return $default(_that.id,_that.blogId,_that.userId,_that.nickname,_that.avatar,_that.content,_that.parentId,_that.rootId,_that.replyUserId,_that.replyNickname,_that.likeCount,_that.liked,_that.replyCount,_that.pinned,_that.pinTime,_that.previewReplies,_that.createTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? blogId,  int? userId,  String? nickname,  String? avatar,  String? content,  int? parentId,  int? rootId,  int? replyUserId,  String? replyNickname,  int? likeCount,  bool? liked,  int? replyCount,  bool? pinned,  String? pinTime, @JsonKey(fromJson: previewRepliesFromJson, toJson: previewRepliesToJson)  List<BlogComment> previewReplies,  String? createTime)  $default,) {final _that = this;
switch (_that) {
case _BlogComment():
return $default(_that.id,_that.blogId,_that.userId,_that.nickname,_that.avatar,_that.content,_that.parentId,_that.rootId,_that.replyUserId,_that.replyNickname,_that.likeCount,_that.liked,_that.replyCount,_that.pinned,_that.pinTime,_that.previewReplies,_that.createTime);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? blogId,  int? userId,  String? nickname,  String? avatar,  String? content,  int? parentId,  int? rootId,  int? replyUserId,  String? replyNickname,  int? likeCount,  bool? liked,  int? replyCount,  bool? pinned,  String? pinTime, @JsonKey(fromJson: previewRepliesFromJson, toJson: previewRepliesToJson)  List<BlogComment> previewReplies,  String? createTime)?  $default,) {final _that = this;
switch (_that) {
case _BlogComment() when $default != null:
return $default(_that.id,_that.blogId,_that.userId,_that.nickname,_that.avatar,_that.content,_that.parentId,_that.rootId,_that.replyUserId,_that.replyNickname,_that.likeCount,_that.liked,_that.replyCount,_that.pinned,_that.pinTime,_that.previewReplies,_that.createTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlogComment implements BlogComment {
  const _BlogComment({this.id, this.blogId, this.userId, this.nickname, this.avatar, this.content, this.parentId, this.rootId, this.replyUserId, this.replyNickname, this.likeCount, this.liked, this.replyCount, this.pinned, this.pinTime, @JsonKey(fromJson: previewRepliesFromJson, toJson: previewRepliesToJson) final  List<BlogComment> previewReplies = const [], this.createTime}): _previewReplies = previewReplies;
  factory _BlogComment.fromJson(Map<String, dynamic> json) => _$BlogCommentFromJson(json);

@override final  int? id;
@override final  int? blogId;
@override final  int? userId;
@override final  String? nickname;
@override final  String? avatar;
@override final  String? content;
@override final  int? parentId;
@override final  int? rootId;
@override final  int? replyUserId;
@override final  String? replyNickname;
@override final  int? likeCount;
@override final  bool? liked;
@override final  int? replyCount;
@override final  bool? pinned;
@override final  String? pinTime;
 final  List<BlogComment> _previewReplies;
@override@JsonKey(fromJson: previewRepliesFromJson, toJson: previewRepliesToJson) List<BlogComment> get previewReplies {
  if (_previewReplies is EqualUnmodifiableListView) return _previewReplies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_previewReplies);
}

@override final  String? createTime;

/// Create a copy of BlogComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlogCommentCopyWith<_BlogComment> get copyWith => __$BlogCommentCopyWithImpl<_BlogComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlogCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogComment&&(identical(other.id, id) || other.id == id)&&(identical(other.blogId, blogId) || other.blogId == blogId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.content, content) || other.content == content)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.rootId, rootId) || other.rootId == rootId)&&(identical(other.replyUserId, replyUserId) || other.replyUserId == replyUserId)&&(identical(other.replyNickname, replyNickname) || other.replyNickname == replyNickname)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.pinned, pinned) || other.pinned == pinned)&&(identical(other.pinTime, pinTime) || other.pinTime == pinTime)&&const DeepCollectionEquality().equals(other._previewReplies, _previewReplies)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,blogId,userId,nickname,avatar,content,parentId,rootId,replyUserId,replyNickname,likeCount,liked,replyCount,pinned,pinTime,const DeepCollectionEquality().hash(_previewReplies),createTime);

@override
String toString() {
  return 'BlogComment(id: $id, blogId: $blogId, userId: $userId, nickname: $nickname, avatar: $avatar, content: $content, parentId: $parentId, rootId: $rootId, replyUserId: $replyUserId, replyNickname: $replyNickname, likeCount: $likeCount, liked: $liked, replyCount: $replyCount, pinned: $pinned, pinTime: $pinTime, previewReplies: $previewReplies, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class _$BlogCommentCopyWith<$Res> implements $BlogCommentCopyWith<$Res> {
  factory _$BlogCommentCopyWith(_BlogComment value, $Res Function(_BlogComment) _then) = __$BlogCommentCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? blogId, int? userId, String? nickname, String? avatar, String? content, int? parentId, int? rootId, int? replyUserId, String? replyNickname, int? likeCount, bool? liked, int? replyCount, bool? pinned, String? pinTime,@JsonKey(fromJson: previewRepliesFromJson, toJson: previewRepliesToJson) List<BlogComment> previewReplies, String? createTime
});




}
/// @nodoc
class __$BlogCommentCopyWithImpl<$Res>
    implements _$BlogCommentCopyWith<$Res> {
  __$BlogCommentCopyWithImpl(this._self, this._then);

  final _BlogComment _self;
  final $Res Function(_BlogComment) _then;

/// Create a copy of BlogComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? blogId = freezed,Object? userId = freezed,Object? nickname = freezed,Object? avatar = freezed,Object? content = freezed,Object? parentId = freezed,Object? rootId = freezed,Object? replyUserId = freezed,Object? replyNickname = freezed,Object? likeCount = freezed,Object? liked = freezed,Object? replyCount = freezed,Object? pinned = freezed,Object? pinTime = freezed,Object? previewReplies = null,Object? createTime = freezed,}) {
  return _then(_BlogComment(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,blogId: freezed == blogId ? _self.blogId : blogId // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,rootId: freezed == rootId ? _self.rootId : rootId // ignore: cast_nullable_to_non_nullable
as int?,replyUserId: freezed == replyUserId ? _self.replyUserId : replyUserId // ignore: cast_nullable_to_non_nullable
as int?,replyNickname: freezed == replyNickname ? _self.replyNickname : replyNickname // ignore: cast_nullable_to_non_nullable
as String?,likeCount: freezed == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int?,liked: freezed == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool?,replyCount: freezed == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int?,pinned: freezed == pinned ? _self.pinned : pinned // ignore: cast_nullable_to_non_nullable
as bool?,pinTime: freezed == pinTime ? _self.pinTime : pinTime // ignore: cast_nullable_to_non_nullable
as String?,previewReplies: null == previewReplies ? _self._previewReplies : previewReplies // ignore: cast_nullable_to_non_nullable
as List<BlogComment>,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BlogCommentPageData {

 List<BlogComment>? get list; int? get total;
/// Create a copy of BlogCommentPageData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogCommentPageDataCopyWith<BlogCommentPageData> get copyWith => _$BlogCommentPageDataCopyWithImpl<BlogCommentPageData>(this as BlogCommentPageData, _$identity);

  /// Serializes this BlogCommentPageData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogCommentPageData&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),total);

@override
String toString() {
  return 'BlogCommentPageData(list: $list, total: $total)';
}


}

/// @nodoc
abstract mixin class $BlogCommentPageDataCopyWith<$Res>  {
  factory $BlogCommentPageDataCopyWith(BlogCommentPageData value, $Res Function(BlogCommentPageData) _then) = _$BlogCommentPageDataCopyWithImpl;
@useResult
$Res call({
 List<BlogComment>? list, int? total
});




}
/// @nodoc
class _$BlogCommentPageDataCopyWithImpl<$Res>
    implements $BlogCommentPageDataCopyWith<$Res> {
  _$BlogCommentPageDataCopyWithImpl(this._self, this._then);

  final BlogCommentPageData _self;
  final $Res Function(BlogCommentPageData) _then;

/// Create a copy of BlogCommentPageData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = freezed,Object? total = freezed,}) {
  return _then(_self.copyWith(
list: freezed == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<BlogComment>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BlogCommentPageData].
extension BlogCommentPageDataPatterns on BlogCommentPageData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlogCommentPageData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlogCommentPageData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlogCommentPageData value)  $default,){
final _that = this;
switch (_that) {
case _BlogCommentPageData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlogCommentPageData value)?  $default,){
final _that = this;
switch (_that) {
case _BlogCommentPageData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BlogComment>? list,  int? total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogCommentPageData() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BlogComment>? list,  int? total)  $default,) {final _that = this;
switch (_that) {
case _BlogCommentPageData():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BlogComment>? list,  int? total)?  $default,) {final _that = this;
switch (_that) {
case _BlogCommentPageData() when $default != null:
return $default(_that.list,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlogCommentPageData implements BlogCommentPageData {
  const _BlogCommentPageData({final  List<BlogComment>? list, this.total}): _list = list;
  factory _BlogCommentPageData.fromJson(Map<String, dynamic> json) => _$BlogCommentPageDataFromJson(json);

 final  List<BlogComment>? _list;
@override List<BlogComment>? get list {
  final value = _list;
  if (value == null) return null;
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? total;

/// Create a copy of BlogCommentPageData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlogCommentPageDataCopyWith<_BlogCommentPageData> get copyWith => __$BlogCommentPageDataCopyWithImpl<_BlogCommentPageData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlogCommentPageDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogCommentPageData&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),total);

@override
String toString() {
  return 'BlogCommentPageData(list: $list, total: $total)';
}


}

/// @nodoc
abstract mixin class _$BlogCommentPageDataCopyWith<$Res> implements $BlogCommentPageDataCopyWith<$Res> {
  factory _$BlogCommentPageDataCopyWith(_BlogCommentPageData value, $Res Function(_BlogCommentPageData) _then) = __$BlogCommentPageDataCopyWithImpl;
@override @useResult
$Res call({
 List<BlogComment>? list, int? total
});




}
/// @nodoc
class __$BlogCommentPageDataCopyWithImpl<$Res>
    implements _$BlogCommentPageDataCopyWith<$Res> {
  __$BlogCommentPageDataCopyWithImpl(this._self, this._then);

  final _BlogCommentPageData _self;
  final $Res Function(_BlogCommentPageData) _then;

/// Create a copy of BlogCommentPageData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = freezed,Object? total = freezed,}) {
  return _then(_BlogCommentPageData(
list: freezed == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<BlogComment>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

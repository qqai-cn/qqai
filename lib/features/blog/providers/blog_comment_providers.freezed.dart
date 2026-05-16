// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blog_comment_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BlogCommentFeedState {

 bool get loading; bool get loadingMore; bool get sending; String get sortType; List<BlogCommentThread> get threads; int get totalCount; int get pageNo; bool get hasMore; BlogCommentReplyTarget? get replyTarget; String? get error;
/// Create a copy of BlogCommentFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogCommentFeedStateCopyWith<BlogCommentFeedState> get copyWith => _$BlogCommentFeedStateCopyWithImpl<BlogCommentFeedState>(this as BlogCommentFeedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogCommentFeedState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.sending, sending) || other.sending == sending)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&const DeepCollectionEquality().equals(other.threads, threads)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.pageNo, pageNo) || other.pageNo == pageNo)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.replyTarget, replyTarget) || other.replyTarget == replyTarget)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,loading,loadingMore,sending,sortType,const DeepCollectionEquality().hash(threads),totalCount,pageNo,hasMore,replyTarget,error);

@override
String toString() {
  return 'BlogCommentFeedState(loading: $loading, loadingMore: $loadingMore, sending: $sending, sortType: $sortType, threads: $threads, totalCount: $totalCount, pageNo: $pageNo, hasMore: $hasMore, replyTarget: $replyTarget, error: $error)';
}


}

/// @nodoc
abstract mixin class $BlogCommentFeedStateCopyWith<$Res>  {
  factory $BlogCommentFeedStateCopyWith(BlogCommentFeedState value, $Res Function(BlogCommentFeedState) _then) = _$BlogCommentFeedStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool loadingMore, bool sending, String sortType, List<BlogCommentThread> threads, int totalCount, int pageNo, bool hasMore, BlogCommentReplyTarget? replyTarget, String? error
});




}
/// @nodoc
class _$BlogCommentFeedStateCopyWithImpl<$Res>
    implements $BlogCommentFeedStateCopyWith<$Res> {
  _$BlogCommentFeedStateCopyWithImpl(this._self, this._then);

  final BlogCommentFeedState _self;
  final $Res Function(BlogCommentFeedState) _then;

/// Create a copy of BlogCommentFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? loadingMore = null,Object? sending = null,Object? sortType = null,Object? threads = null,Object? totalCount = null,Object? pageNo = null,Object? hasMore = null,Object? replyTarget = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,sending: null == sending ? _self.sending : sending // ignore: cast_nullable_to_non_nullable
as bool,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as String,threads: null == threads ? _self.threads : threads // ignore: cast_nullable_to_non_nullable
as List<BlogCommentThread>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,pageNo: null == pageNo ? _self.pageNo : pageNo // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,replyTarget: freezed == replyTarget ? _self.replyTarget : replyTarget // ignore: cast_nullable_to_non_nullable
as BlogCommentReplyTarget?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BlogCommentFeedState].
extension BlogCommentFeedStatePatterns on BlogCommentFeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlogCommentFeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlogCommentFeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlogCommentFeedState value)  $default,){
final _that = this;
switch (_that) {
case _BlogCommentFeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlogCommentFeedState value)?  $default,){
final _that = this;
switch (_that) {
case _BlogCommentFeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool loadingMore,  bool sending,  String sortType,  List<BlogCommentThread> threads,  int totalCount,  int pageNo,  bool hasMore,  BlogCommentReplyTarget? replyTarget,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogCommentFeedState() when $default != null:
return $default(_that.loading,_that.loadingMore,_that.sending,_that.sortType,_that.threads,_that.totalCount,_that.pageNo,_that.hasMore,_that.replyTarget,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool loadingMore,  bool sending,  String sortType,  List<BlogCommentThread> threads,  int totalCount,  int pageNo,  bool hasMore,  BlogCommentReplyTarget? replyTarget,  String? error)  $default,) {final _that = this;
switch (_that) {
case _BlogCommentFeedState():
return $default(_that.loading,_that.loadingMore,_that.sending,_that.sortType,_that.threads,_that.totalCount,_that.pageNo,_that.hasMore,_that.replyTarget,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool loadingMore,  bool sending,  String sortType,  List<BlogCommentThread> threads,  int totalCount,  int pageNo,  bool hasMore,  BlogCommentReplyTarget? replyTarget,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _BlogCommentFeedState() when $default != null:
return $default(_that.loading,_that.loadingMore,_that.sending,_that.sortType,_that.threads,_that.totalCount,_that.pageNo,_that.hasMore,_that.replyTarget,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _BlogCommentFeedState implements BlogCommentFeedState {
  const _BlogCommentFeedState({this.loading = false, this.loadingMore = false, this.sending = false, this.sortType = 'hot', final  List<BlogCommentThread> threads = const [], this.totalCount = 0, this.pageNo = 1, this.hasMore = true, this.replyTarget, this.error}): _threads = threads;
  

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool loadingMore;
@override@JsonKey() final  bool sending;
@override@JsonKey() final  String sortType;
 final  List<BlogCommentThread> _threads;
@override@JsonKey() List<BlogCommentThread> get threads {
  if (_threads is EqualUnmodifiableListView) return _threads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_threads);
}

@override@JsonKey() final  int totalCount;
@override@JsonKey() final  int pageNo;
@override@JsonKey() final  bool hasMore;
@override final  BlogCommentReplyTarget? replyTarget;
@override final  String? error;

/// Create a copy of BlogCommentFeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlogCommentFeedStateCopyWith<_BlogCommentFeedState> get copyWith => __$BlogCommentFeedStateCopyWithImpl<_BlogCommentFeedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogCommentFeedState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.sending, sending) || other.sending == sending)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&const DeepCollectionEquality().equals(other._threads, _threads)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.pageNo, pageNo) || other.pageNo == pageNo)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.replyTarget, replyTarget) || other.replyTarget == replyTarget)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,loading,loadingMore,sending,sortType,const DeepCollectionEquality().hash(_threads),totalCount,pageNo,hasMore,replyTarget,error);

@override
String toString() {
  return 'BlogCommentFeedState(loading: $loading, loadingMore: $loadingMore, sending: $sending, sortType: $sortType, threads: $threads, totalCount: $totalCount, pageNo: $pageNo, hasMore: $hasMore, replyTarget: $replyTarget, error: $error)';
}


}

/// @nodoc
abstract mixin class _$BlogCommentFeedStateCopyWith<$Res> implements $BlogCommentFeedStateCopyWith<$Res> {
  factory _$BlogCommentFeedStateCopyWith(_BlogCommentFeedState value, $Res Function(_BlogCommentFeedState) _then) = __$BlogCommentFeedStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool loadingMore, bool sending, String sortType, List<BlogCommentThread> threads, int totalCount, int pageNo, bool hasMore, BlogCommentReplyTarget? replyTarget, String? error
});




}
/// @nodoc
class __$BlogCommentFeedStateCopyWithImpl<$Res>
    implements _$BlogCommentFeedStateCopyWith<$Res> {
  __$BlogCommentFeedStateCopyWithImpl(this._self, this._then);

  final _BlogCommentFeedState _self;
  final $Res Function(_BlogCommentFeedState) _then;

/// Create a copy of BlogCommentFeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? loadingMore = null,Object? sending = null,Object? sortType = null,Object? threads = null,Object? totalCount = null,Object? pageNo = null,Object? hasMore = null,Object? replyTarget = freezed,Object? error = freezed,}) {
  return _then(_BlogCommentFeedState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,sending: null == sending ? _self.sending : sending // ignore: cast_nullable_to_non_nullable
as bool,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as String,threads: null == threads ? _self._threads : threads // ignore: cast_nullable_to_non_nullable
as List<BlogCommentThread>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,pageNo: null == pageNo ? _self.pageNo : pageNo // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,replyTarget: freezed == replyTarget ? _self.replyTarget : replyTarget // ignore: cast_nullable_to_non_nullable
as BlogCommentReplyTarget?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

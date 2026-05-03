// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_recommend_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VideoRecommendState {

 AsyncValue<BlogPageModelData> get blogPageData; List<BlogItem> get allItems; int get currentPage; bool get isLoadingMore; bool get hasMore; String? get error;
/// Create a copy of VideoRecommendState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoRecommendStateCopyWith<VideoRecommendState> get copyWith => _$VideoRecommendStateCopyWithImpl<VideoRecommendState>(this as VideoRecommendState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoRecommendState&&(identical(other.blogPageData, blogPageData) || other.blogPageData == blogPageData)&&const DeepCollectionEquality().equals(other.allItems, allItems)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,blogPageData,const DeepCollectionEquality().hash(allItems),currentPage,isLoadingMore,hasMore,error);

@override
String toString() {
  return 'VideoRecommendState(blogPageData: $blogPageData, allItems: $allItems, currentPage: $currentPage, isLoadingMore: $isLoadingMore, hasMore: $hasMore, error: $error)';
}


}

/// @nodoc
abstract mixin class $VideoRecommendStateCopyWith<$Res>  {
  factory $VideoRecommendStateCopyWith(VideoRecommendState value, $Res Function(VideoRecommendState) _then) = _$VideoRecommendStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<BlogPageModelData> blogPageData, List<BlogItem> allItems, int currentPage, bool isLoadingMore, bool hasMore, String? error
});




}
/// @nodoc
class _$VideoRecommendStateCopyWithImpl<$Res>
    implements $VideoRecommendStateCopyWith<$Res> {
  _$VideoRecommendStateCopyWithImpl(this._self, this._then);

  final VideoRecommendState _self;
  final $Res Function(VideoRecommendState) _then;

/// Create a copy of VideoRecommendState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? blogPageData = null,Object? allItems = null,Object? currentPage = null,Object? isLoadingMore = null,Object? hasMore = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
blogPageData: null == blogPageData ? _self.blogPageData : blogPageData // ignore: cast_nullable_to_non_nullable
as AsyncValue<BlogPageModelData>,allItems: null == allItems ? _self.allItems : allItems // ignore: cast_nullable_to_non_nullable
as List<BlogItem>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoRecommendState].
extension VideoRecommendStatePatterns on VideoRecommendState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoRecommendState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoRecommendState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoRecommendState value)  $default,){
final _that = this;
switch (_that) {
case _VideoRecommendState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoRecommendState value)?  $default,){
final _that = this;
switch (_that) {
case _VideoRecommendState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<BlogPageModelData> blogPageData,  List<BlogItem> allItems,  int currentPage,  bool isLoadingMore,  bool hasMore,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoRecommendState() when $default != null:
return $default(_that.blogPageData,_that.allItems,_that.currentPage,_that.isLoadingMore,_that.hasMore,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<BlogPageModelData> blogPageData,  List<BlogItem> allItems,  int currentPage,  bool isLoadingMore,  bool hasMore,  String? error)  $default,) {final _that = this;
switch (_that) {
case _VideoRecommendState():
return $default(_that.blogPageData,_that.allItems,_that.currentPage,_that.isLoadingMore,_that.hasMore,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<BlogPageModelData> blogPageData,  List<BlogItem> allItems,  int currentPage,  bool isLoadingMore,  bool hasMore,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _VideoRecommendState() when $default != null:
return $default(_that.blogPageData,_that.allItems,_that.currentPage,_that.isLoadingMore,_that.hasMore,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _VideoRecommendState implements VideoRecommendState {
  const _VideoRecommendState({this.blogPageData = const AsyncLoading(), final  List<BlogItem> allItems = const [], this.currentPage = 1, this.isLoadingMore = false, this.hasMore = false, this.error}): _allItems = allItems;
  

@override@JsonKey() final  AsyncValue<BlogPageModelData> blogPageData;
 final  List<BlogItem> _allItems;
@override@JsonKey() List<BlogItem> get allItems {
  if (_allItems is EqualUnmodifiableListView) return _allItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allItems);
}

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasMore;
@override final  String? error;

/// Create a copy of VideoRecommendState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoRecommendStateCopyWith<_VideoRecommendState> get copyWith => __$VideoRecommendStateCopyWithImpl<_VideoRecommendState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoRecommendState&&(identical(other.blogPageData, blogPageData) || other.blogPageData == blogPageData)&&const DeepCollectionEquality().equals(other._allItems, _allItems)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,blogPageData,const DeepCollectionEquality().hash(_allItems),currentPage,isLoadingMore,hasMore,error);

@override
String toString() {
  return 'VideoRecommendState(blogPageData: $blogPageData, allItems: $allItems, currentPage: $currentPage, isLoadingMore: $isLoadingMore, hasMore: $hasMore, error: $error)';
}


}

/// @nodoc
abstract mixin class _$VideoRecommendStateCopyWith<$Res> implements $VideoRecommendStateCopyWith<$Res> {
  factory _$VideoRecommendStateCopyWith(_VideoRecommendState value, $Res Function(_VideoRecommendState) _then) = __$VideoRecommendStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<BlogPageModelData> blogPageData, List<BlogItem> allItems, int currentPage, bool isLoadingMore, bool hasMore, String? error
});




}
/// @nodoc
class __$VideoRecommendStateCopyWithImpl<$Res>
    implements _$VideoRecommendStateCopyWith<$Res> {
  __$VideoRecommendStateCopyWithImpl(this._self, this._then);

  final _VideoRecommendState _self;
  final $Res Function(_VideoRecommendState) _then;

/// Create a copy of VideoRecommendState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? blogPageData = null,Object? allItems = null,Object? currentPage = null,Object? isLoadingMore = null,Object? hasMore = null,Object? error = freezed,}) {
  return _then(_VideoRecommendState(
blogPageData: null == blogPageData ? _self.blogPageData : blogPageData // ignore: cast_nullable_to_non_nullable
as AsyncValue<BlogPageModelData>,allItems: null == allItems ? _self._allItems : allItems // ignore: cast_nullable_to_non_nullable
as List<BlogItem>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

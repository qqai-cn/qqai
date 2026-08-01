// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState {

 String get keyword; SearchCategory get category; SearchBlogBucket get blog; SearchBlogBucket get video; SearchGoodsBucket get goods;
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateCopyWith<SearchState> get copyWith => _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.category, category) || other.category == category)&&(identical(other.blog, blog) || other.blog == blog)&&(identical(other.video, video) || other.video == video)&&(identical(other.goods, goods) || other.goods == goods));
}


@override
int get hashCode => Object.hash(runtimeType,keyword,category,blog,video,goods);

@override
String toString() {
  return 'SearchState(keyword: $keyword, category: $category, blog: $blog, video: $video, goods: $goods)';
}


}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res>  {
  factory $SearchStateCopyWith(SearchState value, $Res Function(SearchState) _then) = _$SearchStateCopyWithImpl;
@useResult
$Res call({
 String keyword, SearchCategory category, SearchBlogBucket blog, SearchBlogBucket video, SearchGoodsBucket goods
});


$SearchBlogBucketCopyWith<$Res> get blog;$SearchBlogBucketCopyWith<$Res> get video;$SearchGoodsBucketCopyWith<$Res> get goods;

}
/// @nodoc
class _$SearchStateCopyWithImpl<$Res>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyword = null,Object? category = null,Object? blog = null,Object? video = null,Object? goods = null,}) {
  return _then(_self.copyWith(
keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SearchCategory,blog: null == blog ? _self.blog : blog // ignore: cast_nullable_to_non_nullable
as SearchBlogBucket,video: null == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as SearchBlogBucket,goods: null == goods ? _self.goods : goods // ignore: cast_nullable_to_non_nullable
as SearchGoodsBucket,
  ));
}
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchBlogBucketCopyWith<$Res> get blog {
  
  return $SearchBlogBucketCopyWith<$Res>(_self.blog, (value) {
    return _then(_self.copyWith(blog: value));
  });
}/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchBlogBucketCopyWith<$Res> get video {
  
  return $SearchBlogBucketCopyWith<$Res>(_self.video, (value) {
    return _then(_self.copyWith(video: value));
  });
}/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchGoodsBucketCopyWith<$Res> get goods {
  
  return $SearchGoodsBucketCopyWith<$Res>(_self.goods, (value) {
    return _then(_self.copyWith(goods: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchState value)  $default,){
final _that = this;
switch (_that) {
case _SearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String keyword,  SearchCategory category,  SearchBlogBucket blog,  SearchBlogBucket video,  SearchGoodsBucket goods)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.keyword,_that.category,_that.blog,_that.video,_that.goods);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String keyword,  SearchCategory category,  SearchBlogBucket blog,  SearchBlogBucket video,  SearchGoodsBucket goods)  $default,) {final _that = this;
switch (_that) {
case _SearchState():
return $default(_that.keyword,_that.category,_that.blog,_that.video,_that.goods);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String keyword,  SearchCategory category,  SearchBlogBucket blog,  SearchBlogBucket video,  SearchGoodsBucket goods)?  $default,) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.keyword,_that.category,_that.blog,_that.video,_that.goods);case _:
  return null;

}
}

}

/// @nodoc


class _SearchState extends SearchState {
  const _SearchState({this.keyword = '', this.category = SearchCategory.blog, this.blog = const SearchBlogBucket(), this.video = const SearchBlogBucket(), this.goods = const SearchGoodsBucket()}): super._();
  

@override@JsonKey() final  String keyword;
@override@JsonKey() final  SearchCategory category;
@override@JsonKey() final  SearchBlogBucket blog;
@override@JsonKey() final  SearchBlogBucket video;
@override@JsonKey() final  SearchGoodsBucket goods;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchStateCopyWith<_SearchState> get copyWith => __$SearchStateCopyWithImpl<_SearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchState&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.category, category) || other.category == category)&&(identical(other.blog, blog) || other.blog == blog)&&(identical(other.video, video) || other.video == video)&&(identical(other.goods, goods) || other.goods == goods));
}


@override
int get hashCode => Object.hash(runtimeType,keyword,category,blog,video,goods);

@override
String toString() {
  return 'SearchState(keyword: $keyword, category: $category, blog: $blog, video: $video, goods: $goods)';
}


}

/// @nodoc
abstract mixin class _$SearchStateCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory _$SearchStateCopyWith(_SearchState value, $Res Function(_SearchState) _then) = __$SearchStateCopyWithImpl;
@override @useResult
$Res call({
 String keyword, SearchCategory category, SearchBlogBucket blog, SearchBlogBucket video, SearchGoodsBucket goods
});


@override $SearchBlogBucketCopyWith<$Res> get blog;@override $SearchBlogBucketCopyWith<$Res> get video;@override $SearchGoodsBucketCopyWith<$Res> get goods;

}
/// @nodoc
class __$SearchStateCopyWithImpl<$Res>
    implements _$SearchStateCopyWith<$Res> {
  __$SearchStateCopyWithImpl(this._self, this._then);

  final _SearchState _self;
  final $Res Function(_SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyword = null,Object? category = null,Object? blog = null,Object? video = null,Object? goods = null,}) {
  return _then(_SearchState(
keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SearchCategory,blog: null == blog ? _self.blog : blog // ignore: cast_nullable_to_non_nullable
as SearchBlogBucket,video: null == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as SearchBlogBucket,goods: null == goods ? _self.goods : goods // ignore: cast_nullable_to_non_nullable
as SearchGoodsBucket,
  ));
}

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchBlogBucketCopyWith<$Res> get blog {
  
  return $SearchBlogBucketCopyWith<$Res>(_self.blog, (value) {
    return _then(_self.copyWith(blog: value));
  });
}/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchBlogBucketCopyWith<$Res> get video {
  
  return $SearchBlogBucketCopyWith<$Res>(_self.video, (value) {
    return _then(_self.copyWith(video: value));
  });
}/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchGoodsBucketCopyWith<$Res> get goods {
  
  return $SearchGoodsBucketCopyWith<$Res>(_self.goods, (value) {
    return _then(_self.copyWith(goods: value));
  });
}
}

// dart format on

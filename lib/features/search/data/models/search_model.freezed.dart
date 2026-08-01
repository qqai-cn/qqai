// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchBlogBucket {

 List<BlogItem> get items; int get pageNo; int get total; bool get loading; bool get loadingMore; String? get error;
/// Create a copy of SearchBlogBucket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchBlogBucketCopyWith<SearchBlogBucket> get copyWith => _$SearchBlogBucketCopyWithImpl<SearchBlogBucket>(this as SearchBlogBucket, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchBlogBucket&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.pageNo, pageNo) || other.pageNo == pageNo)&&(identical(other.total, total) || other.total == total)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),pageNo,total,loading,loadingMore,error);

@override
String toString() {
  return 'SearchBlogBucket(items: $items, pageNo: $pageNo, total: $total, loading: $loading, loadingMore: $loadingMore, error: $error)';
}


}

/// @nodoc
abstract mixin class $SearchBlogBucketCopyWith<$Res>  {
  factory $SearchBlogBucketCopyWith(SearchBlogBucket value, $Res Function(SearchBlogBucket) _then) = _$SearchBlogBucketCopyWithImpl;
@useResult
$Res call({
 List<BlogItem> items, int pageNo, int total, bool loading, bool loadingMore, String? error
});




}
/// @nodoc
class _$SearchBlogBucketCopyWithImpl<$Res>
    implements $SearchBlogBucketCopyWith<$Res> {
  _$SearchBlogBucketCopyWithImpl(this._self, this._then);

  final SearchBlogBucket _self;
  final $Res Function(SearchBlogBucket) _then;

/// Create a copy of SearchBlogBucket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? pageNo = null,Object? total = null,Object? loading = null,Object? loadingMore = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BlogItem>,pageNo: null == pageNo ? _self.pageNo : pageNo // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchBlogBucket].
extension SearchBlogBucketPatterns on SearchBlogBucket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchBlogBucket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchBlogBucket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchBlogBucket value)  $default,){
final _that = this;
switch (_that) {
case _SearchBlogBucket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchBlogBucket value)?  $default,){
final _that = this;
switch (_that) {
case _SearchBlogBucket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BlogItem> items,  int pageNo,  int total,  bool loading,  bool loadingMore,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchBlogBucket() when $default != null:
return $default(_that.items,_that.pageNo,_that.total,_that.loading,_that.loadingMore,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BlogItem> items,  int pageNo,  int total,  bool loading,  bool loadingMore,  String? error)  $default,) {final _that = this;
switch (_that) {
case _SearchBlogBucket():
return $default(_that.items,_that.pageNo,_that.total,_that.loading,_that.loadingMore,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BlogItem> items,  int pageNo,  int total,  bool loading,  bool loadingMore,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _SearchBlogBucket() when $default != null:
return $default(_that.items,_that.pageNo,_that.total,_that.loading,_that.loadingMore,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _SearchBlogBucket extends SearchBlogBucket {
  const _SearchBlogBucket({final  List<BlogItem> items = const [], this.pageNo = 1, this.total = 0, this.loading = false, this.loadingMore = false, this.error}): _items = items,super._();
  

 final  List<BlogItem> _items;
@override@JsonKey() List<BlogItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int pageNo;
@override@JsonKey() final  int total;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool loadingMore;
@override final  String? error;

/// Create a copy of SearchBlogBucket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchBlogBucketCopyWith<_SearchBlogBucket> get copyWith => __$SearchBlogBucketCopyWithImpl<_SearchBlogBucket>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchBlogBucket&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.pageNo, pageNo) || other.pageNo == pageNo)&&(identical(other.total, total) || other.total == total)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),pageNo,total,loading,loadingMore,error);

@override
String toString() {
  return 'SearchBlogBucket(items: $items, pageNo: $pageNo, total: $total, loading: $loading, loadingMore: $loadingMore, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SearchBlogBucketCopyWith<$Res> implements $SearchBlogBucketCopyWith<$Res> {
  factory _$SearchBlogBucketCopyWith(_SearchBlogBucket value, $Res Function(_SearchBlogBucket) _then) = __$SearchBlogBucketCopyWithImpl;
@override @useResult
$Res call({
 List<BlogItem> items, int pageNo, int total, bool loading, bool loadingMore, String? error
});




}
/// @nodoc
class __$SearchBlogBucketCopyWithImpl<$Res>
    implements _$SearchBlogBucketCopyWith<$Res> {
  __$SearchBlogBucketCopyWithImpl(this._self, this._then);

  final _SearchBlogBucket _self;
  final $Res Function(_SearchBlogBucket) _then;

/// Create a copy of SearchBlogBucket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? pageNo = null,Object? total = null,Object? loading = null,Object? loadingMore = null,Object? error = freezed,}) {
  return _then(_SearchBlogBucket(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BlogItem>,pageNo: null == pageNo ? _self.pageNo : pageNo // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$SearchGoodsBucket {

 List<MallProduct> get items; int get pageNo; int get total; bool get loading; bool get loadingMore; String? get error;
/// Create a copy of SearchGoodsBucket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchGoodsBucketCopyWith<SearchGoodsBucket> get copyWith => _$SearchGoodsBucketCopyWithImpl<SearchGoodsBucket>(this as SearchGoodsBucket, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchGoodsBucket&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.pageNo, pageNo) || other.pageNo == pageNo)&&(identical(other.total, total) || other.total == total)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),pageNo,total,loading,loadingMore,error);

@override
String toString() {
  return 'SearchGoodsBucket(items: $items, pageNo: $pageNo, total: $total, loading: $loading, loadingMore: $loadingMore, error: $error)';
}


}

/// @nodoc
abstract mixin class $SearchGoodsBucketCopyWith<$Res>  {
  factory $SearchGoodsBucketCopyWith(SearchGoodsBucket value, $Res Function(SearchGoodsBucket) _then) = _$SearchGoodsBucketCopyWithImpl;
@useResult
$Res call({
 List<MallProduct> items, int pageNo, int total, bool loading, bool loadingMore, String? error
});




}
/// @nodoc
class _$SearchGoodsBucketCopyWithImpl<$Res>
    implements $SearchGoodsBucketCopyWith<$Res> {
  _$SearchGoodsBucketCopyWithImpl(this._self, this._then);

  final SearchGoodsBucket _self;
  final $Res Function(SearchGoodsBucket) _then;

/// Create a copy of SearchGoodsBucket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? pageNo = null,Object? total = null,Object? loading = null,Object? loadingMore = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MallProduct>,pageNo: null == pageNo ? _self.pageNo : pageNo // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchGoodsBucket].
extension SearchGoodsBucketPatterns on SearchGoodsBucket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchGoodsBucket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchGoodsBucket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchGoodsBucket value)  $default,){
final _that = this;
switch (_that) {
case _SearchGoodsBucket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchGoodsBucket value)?  $default,){
final _that = this;
switch (_that) {
case _SearchGoodsBucket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MallProduct> items,  int pageNo,  int total,  bool loading,  bool loadingMore,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchGoodsBucket() when $default != null:
return $default(_that.items,_that.pageNo,_that.total,_that.loading,_that.loadingMore,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MallProduct> items,  int pageNo,  int total,  bool loading,  bool loadingMore,  String? error)  $default,) {final _that = this;
switch (_that) {
case _SearchGoodsBucket():
return $default(_that.items,_that.pageNo,_that.total,_that.loading,_that.loadingMore,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MallProduct> items,  int pageNo,  int total,  bool loading,  bool loadingMore,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _SearchGoodsBucket() when $default != null:
return $default(_that.items,_that.pageNo,_that.total,_that.loading,_that.loadingMore,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _SearchGoodsBucket extends SearchGoodsBucket {
  const _SearchGoodsBucket({final  List<MallProduct> items = const [], this.pageNo = 1, this.total = 0, this.loading = false, this.loadingMore = false, this.error}): _items = items,super._();
  

 final  List<MallProduct> _items;
@override@JsonKey() List<MallProduct> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int pageNo;
@override@JsonKey() final  int total;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool loadingMore;
@override final  String? error;

/// Create a copy of SearchGoodsBucket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchGoodsBucketCopyWith<_SearchGoodsBucket> get copyWith => __$SearchGoodsBucketCopyWithImpl<_SearchGoodsBucket>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchGoodsBucket&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.pageNo, pageNo) || other.pageNo == pageNo)&&(identical(other.total, total) || other.total == total)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),pageNo,total,loading,loadingMore,error);

@override
String toString() {
  return 'SearchGoodsBucket(items: $items, pageNo: $pageNo, total: $total, loading: $loading, loadingMore: $loadingMore, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SearchGoodsBucketCopyWith<$Res> implements $SearchGoodsBucketCopyWith<$Res> {
  factory _$SearchGoodsBucketCopyWith(_SearchGoodsBucket value, $Res Function(_SearchGoodsBucket) _then) = __$SearchGoodsBucketCopyWithImpl;
@override @useResult
$Res call({
 List<MallProduct> items, int pageNo, int total, bool loading, bool loadingMore, String? error
});




}
/// @nodoc
class __$SearchGoodsBucketCopyWithImpl<$Res>
    implements _$SearchGoodsBucketCopyWith<$Res> {
  __$SearchGoodsBucketCopyWithImpl(this._self, this._then);

  final _SearchGoodsBucket _self;
  final $Res Function(_SearchGoodsBucket) _then;

/// Create a copy of SearchGoodsBucket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? pageNo = null,Object? total = null,Object? loading = null,Object? loadingMore = null,Object? error = freezed,}) {
  return _then(_SearchGoodsBucket(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MallProduct>,pageNo: null == pageNo ? _self.pageNo : pageNo // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blog_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BlogState {

 BlogPageModel? get blogPageModel; int? get total; List<BlogItem> get blogItems; bool get isLoading; String get error; double get scrollOffset;
/// Create a copy of BlogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogStateCopyWith<BlogState> get copyWith => _$BlogStateCopyWithImpl<BlogState>(this as BlogState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogState&&(identical(other.blogPageModel, blogPageModel) || other.blogPageModel == blogPageModel)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.blogItems, blogItems)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error)&&(identical(other.scrollOffset, scrollOffset) || other.scrollOffset == scrollOffset));
}


@override
int get hashCode => Object.hash(runtimeType,blogPageModel,total,const DeepCollectionEquality().hash(blogItems),isLoading,error,scrollOffset);

@override
String toString() {
  return 'BlogState(blogPageModel: $blogPageModel, total: $total, blogItems: $blogItems, isLoading: $isLoading, error: $error, scrollOffset: $scrollOffset)';
}


}

/// @nodoc
abstract mixin class $BlogStateCopyWith<$Res>  {
  factory $BlogStateCopyWith(BlogState value, $Res Function(BlogState) _then) = _$BlogStateCopyWithImpl;
@useResult
$Res call({
 BlogPageModel? blogPageModel, int? total, List<BlogItem> blogItems, bool isLoading, String error, double scrollOffset
});




}
/// @nodoc
class _$BlogStateCopyWithImpl<$Res>
    implements $BlogStateCopyWith<$Res> {
  _$BlogStateCopyWithImpl(this._self, this._then);

  final BlogState _self;
  final $Res Function(BlogState) _then;

/// Create a copy of BlogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? blogPageModel = freezed,Object? total = freezed,Object? blogItems = null,Object? isLoading = null,Object? error = null,Object? scrollOffset = null,}) {
  return _then(_self.copyWith(
blogPageModel: freezed == blogPageModel ? _self.blogPageModel : blogPageModel // ignore: cast_nullable_to_non_nullable
as BlogPageModel?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,blogItems: null == blogItems ? _self.blogItems : blogItems // ignore: cast_nullable_to_non_nullable
as List<BlogItem>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,scrollOffset: null == scrollOffset ? _self.scrollOffset : scrollOffset // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [BlogState].
extension BlogStatePatterns on BlogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlogState value)  $default,){
final _that = this;
switch (_that) {
case _BlogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlogState value)?  $default,){
final _that = this;
switch (_that) {
case _BlogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BlogPageModel? blogPageModel,  int? total,  List<BlogItem> blogItems,  bool isLoading,  String error,  double scrollOffset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogState() when $default != null:
return $default(_that.blogPageModel,_that.total,_that.blogItems,_that.isLoading,_that.error,_that.scrollOffset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BlogPageModel? blogPageModel,  int? total,  List<BlogItem> blogItems,  bool isLoading,  String error,  double scrollOffset)  $default,) {final _that = this;
switch (_that) {
case _BlogState():
return $default(_that.blogPageModel,_that.total,_that.blogItems,_that.isLoading,_that.error,_that.scrollOffset);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BlogPageModel? blogPageModel,  int? total,  List<BlogItem> blogItems,  bool isLoading,  String error,  double scrollOffset)?  $default,) {final _that = this;
switch (_that) {
case _BlogState() when $default != null:
return $default(_that.blogPageModel,_that.total,_that.blogItems,_that.isLoading,_that.error,_that.scrollOffset);case _:
  return null;

}
}

}

/// @nodoc


class _BlogState implements BlogState {
  const _BlogState({this.blogPageModel, this.total, final  List<BlogItem> blogItems = const [], this.isLoading = false, this.error = '', this.scrollOffset = 0.0}): _blogItems = blogItems;
  

@override final  BlogPageModel? blogPageModel;
@override final  int? total;
 final  List<BlogItem> _blogItems;
@override@JsonKey() List<BlogItem> get blogItems {
  if (_blogItems is EqualUnmodifiableListView) return _blogItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blogItems);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String error;
@override@JsonKey() final  double scrollOffset;

/// Create a copy of BlogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlogStateCopyWith<_BlogState> get copyWith => __$BlogStateCopyWithImpl<_BlogState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogState&&(identical(other.blogPageModel, blogPageModel) || other.blogPageModel == blogPageModel)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._blogItems, _blogItems)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error)&&(identical(other.scrollOffset, scrollOffset) || other.scrollOffset == scrollOffset));
}


@override
int get hashCode => Object.hash(runtimeType,blogPageModel,total,const DeepCollectionEquality().hash(_blogItems),isLoading,error,scrollOffset);

@override
String toString() {
  return 'BlogState(blogPageModel: $blogPageModel, total: $total, blogItems: $blogItems, isLoading: $isLoading, error: $error, scrollOffset: $scrollOffset)';
}


}

/// @nodoc
abstract mixin class _$BlogStateCopyWith<$Res> implements $BlogStateCopyWith<$Res> {
  factory _$BlogStateCopyWith(_BlogState value, $Res Function(_BlogState) _then) = __$BlogStateCopyWithImpl;
@override @useResult
$Res call({
 BlogPageModel? blogPageModel, int? total, List<BlogItem> blogItems, bool isLoading, String error, double scrollOffset
});




}
/// @nodoc
class __$BlogStateCopyWithImpl<$Res>
    implements _$BlogStateCopyWith<$Res> {
  __$BlogStateCopyWithImpl(this._self, this._then);

  final _BlogState _self;
  final $Res Function(_BlogState) _then;

/// Create a copy of BlogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? blogPageModel = freezed,Object? total = freezed,Object? blogItems = null,Object? isLoading = null,Object? error = null,Object? scrollOffset = null,}) {
  return _then(_BlogState(
blogPageModel: freezed == blogPageModel ? _self.blogPageModel : blogPageModel // ignore: cast_nullable_to_non_nullable
as BlogPageModel?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,blogItems: null == blogItems ? _self._blogItems : blogItems // ignore: cast_nullable_to_non_nullable
as List<BlogItem>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,scrollOffset: null == scrollOffset ? _self.scrollOffset : scrollOffset // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

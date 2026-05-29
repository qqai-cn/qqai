// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_follows_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyFollowsState {

 AsyncValue<BlogFollowMemberPageData> get pageData; List<BlogFollowMember> get allItems; int get currentPage; bool get isLoadingMore; bool get hasMore; String? get error; Set<int> get unfollowingIds;
/// Create a copy of MyFollowsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyFollowsStateCopyWith<MyFollowsState> get copyWith => _$MyFollowsStateCopyWithImpl<MyFollowsState>(this as MyFollowsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyFollowsState&&(identical(other.pageData, pageData) || other.pageData == pageData)&&const DeepCollectionEquality().equals(other.allItems, allItems)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.unfollowingIds, unfollowingIds));
}


@override
int get hashCode => Object.hash(runtimeType,pageData,const DeepCollectionEquality().hash(allItems),currentPage,isLoadingMore,hasMore,error,const DeepCollectionEquality().hash(unfollowingIds));

@override
String toString() {
  return 'MyFollowsState(pageData: $pageData, allItems: $allItems, currentPage: $currentPage, isLoadingMore: $isLoadingMore, hasMore: $hasMore, error: $error, unfollowingIds: $unfollowingIds)';
}


}

/// @nodoc
abstract mixin class $MyFollowsStateCopyWith<$Res>  {
  factory $MyFollowsStateCopyWith(MyFollowsState value, $Res Function(MyFollowsState) _then) = _$MyFollowsStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<BlogFollowMemberPageData> pageData, List<BlogFollowMember> allItems, int currentPage, bool isLoadingMore, bool hasMore, String? error, Set<int> unfollowingIds
});




}
/// @nodoc
class _$MyFollowsStateCopyWithImpl<$Res>
    implements $MyFollowsStateCopyWith<$Res> {
  _$MyFollowsStateCopyWithImpl(this._self, this._then);

  final MyFollowsState _self;
  final $Res Function(MyFollowsState) _then;

/// Create a copy of MyFollowsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageData = null,Object? allItems = null,Object? currentPage = null,Object? isLoadingMore = null,Object? hasMore = null,Object? error = freezed,Object? unfollowingIds = null,}) {
  return _then(_self.copyWith(
pageData: null == pageData ? _self.pageData : pageData // ignore: cast_nullable_to_non_nullable
as AsyncValue<BlogFollowMemberPageData>,allItems: null == allItems ? _self.allItems : allItems // ignore: cast_nullable_to_non_nullable
as List<BlogFollowMember>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,unfollowingIds: null == unfollowingIds ? _self.unfollowingIds : unfollowingIds // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [MyFollowsState].
extension MyFollowsStatePatterns on MyFollowsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyFollowsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyFollowsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyFollowsState value)  $default,){
final _that = this;
switch (_that) {
case _MyFollowsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyFollowsState value)?  $default,){
final _that = this;
switch (_that) {
case _MyFollowsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<BlogFollowMemberPageData> pageData,  List<BlogFollowMember> allItems,  int currentPage,  bool isLoadingMore,  bool hasMore,  String? error,  Set<int> unfollowingIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyFollowsState() when $default != null:
return $default(_that.pageData,_that.allItems,_that.currentPage,_that.isLoadingMore,_that.hasMore,_that.error,_that.unfollowingIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<BlogFollowMemberPageData> pageData,  List<BlogFollowMember> allItems,  int currentPage,  bool isLoadingMore,  bool hasMore,  String? error,  Set<int> unfollowingIds)  $default,) {final _that = this;
switch (_that) {
case _MyFollowsState():
return $default(_that.pageData,_that.allItems,_that.currentPage,_that.isLoadingMore,_that.hasMore,_that.error,_that.unfollowingIds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<BlogFollowMemberPageData> pageData,  List<BlogFollowMember> allItems,  int currentPage,  bool isLoadingMore,  bool hasMore,  String? error,  Set<int> unfollowingIds)?  $default,) {final _that = this;
switch (_that) {
case _MyFollowsState() when $default != null:
return $default(_that.pageData,_that.allItems,_that.currentPage,_that.isLoadingMore,_that.hasMore,_that.error,_that.unfollowingIds);case _:
  return null;

}
}

}

/// @nodoc


class _MyFollowsState implements MyFollowsState {
  const _MyFollowsState({this.pageData = const AsyncLoading(), final  List<BlogFollowMember> allItems = const [], this.currentPage = 1, this.isLoadingMore = false, this.hasMore = false, this.error, final  Set<int> unfollowingIds = const {}}): _allItems = allItems,_unfollowingIds = unfollowingIds;
  

@override@JsonKey() final  AsyncValue<BlogFollowMemberPageData> pageData;
 final  List<BlogFollowMember> _allItems;
@override@JsonKey() List<BlogFollowMember> get allItems {
  if (_allItems is EqualUnmodifiableListView) return _allItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allItems);
}

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasMore;
@override final  String? error;
 final  Set<int> _unfollowingIds;
@override@JsonKey() Set<int> get unfollowingIds {
  if (_unfollowingIds is EqualUnmodifiableSetView) return _unfollowingIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_unfollowingIds);
}


/// Create a copy of MyFollowsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyFollowsStateCopyWith<_MyFollowsState> get copyWith => __$MyFollowsStateCopyWithImpl<_MyFollowsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyFollowsState&&(identical(other.pageData, pageData) || other.pageData == pageData)&&const DeepCollectionEquality().equals(other._allItems, _allItems)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other._unfollowingIds, _unfollowingIds));
}


@override
int get hashCode => Object.hash(runtimeType,pageData,const DeepCollectionEquality().hash(_allItems),currentPage,isLoadingMore,hasMore,error,const DeepCollectionEquality().hash(_unfollowingIds));

@override
String toString() {
  return 'MyFollowsState(pageData: $pageData, allItems: $allItems, currentPage: $currentPage, isLoadingMore: $isLoadingMore, hasMore: $hasMore, error: $error, unfollowingIds: $unfollowingIds)';
}


}

/// @nodoc
abstract mixin class _$MyFollowsStateCopyWith<$Res> implements $MyFollowsStateCopyWith<$Res> {
  factory _$MyFollowsStateCopyWith(_MyFollowsState value, $Res Function(_MyFollowsState) _then) = __$MyFollowsStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<BlogFollowMemberPageData> pageData, List<BlogFollowMember> allItems, int currentPage, bool isLoadingMore, bool hasMore, String? error, Set<int> unfollowingIds
});




}
/// @nodoc
class __$MyFollowsStateCopyWithImpl<$Res>
    implements _$MyFollowsStateCopyWith<$Res> {
  __$MyFollowsStateCopyWithImpl(this._self, this._then);

  final _MyFollowsState _self;
  final $Res Function(_MyFollowsState) _then;

/// Create a copy of MyFollowsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageData = null,Object? allItems = null,Object? currentPage = null,Object? isLoadingMore = null,Object? hasMore = null,Object? error = freezed,Object? unfollowingIds = null,}) {
  return _then(_MyFollowsState(
pageData: null == pageData ? _self.pageData : pageData // ignore: cast_nullable_to_non_nullable
as AsyncValue<BlogFollowMemberPageData>,allItems: null == allItems ? _self._allItems : allItems // ignore: cast_nullable_to_non_nullable
as List<BlogFollowMember>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,unfollowingIds: null == unfollowingIds ? _self._unfollowingIds : unfollowingIds // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}


}

// dart format on

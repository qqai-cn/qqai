// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_followers_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyFollowersState {

 AsyncValue<BlogFollowMemberPageData> get pageData; List<BlogFollowMember> get allItems; int get currentPage; bool get isLoadingMore; bool get hasMore; String? get error; Set<int> get togglingIds;
/// Create a copy of MyFollowersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyFollowersStateCopyWith<MyFollowersState> get copyWith => _$MyFollowersStateCopyWithImpl<MyFollowersState>(this as MyFollowersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyFollowersState&&(identical(other.pageData, pageData) || other.pageData == pageData)&&const DeepCollectionEquality().equals(other.allItems, allItems)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.togglingIds, togglingIds));
}


@override
int get hashCode => Object.hash(runtimeType,pageData,const DeepCollectionEquality().hash(allItems),currentPage,isLoadingMore,hasMore,error,const DeepCollectionEquality().hash(togglingIds));

@override
String toString() {
  return 'MyFollowersState(pageData: $pageData, allItems: $allItems, currentPage: $currentPage, isLoadingMore: $isLoadingMore, hasMore: $hasMore, error: $error, togglingIds: $togglingIds)';
}


}

/// @nodoc
abstract mixin class $MyFollowersStateCopyWith<$Res>  {
  factory $MyFollowersStateCopyWith(MyFollowersState value, $Res Function(MyFollowersState) _then) = _$MyFollowersStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<BlogFollowMemberPageData> pageData, List<BlogFollowMember> allItems, int currentPage, bool isLoadingMore, bool hasMore, String? error, Set<int> togglingIds
});




}
/// @nodoc
class _$MyFollowersStateCopyWithImpl<$Res>
    implements $MyFollowersStateCopyWith<$Res> {
  _$MyFollowersStateCopyWithImpl(this._self, this._then);

  final MyFollowersState _self;
  final $Res Function(MyFollowersState) _then;

/// Create a copy of MyFollowersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageData = null,Object? allItems = null,Object? currentPage = null,Object? isLoadingMore = null,Object? hasMore = null,Object? error = freezed,Object? togglingIds = null,}) {
  return _then(_self.copyWith(
pageData: null == pageData ? _self.pageData : pageData // ignore: cast_nullable_to_non_nullable
as AsyncValue<BlogFollowMemberPageData>,allItems: null == allItems ? _self.allItems : allItems // ignore: cast_nullable_to_non_nullable
as List<BlogFollowMember>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,togglingIds: null == togglingIds ? _self.togglingIds : togglingIds // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [MyFollowersState].
extension MyFollowersStatePatterns on MyFollowersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyFollowersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyFollowersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyFollowersState value)  $default,){
final _that = this;
switch (_that) {
case _MyFollowersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyFollowersState value)?  $default,){
final _that = this;
switch (_that) {
case _MyFollowersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<BlogFollowMemberPageData> pageData,  List<BlogFollowMember> allItems,  int currentPage,  bool isLoadingMore,  bool hasMore,  String? error,  Set<int> togglingIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyFollowersState() when $default != null:
return $default(_that.pageData,_that.allItems,_that.currentPage,_that.isLoadingMore,_that.hasMore,_that.error,_that.togglingIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<BlogFollowMemberPageData> pageData,  List<BlogFollowMember> allItems,  int currentPage,  bool isLoadingMore,  bool hasMore,  String? error,  Set<int> togglingIds)  $default,) {final _that = this;
switch (_that) {
case _MyFollowersState():
return $default(_that.pageData,_that.allItems,_that.currentPage,_that.isLoadingMore,_that.hasMore,_that.error,_that.togglingIds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<BlogFollowMemberPageData> pageData,  List<BlogFollowMember> allItems,  int currentPage,  bool isLoadingMore,  bool hasMore,  String? error,  Set<int> togglingIds)?  $default,) {final _that = this;
switch (_that) {
case _MyFollowersState() when $default != null:
return $default(_that.pageData,_that.allItems,_that.currentPage,_that.isLoadingMore,_that.hasMore,_that.error,_that.togglingIds);case _:
  return null;

}
}

}

/// @nodoc


class _MyFollowersState implements MyFollowersState {
  const _MyFollowersState({this.pageData = const AsyncLoading(), final  List<BlogFollowMember> allItems = const [], this.currentPage = 1, this.isLoadingMore = false, this.hasMore = false, this.error, final  Set<int> togglingIds = const {}}): _allItems = allItems,_togglingIds = togglingIds;
  

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
 final  Set<int> _togglingIds;
@override@JsonKey() Set<int> get togglingIds {
  if (_togglingIds is EqualUnmodifiableSetView) return _togglingIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_togglingIds);
}


/// Create a copy of MyFollowersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyFollowersStateCopyWith<_MyFollowersState> get copyWith => __$MyFollowersStateCopyWithImpl<_MyFollowersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyFollowersState&&(identical(other.pageData, pageData) || other.pageData == pageData)&&const DeepCollectionEquality().equals(other._allItems, _allItems)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other._togglingIds, _togglingIds));
}


@override
int get hashCode => Object.hash(runtimeType,pageData,const DeepCollectionEquality().hash(_allItems),currentPage,isLoadingMore,hasMore,error,const DeepCollectionEquality().hash(_togglingIds));

@override
String toString() {
  return 'MyFollowersState(pageData: $pageData, allItems: $allItems, currentPage: $currentPage, isLoadingMore: $isLoadingMore, hasMore: $hasMore, error: $error, togglingIds: $togglingIds)';
}


}

/// @nodoc
abstract mixin class _$MyFollowersStateCopyWith<$Res> implements $MyFollowersStateCopyWith<$Res> {
  factory _$MyFollowersStateCopyWith(_MyFollowersState value, $Res Function(_MyFollowersState) _then) = __$MyFollowersStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<BlogFollowMemberPageData> pageData, List<BlogFollowMember> allItems, int currentPage, bool isLoadingMore, bool hasMore, String? error, Set<int> togglingIds
});




}
/// @nodoc
class __$MyFollowersStateCopyWithImpl<$Res>
    implements _$MyFollowersStateCopyWith<$Res> {
  __$MyFollowersStateCopyWithImpl(this._self, this._then);

  final _MyFollowersState _self;
  final $Res Function(_MyFollowersState) _then;

/// Create a copy of MyFollowersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageData = null,Object? allItems = null,Object? currentPage = null,Object? isLoadingMore = null,Object? hasMore = null,Object? error = freezed,Object? togglingIds = null,}) {
  return _then(_MyFollowersState(
pageData: null == pageData ? _self.pageData : pageData // ignore: cast_nullable_to_non_nullable
as AsyncValue<BlogFollowMemberPageData>,allItems: null == allItems ? _self._allItems : allItems // ignore: cast_nullable_to_non_nullable
as List<BlogFollowMember>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,togglingIds: null == togglingIds ? _self._togglingIds : togglingIds // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}


}

// dart format on

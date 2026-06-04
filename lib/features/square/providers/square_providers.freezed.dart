// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'square_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SquareListState {

 AsyncValue<SquarePageData> get pageData; List<SquareItem> get allItems; int get currentPage; bool get hasMore; bool get isLoadingMore; bool get isRefreshing; String? get error;
/// Create a copy of SquareListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SquareListStateCopyWith<SquareListState> get copyWith => _$SquareListStateCopyWithImpl<SquareListState>(this as SquareListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SquareListState&&(identical(other.pageData, pageData) || other.pageData == pageData)&&const DeepCollectionEquality().equals(other.allItems, allItems)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,pageData,const DeepCollectionEquality().hash(allItems),currentPage,hasMore,isLoadingMore,isRefreshing,error);

@override
String toString() {
  return 'SquareListState(pageData: $pageData, allItems: $allItems, currentPage: $currentPage, hasMore: $hasMore, isLoadingMore: $isLoadingMore, isRefreshing: $isRefreshing, error: $error)';
}


}

/// @nodoc
abstract mixin class $SquareListStateCopyWith<$Res>  {
  factory $SquareListStateCopyWith(SquareListState value, $Res Function(SquareListState) _then) = _$SquareListStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<SquarePageData> pageData, List<SquareItem> allItems, int currentPage, bool hasMore, bool isLoadingMore, bool isRefreshing, String? error
});




}
/// @nodoc
class _$SquareListStateCopyWithImpl<$Res>
    implements $SquareListStateCopyWith<$Res> {
  _$SquareListStateCopyWithImpl(this._self, this._then);

  final SquareListState _self;
  final $Res Function(SquareListState) _then;

/// Create a copy of SquareListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageData = null,Object? allItems = null,Object? currentPage = null,Object? hasMore = null,Object? isLoadingMore = null,Object? isRefreshing = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
pageData: null == pageData ? _self.pageData : pageData // ignore: cast_nullable_to_non_nullable
as AsyncValue<SquarePageData>,allItems: null == allItems ? _self.allItems : allItems // ignore: cast_nullable_to_non_nullable
as List<SquareItem>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SquareListState].
extension SquareListStatePatterns on SquareListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SquareListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SquareListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SquareListState value)  $default,){
final _that = this;
switch (_that) {
case _SquareListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SquareListState value)?  $default,){
final _that = this;
switch (_that) {
case _SquareListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<SquarePageData> pageData,  List<SquareItem> allItems,  int currentPage,  bool hasMore,  bool isLoadingMore,  bool isRefreshing,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SquareListState() when $default != null:
return $default(_that.pageData,_that.allItems,_that.currentPage,_that.hasMore,_that.isLoadingMore,_that.isRefreshing,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<SquarePageData> pageData,  List<SquareItem> allItems,  int currentPage,  bool hasMore,  bool isLoadingMore,  bool isRefreshing,  String? error)  $default,) {final _that = this;
switch (_that) {
case _SquareListState():
return $default(_that.pageData,_that.allItems,_that.currentPage,_that.hasMore,_that.isLoadingMore,_that.isRefreshing,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<SquarePageData> pageData,  List<SquareItem> allItems,  int currentPage,  bool hasMore,  bool isLoadingMore,  bool isRefreshing,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _SquareListState() when $default != null:
return $default(_that.pageData,_that.allItems,_that.currentPage,_that.hasMore,_that.isLoadingMore,_that.isRefreshing,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _SquareListState implements SquareListState {
  const _SquareListState({this.pageData = const AsyncLoading(), final  List<SquareItem> allItems = const [], this.currentPage = 1, this.hasMore = false, this.isLoadingMore = false, this.isRefreshing = false, this.error}): _allItems = allItems;
  

@override@JsonKey() final  AsyncValue<SquarePageData> pageData;
 final  List<SquareItem> _allItems;
@override@JsonKey() List<SquareItem> get allItems {
  if (_allItems is EqualUnmodifiableListView) return _allItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allItems);
}

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool isRefreshing;
@override final  String? error;

/// Create a copy of SquareListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SquareListStateCopyWith<_SquareListState> get copyWith => __$SquareListStateCopyWithImpl<_SquareListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SquareListState&&(identical(other.pageData, pageData) || other.pageData == pageData)&&const DeepCollectionEquality().equals(other._allItems, _allItems)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,pageData,const DeepCollectionEquality().hash(_allItems),currentPage,hasMore,isLoadingMore,isRefreshing,error);

@override
String toString() {
  return 'SquareListState(pageData: $pageData, allItems: $allItems, currentPage: $currentPage, hasMore: $hasMore, isLoadingMore: $isLoadingMore, isRefreshing: $isRefreshing, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SquareListStateCopyWith<$Res> implements $SquareListStateCopyWith<$Res> {
  factory _$SquareListStateCopyWith(_SquareListState value, $Res Function(_SquareListState) _then) = __$SquareListStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<SquarePageData> pageData, List<SquareItem> allItems, int currentPage, bool hasMore, bool isLoadingMore, bool isRefreshing, String? error
});




}
/// @nodoc
class __$SquareListStateCopyWithImpl<$Res>
    implements _$SquareListStateCopyWith<$Res> {
  __$SquareListStateCopyWithImpl(this._self, this._then);

  final _SquareListState _self;
  final $Res Function(_SquareListState) _then;

/// Create a copy of SquareListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageData = null,Object? allItems = null,Object? currentPage = null,Object? hasMore = null,Object? isLoadingMore = null,Object? isRefreshing = null,Object? error = freezed,}) {
  return _then(_SquareListState(
pageData: null == pageData ? _self.pageData : pageData // ignore: cast_nullable_to_non_nullable
as AsyncValue<SquarePageData>,allItems: null == allItems ? _self._allItems : allItems // ignore: cast_nullable_to_non_nullable
as List<SquareItem>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

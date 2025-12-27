// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fabu_zuopin_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FabuZuoPinState {

 TabController? get tabController; List<String> get tabTitle; List<Widget> get tabBoby;
/// Create a copy of FabuZuoPinState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FabuZuoPinStateCopyWith<FabuZuoPinState> get copyWith => _$FabuZuoPinStateCopyWithImpl<FabuZuoPinState>(this as FabuZuoPinState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FabuZuoPinState&&(identical(other.tabController, tabController) || other.tabController == tabController)&&const DeepCollectionEquality().equals(other.tabTitle, tabTitle)&&const DeepCollectionEquality().equals(other.tabBoby, tabBoby));
}


@override
int get hashCode => Object.hash(runtimeType,tabController,const DeepCollectionEquality().hash(tabTitle),const DeepCollectionEquality().hash(tabBoby));

@override
String toString() {
  return 'FabuZuoPinState(tabController: $tabController, tabTitle: $tabTitle, tabBoby: $tabBoby)';
}


}

/// @nodoc
abstract mixin class $FabuZuoPinStateCopyWith<$Res>  {
  factory $FabuZuoPinStateCopyWith(FabuZuoPinState value, $Res Function(FabuZuoPinState) _then) = _$FabuZuoPinStateCopyWithImpl;
@useResult
$Res call({
 TabController? tabController, List<String> tabTitle, List<Widget> tabBoby
});




}
/// @nodoc
class _$FabuZuoPinStateCopyWithImpl<$Res>
    implements $FabuZuoPinStateCopyWith<$Res> {
  _$FabuZuoPinStateCopyWithImpl(this._self, this._then);

  final FabuZuoPinState _self;
  final $Res Function(FabuZuoPinState) _then;

/// Create a copy of FabuZuoPinState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tabController = freezed,Object? tabTitle = null,Object? tabBoby = null,}) {
  return _then(_self.copyWith(
tabController: freezed == tabController ? _self.tabController : tabController // ignore: cast_nullable_to_non_nullable
as TabController?,tabTitle: null == tabTitle ? _self.tabTitle : tabTitle // ignore: cast_nullable_to_non_nullable
as List<String>,tabBoby: null == tabBoby ? _self.tabBoby : tabBoby // ignore: cast_nullable_to_non_nullable
as List<Widget>,
  ));
}

}


/// Adds pattern-matching-related methods to [FabuZuoPinState].
extension FabuZuoPinStatePatterns on FabuZuoPinState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FabuZuoPinState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FabuZuoPinState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FabuZuoPinState value)  $default,){
final _that = this;
switch (_that) {
case _FabuZuoPinState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FabuZuoPinState value)?  $default,){
final _that = this;
switch (_that) {
case _FabuZuoPinState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TabController? tabController,  List<String> tabTitle,  List<Widget> tabBoby)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FabuZuoPinState() when $default != null:
return $default(_that.tabController,_that.tabTitle,_that.tabBoby);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TabController? tabController,  List<String> tabTitle,  List<Widget> tabBoby)  $default,) {final _that = this;
switch (_that) {
case _FabuZuoPinState():
return $default(_that.tabController,_that.tabTitle,_that.tabBoby);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TabController? tabController,  List<String> tabTitle,  List<Widget> tabBoby)?  $default,) {final _that = this;
switch (_that) {
case _FabuZuoPinState() when $default != null:
return $default(_that.tabController,_that.tabTitle,_that.tabBoby);case _:
  return null;

}
}

}

/// @nodoc


class _FabuZuoPinState implements FabuZuoPinState {
  const _FabuZuoPinState({this.tabController, final  List<String> tabTitle = const ['发布动态', '发布视频', '发布商品', '发布爱心'], final  List<Widget> tabBoby = const []}): _tabTitle = tabTitle,_tabBoby = tabBoby;
  

@override final  TabController? tabController;
 final  List<String> _tabTitle;
@override@JsonKey() List<String> get tabTitle {
  if (_tabTitle is EqualUnmodifiableListView) return _tabTitle;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tabTitle);
}

 final  List<Widget> _tabBoby;
@override@JsonKey() List<Widget> get tabBoby {
  if (_tabBoby is EqualUnmodifiableListView) return _tabBoby;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tabBoby);
}


/// Create a copy of FabuZuoPinState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FabuZuoPinStateCopyWith<_FabuZuoPinState> get copyWith => __$FabuZuoPinStateCopyWithImpl<_FabuZuoPinState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FabuZuoPinState&&(identical(other.tabController, tabController) || other.tabController == tabController)&&const DeepCollectionEquality().equals(other._tabTitle, _tabTitle)&&const DeepCollectionEquality().equals(other._tabBoby, _tabBoby));
}


@override
int get hashCode => Object.hash(runtimeType,tabController,const DeepCollectionEquality().hash(_tabTitle),const DeepCollectionEquality().hash(_tabBoby));

@override
String toString() {
  return 'FabuZuoPinState(tabController: $tabController, tabTitle: $tabTitle, tabBoby: $tabBoby)';
}


}

/// @nodoc
abstract mixin class _$FabuZuoPinStateCopyWith<$Res> implements $FabuZuoPinStateCopyWith<$Res> {
  factory _$FabuZuoPinStateCopyWith(_FabuZuoPinState value, $Res Function(_FabuZuoPinState) _then) = __$FabuZuoPinStateCopyWithImpl;
@override @useResult
$Res call({
 TabController? tabController, List<String> tabTitle, List<Widget> tabBoby
});




}
/// @nodoc
class __$FabuZuoPinStateCopyWithImpl<$Res>
    implements _$FabuZuoPinStateCopyWith<$Res> {
  __$FabuZuoPinStateCopyWithImpl(this._self, this._then);

  final _FabuZuoPinState _self;
  final $Res Function(_FabuZuoPinState) _then;

/// Create a copy of FabuZuoPinState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tabController = freezed,Object? tabTitle = null,Object? tabBoby = null,}) {
  return _then(_FabuZuoPinState(
tabController: freezed == tabController ? _self.tabController : tabController // ignore: cast_nullable_to_non_nullable
as TabController?,tabTitle: null == tabTitle ? _self._tabTitle : tabTitle // ignore: cast_nullable_to_non_nullable
as List<String>,tabBoby: null == tabBoby ? _self._tabBoby : tabBoby // ignore: cast_nullable_to_non_nullable
as List<Widget>,
  ));
}


}

// dart format on

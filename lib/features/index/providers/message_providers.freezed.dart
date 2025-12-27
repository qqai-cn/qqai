// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MessageState {

 List<String> get tabTitle; TabController? get tabController;
/// Create a copy of MessageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageStateCopyWith<MessageState> get copyWith => _$MessageStateCopyWithImpl<MessageState>(this as MessageState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageState&&const DeepCollectionEquality().equals(other.tabTitle, tabTitle)&&(identical(other.tabController, tabController) || other.tabController == tabController));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tabTitle),tabController);

@override
String toString() {
  return 'MessageState(tabTitle: $tabTitle, tabController: $tabController)';
}


}

/// @nodoc
abstract mixin class $MessageStateCopyWith<$Res>  {
  factory $MessageStateCopyWith(MessageState value, $Res Function(MessageState) _then) = _$MessageStateCopyWithImpl;
@useResult
$Res call({
 List<String> tabTitle, TabController? tabController
});




}
/// @nodoc
class _$MessageStateCopyWithImpl<$Res>
    implements $MessageStateCopyWith<$Res> {
  _$MessageStateCopyWithImpl(this._self, this._then);

  final MessageState _self;
  final $Res Function(MessageState) _then;

/// Create a copy of MessageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tabTitle = null,Object? tabController = freezed,}) {
  return _then(_self.copyWith(
tabTitle: null == tabTitle ? _self.tabTitle : tabTitle // ignore: cast_nullable_to_non_nullable
as List<String>,tabController: freezed == tabController ? _self.tabController : tabController // ignore: cast_nullable_to_non_nullable
as TabController?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageState].
extension MessageStatePatterns on MessageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageState value)  $default,){
final _that = this;
switch (_that) {
case _MessageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageState value)?  $default,){
final _that = this;
switch (_that) {
case _MessageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> tabTitle,  TabController? tabController)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageState() when $default != null:
return $default(_that.tabTitle,_that.tabController);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> tabTitle,  TabController? tabController)  $default,) {final _that = this;
switch (_that) {
case _MessageState():
return $default(_that.tabTitle,_that.tabController);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> tabTitle,  TabController? tabController)?  $default,) {final _that = this;
switch (_that) {
case _MessageState() when $default != null:
return $default(_that.tabTitle,_that.tabController);case _:
  return null;

}
}

}

/// @nodoc


class _MessageState implements MessageState {
  const _MessageState({final  List<String> tabTitle = const [], this.tabController}): _tabTitle = tabTitle;
  

 final  List<String> _tabTitle;
@override@JsonKey() List<String> get tabTitle {
  if (_tabTitle is EqualUnmodifiableListView) return _tabTitle;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tabTitle);
}

@override final  TabController? tabController;

/// Create a copy of MessageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageStateCopyWith<_MessageState> get copyWith => __$MessageStateCopyWithImpl<_MessageState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageState&&const DeepCollectionEquality().equals(other._tabTitle, _tabTitle)&&(identical(other.tabController, tabController) || other.tabController == tabController));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tabTitle),tabController);

@override
String toString() {
  return 'MessageState(tabTitle: $tabTitle, tabController: $tabController)';
}


}

/// @nodoc
abstract mixin class _$MessageStateCopyWith<$Res> implements $MessageStateCopyWith<$Res> {
  factory _$MessageStateCopyWith(_MessageState value, $Res Function(_MessageState) _then) = __$MessageStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> tabTitle, TabController? tabController
});




}
/// @nodoc
class __$MessageStateCopyWithImpl<$Res>
    implements _$MessageStateCopyWith<$Res> {
  __$MessageStateCopyWithImpl(this._self, this._then);

  final _MessageState _self;
  final $Res Function(_MessageState) _then;

/// Create a copy of MessageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tabTitle = null,Object? tabController = freezed,}) {
  return _then(_MessageState(
tabTitle: null == tabTitle ? _self._tabTitle : tabTitle // ignore: cast_nullable_to_non_nullable
as List<String>,tabController: freezed == tabController ? _self.tabController : tabController // ignore: cast_nullable_to_non_nullable
as TabController?,
  ));
}


}

// dart format on

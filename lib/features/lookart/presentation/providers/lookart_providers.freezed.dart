// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lookart_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LookArtState {

 int get contentLine; bool get hiddenRight; int get selectItemIndex; bool get allComment; String get text; bool get ifInputing; TabController? get tabController;
/// Create a copy of LookArtState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LookArtStateCopyWith<LookArtState> get copyWith => _$LookArtStateCopyWithImpl<LookArtState>(this as LookArtState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LookArtState&&(identical(other.contentLine, contentLine) || other.contentLine == contentLine)&&(identical(other.hiddenRight, hiddenRight) || other.hiddenRight == hiddenRight)&&(identical(other.selectItemIndex, selectItemIndex) || other.selectItemIndex == selectItemIndex)&&(identical(other.allComment, allComment) || other.allComment == allComment)&&(identical(other.text, text) || other.text == text)&&(identical(other.ifInputing, ifInputing) || other.ifInputing == ifInputing)&&(identical(other.tabController, tabController) || other.tabController == tabController));
}


@override
int get hashCode => Object.hash(runtimeType,contentLine,hiddenRight,selectItemIndex,allComment,text,ifInputing,tabController);

@override
String toString() {
  return 'LookArtState(contentLine: $contentLine, hiddenRight: $hiddenRight, selectItemIndex: $selectItemIndex, allComment: $allComment, text: $text, ifInputing: $ifInputing, tabController: $tabController)';
}


}

/// @nodoc
abstract mixin class $LookArtStateCopyWith<$Res>  {
  factory $LookArtStateCopyWith(LookArtState value, $Res Function(LookArtState) _then) = _$LookArtStateCopyWithImpl;
@useResult
$Res call({
 int contentLine, bool hiddenRight, int selectItemIndex, bool allComment, String text, bool ifInputing, TabController? tabController
});




}
/// @nodoc
class _$LookArtStateCopyWithImpl<$Res>
    implements $LookArtStateCopyWith<$Res> {
  _$LookArtStateCopyWithImpl(this._self, this._then);

  final LookArtState _self;
  final $Res Function(LookArtState) _then;

/// Create a copy of LookArtState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contentLine = null,Object? hiddenRight = null,Object? selectItemIndex = null,Object? allComment = null,Object? text = null,Object? ifInputing = null,Object? tabController = freezed,}) {
  return _then(_self.copyWith(
contentLine: null == contentLine ? _self.contentLine : contentLine // ignore: cast_nullable_to_non_nullable
as int,hiddenRight: null == hiddenRight ? _self.hiddenRight : hiddenRight // ignore: cast_nullable_to_non_nullable
as bool,selectItemIndex: null == selectItemIndex ? _self.selectItemIndex : selectItemIndex // ignore: cast_nullable_to_non_nullable
as int,allComment: null == allComment ? _self.allComment : allComment // ignore: cast_nullable_to_non_nullable
as bool,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,ifInputing: null == ifInputing ? _self.ifInputing : ifInputing // ignore: cast_nullable_to_non_nullable
as bool,tabController: freezed == tabController ? _self.tabController : tabController // ignore: cast_nullable_to_non_nullable
as TabController?,
  ));
}

}


/// Adds pattern-matching-related methods to [LookArtState].
extension LookArtStatePatterns on LookArtState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LookArtState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LookArtState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LookArtState value)  $default,){
final _that = this;
switch (_that) {
case _LookArtState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LookArtState value)?  $default,){
final _that = this;
switch (_that) {
case _LookArtState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int contentLine,  bool hiddenRight,  int selectItemIndex,  bool allComment,  String text,  bool ifInputing,  TabController? tabController)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LookArtState() when $default != null:
return $default(_that.contentLine,_that.hiddenRight,_that.selectItemIndex,_that.allComment,_that.text,_that.ifInputing,_that.tabController);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int contentLine,  bool hiddenRight,  int selectItemIndex,  bool allComment,  String text,  bool ifInputing,  TabController? tabController)  $default,) {final _that = this;
switch (_that) {
case _LookArtState():
return $default(_that.contentLine,_that.hiddenRight,_that.selectItemIndex,_that.allComment,_that.text,_that.ifInputing,_that.tabController);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int contentLine,  bool hiddenRight,  int selectItemIndex,  bool allComment,  String text,  bool ifInputing,  TabController? tabController)?  $default,) {final _that = this;
switch (_that) {
case _LookArtState() when $default != null:
return $default(_that.contentLine,_that.hiddenRight,_that.selectItemIndex,_that.allComment,_that.text,_that.ifInputing,_that.tabController);case _:
  return null;

}
}

}

/// @nodoc


class _LookArtState implements LookArtState {
  const _LookArtState({this.contentLine = 4, this.hiddenRight = false, this.selectItemIndex = 0, this.allComment = true, this.text = '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。我真的很喜欢你这个让我看一眼就会笑的女孩子，只靠爱情是不可能在一起辈子的，白头偕老需要的很多，成为情侣可能只需要爱情，但成为家人需要是我们两个人厮守到老，不仅仅要靠爱情更多的是习惯与责任。想和你走到最后，我会口是心非但我想让你看透我的心，我生气也好冷战也罢，这只能证明我爱你，我会故意气气你会粘着你会和你吵架，但是不会轻易离开你，我会管着你但不想失去你。', this.ifInputing = false, this.tabController});
  

@override@JsonKey() final  int contentLine;
@override@JsonKey() final  bool hiddenRight;
@override@JsonKey() final  int selectItemIndex;
@override@JsonKey() final  bool allComment;
@override@JsonKey() final  String text;
@override@JsonKey() final  bool ifInputing;
@override final  TabController? tabController;

/// Create a copy of LookArtState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LookArtStateCopyWith<_LookArtState> get copyWith => __$LookArtStateCopyWithImpl<_LookArtState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LookArtState&&(identical(other.contentLine, contentLine) || other.contentLine == contentLine)&&(identical(other.hiddenRight, hiddenRight) || other.hiddenRight == hiddenRight)&&(identical(other.selectItemIndex, selectItemIndex) || other.selectItemIndex == selectItemIndex)&&(identical(other.allComment, allComment) || other.allComment == allComment)&&(identical(other.text, text) || other.text == text)&&(identical(other.ifInputing, ifInputing) || other.ifInputing == ifInputing)&&(identical(other.tabController, tabController) || other.tabController == tabController));
}


@override
int get hashCode => Object.hash(runtimeType,contentLine,hiddenRight,selectItemIndex,allComment,text,ifInputing,tabController);

@override
String toString() {
  return 'LookArtState(contentLine: $contentLine, hiddenRight: $hiddenRight, selectItemIndex: $selectItemIndex, allComment: $allComment, text: $text, ifInputing: $ifInputing, tabController: $tabController)';
}


}

/// @nodoc
abstract mixin class _$LookArtStateCopyWith<$Res> implements $LookArtStateCopyWith<$Res> {
  factory _$LookArtStateCopyWith(_LookArtState value, $Res Function(_LookArtState) _then) = __$LookArtStateCopyWithImpl;
@override @useResult
$Res call({
 int contentLine, bool hiddenRight, int selectItemIndex, bool allComment, String text, bool ifInputing, TabController? tabController
});




}
/// @nodoc
class __$LookArtStateCopyWithImpl<$Res>
    implements _$LookArtStateCopyWith<$Res> {
  __$LookArtStateCopyWithImpl(this._self, this._then);

  final _LookArtState _self;
  final $Res Function(_LookArtState) _then;

/// Create a copy of LookArtState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contentLine = null,Object? hiddenRight = null,Object? selectItemIndex = null,Object? allComment = null,Object? text = null,Object? ifInputing = null,Object? tabController = freezed,}) {
  return _then(_LookArtState(
contentLine: null == contentLine ? _self.contentLine : contentLine // ignore: cast_nullable_to_non_nullable
as int,hiddenRight: null == hiddenRight ? _self.hiddenRight : hiddenRight // ignore: cast_nullable_to_non_nullable
as bool,selectItemIndex: null == selectItemIndex ? _self.selectItemIndex : selectItemIndex // ignore: cast_nullable_to_non_nullable
as int,allComment: null == allComment ? _self.allComment : allComment // ignore: cast_nullable_to_non_nullable
as bool,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,ifInputing: null == ifInputing ? _self.ifInputing : ifInputing // ignore: cast_nullable_to_non_nullable
as bool,tabController: freezed == tabController ? _self.tabController : tabController // ignore: cast_nullable_to_non_nullable
as TabController?,
  ));
}


}

// dart format on

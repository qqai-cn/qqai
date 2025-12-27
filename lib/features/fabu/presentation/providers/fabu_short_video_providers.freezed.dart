// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fabu_short_video_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FabuShortVideoState {

 TextEditingController get publishController; List<XFile> get files; List<XFile> get videoFiles; List<AddressEntity> get addressList; List<String> get whoCanSee; AddressEntity? get selAddressEntity; String? get whoCanSeeSel; Map<int, String> get huatiSel;
/// Create a copy of FabuShortVideoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FabuShortVideoStateCopyWith<FabuShortVideoState> get copyWith => _$FabuShortVideoStateCopyWithImpl<FabuShortVideoState>(this as FabuShortVideoState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FabuShortVideoState&&(identical(other.publishController, publishController) || other.publishController == publishController)&&const DeepCollectionEquality().equals(other.files, files)&&const DeepCollectionEquality().equals(other.videoFiles, videoFiles)&&const DeepCollectionEquality().equals(other.addressList, addressList)&&const DeepCollectionEquality().equals(other.whoCanSee, whoCanSee)&&(identical(other.selAddressEntity, selAddressEntity) || other.selAddressEntity == selAddressEntity)&&(identical(other.whoCanSeeSel, whoCanSeeSel) || other.whoCanSeeSel == whoCanSeeSel)&&const DeepCollectionEquality().equals(other.huatiSel, huatiSel));
}


@override
int get hashCode => Object.hash(runtimeType,publishController,const DeepCollectionEquality().hash(files),const DeepCollectionEquality().hash(videoFiles),const DeepCollectionEquality().hash(addressList),const DeepCollectionEquality().hash(whoCanSee),selAddressEntity,whoCanSeeSel,const DeepCollectionEquality().hash(huatiSel));

@override
String toString() {
  return 'FabuShortVideoState(publishController: $publishController, files: $files, videoFiles: $videoFiles, addressList: $addressList, whoCanSee: $whoCanSee, selAddressEntity: $selAddressEntity, whoCanSeeSel: $whoCanSeeSel, huatiSel: $huatiSel)';
}


}

/// @nodoc
abstract mixin class $FabuShortVideoStateCopyWith<$Res>  {
  factory $FabuShortVideoStateCopyWith(FabuShortVideoState value, $Res Function(FabuShortVideoState) _then) = _$FabuShortVideoStateCopyWithImpl;
@useResult
$Res call({
 TextEditingController publishController, List<XFile> files, List<XFile> videoFiles, List<AddressEntity> addressList, List<String> whoCanSee, AddressEntity? selAddressEntity, String? whoCanSeeSel, Map<int, String> huatiSel
});




}
/// @nodoc
class _$FabuShortVideoStateCopyWithImpl<$Res>
    implements $FabuShortVideoStateCopyWith<$Res> {
  _$FabuShortVideoStateCopyWithImpl(this._self, this._then);

  final FabuShortVideoState _self;
  final $Res Function(FabuShortVideoState) _then;

/// Create a copy of FabuShortVideoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publishController = null,Object? files = null,Object? videoFiles = null,Object? addressList = null,Object? whoCanSee = null,Object? selAddressEntity = freezed,Object? whoCanSeeSel = freezed,Object? huatiSel = null,}) {
  return _then(_self.copyWith(
publishController: null == publishController ? _self.publishController : publishController // ignore: cast_nullable_to_non_nullable
as TextEditingController,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<XFile>,videoFiles: null == videoFiles ? _self.videoFiles : videoFiles // ignore: cast_nullable_to_non_nullable
as List<XFile>,addressList: null == addressList ? _self.addressList : addressList // ignore: cast_nullable_to_non_nullable
as List<AddressEntity>,whoCanSee: null == whoCanSee ? _self.whoCanSee : whoCanSee // ignore: cast_nullable_to_non_nullable
as List<String>,selAddressEntity: freezed == selAddressEntity ? _self.selAddressEntity : selAddressEntity // ignore: cast_nullable_to_non_nullable
as AddressEntity?,whoCanSeeSel: freezed == whoCanSeeSel ? _self.whoCanSeeSel : whoCanSeeSel // ignore: cast_nullable_to_non_nullable
as String?,huatiSel: null == huatiSel ? _self.huatiSel : huatiSel // ignore: cast_nullable_to_non_nullable
as Map<int, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [FabuShortVideoState].
extension FabuShortVideoStatePatterns on FabuShortVideoState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FabuShortVideoState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FabuShortVideoState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FabuShortVideoState value)  $default,){
final _that = this;
switch (_that) {
case _FabuShortVideoState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FabuShortVideoState value)?  $default,){
final _that = this;
switch (_that) {
case _FabuShortVideoState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TextEditingController publishController,  List<XFile> files,  List<XFile> videoFiles,  List<AddressEntity> addressList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  String? whoCanSeeSel,  Map<int, String> huatiSel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FabuShortVideoState() when $default != null:
return $default(_that.publishController,_that.files,_that.videoFiles,_that.addressList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.huatiSel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TextEditingController publishController,  List<XFile> files,  List<XFile> videoFiles,  List<AddressEntity> addressList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  String? whoCanSeeSel,  Map<int, String> huatiSel)  $default,) {final _that = this;
switch (_that) {
case _FabuShortVideoState():
return $default(_that.publishController,_that.files,_that.videoFiles,_that.addressList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.huatiSel);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TextEditingController publishController,  List<XFile> files,  List<XFile> videoFiles,  List<AddressEntity> addressList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  String? whoCanSeeSel,  Map<int, String> huatiSel)?  $default,) {final _that = this;
switch (_that) {
case _FabuShortVideoState() when $default != null:
return $default(_that.publishController,_that.files,_that.videoFiles,_that.addressList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.huatiSel);case _:
  return null;

}
}

}

/// @nodoc


class _FabuShortVideoState implements FabuShortVideoState {
  const _FabuShortVideoState({required this.publishController, final  List<XFile> files = const [], final  List<XFile> videoFiles = const [], final  List<AddressEntity> addressList = const [], final  List<String> whoCanSee = const [], this.selAddressEntity, this.whoCanSeeSel, final  Map<int, String> huatiSel = const {}}): _files = files,_videoFiles = videoFiles,_addressList = addressList,_whoCanSee = whoCanSee,_huatiSel = huatiSel;
  

@override final  TextEditingController publishController;
 final  List<XFile> _files;
@override@JsonKey() List<XFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

 final  List<XFile> _videoFiles;
@override@JsonKey() List<XFile> get videoFiles {
  if (_videoFiles is EqualUnmodifiableListView) return _videoFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videoFiles);
}

 final  List<AddressEntity> _addressList;
@override@JsonKey() List<AddressEntity> get addressList {
  if (_addressList is EqualUnmodifiableListView) return _addressList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_addressList);
}

 final  List<String> _whoCanSee;
@override@JsonKey() List<String> get whoCanSee {
  if (_whoCanSee is EqualUnmodifiableListView) return _whoCanSee;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_whoCanSee);
}

@override final  AddressEntity? selAddressEntity;
@override final  String? whoCanSeeSel;
 final  Map<int, String> _huatiSel;
@override@JsonKey() Map<int, String> get huatiSel {
  if (_huatiSel is EqualUnmodifiableMapView) return _huatiSel;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_huatiSel);
}


/// Create a copy of FabuShortVideoState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FabuShortVideoStateCopyWith<_FabuShortVideoState> get copyWith => __$FabuShortVideoStateCopyWithImpl<_FabuShortVideoState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FabuShortVideoState&&(identical(other.publishController, publishController) || other.publishController == publishController)&&const DeepCollectionEquality().equals(other._files, _files)&&const DeepCollectionEquality().equals(other._videoFiles, _videoFiles)&&const DeepCollectionEquality().equals(other._addressList, _addressList)&&const DeepCollectionEquality().equals(other._whoCanSee, _whoCanSee)&&(identical(other.selAddressEntity, selAddressEntity) || other.selAddressEntity == selAddressEntity)&&(identical(other.whoCanSeeSel, whoCanSeeSel) || other.whoCanSeeSel == whoCanSeeSel)&&const DeepCollectionEquality().equals(other._huatiSel, _huatiSel));
}


@override
int get hashCode => Object.hash(runtimeType,publishController,const DeepCollectionEquality().hash(_files),const DeepCollectionEquality().hash(_videoFiles),const DeepCollectionEquality().hash(_addressList),const DeepCollectionEquality().hash(_whoCanSee),selAddressEntity,whoCanSeeSel,const DeepCollectionEquality().hash(_huatiSel));

@override
String toString() {
  return 'FabuShortVideoState(publishController: $publishController, files: $files, videoFiles: $videoFiles, addressList: $addressList, whoCanSee: $whoCanSee, selAddressEntity: $selAddressEntity, whoCanSeeSel: $whoCanSeeSel, huatiSel: $huatiSel)';
}


}

/// @nodoc
abstract mixin class _$FabuShortVideoStateCopyWith<$Res> implements $FabuShortVideoStateCopyWith<$Res> {
  factory _$FabuShortVideoStateCopyWith(_FabuShortVideoState value, $Res Function(_FabuShortVideoState) _then) = __$FabuShortVideoStateCopyWithImpl;
@override @useResult
$Res call({
 TextEditingController publishController, List<XFile> files, List<XFile> videoFiles, List<AddressEntity> addressList, List<String> whoCanSee, AddressEntity? selAddressEntity, String? whoCanSeeSel, Map<int, String> huatiSel
});




}
/// @nodoc
class __$FabuShortVideoStateCopyWithImpl<$Res>
    implements _$FabuShortVideoStateCopyWith<$Res> {
  __$FabuShortVideoStateCopyWithImpl(this._self, this._then);

  final _FabuShortVideoState _self;
  final $Res Function(_FabuShortVideoState) _then;

/// Create a copy of FabuShortVideoState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publishController = null,Object? files = null,Object? videoFiles = null,Object? addressList = null,Object? whoCanSee = null,Object? selAddressEntity = freezed,Object? whoCanSeeSel = freezed,Object? huatiSel = null,}) {
  return _then(_FabuShortVideoState(
publishController: null == publishController ? _self.publishController : publishController // ignore: cast_nullable_to_non_nullable
as TextEditingController,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<XFile>,videoFiles: null == videoFiles ? _self._videoFiles : videoFiles // ignore: cast_nullable_to_non_nullable
as List<XFile>,addressList: null == addressList ? _self._addressList : addressList // ignore: cast_nullable_to_non_nullable
as List<AddressEntity>,whoCanSee: null == whoCanSee ? _self._whoCanSee : whoCanSee // ignore: cast_nullable_to_non_nullable
as List<String>,selAddressEntity: freezed == selAddressEntity ? _self.selAddressEntity : selAddressEntity // ignore: cast_nullable_to_non_nullable
as AddressEntity?,whoCanSeeSel: freezed == whoCanSeeSel ? _self.whoCanSeeSel : whoCanSeeSel // ignore: cast_nullable_to_non_nullable
as String?,huatiSel: null == huatiSel ? _self._huatiSel : huatiSel // ignore: cast_nullable_to_non_nullable
as Map<int, String>,
  ));
}


}

// dart format on

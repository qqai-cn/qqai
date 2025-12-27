// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fabu_video_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FabuVideoState {

 TextEditingController get titleController; TextEditingController get contentController; List<XFile> get files; List<XFile> get videoFiles; List<AddressEntity> get addressList; List<String> get whoCanSee; AddressEntity? get selAddressEntity; String? get whoCanSeeSel; Map<int, String> get huatiSel;
/// Create a copy of FabuVideoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FabuVideoStateCopyWith<FabuVideoState> get copyWith => _$FabuVideoStateCopyWithImpl<FabuVideoState>(this as FabuVideoState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FabuVideoState&&(identical(other.titleController, titleController) || other.titleController == titleController)&&(identical(other.contentController, contentController) || other.contentController == contentController)&&const DeepCollectionEquality().equals(other.files, files)&&const DeepCollectionEquality().equals(other.videoFiles, videoFiles)&&const DeepCollectionEquality().equals(other.addressList, addressList)&&const DeepCollectionEquality().equals(other.whoCanSee, whoCanSee)&&(identical(other.selAddressEntity, selAddressEntity) || other.selAddressEntity == selAddressEntity)&&(identical(other.whoCanSeeSel, whoCanSeeSel) || other.whoCanSeeSel == whoCanSeeSel)&&const DeepCollectionEquality().equals(other.huatiSel, huatiSel));
}


@override
int get hashCode => Object.hash(runtimeType,titleController,contentController,const DeepCollectionEquality().hash(files),const DeepCollectionEquality().hash(videoFiles),const DeepCollectionEquality().hash(addressList),const DeepCollectionEquality().hash(whoCanSee),selAddressEntity,whoCanSeeSel,const DeepCollectionEquality().hash(huatiSel));

@override
String toString() {
  return 'FabuVideoState(titleController: $titleController, contentController: $contentController, files: $files, videoFiles: $videoFiles, addressList: $addressList, whoCanSee: $whoCanSee, selAddressEntity: $selAddressEntity, whoCanSeeSel: $whoCanSeeSel, huatiSel: $huatiSel)';
}


}

/// @nodoc
abstract mixin class $FabuVideoStateCopyWith<$Res>  {
  factory $FabuVideoStateCopyWith(FabuVideoState value, $Res Function(FabuVideoState) _then) = _$FabuVideoStateCopyWithImpl;
@useResult
$Res call({
 TextEditingController titleController, TextEditingController contentController, List<XFile> files, List<XFile> videoFiles, List<AddressEntity> addressList, List<String> whoCanSee, AddressEntity? selAddressEntity, String? whoCanSeeSel, Map<int, String> huatiSel
});




}
/// @nodoc
class _$FabuVideoStateCopyWithImpl<$Res>
    implements $FabuVideoStateCopyWith<$Res> {
  _$FabuVideoStateCopyWithImpl(this._self, this._then);

  final FabuVideoState _self;
  final $Res Function(FabuVideoState) _then;

/// Create a copy of FabuVideoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleController = null,Object? contentController = null,Object? files = null,Object? videoFiles = null,Object? addressList = null,Object? whoCanSee = null,Object? selAddressEntity = freezed,Object? whoCanSeeSel = freezed,Object? huatiSel = null,}) {
  return _then(_self.copyWith(
titleController: null == titleController ? _self.titleController : titleController // ignore: cast_nullable_to_non_nullable
as TextEditingController,contentController: null == contentController ? _self.contentController : contentController // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [FabuVideoState].
extension FabuVideoStatePatterns on FabuVideoState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FabuVideoState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FabuVideoState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FabuVideoState value)  $default,){
final _that = this;
switch (_that) {
case _FabuVideoState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FabuVideoState value)?  $default,){
final _that = this;
switch (_that) {
case _FabuVideoState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TextEditingController titleController,  TextEditingController contentController,  List<XFile> files,  List<XFile> videoFiles,  List<AddressEntity> addressList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  String? whoCanSeeSel,  Map<int, String> huatiSel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FabuVideoState() when $default != null:
return $default(_that.titleController,_that.contentController,_that.files,_that.videoFiles,_that.addressList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.huatiSel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TextEditingController titleController,  TextEditingController contentController,  List<XFile> files,  List<XFile> videoFiles,  List<AddressEntity> addressList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  String? whoCanSeeSel,  Map<int, String> huatiSel)  $default,) {final _that = this;
switch (_that) {
case _FabuVideoState():
return $default(_that.titleController,_that.contentController,_that.files,_that.videoFiles,_that.addressList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.huatiSel);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TextEditingController titleController,  TextEditingController contentController,  List<XFile> files,  List<XFile> videoFiles,  List<AddressEntity> addressList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  String? whoCanSeeSel,  Map<int, String> huatiSel)?  $default,) {final _that = this;
switch (_that) {
case _FabuVideoState() when $default != null:
return $default(_that.titleController,_that.contentController,_that.files,_that.videoFiles,_that.addressList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.huatiSel);case _:
  return null;

}
}

}

/// @nodoc


class _FabuVideoState implements FabuVideoState {
  const _FabuVideoState({required this.titleController, required this.contentController, final  List<XFile> files = const [], final  List<XFile> videoFiles = const [], final  List<AddressEntity> addressList = const [], final  List<String> whoCanSee = const [], this.selAddressEntity, this.whoCanSeeSel, final  Map<int, String> huatiSel = const {}}): _files = files,_videoFiles = videoFiles,_addressList = addressList,_whoCanSee = whoCanSee,_huatiSel = huatiSel;
  

@override final  TextEditingController titleController;
@override final  TextEditingController contentController;
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


/// Create a copy of FabuVideoState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FabuVideoStateCopyWith<_FabuVideoState> get copyWith => __$FabuVideoStateCopyWithImpl<_FabuVideoState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FabuVideoState&&(identical(other.titleController, titleController) || other.titleController == titleController)&&(identical(other.contentController, contentController) || other.contentController == contentController)&&const DeepCollectionEquality().equals(other._files, _files)&&const DeepCollectionEquality().equals(other._videoFiles, _videoFiles)&&const DeepCollectionEquality().equals(other._addressList, _addressList)&&const DeepCollectionEquality().equals(other._whoCanSee, _whoCanSee)&&(identical(other.selAddressEntity, selAddressEntity) || other.selAddressEntity == selAddressEntity)&&(identical(other.whoCanSeeSel, whoCanSeeSel) || other.whoCanSeeSel == whoCanSeeSel)&&const DeepCollectionEquality().equals(other._huatiSel, _huatiSel));
}


@override
int get hashCode => Object.hash(runtimeType,titleController,contentController,const DeepCollectionEquality().hash(_files),const DeepCollectionEquality().hash(_videoFiles),const DeepCollectionEquality().hash(_addressList),const DeepCollectionEquality().hash(_whoCanSee),selAddressEntity,whoCanSeeSel,const DeepCollectionEquality().hash(_huatiSel));

@override
String toString() {
  return 'FabuVideoState(titleController: $titleController, contentController: $contentController, files: $files, videoFiles: $videoFiles, addressList: $addressList, whoCanSee: $whoCanSee, selAddressEntity: $selAddressEntity, whoCanSeeSel: $whoCanSeeSel, huatiSel: $huatiSel)';
}


}

/// @nodoc
abstract mixin class _$FabuVideoStateCopyWith<$Res> implements $FabuVideoStateCopyWith<$Res> {
  factory _$FabuVideoStateCopyWith(_FabuVideoState value, $Res Function(_FabuVideoState) _then) = __$FabuVideoStateCopyWithImpl;
@override @useResult
$Res call({
 TextEditingController titleController, TextEditingController contentController, List<XFile> files, List<XFile> videoFiles, List<AddressEntity> addressList, List<String> whoCanSee, AddressEntity? selAddressEntity, String? whoCanSeeSel, Map<int, String> huatiSel
});




}
/// @nodoc
class __$FabuVideoStateCopyWithImpl<$Res>
    implements _$FabuVideoStateCopyWith<$Res> {
  __$FabuVideoStateCopyWithImpl(this._self, this._then);

  final _FabuVideoState _self;
  final $Res Function(_FabuVideoState) _then;

/// Create a copy of FabuVideoState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleController = null,Object? contentController = null,Object? files = null,Object? videoFiles = null,Object? addressList = null,Object? whoCanSee = null,Object? selAddressEntity = freezed,Object? whoCanSeeSel = freezed,Object? huatiSel = null,}) {
  return _then(_FabuVideoState(
titleController: null == titleController ? _self.titleController : titleController // ignore: cast_nullable_to_non_nullable
as TextEditingController,contentController: null == contentController ? _self.contentController : contentController // ignore: cast_nullable_to_non_nullable
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

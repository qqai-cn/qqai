// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fabu_dynamic_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FabuDynamicState {

 ApiCallStatus get apiCallStatus; TextEditingController get publishController; List<XFile> get files; List<XFile> get videoFiles; List<AddressEntity> get addressList; List<String> get whoCanSee; AddressEntity? get selAddressEntity; int? get whoCanSeeSel; Map<int, String> get huatiSel; int? get blogType;
/// Create a copy of FabuDynamicState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FabuDynamicStateCopyWith<FabuDynamicState> get copyWith => _$FabuDynamicStateCopyWithImpl<FabuDynamicState>(this as FabuDynamicState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FabuDynamicState&&(identical(other.apiCallStatus, apiCallStatus) || other.apiCallStatus == apiCallStatus)&&(identical(other.publishController, publishController) || other.publishController == publishController)&&const DeepCollectionEquality().equals(other.files, files)&&const DeepCollectionEquality().equals(other.videoFiles, videoFiles)&&const DeepCollectionEquality().equals(other.addressList, addressList)&&const DeepCollectionEquality().equals(other.whoCanSee, whoCanSee)&&(identical(other.selAddressEntity, selAddressEntity) || other.selAddressEntity == selAddressEntity)&&(identical(other.whoCanSeeSel, whoCanSeeSel) || other.whoCanSeeSel == whoCanSeeSel)&&const DeepCollectionEquality().equals(other.huatiSel, huatiSel)&&(identical(other.blogType, blogType) || other.blogType == blogType));
}


@override
int get hashCode => Object.hash(runtimeType,apiCallStatus,publishController,const DeepCollectionEquality().hash(files),const DeepCollectionEquality().hash(videoFiles),const DeepCollectionEquality().hash(addressList),const DeepCollectionEquality().hash(whoCanSee),selAddressEntity,whoCanSeeSel,const DeepCollectionEquality().hash(huatiSel),blogType);

@override
String toString() {
  return 'FabuDynamicState(apiCallStatus: $apiCallStatus, publishController: $publishController, files: $files, videoFiles: $videoFiles, addressList: $addressList, whoCanSee: $whoCanSee, selAddressEntity: $selAddressEntity, whoCanSeeSel: $whoCanSeeSel, huatiSel: $huatiSel, blogType: $blogType)';
}


}

/// @nodoc
abstract mixin class $FabuDynamicStateCopyWith<$Res>  {
  factory $FabuDynamicStateCopyWith(FabuDynamicState value, $Res Function(FabuDynamicState) _then) = _$FabuDynamicStateCopyWithImpl;
@useResult
$Res call({
 ApiCallStatus apiCallStatus, TextEditingController publishController, List<XFile> files, List<XFile> videoFiles, List<AddressEntity> addressList, List<String> whoCanSee, AddressEntity? selAddressEntity, int? whoCanSeeSel, Map<int, String> huatiSel, int? blogType
});




}
/// @nodoc
class _$FabuDynamicStateCopyWithImpl<$Res>
    implements $FabuDynamicStateCopyWith<$Res> {
  _$FabuDynamicStateCopyWithImpl(this._self, this._then);

  final FabuDynamicState _self;
  final $Res Function(FabuDynamicState) _then;

/// Create a copy of FabuDynamicState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? apiCallStatus = null,Object? publishController = null,Object? files = null,Object? videoFiles = null,Object? addressList = null,Object? whoCanSee = null,Object? selAddressEntity = freezed,Object? whoCanSeeSel = freezed,Object? huatiSel = null,Object? blogType = freezed,}) {
  return _then(_self.copyWith(
apiCallStatus: null == apiCallStatus ? _self.apiCallStatus : apiCallStatus // ignore: cast_nullable_to_non_nullable
as ApiCallStatus,publishController: null == publishController ? _self.publishController : publishController // ignore: cast_nullable_to_non_nullable
as TextEditingController,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<XFile>,videoFiles: null == videoFiles ? _self.videoFiles : videoFiles // ignore: cast_nullable_to_non_nullable
as List<XFile>,addressList: null == addressList ? _self.addressList : addressList // ignore: cast_nullable_to_non_nullable
as List<AddressEntity>,whoCanSee: null == whoCanSee ? _self.whoCanSee : whoCanSee // ignore: cast_nullable_to_non_nullable
as List<String>,selAddressEntity: freezed == selAddressEntity ? _self.selAddressEntity : selAddressEntity // ignore: cast_nullable_to_non_nullable
as AddressEntity?,whoCanSeeSel: freezed == whoCanSeeSel ? _self.whoCanSeeSel : whoCanSeeSel // ignore: cast_nullable_to_non_nullable
as int?,huatiSel: null == huatiSel ? _self.huatiSel : huatiSel // ignore: cast_nullable_to_non_nullable
as Map<int, String>,blogType: freezed == blogType ? _self.blogType : blogType // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FabuDynamicState].
extension FabuDynamicStatePatterns on FabuDynamicState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FabuDynamicState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FabuDynamicState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FabuDynamicState value)  $default,){
final _that = this;
switch (_that) {
case _FabuDynamicState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FabuDynamicState value)?  $default,){
final _that = this;
switch (_that) {
case _FabuDynamicState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ApiCallStatus apiCallStatus,  TextEditingController publishController,  List<XFile> files,  List<XFile> videoFiles,  List<AddressEntity> addressList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  int? whoCanSeeSel,  Map<int, String> huatiSel,  int? blogType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FabuDynamicState() when $default != null:
return $default(_that.apiCallStatus,_that.publishController,_that.files,_that.videoFiles,_that.addressList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.huatiSel,_that.blogType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ApiCallStatus apiCallStatus,  TextEditingController publishController,  List<XFile> files,  List<XFile> videoFiles,  List<AddressEntity> addressList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  int? whoCanSeeSel,  Map<int, String> huatiSel,  int? blogType)  $default,) {final _that = this;
switch (_that) {
case _FabuDynamicState():
return $default(_that.apiCallStatus,_that.publishController,_that.files,_that.videoFiles,_that.addressList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.huatiSel,_that.blogType);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ApiCallStatus apiCallStatus,  TextEditingController publishController,  List<XFile> files,  List<XFile> videoFiles,  List<AddressEntity> addressList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  int? whoCanSeeSel,  Map<int, String> huatiSel,  int? blogType)?  $default,) {final _that = this;
switch (_that) {
case _FabuDynamicState() when $default != null:
return $default(_that.apiCallStatus,_that.publishController,_that.files,_that.videoFiles,_that.addressList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.huatiSel,_that.blogType);case _:
  return null;

}
}

}

/// @nodoc


class _FabuDynamicState implements FabuDynamicState {
  const _FabuDynamicState({this.apiCallStatus = ApiCallStatus.holding, required this.publishController, final  List<XFile> files = const [], final  List<XFile> videoFiles = const [], final  List<AddressEntity> addressList = const [], final  List<String> whoCanSee = const [], this.selAddressEntity, this.whoCanSeeSel = 0, final  Map<int, String> huatiSel = const {}, this.blogType}): _files = files,_videoFiles = videoFiles,_addressList = addressList,_whoCanSee = whoCanSee,_huatiSel = huatiSel;
  

@override@JsonKey() final  ApiCallStatus apiCallStatus;
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
@override@JsonKey() final  int? whoCanSeeSel;
 final  Map<int, String> _huatiSel;
@override@JsonKey() Map<int, String> get huatiSel {
  if (_huatiSel is EqualUnmodifiableMapView) return _huatiSel;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_huatiSel);
}

@override final  int? blogType;

/// Create a copy of FabuDynamicState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FabuDynamicStateCopyWith<_FabuDynamicState> get copyWith => __$FabuDynamicStateCopyWithImpl<_FabuDynamicState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FabuDynamicState&&(identical(other.apiCallStatus, apiCallStatus) || other.apiCallStatus == apiCallStatus)&&(identical(other.publishController, publishController) || other.publishController == publishController)&&const DeepCollectionEquality().equals(other._files, _files)&&const DeepCollectionEquality().equals(other._videoFiles, _videoFiles)&&const DeepCollectionEquality().equals(other._addressList, _addressList)&&const DeepCollectionEquality().equals(other._whoCanSee, _whoCanSee)&&(identical(other.selAddressEntity, selAddressEntity) || other.selAddressEntity == selAddressEntity)&&(identical(other.whoCanSeeSel, whoCanSeeSel) || other.whoCanSeeSel == whoCanSeeSel)&&const DeepCollectionEquality().equals(other._huatiSel, _huatiSel)&&(identical(other.blogType, blogType) || other.blogType == blogType));
}


@override
int get hashCode => Object.hash(runtimeType,apiCallStatus,publishController,const DeepCollectionEquality().hash(_files),const DeepCollectionEquality().hash(_videoFiles),const DeepCollectionEquality().hash(_addressList),const DeepCollectionEquality().hash(_whoCanSee),selAddressEntity,whoCanSeeSel,const DeepCollectionEquality().hash(_huatiSel),blogType);

@override
String toString() {
  return 'FabuDynamicState(apiCallStatus: $apiCallStatus, publishController: $publishController, files: $files, videoFiles: $videoFiles, addressList: $addressList, whoCanSee: $whoCanSee, selAddressEntity: $selAddressEntity, whoCanSeeSel: $whoCanSeeSel, huatiSel: $huatiSel, blogType: $blogType)';
}


}

/// @nodoc
abstract mixin class _$FabuDynamicStateCopyWith<$Res> implements $FabuDynamicStateCopyWith<$Res> {
  factory _$FabuDynamicStateCopyWith(_FabuDynamicState value, $Res Function(_FabuDynamicState) _then) = __$FabuDynamicStateCopyWithImpl;
@override @useResult
$Res call({
 ApiCallStatus apiCallStatus, TextEditingController publishController, List<XFile> files, List<XFile> videoFiles, List<AddressEntity> addressList, List<String> whoCanSee, AddressEntity? selAddressEntity, int? whoCanSeeSel, Map<int, String> huatiSel, int? blogType
});




}
/// @nodoc
class __$FabuDynamicStateCopyWithImpl<$Res>
    implements _$FabuDynamicStateCopyWith<$Res> {
  __$FabuDynamicStateCopyWithImpl(this._self, this._then);

  final _FabuDynamicState _self;
  final $Res Function(_FabuDynamicState) _then;

/// Create a copy of FabuDynamicState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? apiCallStatus = null,Object? publishController = null,Object? files = null,Object? videoFiles = null,Object? addressList = null,Object? whoCanSee = null,Object? selAddressEntity = freezed,Object? whoCanSeeSel = freezed,Object? huatiSel = null,Object? blogType = freezed,}) {
  return _then(_FabuDynamicState(
apiCallStatus: null == apiCallStatus ? _self.apiCallStatus : apiCallStatus // ignore: cast_nullable_to_non_nullable
as ApiCallStatus,publishController: null == publishController ? _self.publishController : publishController // ignore: cast_nullable_to_non_nullable
as TextEditingController,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<XFile>,videoFiles: null == videoFiles ? _self._videoFiles : videoFiles // ignore: cast_nullable_to_non_nullable
as List<XFile>,addressList: null == addressList ? _self._addressList : addressList // ignore: cast_nullable_to_non_nullable
as List<AddressEntity>,whoCanSee: null == whoCanSee ? _self._whoCanSee : whoCanSee // ignore: cast_nullable_to_non_nullable
as List<String>,selAddressEntity: freezed == selAddressEntity ? _self.selAddressEntity : selAddressEntity // ignore: cast_nullable_to_non_nullable
as AddressEntity?,whoCanSeeSel: freezed == whoCanSeeSel ? _self.whoCanSeeSel : whoCanSeeSel // ignore: cast_nullable_to_non_nullable
as int?,huatiSel: null == huatiSel ? _self._huatiSel : huatiSel // ignore: cast_nullable_to_non_nullable
as Map<int, String>,blogType: freezed == blogType ? _self.blogType : blogType // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

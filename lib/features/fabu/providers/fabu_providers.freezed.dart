// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fabu_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FabuState {

// freezed 的 @Default 必须是 const
 AsyncValue<List<FabuModel>> get items; List<XFile> get files; List<XFile> get videoFiles; List<AddressEntity> get addressList; List<String> get whoCanSee; AddressEntity? get selAddressEntity; int? get whoCanSeeSel; int get aixinType; Map<int, String> get huatiSel; String? get error; bool get isLoading; String get textContent;
/// Create a copy of FabuState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FabuStateCopyWith<FabuState> get copyWith => _$FabuStateCopyWithImpl<FabuState>(this as FabuState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FabuState&&(identical(other.items, items) || other.items == items)&&const DeepCollectionEquality().equals(other.files, files)&&const DeepCollectionEquality().equals(other.videoFiles, videoFiles)&&const DeepCollectionEquality().equals(other.addressList, addressList)&&const DeepCollectionEquality().equals(other.whoCanSee, whoCanSee)&&(identical(other.selAddressEntity, selAddressEntity) || other.selAddressEntity == selAddressEntity)&&(identical(other.whoCanSeeSel, whoCanSeeSel) || other.whoCanSeeSel == whoCanSeeSel)&&(identical(other.aixinType, aixinType) || other.aixinType == aixinType)&&const DeepCollectionEquality().equals(other.huatiSel, huatiSel)&&(identical(other.error, error) || other.error == error)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.textContent, textContent) || other.textContent == textContent));
}


@override
int get hashCode => Object.hash(runtimeType,items,const DeepCollectionEquality().hash(files),const DeepCollectionEquality().hash(videoFiles),const DeepCollectionEquality().hash(addressList),const DeepCollectionEquality().hash(whoCanSee),selAddressEntity,whoCanSeeSel,aixinType,const DeepCollectionEquality().hash(huatiSel),error,isLoading,textContent);

@override
String toString() {
  return 'FabuState(items: $items, files: $files, videoFiles: $videoFiles, addressList: $addressList, whoCanSee: $whoCanSee, selAddressEntity: $selAddressEntity, whoCanSeeSel: $whoCanSeeSel, aixinType: $aixinType, huatiSel: $huatiSel, error: $error, isLoading: $isLoading, textContent: $textContent)';
}


}

/// @nodoc
abstract mixin class $FabuStateCopyWith<$Res>  {
  factory $FabuStateCopyWith(FabuState value, $Res Function(FabuState) _then) = _$FabuStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<List<FabuModel>> items, List<XFile> files, List<XFile> videoFiles, List<AddressEntity> addressList, List<String> whoCanSee, AddressEntity? selAddressEntity, int? whoCanSeeSel, int aixinType, Map<int, String> huatiSel, String? error, bool isLoading, String textContent
});




}
/// @nodoc
class _$FabuStateCopyWithImpl<$Res>
    implements $FabuStateCopyWith<$Res> {
  _$FabuStateCopyWithImpl(this._self, this._then);

  final FabuState _self;
  final $Res Function(FabuState) _then;

/// Create a copy of FabuState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? files = null,Object? videoFiles = null,Object? addressList = null,Object? whoCanSee = null,Object? selAddressEntity = freezed,Object? whoCanSeeSel = freezed,Object? aixinType = null,Object? huatiSel = null,Object? error = freezed,Object? isLoading = null,Object? textContent = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<FabuModel>>,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<XFile>,videoFiles: null == videoFiles ? _self.videoFiles : videoFiles // ignore: cast_nullable_to_non_nullable
as List<XFile>,addressList: null == addressList ? _self.addressList : addressList // ignore: cast_nullable_to_non_nullable
as List<AddressEntity>,whoCanSee: null == whoCanSee ? _self.whoCanSee : whoCanSee // ignore: cast_nullable_to_non_nullable
as List<String>,selAddressEntity: freezed == selAddressEntity ? _self.selAddressEntity : selAddressEntity // ignore: cast_nullable_to_non_nullable
as AddressEntity?,whoCanSeeSel: freezed == whoCanSeeSel ? _self.whoCanSeeSel : whoCanSeeSel // ignore: cast_nullable_to_non_nullable
as int?,aixinType: null == aixinType ? _self.aixinType : aixinType // ignore: cast_nullable_to_non_nullable
as int,huatiSel: null == huatiSel ? _self.huatiSel : huatiSel // ignore: cast_nullable_to_non_nullable
as Map<int, String>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,textContent: null == textContent ? _self.textContent : textContent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FabuState].
extension FabuStatePatterns on FabuState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FabuState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FabuState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FabuState value)  $default,){
final _that = this;
switch (_that) {
case _FabuState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FabuState value)?  $default,){
final _that = this;
switch (_that) {
case _FabuState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<List<FabuModel>> items,  List<XFile> files,  List<XFile> videoFiles,  List<AddressEntity> addressList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  int? whoCanSeeSel,  int aixinType,  Map<int, String> huatiSel,  String? error,  bool isLoading,  String textContent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FabuState() when $default != null:
return $default(_that.items,_that.files,_that.videoFiles,_that.addressList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.aixinType,_that.huatiSel,_that.error,_that.isLoading,_that.textContent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<List<FabuModel>> items,  List<XFile> files,  List<XFile> videoFiles,  List<AddressEntity> addressList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  int? whoCanSeeSel,  int aixinType,  Map<int, String> huatiSel,  String? error,  bool isLoading,  String textContent)  $default,) {final _that = this;
switch (_that) {
case _FabuState():
return $default(_that.items,_that.files,_that.videoFiles,_that.addressList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.aixinType,_that.huatiSel,_that.error,_that.isLoading,_that.textContent);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<List<FabuModel>> items,  List<XFile> files,  List<XFile> videoFiles,  List<AddressEntity> addressList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  int? whoCanSeeSel,  int aixinType,  Map<int, String> huatiSel,  String? error,  bool isLoading,  String textContent)?  $default,) {final _that = this;
switch (_that) {
case _FabuState() when $default != null:
return $default(_that.items,_that.files,_that.videoFiles,_that.addressList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.aixinType,_that.huatiSel,_that.error,_that.isLoading,_that.textContent);case _:
  return null;

}
}

}

/// @nodoc


class _FabuState implements FabuState {
  const _FabuState({this.items = const AsyncLoading(), final  List<XFile> files = const [], final  List<XFile> videoFiles = const [], final  List<AddressEntity> addressList = const [], final  List<String> whoCanSee = const [], this.selAddressEntity, this.whoCanSeeSel = 0, this.aixinType = 0, final  Map<int, String> huatiSel = const {}, this.error, this.isLoading = false, this.textContent = ''}): _files = files,_videoFiles = videoFiles,_addressList = addressList,_whoCanSee = whoCanSee,_huatiSel = huatiSel;
  

// freezed 的 @Default 必须是 const
@override@JsonKey() final  AsyncValue<List<FabuModel>> items;
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
@override@JsonKey() final  int aixinType;
 final  Map<int, String> _huatiSel;
@override@JsonKey() Map<int, String> get huatiSel {
  if (_huatiSel is EqualUnmodifiableMapView) return _huatiSel;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_huatiSel);
}

@override final  String? error;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String textContent;

/// Create a copy of FabuState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FabuStateCopyWith<_FabuState> get copyWith => __$FabuStateCopyWithImpl<_FabuState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FabuState&&(identical(other.items, items) || other.items == items)&&const DeepCollectionEquality().equals(other._files, _files)&&const DeepCollectionEquality().equals(other._videoFiles, _videoFiles)&&const DeepCollectionEquality().equals(other._addressList, _addressList)&&const DeepCollectionEquality().equals(other._whoCanSee, _whoCanSee)&&(identical(other.selAddressEntity, selAddressEntity) || other.selAddressEntity == selAddressEntity)&&(identical(other.whoCanSeeSel, whoCanSeeSel) || other.whoCanSeeSel == whoCanSeeSel)&&(identical(other.aixinType, aixinType) || other.aixinType == aixinType)&&const DeepCollectionEquality().equals(other._huatiSel, _huatiSel)&&(identical(other.error, error) || other.error == error)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.textContent, textContent) || other.textContent == textContent));
}


@override
int get hashCode => Object.hash(runtimeType,items,const DeepCollectionEquality().hash(_files),const DeepCollectionEquality().hash(_videoFiles),const DeepCollectionEquality().hash(_addressList),const DeepCollectionEquality().hash(_whoCanSee),selAddressEntity,whoCanSeeSel,aixinType,const DeepCollectionEquality().hash(_huatiSel),error,isLoading,textContent);

@override
String toString() {
  return 'FabuState(items: $items, files: $files, videoFiles: $videoFiles, addressList: $addressList, whoCanSee: $whoCanSee, selAddressEntity: $selAddressEntity, whoCanSeeSel: $whoCanSeeSel, aixinType: $aixinType, huatiSel: $huatiSel, error: $error, isLoading: $isLoading, textContent: $textContent)';
}


}

/// @nodoc
abstract mixin class _$FabuStateCopyWith<$Res> implements $FabuStateCopyWith<$Res> {
  factory _$FabuStateCopyWith(_FabuState value, $Res Function(_FabuState) _then) = __$FabuStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<List<FabuModel>> items, List<XFile> files, List<XFile> videoFiles, List<AddressEntity> addressList, List<String> whoCanSee, AddressEntity? selAddressEntity, int? whoCanSeeSel, int aixinType, Map<int, String> huatiSel, String? error, bool isLoading, String textContent
});




}
/// @nodoc
class __$FabuStateCopyWithImpl<$Res>
    implements _$FabuStateCopyWith<$Res> {
  __$FabuStateCopyWithImpl(this._self, this._then);

  final _FabuState _self;
  final $Res Function(_FabuState) _then;

/// Create a copy of FabuState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? files = null,Object? videoFiles = null,Object? addressList = null,Object? whoCanSee = null,Object? selAddressEntity = freezed,Object? whoCanSeeSel = freezed,Object? aixinType = null,Object? huatiSel = null,Object? error = freezed,Object? isLoading = null,Object? textContent = null,}) {
  return _then(_FabuState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<FabuModel>>,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<XFile>,videoFiles: null == videoFiles ? _self._videoFiles : videoFiles // ignore: cast_nullable_to_non_nullable
as List<XFile>,addressList: null == addressList ? _self._addressList : addressList // ignore: cast_nullable_to_non_nullable
as List<AddressEntity>,whoCanSee: null == whoCanSee ? _self._whoCanSee : whoCanSee // ignore: cast_nullable_to_non_nullable
as List<String>,selAddressEntity: freezed == selAddressEntity ? _self.selAddressEntity : selAddressEntity // ignore: cast_nullable_to_non_nullable
as AddressEntity?,whoCanSeeSel: freezed == whoCanSeeSel ? _self.whoCanSeeSel : whoCanSeeSel // ignore: cast_nullable_to_non_nullable
as int?,aixinType: null == aixinType ? _self.aixinType : aixinType // ignore: cast_nullable_to_non_nullable
as int,huatiSel: null == huatiSel ? _self._huatiSel : huatiSel // ignore: cast_nullable_to_non_nullable
as Map<int, String>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,textContent: null == textContent ? _self.textContent : textContent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

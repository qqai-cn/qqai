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
mixin _$FabuState implements DiagnosticableTreeMixin {

// freezed 的 @Default 必须是 const
 AsyncValue<List<FabuModel>> get items; List<XFile> get files; List<XFile> get videoFiles; XFile? get coverFile; Uint8List? get coverPreviewBytes; List<String> get uploadedFileUrls; List<String> get uploadedVideoUrls; String? get uploadedCoverUrl; XFile? get backgroundMusicFile; String? get uploadedBackgroundMusicUrl; String? get backgroundMusicName; int get soundMode; int get selectedCoverStyleId; List<AddressEntity> get addressList; List<SkuuTopicResVO> get topicList; List<String> get whoCanSee; AddressEntity? get selAddressEntity; int? get whoCanSeeSel; int get aixinType; Map<int, String> get huatiSel; Map<int, String> get collectionSel; int? get collectionItemCount; int? get collectionEpisode; List<MallProduct> get shopProducts; String? get error; bool get isLoading; bool get isUploading; bool get isCoverUploading; bool get isCoverPreviewing; String get textContent; String get blogTitle; bool get isLoadingGPS; double get publishProgress; String get publishStage;
/// Create a copy of FabuState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FabuStateCopyWith<FabuState> get copyWith => _$FabuStateCopyWithImpl<FabuState>(this as FabuState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FabuState'))
    ..add(DiagnosticsProperty('items', items))..add(DiagnosticsProperty('files', files))..add(DiagnosticsProperty('videoFiles', videoFiles))..add(DiagnosticsProperty('coverFile', coverFile))..add(DiagnosticsProperty('coverPreviewBytes', coverPreviewBytes))..add(DiagnosticsProperty('uploadedFileUrls', uploadedFileUrls))..add(DiagnosticsProperty('uploadedVideoUrls', uploadedVideoUrls))..add(DiagnosticsProperty('uploadedCoverUrl', uploadedCoverUrl))..add(DiagnosticsProperty('backgroundMusicFile', backgroundMusicFile))..add(DiagnosticsProperty('uploadedBackgroundMusicUrl', uploadedBackgroundMusicUrl))..add(DiagnosticsProperty('backgroundMusicName', backgroundMusicName))..add(DiagnosticsProperty('soundMode', soundMode))..add(DiagnosticsProperty('selectedCoverStyleId', selectedCoverStyleId))..add(DiagnosticsProperty('addressList', addressList))..add(DiagnosticsProperty('topicList', topicList))..add(DiagnosticsProperty('whoCanSee', whoCanSee))..add(DiagnosticsProperty('selAddressEntity', selAddressEntity))..add(DiagnosticsProperty('whoCanSeeSel', whoCanSeeSel))..add(DiagnosticsProperty('aixinType', aixinType))..add(DiagnosticsProperty('huatiSel', huatiSel))..add(DiagnosticsProperty('collectionSel', collectionSel))..add(DiagnosticsProperty('collectionItemCount', collectionItemCount))..add(DiagnosticsProperty('collectionEpisode', collectionEpisode))..add(DiagnosticsProperty('shopProducts', shopProducts))..add(DiagnosticsProperty('error', error))..add(DiagnosticsProperty('isLoading', isLoading))..add(DiagnosticsProperty('isUploading', isUploading))..add(DiagnosticsProperty('isCoverUploading', isCoverUploading))..add(DiagnosticsProperty('isCoverPreviewing', isCoverPreviewing))..add(DiagnosticsProperty('textContent', textContent))..add(DiagnosticsProperty('blogTitle', blogTitle))..add(DiagnosticsProperty('isLoadingGPS', isLoadingGPS))..add(DiagnosticsProperty('publishProgress', publishProgress))..add(DiagnosticsProperty('publishStage', publishStage));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FabuState&&(identical(other.items, items) || other.items == items)&&const DeepCollectionEquality().equals(other.files, files)&&const DeepCollectionEquality().equals(other.videoFiles, videoFiles)&&(identical(other.coverFile, coverFile) || other.coverFile == coverFile)&&const DeepCollectionEquality().equals(other.coverPreviewBytes, coverPreviewBytes)&&const DeepCollectionEquality().equals(other.uploadedFileUrls, uploadedFileUrls)&&const DeepCollectionEquality().equals(other.uploadedVideoUrls, uploadedVideoUrls)&&(identical(other.uploadedCoverUrl, uploadedCoverUrl) || other.uploadedCoverUrl == uploadedCoverUrl)&&(identical(other.backgroundMusicFile, backgroundMusicFile) || other.backgroundMusicFile == backgroundMusicFile)&&(identical(other.uploadedBackgroundMusicUrl, uploadedBackgroundMusicUrl) || other.uploadedBackgroundMusicUrl == uploadedBackgroundMusicUrl)&&(identical(other.backgroundMusicName, backgroundMusicName) || other.backgroundMusicName == backgroundMusicName)&&(identical(other.soundMode, soundMode) || other.soundMode == soundMode)&&(identical(other.selectedCoverStyleId, selectedCoverStyleId) || other.selectedCoverStyleId == selectedCoverStyleId)&&const DeepCollectionEquality().equals(other.addressList, addressList)&&const DeepCollectionEquality().equals(other.topicList, topicList)&&const DeepCollectionEquality().equals(other.whoCanSee, whoCanSee)&&(identical(other.selAddressEntity, selAddressEntity) || other.selAddressEntity == selAddressEntity)&&(identical(other.whoCanSeeSel, whoCanSeeSel) || other.whoCanSeeSel == whoCanSeeSel)&&(identical(other.aixinType, aixinType) || other.aixinType == aixinType)&&const DeepCollectionEquality().equals(other.huatiSel, huatiSel)&&const DeepCollectionEquality().equals(other.collectionSel, collectionSel)&&(identical(other.collectionItemCount, collectionItemCount) || other.collectionItemCount == collectionItemCount)&&(identical(other.collectionEpisode, collectionEpisode) || other.collectionEpisode == collectionEpisode)&&const DeepCollectionEquality().equals(other.shopProducts, shopProducts)&&(identical(other.error, error) || other.error == error)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isUploading, isUploading) || other.isUploading == isUploading)&&(identical(other.isCoverUploading, isCoverUploading) || other.isCoverUploading == isCoverUploading)&&(identical(other.isCoverPreviewing, isCoverPreviewing) || other.isCoverPreviewing == isCoverPreviewing)&&(identical(other.textContent, textContent) || other.textContent == textContent)&&(identical(other.blogTitle, blogTitle) || other.blogTitle == blogTitle)&&(identical(other.isLoadingGPS, isLoadingGPS) || other.isLoadingGPS == isLoadingGPS)&&(identical(other.publishProgress, publishProgress) || other.publishProgress == publishProgress)&&(identical(other.publishStage, publishStage) || other.publishStage == publishStage));
}


@override
int get hashCode => Object.hashAll([runtimeType,items,const DeepCollectionEquality().hash(files),const DeepCollectionEquality().hash(videoFiles),coverFile,const DeepCollectionEquality().hash(coverPreviewBytes),const DeepCollectionEquality().hash(uploadedFileUrls),const DeepCollectionEquality().hash(uploadedVideoUrls),uploadedCoverUrl,backgroundMusicFile,uploadedBackgroundMusicUrl,backgroundMusicName,soundMode,selectedCoverStyleId,const DeepCollectionEquality().hash(addressList),const DeepCollectionEquality().hash(topicList),const DeepCollectionEquality().hash(whoCanSee),selAddressEntity,whoCanSeeSel,aixinType,const DeepCollectionEquality().hash(huatiSel),const DeepCollectionEquality().hash(collectionSel),collectionItemCount,collectionEpisode,const DeepCollectionEquality().hash(shopProducts),error,isLoading,isUploading,isCoverUploading,isCoverPreviewing,textContent,blogTitle,isLoadingGPS,publishProgress,publishStage]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FabuState(items: $items, files: $files, videoFiles: $videoFiles, coverFile: $coverFile, coverPreviewBytes: $coverPreviewBytes, uploadedFileUrls: $uploadedFileUrls, uploadedVideoUrls: $uploadedVideoUrls, uploadedCoverUrl: $uploadedCoverUrl, backgroundMusicFile: $backgroundMusicFile, uploadedBackgroundMusicUrl: $uploadedBackgroundMusicUrl, backgroundMusicName: $backgroundMusicName, soundMode: $soundMode, selectedCoverStyleId: $selectedCoverStyleId, addressList: $addressList, topicList: $topicList, whoCanSee: $whoCanSee, selAddressEntity: $selAddressEntity, whoCanSeeSel: $whoCanSeeSel, aixinType: $aixinType, huatiSel: $huatiSel, collectionSel: $collectionSel, collectionItemCount: $collectionItemCount, collectionEpisode: $collectionEpisode, shopProducts: $shopProducts, error: $error, isLoading: $isLoading, isUploading: $isUploading, isCoverUploading: $isCoverUploading, isCoverPreviewing: $isCoverPreviewing, textContent: $textContent, blogTitle: $blogTitle, isLoadingGPS: $isLoadingGPS, publishProgress: $publishProgress, publishStage: $publishStage)';
}


}

/// @nodoc
abstract mixin class $FabuStateCopyWith<$Res>  {
  factory $FabuStateCopyWith(FabuState value, $Res Function(FabuState) _then) = _$FabuStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<List<FabuModel>> items, List<XFile> files, List<XFile> videoFiles, XFile? coverFile, Uint8List? coverPreviewBytes, List<String> uploadedFileUrls, List<String> uploadedVideoUrls, String? uploadedCoverUrl, XFile? backgroundMusicFile, String? uploadedBackgroundMusicUrl, String? backgroundMusicName, int soundMode, int selectedCoverStyleId, List<AddressEntity> addressList, List<SkuuTopicResVO> topicList, List<String> whoCanSee, AddressEntity? selAddressEntity, int? whoCanSeeSel, int aixinType, Map<int, String> huatiSel, Map<int, String> collectionSel, int? collectionItemCount, int? collectionEpisode, List<MallProduct> shopProducts, String? error, bool isLoading, bool isUploading, bool isCoverUploading, bool isCoverPreviewing, String textContent, String blogTitle, bool isLoadingGPS, double publishProgress, String publishStage
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
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? files = null,Object? videoFiles = null,Object? coverFile = freezed,Object? coverPreviewBytes = freezed,Object? uploadedFileUrls = null,Object? uploadedVideoUrls = null,Object? uploadedCoverUrl = freezed,Object? backgroundMusicFile = freezed,Object? uploadedBackgroundMusicUrl = freezed,Object? backgroundMusicName = freezed,Object? soundMode = null,Object? selectedCoverStyleId = null,Object? addressList = null,Object? topicList = null,Object? whoCanSee = null,Object? selAddressEntity = freezed,Object? whoCanSeeSel = freezed,Object? aixinType = null,Object? huatiSel = null,Object? collectionSel = null,Object? collectionItemCount = freezed,Object? collectionEpisode = freezed,Object? shopProducts = null,Object? error = freezed,Object? isLoading = null,Object? isUploading = null,Object? isCoverUploading = null,Object? isCoverPreviewing = null,Object? textContent = null,Object? blogTitle = null,Object? isLoadingGPS = null,Object? publishProgress = null,Object? publishStage = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<FabuModel>>,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<XFile>,videoFiles: null == videoFiles ? _self.videoFiles : videoFiles // ignore: cast_nullable_to_non_nullable
as List<XFile>,coverFile: freezed == coverFile ? _self.coverFile : coverFile // ignore: cast_nullable_to_non_nullable
as XFile?,coverPreviewBytes: freezed == coverPreviewBytes ? _self.coverPreviewBytes : coverPreviewBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,uploadedFileUrls: null == uploadedFileUrls ? _self.uploadedFileUrls : uploadedFileUrls // ignore: cast_nullable_to_non_nullable
as List<String>,uploadedVideoUrls: null == uploadedVideoUrls ? _self.uploadedVideoUrls : uploadedVideoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,uploadedCoverUrl: freezed == uploadedCoverUrl ? _self.uploadedCoverUrl : uploadedCoverUrl // ignore: cast_nullable_to_non_nullable
as String?,backgroundMusicFile: freezed == backgroundMusicFile ? _self.backgroundMusicFile : backgroundMusicFile // ignore: cast_nullable_to_non_nullable
as XFile?,uploadedBackgroundMusicUrl: freezed == uploadedBackgroundMusicUrl ? _self.uploadedBackgroundMusicUrl : uploadedBackgroundMusicUrl // ignore: cast_nullable_to_non_nullable
as String?,backgroundMusicName: freezed == backgroundMusicName ? _self.backgroundMusicName : backgroundMusicName // ignore: cast_nullable_to_non_nullable
as String?,soundMode: null == soundMode ? _self.soundMode : soundMode // ignore: cast_nullable_to_non_nullable
as int,selectedCoverStyleId: null == selectedCoverStyleId ? _self.selectedCoverStyleId : selectedCoverStyleId // ignore: cast_nullable_to_non_nullable
as int,addressList: null == addressList ? _self.addressList : addressList // ignore: cast_nullable_to_non_nullable
as List<AddressEntity>,topicList: null == topicList ? _self.topicList : topicList // ignore: cast_nullable_to_non_nullable
as List<SkuuTopicResVO>,whoCanSee: null == whoCanSee ? _self.whoCanSee : whoCanSee // ignore: cast_nullable_to_non_nullable
as List<String>,selAddressEntity: freezed == selAddressEntity ? _self.selAddressEntity : selAddressEntity // ignore: cast_nullable_to_non_nullable
as AddressEntity?,whoCanSeeSel: freezed == whoCanSeeSel ? _self.whoCanSeeSel : whoCanSeeSel // ignore: cast_nullable_to_non_nullable
as int?,aixinType: null == aixinType ? _self.aixinType : aixinType // ignore: cast_nullable_to_non_nullable
as int,huatiSel: null == huatiSel ? _self.huatiSel : huatiSel // ignore: cast_nullable_to_non_nullable
as Map<int, String>,collectionSel: null == collectionSel ? _self.collectionSel : collectionSel // ignore: cast_nullable_to_non_nullable
as Map<int, String>,collectionItemCount: freezed == collectionItemCount ? _self.collectionItemCount : collectionItemCount // ignore: cast_nullable_to_non_nullable
as int?,collectionEpisode: freezed == collectionEpisode ? _self.collectionEpisode : collectionEpisode // ignore: cast_nullable_to_non_nullable
as int?,shopProducts: null == shopProducts ? _self.shopProducts : shopProducts // ignore: cast_nullable_to_non_nullable
as List<MallProduct>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isUploading: null == isUploading ? _self.isUploading : isUploading // ignore: cast_nullable_to_non_nullable
as bool,isCoverUploading: null == isCoverUploading ? _self.isCoverUploading : isCoverUploading // ignore: cast_nullable_to_non_nullable
as bool,isCoverPreviewing: null == isCoverPreviewing ? _self.isCoverPreviewing : isCoverPreviewing // ignore: cast_nullable_to_non_nullable
as bool,textContent: null == textContent ? _self.textContent : textContent // ignore: cast_nullable_to_non_nullable
as String,blogTitle: null == blogTitle ? _self.blogTitle : blogTitle // ignore: cast_nullable_to_non_nullable
as String,isLoadingGPS: null == isLoadingGPS ? _self.isLoadingGPS : isLoadingGPS // ignore: cast_nullable_to_non_nullable
as bool,publishProgress: null == publishProgress ? _self.publishProgress : publishProgress // ignore: cast_nullable_to_non_nullable
as double,publishStage: null == publishStage ? _self.publishStage : publishStage // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<List<FabuModel>> items,  List<XFile> files,  List<XFile> videoFiles,  XFile? coverFile,  Uint8List? coverPreviewBytes,  List<String> uploadedFileUrls,  List<String> uploadedVideoUrls,  String? uploadedCoverUrl,  XFile? backgroundMusicFile,  String? uploadedBackgroundMusicUrl,  String? backgroundMusicName,  int soundMode,  int selectedCoverStyleId,  List<AddressEntity> addressList,  List<SkuuTopicResVO> topicList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  int? whoCanSeeSel,  int aixinType,  Map<int, String> huatiSel,  Map<int, String> collectionSel,  int? collectionItemCount,  int? collectionEpisode,  List<MallProduct> shopProducts,  String? error,  bool isLoading,  bool isUploading,  bool isCoverUploading,  bool isCoverPreviewing,  String textContent,  String blogTitle,  bool isLoadingGPS,  double publishProgress,  String publishStage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FabuState() when $default != null:
return $default(_that.items,_that.files,_that.videoFiles,_that.coverFile,_that.coverPreviewBytes,_that.uploadedFileUrls,_that.uploadedVideoUrls,_that.uploadedCoverUrl,_that.backgroundMusicFile,_that.uploadedBackgroundMusicUrl,_that.backgroundMusicName,_that.soundMode,_that.selectedCoverStyleId,_that.addressList,_that.topicList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.aixinType,_that.huatiSel,_that.collectionSel,_that.collectionItemCount,_that.collectionEpisode,_that.shopProducts,_that.error,_that.isLoading,_that.isUploading,_that.isCoverUploading,_that.isCoverPreviewing,_that.textContent,_that.blogTitle,_that.isLoadingGPS,_that.publishProgress,_that.publishStage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<List<FabuModel>> items,  List<XFile> files,  List<XFile> videoFiles,  XFile? coverFile,  Uint8List? coverPreviewBytes,  List<String> uploadedFileUrls,  List<String> uploadedVideoUrls,  String? uploadedCoverUrl,  XFile? backgroundMusicFile,  String? uploadedBackgroundMusicUrl,  String? backgroundMusicName,  int soundMode,  int selectedCoverStyleId,  List<AddressEntity> addressList,  List<SkuuTopicResVO> topicList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  int? whoCanSeeSel,  int aixinType,  Map<int, String> huatiSel,  Map<int, String> collectionSel,  int? collectionItemCount,  int? collectionEpisode,  List<MallProduct> shopProducts,  String? error,  bool isLoading,  bool isUploading,  bool isCoverUploading,  bool isCoverPreviewing,  String textContent,  String blogTitle,  bool isLoadingGPS,  double publishProgress,  String publishStage)  $default,) {final _that = this;
switch (_that) {
case _FabuState():
return $default(_that.items,_that.files,_that.videoFiles,_that.coverFile,_that.coverPreviewBytes,_that.uploadedFileUrls,_that.uploadedVideoUrls,_that.uploadedCoverUrl,_that.backgroundMusicFile,_that.uploadedBackgroundMusicUrl,_that.backgroundMusicName,_that.soundMode,_that.selectedCoverStyleId,_that.addressList,_that.topicList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.aixinType,_that.huatiSel,_that.collectionSel,_that.collectionItemCount,_that.collectionEpisode,_that.shopProducts,_that.error,_that.isLoading,_that.isUploading,_that.isCoverUploading,_that.isCoverPreviewing,_that.textContent,_that.blogTitle,_that.isLoadingGPS,_that.publishProgress,_that.publishStage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<List<FabuModel>> items,  List<XFile> files,  List<XFile> videoFiles,  XFile? coverFile,  Uint8List? coverPreviewBytes,  List<String> uploadedFileUrls,  List<String> uploadedVideoUrls,  String? uploadedCoverUrl,  XFile? backgroundMusicFile,  String? uploadedBackgroundMusicUrl,  String? backgroundMusicName,  int soundMode,  int selectedCoverStyleId,  List<AddressEntity> addressList,  List<SkuuTopicResVO> topicList,  List<String> whoCanSee,  AddressEntity? selAddressEntity,  int? whoCanSeeSel,  int aixinType,  Map<int, String> huatiSel,  Map<int, String> collectionSel,  int? collectionItemCount,  int? collectionEpisode,  List<MallProduct> shopProducts,  String? error,  bool isLoading,  bool isUploading,  bool isCoverUploading,  bool isCoverPreviewing,  String textContent,  String blogTitle,  bool isLoadingGPS,  double publishProgress,  String publishStage)?  $default,) {final _that = this;
switch (_that) {
case _FabuState() when $default != null:
return $default(_that.items,_that.files,_that.videoFiles,_that.coverFile,_that.coverPreviewBytes,_that.uploadedFileUrls,_that.uploadedVideoUrls,_that.uploadedCoverUrl,_that.backgroundMusicFile,_that.uploadedBackgroundMusicUrl,_that.backgroundMusicName,_that.soundMode,_that.selectedCoverStyleId,_that.addressList,_that.topicList,_that.whoCanSee,_that.selAddressEntity,_that.whoCanSeeSel,_that.aixinType,_that.huatiSel,_that.collectionSel,_that.collectionItemCount,_that.collectionEpisode,_that.shopProducts,_that.error,_that.isLoading,_that.isUploading,_that.isCoverUploading,_that.isCoverPreviewing,_that.textContent,_that.blogTitle,_that.isLoadingGPS,_that.publishProgress,_that.publishStage);case _:
  return null;

}
}

}

/// @nodoc


class _FabuState with DiagnosticableTreeMixin implements FabuState {
  const _FabuState({this.items = const AsyncLoading(), final  List<XFile> files = const [], final  List<XFile> videoFiles = const [], this.coverFile, this.coverPreviewBytes, final  List<String> uploadedFileUrls = const [], final  List<String> uploadedVideoUrls = const [], this.uploadedCoverUrl, this.backgroundMusicFile, this.uploadedBackgroundMusicUrl, this.backgroundMusicName, this.soundMode = 1, this.selectedCoverStyleId = 1, final  List<AddressEntity> addressList = const [], final  List<SkuuTopicResVO> topicList = const [], final  List<String> whoCanSee = const ['公开', '仅自己可见', '部分好友可见', '部分好友不可见'], this.selAddressEntity, this.whoCanSeeSel = 0, this.aixinType = 0, final  Map<int, String> huatiSel = const {}, final  Map<int, String> collectionSel = const {}, this.collectionItemCount, this.collectionEpisode, final  List<MallProduct> shopProducts = const [], this.error, this.isLoading = false, this.isUploading = false, this.isCoverUploading = false, this.isCoverPreviewing = false, this.textContent = '', this.blogTitle = '', this.isLoadingGPS = false, this.publishProgress = 0.0, this.publishStage = ''}): _files = files,_videoFiles = videoFiles,_uploadedFileUrls = uploadedFileUrls,_uploadedVideoUrls = uploadedVideoUrls,_addressList = addressList,_topicList = topicList,_whoCanSee = whoCanSee,_huatiSel = huatiSel,_collectionSel = collectionSel,_shopProducts = shopProducts;
  

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

@override final  XFile? coverFile;
@override final  Uint8List? coverPreviewBytes;
 final  List<String> _uploadedFileUrls;
@override@JsonKey() List<String> get uploadedFileUrls {
  if (_uploadedFileUrls is EqualUnmodifiableListView) return _uploadedFileUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uploadedFileUrls);
}

 final  List<String> _uploadedVideoUrls;
@override@JsonKey() List<String> get uploadedVideoUrls {
  if (_uploadedVideoUrls is EqualUnmodifiableListView) return _uploadedVideoUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uploadedVideoUrls);
}

@override final  String? uploadedCoverUrl;
@override final  XFile? backgroundMusicFile;
@override final  String? uploadedBackgroundMusicUrl;
@override final  String? backgroundMusicName;
@override@JsonKey() final  int soundMode;
@override@JsonKey() final  int selectedCoverStyleId;
 final  List<AddressEntity> _addressList;
@override@JsonKey() List<AddressEntity> get addressList {
  if (_addressList is EqualUnmodifiableListView) return _addressList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_addressList);
}

 final  List<SkuuTopicResVO> _topicList;
@override@JsonKey() List<SkuuTopicResVO> get topicList {
  if (_topicList is EqualUnmodifiableListView) return _topicList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topicList);
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

 final  Map<int, String> _collectionSel;
@override@JsonKey() Map<int, String> get collectionSel {
  if (_collectionSel is EqualUnmodifiableMapView) return _collectionSel;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_collectionSel);
}

@override final  int? collectionItemCount;
@override final  int? collectionEpisode;
 final  List<MallProduct> _shopProducts;
@override@JsonKey() List<MallProduct> get shopProducts {
  if (_shopProducts is EqualUnmodifiableListView) return _shopProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shopProducts);
}

@override final  String? error;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isUploading;
@override@JsonKey() final  bool isCoverUploading;
@override@JsonKey() final  bool isCoverPreviewing;
@override@JsonKey() final  String textContent;
@override@JsonKey() final  String blogTitle;
@override@JsonKey() final  bool isLoadingGPS;
@override@JsonKey() final  double publishProgress;
@override@JsonKey() final  String publishStage;

/// Create a copy of FabuState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FabuStateCopyWith<_FabuState> get copyWith => __$FabuStateCopyWithImpl<_FabuState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FabuState'))
    ..add(DiagnosticsProperty('items', items))..add(DiagnosticsProperty('files', files))..add(DiagnosticsProperty('videoFiles', videoFiles))..add(DiagnosticsProperty('coverFile', coverFile))..add(DiagnosticsProperty('coverPreviewBytes', coverPreviewBytes))..add(DiagnosticsProperty('uploadedFileUrls', uploadedFileUrls))..add(DiagnosticsProperty('uploadedVideoUrls', uploadedVideoUrls))..add(DiagnosticsProperty('uploadedCoverUrl', uploadedCoverUrl))..add(DiagnosticsProperty('backgroundMusicFile', backgroundMusicFile))..add(DiagnosticsProperty('uploadedBackgroundMusicUrl', uploadedBackgroundMusicUrl))..add(DiagnosticsProperty('backgroundMusicName', backgroundMusicName))..add(DiagnosticsProperty('soundMode', soundMode))..add(DiagnosticsProperty('selectedCoverStyleId', selectedCoverStyleId))..add(DiagnosticsProperty('addressList', addressList))..add(DiagnosticsProperty('topicList', topicList))..add(DiagnosticsProperty('whoCanSee', whoCanSee))..add(DiagnosticsProperty('selAddressEntity', selAddressEntity))..add(DiagnosticsProperty('whoCanSeeSel', whoCanSeeSel))..add(DiagnosticsProperty('aixinType', aixinType))..add(DiagnosticsProperty('huatiSel', huatiSel))..add(DiagnosticsProperty('collectionSel', collectionSel))..add(DiagnosticsProperty('collectionItemCount', collectionItemCount))..add(DiagnosticsProperty('collectionEpisode', collectionEpisode))..add(DiagnosticsProperty('shopProducts', shopProducts))..add(DiagnosticsProperty('error', error))..add(DiagnosticsProperty('isLoading', isLoading))..add(DiagnosticsProperty('isUploading', isUploading))..add(DiagnosticsProperty('isCoverUploading', isCoverUploading))..add(DiagnosticsProperty('isCoverPreviewing', isCoverPreviewing))..add(DiagnosticsProperty('textContent', textContent))..add(DiagnosticsProperty('blogTitle', blogTitle))..add(DiagnosticsProperty('isLoadingGPS', isLoadingGPS))..add(DiagnosticsProperty('publishProgress', publishProgress))..add(DiagnosticsProperty('publishStage', publishStage));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FabuState&&(identical(other.items, items) || other.items == items)&&const DeepCollectionEquality().equals(other._files, _files)&&const DeepCollectionEquality().equals(other._videoFiles, _videoFiles)&&(identical(other.coverFile, coverFile) || other.coverFile == coverFile)&&const DeepCollectionEquality().equals(other.coverPreviewBytes, coverPreviewBytes)&&const DeepCollectionEquality().equals(other._uploadedFileUrls, _uploadedFileUrls)&&const DeepCollectionEquality().equals(other._uploadedVideoUrls, _uploadedVideoUrls)&&(identical(other.uploadedCoverUrl, uploadedCoverUrl) || other.uploadedCoverUrl == uploadedCoverUrl)&&(identical(other.backgroundMusicFile, backgroundMusicFile) || other.backgroundMusicFile == backgroundMusicFile)&&(identical(other.uploadedBackgroundMusicUrl, uploadedBackgroundMusicUrl) || other.uploadedBackgroundMusicUrl == uploadedBackgroundMusicUrl)&&(identical(other.backgroundMusicName, backgroundMusicName) || other.backgroundMusicName == backgroundMusicName)&&(identical(other.soundMode, soundMode) || other.soundMode == soundMode)&&(identical(other.selectedCoverStyleId, selectedCoverStyleId) || other.selectedCoverStyleId == selectedCoverStyleId)&&const DeepCollectionEquality().equals(other._addressList, _addressList)&&const DeepCollectionEquality().equals(other._topicList, _topicList)&&const DeepCollectionEquality().equals(other._whoCanSee, _whoCanSee)&&(identical(other.selAddressEntity, selAddressEntity) || other.selAddressEntity == selAddressEntity)&&(identical(other.whoCanSeeSel, whoCanSeeSel) || other.whoCanSeeSel == whoCanSeeSel)&&(identical(other.aixinType, aixinType) || other.aixinType == aixinType)&&const DeepCollectionEquality().equals(other._huatiSel, _huatiSel)&&const DeepCollectionEquality().equals(other._collectionSel, _collectionSel)&&(identical(other.collectionItemCount, collectionItemCount) || other.collectionItemCount == collectionItemCount)&&(identical(other.collectionEpisode, collectionEpisode) || other.collectionEpisode == collectionEpisode)&&const DeepCollectionEquality().equals(other._shopProducts, _shopProducts)&&(identical(other.error, error) || other.error == error)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isUploading, isUploading) || other.isUploading == isUploading)&&(identical(other.isCoverUploading, isCoverUploading) || other.isCoverUploading == isCoverUploading)&&(identical(other.isCoverPreviewing, isCoverPreviewing) || other.isCoverPreviewing == isCoverPreviewing)&&(identical(other.textContent, textContent) || other.textContent == textContent)&&(identical(other.blogTitle, blogTitle) || other.blogTitle == blogTitle)&&(identical(other.isLoadingGPS, isLoadingGPS) || other.isLoadingGPS == isLoadingGPS)&&(identical(other.publishProgress, publishProgress) || other.publishProgress == publishProgress)&&(identical(other.publishStage, publishStage) || other.publishStage == publishStage));
}


@override
int get hashCode => Object.hashAll([runtimeType,items,const DeepCollectionEquality().hash(_files),const DeepCollectionEquality().hash(_videoFiles),coverFile,const DeepCollectionEquality().hash(coverPreviewBytes),const DeepCollectionEquality().hash(_uploadedFileUrls),const DeepCollectionEquality().hash(_uploadedVideoUrls),uploadedCoverUrl,backgroundMusicFile,uploadedBackgroundMusicUrl,backgroundMusicName,soundMode,selectedCoverStyleId,const DeepCollectionEquality().hash(_addressList),const DeepCollectionEquality().hash(_topicList),const DeepCollectionEquality().hash(_whoCanSee),selAddressEntity,whoCanSeeSel,aixinType,const DeepCollectionEquality().hash(_huatiSel),const DeepCollectionEquality().hash(_collectionSel),collectionItemCount,collectionEpisode,const DeepCollectionEquality().hash(_shopProducts),error,isLoading,isUploading,isCoverUploading,isCoverPreviewing,textContent,blogTitle,isLoadingGPS,publishProgress,publishStage]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FabuState(items: $items, files: $files, videoFiles: $videoFiles, coverFile: $coverFile, coverPreviewBytes: $coverPreviewBytes, uploadedFileUrls: $uploadedFileUrls, uploadedVideoUrls: $uploadedVideoUrls, uploadedCoverUrl: $uploadedCoverUrl, backgroundMusicFile: $backgroundMusicFile, uploadedBackgroundMusicUrl: $uploadedBackgroundMusicUrl, backgroundMusicName: $backgroundMusicName, soundMode: $soundMode, selectedCoverStyleId: $selectedCoverStyleId, addressList: $addressList, topicList: $topicList, whoCanSee: $whoCanSee, selAddressEntity: $selAddressEntity, whoCanSeeSel: $whoCanSeeSel, aixinType: $aixinType, huatiSel: $huatiSel, collectionSel: $collectionSel, collectionItemCount: $collectionItemCount, collectionEpisode: $collectionEpisode, shopProducts: $shopProducts, error: $error, isLoading: $isLoading, isUploading: $isUploading, isCoverUploading: $isCoverUploading, isCoverPreviewing: $isCoverPreviewing, textContent: $textContent, blogTitle: $blogTitle, isLoadingGPS: $isLoadingGPS, publishProgress: $publishProgress, publishStage: $publishStage)';
}


}

/// @nodoc
abstract mixin class _$FabuStateCopyWith<$Res> implements $FabuStateCopyWith<$Res> {
  factory _$FabuStateCopyWith(_FabuState value, $Res Function(_FabuState) _then) = __$FabuStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<List<FabuModel>> items, List<XFile> files, List<XFile> videoFiles, XFile? coverFile, Uint8List? coverPreviewBytes, List<String> uploadedFileUrls, List<String> uploadedVideoUrls, String? uploadedCoverUrl, XFile? backgroundMusicFile, String? uploadedBackgroundMusicUrl, String? backgroundMusicName, int soundMode, int selectedCoverStyleId, List<AddressEntity> addressList, List<SkuuTopicResVO> topicList, List<String> whoCanSee, AddressEntity? selAddressEntity, int? whoCanSeeSel, int aixinType, Map<int, String> huatiSel, Map<int, String> collectionSel, int? collectionItemCount, int? collectionEpisode, List<MallProduct> shopProducts, String? error, bool isLoading, bool isUploading, bool isCoverUploading, bool isCoverPreviewing, String textContent, String blogTitle, bool isLoadingGPS, double publishProgress, String publishStage
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
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? files = null,Object? videoFiles = null,Object? coverFile = freezed,Object? coverPreviewBytes = freezed,Object? uploadedFileUrls = null,Object? uploadedVideoUrls = null,Object? uploadedCoverUrl = freezed,Object? backgroundMusicFile = freezed,Object? uploadedBackgroundMusicUrl = freezed,Object? backgroundMusicName = freezed,Object? soundMode = null,Object? selectedCoverStyleId = null,Object? addressList = null,Object? topicList = null,Object? whoCanSee = null,Object? selAddressEntity = freezed,Object? whoCanSeeSel = freezed,Object? aixinType = null,Object? huatiSel = null,Object? collectionSel = null,Object? collectionItemCount = freezed,Object? collectionEpisode = freezed,Object? shopProducts = null,Object? error = freezed,Object? isLoading = null,Object? isUploading = null,Object? isCoverUploading = null,Object? isCoverPreviewing = null,Object? textContent = null,Object? blogTitle = null,Object? isLoadingGPS = null,Object? publishProgress = null,Object? publishStage = null,}) {
  return _then(_FabuState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<FabuModel>>,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<XFile>,videoFiles: null == videoFiles ? _self._videoFiles : videoFiles // ignore: cast_nullable_to_non_nullable
as List<XFile>,coverFile: freezed == coverFile ? _self.coverFile : coverFile // ignore: cast_nullable_to_non_nullable
as XFile?,coverPreviewBytes: freezed == coverPreviewBytes ? _self.coverPreviewBytes : coverPreviewBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,uploadedFileUrls: null == uploadedFileUrls ? _self._uploadedFileUrls : uploadedFileUrls // ignore: cast_nullable_to_non_nullable
as List<String>,uploadedVideoUrls: null == uploadedVideoUrls ? _self._uploadedVideoUrls : uploadedVideoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,uploadedCoverUrl: freezed == uploadedCoverUrl ? _self.uploadedCoverUrl : uploadedCoverUrl // ignore: cast_nullable_to_non_nullable
as String?,backgroundMusicFile: freezed == backgroundMusicFile ? _self.backgroundMusicFile : backgroundMusicFile // ignore: cast_nullable_to_non_nullable
as XFile?,uploadedBackgroundMusicUrl: freezed == uploadedBackgroundMusicUrl ? _self.uploadedBackgroundMusicUrl : uploadedBackgroundMusicUrl // ignore: cast_nullable_to_non_nullable
as String?,backgroundMusicName: freezed == backgroundMusicName ? _self.backgroundMusicName : backgroundMusicName // ignore: cast_nullable_to_non_nullable
as String?,soundMode: null == soundMode ? _self.soundMode : soundMode // ignore: cast_nullable_to_non_nullable
as int,selectedCoverStyleId: null == selectedCoverStyleId ? _self.selectedCoverStyleId : selectedCoverStyleId // ignore: cast_nullable_to_non_nullable
as int,addressList: null == addressList ? _self._addressList : addressList // ignore: cast_nullable_to_non_nullable
as List<AddressEntity>,topicList: null == topicList ? _self._topicList : topicList // ignore: cast_nullable_to_non_nullable
as List<SkuuTopicResVO>,whoCanSee: null == whoCanSee ? _self._whoCanSee : whoCanSee // ignore: cast_nullable_to_non_nullable
as List<String>,selAddressEntity: freezed == selAddressEntity ? _self.selAddressEntity : selAddressEntity // ignore: cast_nullable_to_non_nullable
as AddressEntity?,whoCanSeeSel: freezed == whoCanSeeSel ? _self.whoCanSeeSel : whoCanSeeSel // ignore: cast_nullable_to_non_nullable
as int?,aixinType: null == aixinType ? _self.aixinType : aixinType // ignore: cast_nullable_to_non_nullable
as int,huatiSel: null == huatiSel ? _self._huatiSel : huatiSel // ignore: cast_nullable_to_non_nullable
as Map<int, String>,collectionSel: null == collectionSel ? _self._collectionSel : collectionSel // ignore: cast_nullable_to_non_nullable
as Map<int, String>,collectionItemCount: freezed == collectionItemCount ? _self.collectionItemCount : collectionItemCount // ignore: cast_nullable_to_non_nullable
as int?,collectionEpisode: freezed == collectionEpisode ? _self.collectionEpisode : collectionEpisode // ignore: cast_nullable_to_non_nullable
as int?,shopProducts: null == shopProducts ? _self._shopProducts : shopProducts // ignore: cast_nullable_to_non_nullable
as List<MallProduct>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isUploading: null == isUploading ? _self.isUploading : isUploading // ignore: cast_nullable_to_non_nullable
as bool,isCoverUploading: null == isCoverUploading ? _self.isCoverUploading : isCoverUploading // ignore: cast_nullable_to_non_nullable
as bool,isCoverPreviewing: null == isCoverPreviewing ? _self.isCoverPreviewing : isCoverPreviewing // ignore: cast_nullable_to_non_nullable
as bool,textContent: null == textContent ? _self.textContent : textContent // ignore: cast_nullable_to_non_nullable
as String,blogTitle: null == blogTitle ? _self.blogTitle : blogTitle // ignore: cast_nullable_to_non_nullable
as String,isLoadingGPS: null == isLoadingGPS ? _self.isLoadingGPS : isLoadingGPS // ignore: cast_nullable_to_non_nullable
as bool,publishProgress: null == publishProgress ? _self.publishProgress : publishProgress // ignore: cast_nullable_to_non_nullable
as double,publishStage: null == publishStage ? _self.publishStage : publishStage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

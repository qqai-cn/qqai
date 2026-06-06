import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:video_player/video_player.dart';

import '../../../../util/api_base_client.dart';
import '../../../util/image_bytes_xfile.dart';
import '../../../components/blog/network_image_carousel_pages.dart';
import '../../../components/video_player/local_qqai_player.dart';
import '../../data/models/address_entity.dart';
import '../../tool/video_cover_tool.dart';
import '../data/repos/fabu_repo.dart';
import '../data/models/fabu_model.dart';
import '../data/models/topic_model.dart';
import '../../blog/data/models/blog_save_req_vo.dart';
import '../../blog/data/repos/blog_repo.dart';
import '../../goods/data/models/mall_product_model.dart';
import '../../my/data/models/profile_models.dart';

part 'fabu_providers.freezed.dart';

part 'fabu_providers.g.dart';

@freezed
sealed class FabuState with _$FabuState {
  const factory FabuState({
    // freezed 的 @Default 必须是 const
    @Default(const AsyncLoading()) AsyncValue<List<FabuModel>> items,
    @Default([]) List<XFile> files,
    @Default([]) List<XFile> videoFiles,
    XFile? coverFile,
    Uint8List? coverPreviewBytes,
    @Default([]) List<String> uploadedFileUrls,
    @Default([]) List<String> uploadedVideoUrls,
    String? uploadedCoverUrl,
    XFile? backgroundMusicFile,
    String? uploadedBackgroundMusicUrl,
    String? backgroundMusicName,
    @Default(1) int soundMode,
    @Default(1) int selectedCoverStyleId,
    @Default([]) List<AddressEntity> addressList,
    @Default([]) List<SkuuTopicResVO> topicList,
    @Default(['公开', '仅自己可见', '部分好友可见', '部分好友不可见']) List<String> whoCanSee,
    AddressEntity? selAddressEntity,
    @Default(0) int? whoCanSeeSel,
    @Default(0) int aixinType,
    @Default({}) Map<int, String> huatiSel,
    @Default({}) Map<int, String> collectionSel,
    int? collectionItemCount,
    int? collectionEpisode,
    @Default([]) List<MallProduct> shopProducts,
    String? error,
    @Default(false) bool isLoading,
    @Default(false) bool isUploading,
    @Default(false) bool isCoverUploading,
    @Default(false) bool isCoverPreviewing,
    @Default('') String textContent,
    @Default('') String blogTitle,
    @Default(false) bool isLoadingGPS,
    @Default(0.0) double publishProgress,
    @Default('') String publishStage,
  }) = _FabuState;
}

@riverpod
class FabuNotifier extends _$FabuNotifier {
  late final IFabuRepo _repo;
  int? _cachedVideoDurationMs;
  String? _cachedVideoPath;
  double? _cachedVideoAspectRatio;
  int _coverPreviewGeneration = 0;
  Future<Uint8List?> Function()? _widgetCoverCapture;

  /// 由发布页视频 Tab 注册：发布前从组件预览截图封面。
  void setWidgetCoverCapture(Future<Uint8List?> Function()? capture) {
    _widgetCoverCapture = capture;
  }

  @override
  FabuState build() {
    _repo = ref.read(fabuRepoProvider);
    ref.onDispose(() => _widgetCoverCapture = null);
    return const FabuState();
  }

  Future<void> load() async {
    state = state.copyWith(items: const AsyncLoading(), error: null);
    try {
      final items = await _repo.getAllFabus();
      state = state.copyWith(items: AsyncData(items));
    } catch (e, st) {
      state = state.copyWith(items: AsyncError(e, st), error: e.toString());
    }
  }

  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    final newItem = FabuModel(
      id: const Uuid().v4(),
      title: title,
      isDone: false,
    );
    try {
      await _repo.addFabu(newItem);
      await load();
    } catch (e) {
      state = state.copyWith(error: '添加失败: $e');
    }
  }

  Future<void> toggle(String id) async {
    final item = await _repo.getFabuById(id);
    if (item == null) return;
    final updated = item.copyWith(isDone: !item.isDone);
    try {
      await _repo.updateFabu(updated);
      await load();
    } catch (e) {
      state = state.copyWith(error: '更新失败: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteFabu(id);
      await load();
    } catch (e) {
      state = state.copyWith(error: '删除失败: $e');
    }
  }

  Future<void> loadAddressData() async {
    try {
      final value = await rootBundle.loadString('mock/address.json');
      final list = json.decode(value) as List;
      final addressList = list.map((v) => AddressEntity.fromJson(v)).toList();
      state = state.copyWith(addressList: addressList);
    } catch (e) {
      print('Error loading address data: $e');
    }
  }

  Future<void> loadGPSAddress() async {
    state = state.copyWith(isLoadingGPS: true);
    try {
      // Check location permission
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Call API to get weather city
      final weatherCity = await _repo.getWeatherCityByGPS(
        position.latitude.toString(),
        position.longitude.toString(),
      );

      if (weatherCity != null) {
        final addressEntity = AddressEntity.fromWeatherCity(
          weatherCity,
          latitude: position.latitude,
          longitude: position.longitude,
        );
        final addressEntityOnly = AddressEntity.fromWeatherCityOnly(
          weatherCity,
          latitude: position.latitude,
          longitude: position.longitude,
        );

        // Add GPS address to the top of the list
        final addressList = List<AddressEntity>.from(state.addressList);
        addressList.insert(1, addressEntityOnly);
        addressList.insert(2, addressEntity);
        state = state.copyWith(addressList: addressList);
      }
    } catch (e) {
      print('Error loading GPS address: $e');
    } finally {
      state = state.copyWith(isLoadingGPS: false);
    }
  }

  Future<void> loadTopicList() async {
    try {
      final topics = await _repo.getTopicList(1, 200);
      state = state.copyWith(topicList: topics);
    } catch (e) {
      print('Error loading topic list: $e');
    }
  }

  Future<void> selectVideoCover(XFile file) {
    _coverPreviewGeneration++;
    state = state.copyWith(
      coverFile: file,
      coverPreviewBytes: null,
      uploadedCoverUrl: null,
      isCoverPreviewing: false,
    );
    return Future.value();
  }

  Future<int?> getVideoDurationSeconds(XFile video) async {
    final durationMs = await _videoDurationMs(video);
    return (durationMs / 1000).round();
  }

  Future<double> getVideoAspectRatio(
    XFile video, {
    double fallback = 9 / 16,
  }) async {
    if (_cachedVideoPath == video.path && _cachedVideoAspectRatio != null) {
      return _cachedVideoAspectRatio!;
    }
    final aspectRatio = await _readVideoAspectRatio(video, fallback: fallback);
    _cachedVideoPath = video.path;
    _cachedVideoAspectRatio = aspectRatio;
    return aspectRatio;
  }

  void applyVideoCoverFromBytes(Uint8List bytes) {
    state = state.copyWith(
      coverFile: xFileFromImageBytes(bytes, baseName: 'video-cover'),
      coverPreviewBytes: bytes,
      uploadedCoverUrl: null,
      isCoverPreviewing: false,
    );
  }

  Future<void> captureVideoCoverAtTimeMs(XFile video, int timeMs) async {
    _coverPreviewGeneration++;
    state = state.copyWith(isCoverPreviewing: true, uploadedCoverUrl: null);
    try {
      final durationMs = await _videoDurationMs(video);
      final clampedMs = timeMs.clamp(0, math.max(0, durationMs - 1)).toInt();
      final bytes = await generateVideoCoverBytes(
        videoPath: video.path,
        timeMs: clampedMs,
        imageFormat: ImageFormat.JPEG,
      );
      applyVideoCoverFromBytes(bytes);
    } catch (e) {
      state = state.copyWith(isCoverPreviewing: false);
      rethrow;
    }
  }

  void applyVideoCoverPreview() {
    final previewBytes = state.coverPreviewBytes;
    if (previewBytes == null) return;
    applyVideoCoverFromBytes(previewBytes);
  }

  void clearVideoCover() {
    _coverPreviewGeneration++;
    state = state.copyWith(
      coverFile: null,
      coverPreviewBytes: null,
      uploadedCoverUrl: null,
      isCoverPreviewing: false,
    );
  }

  void setCoverStyle(int styleId) {
    if (styleId == state.selectedCoverStyleId) return;
    state = state.copyWith(
      selectedCoverStyleId: styleId,
      coverPreviewBytes: null,
    );
  }

  Future<int> _videoDurationMs(XFile video) async {
    if (_cachedVideoPath == video.path && _cachedVideoDurationMs != null) {
      return _cachedVideoDurationMs!;
    }
    final durationMs = await _readVideoDurationMs(video);
    _cachedVideoPath = video.path;
    _cachedVideoDurationMs = durationMs;
    return durationMs;
  }

  Future<int> _readVideoDurationMs(XFile video) async {
    VideoPlayerController? controller;
    try {
      final path = video.path;
      final uri = Uri.tryParse(path);
      if (uri != null && uri.hasScheme && uri.scheme != 'file') {
        controller = VideoPlayerController.networkUrl(uri);
      } else if (kIsWeb) {
        controller = VideoPlayerController.networkUrl(uri ?? Uri.parse(path));
      } else {
        controller = VideoPlayerController.file(
          File(uri?.toFilePath() ?? path),
        );
      }
      await controller.initialize();
      return controller.value.duration.inMilliseconds;
    } catch (e) {
      debugPrint('Read video duration error: $e');
      return 0;
    } finally {
      await controller?.dispose();
    }
  }

  void _resetVideoDurationCache() {
    _cachedVideoPath = null;
    _cachedVideoDurationMs = null;
    _cachedVideoAspectRatio = null;
  }

  Future<double> _readVideoAspectRatio(
    XFile video, {
    double fallback = 9 / 16,
  }) {
    return resolveLocalVideoAspectRatio(video, fallbackAspectRatio: fallback);
  }

  Future<LocalVideoMetadata> _readVideoMetadata(
    XFile video, {
    double fallbackAspectRatio = 9 / 16,
  }) {
    return resolveLocalVideoMetadata(
      video,
      fallbackAspectRatio: fallbackAspectRatio,
    );
  }

  void _syncCoverStyleForAspectRatio(double aspectRatio) {
    final styleId = normalizeVideoCoverStyleForAspectRatio(
      state.selectedCoverStyleId,
      aspectRatio,
    );
    if (styleId == state.selectedCoverStyleId) return;
    state = state.copyWith(
      selectedCoverStyleId: styleId,
      coverPreviewBytes: null,
    );
  }

  void clearList(XFile file) {
    final newFiles = List<XFile>.from(state.files)..remove(file);
    state = state.copyWith(
      files: newFiles,
      uploadedFileUrls: [],
      videoFiles: [],
      uploadedVideoUrls: [],
    );
  }

  void clearVideo() {
    final path = state.videoFiles.isEmpty ? null : state.videoFiles.first.path;
    _resetVideoDurationCache();
    if (path != null) {
      clearLocalVideoAspectRatioCache(path);
    }
    _coverPreviewGeneration++;
    state = state.copyWith(
      files: [],
      videoFiles: [],
      uploadedFileUrls: [],
      uploadedVideoUrls: [],
      coverFile: null,
      coverPreviewBytes: null,
      uploadedCoverUrl: null,
      isCoverPreviewing: false,
    );
  }

  Future<void> selectFile(List<XFile> value, BuildContext context) async {
    final allEmpty = state.files.isNotEmpty && state.videoFiles.isNotEmpty;
    if (allEmpty) {
      clearVideo();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('提示'),
          content: const Text('请上传图片'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
      return;
    }
    if (state.files.length + value.length > 6) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('提示'),
          content: const Text('图片超出最大限制：6个'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
      return;
    }
    if (value.isNotEmpty) {
      final newFiles = List<XFile>.from(state.files)..addAll(value);
      state = state.copyWith(files: newFiles, uploadedFileUrls: []);
    }
  }

  Future<void> addVideoFiles(List<XFile> videoFiles) async {
    if (videoFiles.isEmpty) return;
    _resetVideoDurationCache();
    _coverPreviewGeneration++;
    final video = videoFiles.first;

    final metadata = await _readVideoMetadata(video);
    _cachedVideoPath = video.path;
    _cachedVideoAspectRatio = metadata.aspectRatio;
    _cachedVideoDurationMs = metadata.durationMs;

    final newVideoFiles = List<XFile>.from(videoFiles);
    state = state.copyWith(
      files: newVideoFiles,
      uploadedFileUrls: [],
      videoFiles: newVideoFiles,
      uploadedVideoUrls: [],
      coverFile: null,
      coverPreviewBytes: null,
      uploadedCoverUrl: null,
      isCoverPreviewing: false,
    );
    _syncCoverStyleForAspectRatio(metadata.aspectRatio);
  }

  void removeVideoFile(XFile file) {
    final path = file.path;
    final newVideoFiles = List<XFile>.from(state.videoFiles)..remove(file);
    clearLocalVideoAspectRatioCache(path);
    _resetVideoDurationCache();
    _coverPreviewGeneration++;

    if (newVideoFiles.isEmpty) {
      state = state.copyWith(
        files: [],
        videoFiles: [],
        uploadedFileUrls: [],
        uploadedVideoUrls: [],
        coverFile: null,
        coverPreviewBytes: null,
        uploadedCoverUrl: null,
        isCoverPreviewing: false,
      );
      return;
    }

    state = state.copyWith(
      files: newVideoFiles,
      videoFiles: newVideoFiles,
      uploadedFileUrls: [],
      uploadedVideoUrls: [],
      coverFile: null,
      coverPreviewBytes: null,
      uploadedCoverUrl: null,
      isCoverPreviewing: false,
    );
  }

  void selectBackgroundMusic(XFile file) {
    final musicName = file.name.trim().isEmpty
        ? file.path.split('/').last
        : file.name.trim();
    state = state.copyWith(
      backgroundMusicFile: file,
      uploadedBackgroundMusicUrl: null,
      backgroundMusicName: musicName,
      soundMode: 2,
    );
  }

  void selectBackgroundMusicFromLibrary({
    required String url,
    required String name,
  }) {
    if (url.trim().isEmpty) return;
    state = state.copyWith(
      backgroundMusicFile: null,
      uploadedBackgroundMusicUrl: url.trim(),
      backgroundMusicName: name.trim().isEmpty ? '背景音乐' : name.trim(),
      soundMode: 2,
    );
  }

  void clearBackgroundMusic() {
    state = state.copyWith(
      backgroundMusicFile: null,
      uploadedBackgroundMusicUrl: null,
      backgroundMusicName: null,
      soundMode: 1,
    );
  }

  void setSoundMode(int mode) {
    if (mode != 1 && mode != 2) return;
    state = state.copyWith(soundMode: mode);
  }

  void setWhoCanSee(int who) {
    state = state.copyWith(whoCanSeeSel: who);
  }

  void setHuati(Map<int, String> huati) {
    state = state.copyWith(huatiSel: huati);
  }

  void setCollectionSel(Map<int, String> collections) {
    state = state.copyWith(
      collectionSel: collections,
      collectionItemCount: null,
      collectionEpisode: null,
    );
  }

  void setCollection(BlogCollectionResp collection) {
    final id = collection.id;
    if (id == null) return;
    final count = collection.itemCount ?? 0;
    state = state.copyWith(
      collectionSel: {id: collection.name ?? '合集'},
      collectionItemCount: count,
      collectionEpisode: count + 1,
    );
  }

  void setCollectionEpisode(int episode) {
    state = state.copyWith(collectionEpisode: episode);
  }

  void clearCollection() {
    state = state.copyWith(
      collectionSel: {},
      collectionItemCount: null,
      collectionEpisode: null,
    );
  }

  void setShopProducts(List<MallProduct> products) {
    state = state.copyWith(shopProducts: products);
  }

  void removeShopProduct(int productId) {
    state = state.copyWith(
      shopProducts: state.shopProducts
          .where((product) => product.id != productId)
          .toList(),
    );
  }

  void clearShopProducts() {
    state = state.copyWith(shopProducts: []);
  }

  void setAddress(AddressEntity addressEntity) {
    state = state.copyWith(selAddressEntity: addressEntity);
  }

  void changeAiXinType(int t) {
    state = state.copyWith(aixinType: t);
  }

  void updateTextContent(String text) {
    state = state.copyWith(textContent: text);
  }

  void updateBlogTitle(String title) {
    state = state.copyWith(blogTitle: title);
  }

  void updateRewardAmount(int? amount) {
    state = state.copyWith(aixinType: amount ?? 0);
  }

  Future<void> publishBlog({
    int? squareId,
    String? topicIds,
    int? categary,
    int? blogType,
    String? title,
    String? content,
    String? resources,
    int? addressId,
    String? address,
    int? shareType,
    int? rewardAmount,
  }) async {
    state = state.copyWith(
      isLoading: true,
      isUploading: true,
      error: null,
      publishProgress: 0.04,
      publishStage: 'AI 正在启动发布引擎...',
    );
    try {
      final uploadResult = await _uploadPublishResources();
      var backgroundMusicUrl = await _uploadBackgroundMusicForPublish();
      state = state.copyWith(
        publishProgress: 0.92,
        publishStage: 'AI 正在提交并发布内容...',
      );
      final blogRepo = ref.read(blogRepoProvider);
      final blogContent = content ?? state.textContent;
      final blogTitle = (title ?? state.blogTitle).trim();
      final blogResources = uploadResult.mediaUrls.isNotEmpty
          ? uploadResult.mediaUrls.join(',')
          : resources;
      if ((backgroundMusicUrl == null || backgroundMusicUrl.isEmpty) &&
          blogType == 2 &&
          uploadResult.mediaUrls.isNotEmpty) {
        backgroundMusicUrl = uploadResult.mediaUrls.first;
      }

      final selected = state.selAddressEntity;
      final selectedAddress = address ?? selected?.name;
      final resolvedAddressId = addressId ?? selected?.id;
      final withLocation =
          selected != null && selected.id != 0 && selected.hasGeoCoordinates;

      final collectionIds = blogType == 2 && state.collectionSel.isNotEmpty
          ? state.collectionSel.keys.toList()
          : null;
      Map<int, int>? collectionEpisodes;
      if (collectionIds != null &&
          collectionIds.isNotEmpty &&
          state.collectionEpisode != null) {
        collectionEpisodes = {
          for (final id in collectionIds) id: state.collectionEpisode!,
        };
      }
      final shopProductIds = state.shopProducts.isEmpty
          ? null
          : state.shopProducts
              .map((product) => product.id)
              .whereType<int>()
              .toList();
      final videoMetadata = blogType == 2 && state.videoFiles.isNotEmpty
          ? await _readVideoMetadata(state.videoFiles.first)
          : null;

      final req = BlogSaveReqVO(
        squareId: squareId,
        topicIds: topicIds,
        categary: categary,
        blogType: blogType,
        title: blogTitle.isEmpty ? null : blogTitle,
        content: blogContent,
        resources: blogResources,
        coverUrl: uploadResult.coverUrl,
        videoWidth: videoMetadata?.width,
        videoHeight: videoMetadata?.height,
        videoAspectRatio: videoMetadata?.aspectRatio,
        backgroundMusicUrl: backgroundMusicUrl,
        backgroundMusicName:
            backgroundMusicUrl != null && backgroundMusicUrl.isNotEmpty
            ? (state.backgroundMusicName ??
                  (blogTitle.isEmpty ? '视频原声' : blogTitle))
            : null,
        soundMode: backgroundMusicUrl != null && backgroundMusicUrl.isNotEmpty
            ? (blogType == 2 ? state.soundMode : 2)
            : 1,
        addressId: resolvedAddressId != null && resolvedAddressId != 0
            ? resolvedAddressId
            : null,
        address: selectedAddress != null && selectedAddress.isNotEmpty
            ? selectedAddress
            : null,
        latitude: withLocation ? selected.latitude : null,
        longitude: withLocation ? selected.longitude : null,
        shareType: shareType,
        collectionIds: collectionIds,
        collectionEpisodes: collectionEpisodes,
        shopProductIds: shopProductIds,
      );
      await blogRepo.createBlog(
        req,
        rewardAmount: rewardAmount ?? (categary == 2 ? state.aixinType : null),
      );
      state = state.copyWith(
        isLoading: false,
        isUploading: false,
        publishProgress: 1,
        publishStage: '发布完成',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isUploading: false,
        publishProgress: 0,
        publishStage: '',
        error: e.toString(),
      );
      rethrow;
    }
  }

  void _updatePublishProgress(double progress, String stage) {
    state = state.copyWith(
      publishProgress: progress.clamp(0.0, 0.99),
      publishStage: stage,
    );
  }

  Future<({List<String> mediaUrls, String? coverUrl})>
  _uploadPublishResources() async {
    final mediaUrls = <String>[];

    final coverFile = await _resolveCoverFileForPublishAsync();
    final mediaFiles = state.videoFiles.isNotEmpty
        ? state.videoFiles
        : state.files;
    final uploadCount = (coverFile != null ? 1 : 0) + mediaFiles.length;
    var uploaded = 0;
    String? coverUrl;

    void reportUpload(String label) {
      uploaded++;
      final ratio = uploadCount == 0
          ? 0.85
          : 0.08 + (uploaded / uploadCount) * 0.78;
      _updatePublishProgress(ratio, label);
    }

    _updatePublishProgress(0.08, 'AI 正在分析发布内容...');

    if (coverFile != null) {
      _updatePublishProgress(0.12, 'AI 正在上传视频封面...');
      coverUrl = await ApiBaseClient.uploadFile(file: coverFile);
      state = state.copyWith(uploadedCoverUrl: coverUrl);
      reportUpload('AI 正在上传视频封面...');
    }

    if (state.videoFiles.isNotEmpty) {
      final videoUrls = <String>[];
      for (final file in state.videoFiles) {
        _updatePublishProgress(
          0.12 + (uploaded / math.max(uploadCount, 1)) * 0.78,
          'AI 正在上传视频资源...',
        );
        videoUrls.add(await ApiBaseClient.uploadFile(file: file));
        reportUpload('AI 正在上传视频资源...');
      }
      state = state.copyWith(uploadedVideoUrls: videoUrls);
      mediaUrls.addAll(videoUrls);
      return (
        mediaUrls: mediaUrls,
        coverUrl: coverUrl ?? await _uploadVideoCoverFallback(),
      );
    }

    final imageUrls = <String>[];
    for (final file in state.files) {
      _updatePublishProgress(
        0.12 + (uploaded / math.max(uploadCount, 1)) * 0.78,
        'AI 正在上传图片资源...',
      );
      imageUrls.add(await ApiBaseClient.uploadFile(file: file));
      reportUpload('AI 正在上传图片资源...');
    }
    state = state.copyWith(uploadedFileUrls: imageUrls);
    mediaUrls.addAll(imageUrls);
    final resolvedCoverUrl =
        coverUrl ?? firstStillImageUrlFromResources(imageUrls.join(','));
    return (mediaUrls: mediaUrls, coverUrl: resolvedCoverUrl);
  }

  Future<String?> _uploadBackgroundMusicForPublish() async {
    final musicFile = state.backgroundMusicFile;
    if (musicFile == null) return state.uploadedBackgroundMusicUrl;
    _updatePublishProgress(0.88, 'AI 正在上传背景音乐...');
    final url = await ApiBaseClient.uploadFile(file: musicFile);
    state = state.copyWith(uploadedBackgroundMusicUrl: url);
    return url;
  }

  Future<String?> _uploadVideoCoverFallback() async {
    if (state.videoFiles.isEmpty) return null;
    final coverFile = await _generateVideoCoverXFile(state.videoFiles.first);
    if (coverFile == null) return null;
    _updatePublishProgress(0.12, 'AI 正在上传视频封面...');
    final url = await ApiBaseClient.uploadFile(file: coverFile);
    state = state.copyWith(uploadedCoverUrl: url);
    return url;
  }

  Future<XFile?> _resolveCoverFileForPublishAsync() async {
    if (state.coverFile != null) return state.coverFile;
    final previewBytes = state.coverPreviewBytes;
    if (previewBytes != null && previewBytes.isNotEmpty) {
      return _xFileFromCoverBytes(previewBytes);
    }
    if (state.videoFiles.isNotEmpty && _widgetCoverCapture != null) {
      try {
        final bytes = await _widgetCoverCapture!();
        if (bytes != null && bytes.isNotEmpty) {
          final file = _xFileFromCoverBytes(bytes);
          state = state.copyWith(coverFile: file, coverPreviewBytes: bytes);
          return file;
        }
      } catch (e, st) {
        debugPrint('Capture widget cover before publish failed: $e\n$st');
      }
    }
    if (state.videoFiles.isNotEmpty) {
      return _generateVideoCoverXFile(state.videoFiles.first);
    }
    return null;
  }

  XFile _xFileFromCoverBytes(Uint8List bytes) {
    return xFileFromImageBytes(bytes, baseName: 'video-cover');
  }

  Future<XFile?> _generateVideoCoverXFile(XFile video) async {
    try {
      final durationMs = await _videoDurationMs(video);
      final bytes = await generateStyledVideoCoverBytes(
        videoPath: video.path,
        durationMs: durationMs,
        styleId: state.selectedCoverStyleId,
      );
      return _xFileFromCoverBytes(bytes);
    } catch (e, st) {
      debugPrint('Generate styled video cover failed: $e\n$st');
    }
    try {
      final bytes = await generateVideoCoverBytes(
        videoPath: video.path,
        imageFormat: ImageFormat.JPEG,
      );
      return _xFileFromCoverBytes(bytes);
    } catch (e, st) {
      debugPrint('Generate video cover thumbnail failed: $e\n$st');
      return null;
    }
  }
}

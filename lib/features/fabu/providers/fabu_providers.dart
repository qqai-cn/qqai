import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart';

import '../../../../util/api_base_client.dart';
import '../../data/models/address_entity.dart';
import '../data/repos/fabu_repo.dart';
import '../data/models/fabu_model.dart';
import '../data/models/topic_model.dart';
import '../../blog/data/models/blog_save_req_vo.dart';
import '../../blog/data/repos/blog_repo.dart';
import '../../tool/video_cover_tool.dart';

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
    @Default(1) int selectedCoverStyleId,
    @Default([]) List<AddressEntity> addressList,
    @Default([]) List<SkuuTopicResVO> topicList,
    @Default(['公开', '仅自己可见', '部分好友可见', '部分好友不可见']) List<String> whoCanSee,
    AddressEntity? selAddressEntity,
    @Default(0) int? whoCanSeeSel,
    @Default(0) int aixinType,
    @Default({}) Map<int, String> huatiSel,
    String? error,
    @Default(false) bool isLoading,
    @Default(false) bool isUploading,
    @Default(false) bool isCoverUploading,
    @Default(false) bool isCoverPreviewing,
    @Default('') String textContent,
    @Default(false) bool isLoadingGPS,
  }) = _FabuState;
}

@riverpod
class FabuNotifier extends _$FabuNotifier {
  late final IFabuRepo _repo;
  int? _cachedVideoDurationMs;
  String? _cachedVideoPath;
  int _coverPreviewGeneration = 0;

  @override
  FabuState build() {
    _repo = ref.read(fabuRepoProvider);
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

  Future<void> previewVideoCoverFromVideoTool() async {
    if (state.videoFiles.isEmpty) return;
    final generation = ++_coverPreviewGeneration;
    state = state.copyWith(isCoverPreviewing: true);
    try {
      final video = state.videoFiles.first;
      final durationMs = await _videoDurationMs(video);
      if (generation != _coverPreviewGeneration) return;
      final bytes = await generateStyledVideoCoverBytes(
        videoPath: video.path,
        durationMs: durationMs,
        styleId: state.selectedCoverStyleId,
      );
      if (generation != _coverPreviewGeneration) return;
      state = state.copyWith(coverPreviewBytes: bytes);
    } catch (e) {
      if (generation != _coverPreviewGeneration) return;
      debugPrint('Preview cover error: $e');
      rethrow;
    } finally {
      if (generation == _coverPreviewGeneration) {
        state = state.copyWith(isCoverPreviewing: false);
      }
    }
  }

  void applyVideoCoverPreview() {
    final previewBytes = state.coverPreviewBytes;
    if (previewBytes == null) return;

    state = state.copyWith(
      coverFile: XFile.fromData(
        previewBytes,
        name: 'video-cover.png',
        mimeType: 'image/png',
      ),
      uploadedCoverUrl: null,
    );
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
        controller = VideoPlayerController.networkUrl(
          uri ?? Uri.parse(path),
        );
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
    _resetVideoDurationCache();
    _coverPreviewGeneration++;
    state = state.copyWith(
      videoFiles: [],
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
      state = state.copyWith(
        files: newFiles,
        uploadedFileUrls: [],
      );
    }
  }

  Future<void> addVideoFiles(List<XFile> videoFiles) async {
    _resetVideoDurationCache();
    _coverPreviewGeneration++;
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
    if (newVideoFiles.isNotEmpty) {
      unawaited(_videoDurationMs(newVideoFiles.first));
    }
  }

  void setWhoCanSee(int who) {
    state = state.copyWith(whoCanSeeSel: who);
  }

  void setHuati(Map<int, String> huati) {
    state = state.copyWith(huatiSel: huati);
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

  void updateRewardAmount(int? amount) {
    state = state.copyWith(aixinType: amount ?? 0);
  }

  Future<void> publishBlog({
    int? squareId,
    String? topicIds,
    int? categary,
    int? blogType,
    String? content,
    String? resources,
    int? addressId,
    String? address,
    int? shareType,
    int? rewardAmount,
  }) async {
    state = state.copyWith(isLoading: true, isUploading: true, error: null);
    try {
      final resourceUrls = await _uploadPublishResources();
      final blogRepo = ref.read(blogRepoProvider);
      final blogContent = content ?? state.textContent;
      final blogResources =
          resourceUrls.isNotEmpty ? resourceUrls.join(',') : resources;

      final selected = state.selAddressEntity;
      final selectedAddress = address ?? selected?.name;
      final resolvedAddressId = addressId ?? selected?.id;
      final withLocation =
          selected != null && selected.id != 0 && selected.hasGeoCoordinates;

      final req = BlogSaveReqVO(
        squareId: squareId,
        topicIds: topicIds,
        categary: categary,
        blogType: blogType,
        content: blogContent,
        resources: blogResources,
        addressId: resolvedAddressId != null && resolvedAddressId != 0
            ? resolvedAddressId
            : null,
        address: selectedAddress != null && selectedAddress.isNotEmpty
            ? selectedAddress
            : null,
        latitude: withLocation ? selected.latitude : null,
        longitude: withLocation ? selected.longitude : null,
        shareType: shareType,
      );
      await blogRepo.createBlog(
        req,
        rewardAmount: rewardAmount ?? (categary == 2 ? state.aixinType : null),
      );
      state = state.copyWith(isLoading: false, isUploading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isUploading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<List<String>> _uploadPublishResources() async {
    final resourceUrls = <String>[];

    final coverFile = _resolveCoverFileForPublish();
    if (coverFile != null) {
      final coverUrl = await ApiBaseClient.uploadFile(file: coverFile);
      resourceUrls.add(coverUrl);
      state = state.copyWith(uploadedCoverUrl: coverUrl);
    }

    if (state.videoFiles.isNotEmpty) {
      final videoUrls = <String>[];
      for (final file in state.videoFiles) {
        videoUrls.add(await ApiBaseClient.uploadFile(file: file));
      }
      state = state.copyWith(uploadedVideoUrls: videoUrls);
      resourceUrls.addAll(videoUrls);
      return resourceUrls;
    }

    final imageUrls = <String>[];
    for (final file in state.files) {
      imageUrls.add(await ApiBaseClient.uploadFile(file: file));
    }
    state = state.copyWith(uploadedFileUrls: imageUrls);
    resourceUrls.addAll(imageUrls);
    return resourceUrls;
  }

  XFile? _resolveCoverFileForPublish() {
    if (state.coverFile != null) return state.coverFile;
    final previewBytes = state.coverPreviewBytes;
    if (previewBytes == null) return null;
    return XFile.fromData(
      previewBytes,
      name: 'video-cover.png',
      mimeType: 'image/png',
    );
  }
}

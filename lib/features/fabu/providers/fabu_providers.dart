import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../util/api_base_client.dart';
import '../../data/models/address_entity.dart';
import '../data/repos/fabu_repo.dart';
import '../data/models/fabu_model.dart';
import '../data/models/topic_model.dart';
import '../data/models/qqai_weather_city_model.dart';
import '../../blog/data/models/blog_save_req_vo.dart';
import '../../blog/data/repos/blog_repo.dart';

part 'fabu_providers.freezed.dart';

part 'fabu_providers.g.dart';

@freezed
sealed class FabuState with _$FabuState {
  const factory FabuState({
    // freezed 的 @Default 必须是 const
    @Default(const AsyncLoading()) AsyncValue<List<FabuModel>> items,
    @Default([]) List<XFile> files,
    @Default([]) List<XFile> videoFiles,
    @Default([]) List<String> uploadedFileUrls,
    @Default([]) List<String> uploadedVideoUrls,
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
    @Default('') String textContent,
    @Default(false) bool isLoadingGPS,
  }) = _FabuState;
}

@riverpod
class FabuNotifier extends _$FabuNotifier {
  late final IFabuRepo _repo;

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

  Future<void> uploadFiles(List<XFile> files, bool isVideo) async {
    if (files.isEmpty) return;
    
    state = state.copyWith(isUploading: true);
    
    try {
      List<String> newUrls = [];
      for (var file in files) {
        final url = await ApiBaseClient.uploadFile(file: file);
        newUrls.add(url);
      }
      
      if (isVideo) {
        final updatedUrls = List<String>.from(state.uploadedVideoUrls)..addAll(newUrls);
        state = state.copyWith(uploadedVideoUrls: updatedUrls);
      } else {
        final updatedUrls = List<String>.from(state.uploadedFileUrls)..addAll(newUrls);
        state = state.copyWith(uploadedFileUrls: updatedUrls);
      }
    } catch (e) {
      print('Upload error: $e');
    } finally {
      state = state.copyWith(isUploading: false);
    }
  }

  void clearList(XFile file) {
    final fileIndex = state.files.indexOf(file);
    final newFiles = List<XFile>.from(state.files)..remove(file);
    
    // Also remove the corresponding uploaded URL
    final newUrls = List<String>.from(state.uploadedFileUrls);
    if (fileIndex >= 0 && fileIndex < newUrls.length) {
      newUrls.removeAt(fileIndex);
    }
    
    state = state.copyWith(
      files: newFiles, 
      uploadedFileUrls: newUrls,
      videoFiles: [],
      uploadedVideoUrls: []
    );
  }

  void clearVideo() {
    state = state.copyWith(
      videoFiles: [],
      uploadedVideoUrls: []
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
      state = state.copyWith(files: newFiles);
      // Upload immediately
      await uploadFiles(value, false);
    }
  }

  Future<void> addVideoFiles(List<XFile> videoFiles) async {
    final newVideoFiles = List<XFile>.from(state.videoFiles)
      ..addAll(videoFiles);
    state = state.copyWith(videoFiles: newVideoFiles);
    // Upload immediately
    await uploadFiles(videoFiles, true);
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
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final blogRepo = ref.read(blogRepoProvider);
      final blogContent = content ?? state.textContent;
      
      // Collect already uploaded URLs
      List<String> allUrls = [];
      allUrls.addAll(state.uploadedFileUrls);
      allUrls.addAll(state.uploadedVideoUrls);
      
      // Join urls with commas
      final blogResources = allUrls.isNotEmpty 
          ? allUrls.join(',') 
          : resources;
      
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
      await blogRepo.createBlog(req);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}

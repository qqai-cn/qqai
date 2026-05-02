import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/address_entity.dart';
import '../data/repos/fabu_repo.dart';
import '../data/models/fabu_model.dart';
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
    @Default([]) List<AddressEntity> addressList,
    @Default([]) List<String> whoCanSee,
    AddressEntity? selAddressEntity,
    @Default(0) int? whoCanSeeSel,
    @Default(0) int aixinType,
    @Default({}) Map<int, String> huatiSel,
    String? error,
    @Default(false) bool isLoading,
    @Default('') String textContent,
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

  void clearList(XFile file) {
    final newFiles = List<XFile>.from(state.files)..remove(file);
    state = state.copyWith(files: newFiles, videoFiles: []);
  }

  void clearVideo() {
    state = state.copyWith(videoFiles: []);
  }

  void selectFile(List<XFile> value, BuildContext context) {
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
    }
  }

  void addVideoFiles(List<XFile> videoFiles) {
    final newVideoFiles = List<XFile>.from(state.videoFiles)
      ..addAll(videoFiles);
    state = state.copyWith(videoFiles: newVideoFiles);
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
    int? shareType,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final blogRepo = ref.read(blogRepoProvider);
      // Use provided content if available, otherwise use state.textContent
      final blogContent = content ?? state.textContent;
      // For now, we'll just pass resources as is—you might want to process files/videos here
      final blogResources = resources;
      final req = BlogSaveReqVO(
        squareId: squareId,
        topicIds: topicIds,
        categary: categary,
        blogType: blogType,
        content: blogContent,
        resources: blogResources,
        addressId: addressId,
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

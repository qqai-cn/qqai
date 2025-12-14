import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_selector/file_selector.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/address_entity.dart';
import '../../../data/models/skuu_blog_save_entity.dart';
import '../../data/fabu_dynamic_repo.dart';
import '../../../../../util/api_call_status.dart';
import '../../../../../constant/api_constant.dart';

part 'fabu_dynamic_providers.freezed.dart';
part 'fabu_dynamic_providers.g.dart';

// FabuDynamicRepo Provider - 使用 Riverpod 3 代码生成
@riverpod
FabuDynamicRepo fabuDynamicRepo(Ref ref) {
  return FabuDynamicRepo();
}

// FabuDynamicController 状态 - 使用 Freezed
@freezed
sealed class FabuDynamicState with _$FabuDynamicState {
  const factory FabuDynamicState({
    @Default(ApiCallStatus.holding) ApiCallStatus apiCallStatus,
    required TextEditingController publishController,
    @Default([]) List<XFile> files,
    @Default([]) List<XFile> videoFiles,
    @Default([]) List<AddressEntity> addressList,
    @Default([]) List<String> whoCanSee,
    AddressEntity? selAddressEntity,
    @Default(0) int? whoCanSeeSel,
    @Default({}) Map<int, String> huatiSel,
    int? blogType,
  }) = _FabuDynamicState;
  
  // 工厂构造函数用于初始化
  factory FabuDynamicState.initial() => FabuDynamicState(
    publishController: TextEditingController(),
    whoCanSee: const ['公开', '私密', '仅好友可看'],
  );
}

// FabuDynamicController Provider - 使用 Riverpod 3 代码生成（autoDispose）
@Riverpod(keepAlive: false)
class FabuDynamicNotifier extends _$FabuDynamicNotifier {
  @override
  FabuDynamicState build() {
    final state = FabuDynamicState.initial();
    ref.onDispose(() {
      state.publishController.dispose();
    });
    // 初始化后加载数据
    Future.microtask(() => loadAddressData());
    return state;
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
    state = state.copyWith(
      files: newFiles,
      videoFiles: [],
    );
  }

  void clearVideo() {
    state = state.copyWith(videoFiles: []);
  }

  void selectFile(List<XFile> value, BuildContext context) {
    final allEmpty = state.files.isNotEmpty && state.videoFiles.isNotEmpty;
    if (allEmpty) {
      clearVideo();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        desc: '请上传图片',
        btnOkOnPress: () {},
      )..show();
      return;
    }
    if (state.files.length + value.length > 6) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        desc: '图片超出最大限制：6个',
        btnOkOnPress: () {},
      )..show();
      return;
    }
    if (value.isNotEmpty) {
      final newFiles = List<XFile>.from(state.files)..addAll(value);
      state = state.copyWith(files: newFiles);
    }
  }

  void addVideoFiles(List<XFile> videoFiles) {
    final newVideoFiles = List<XFile>.from(state.videoFiles)..addAll(videoFiles);
    state = state.copyWith(videoFiles: newVideoFiles);
  }

  Future<void> fabu() async {
    final saveEntity = SkuuBlogSaveEntity();
    final blogType = state.videoFiles.isEmpty ? 2 : 1;
    final resources = <String>[];
    final resourcesAll = <XFile>[];
    resourcesAll.addAll(state.files);
    resourcesAll.addAll(state.videoFiles);
    
    // TODO: 处理文件上传，将文件转换为资源字符串
    // resourcesAll.forEach((XFile xFile) => {
    //   // 上传文件并获取资源URL
    // });
    
    saveEntity.resources = resources.join(",");
    saveEntity.content = state.publishController.text;
    saveEntity.blogType = blogType;
    saveEntity.addressId = state.selAddressEntity?.id ?? 0;
    saveEntity.categary = 1;
    saveEntity.shareType = state.whoCanSeeSel!;
    saveEntity.squareId = 1;
    saveEntity.topicIds = state.huatiSel.keys.join(",");

    try {
      state = state.copyWith(apiCallStatus: ApiCallStatus.loading);
      final repo = ref.read(fabuDynamicRepoProvider);
      await repo.saveBlog(saveEntity);
      state = state.copyWith(apiCallStatus: ApiCallStatus.success);
    } catch (e) {
      state = state.copyWith(apiCallStatus: ApiCallStatus.error);
    }
  }

  // dispose 已通过 ref.onDispose 在 build 中设置
}

// Provider 已通过代码生成自动创建为 fabuDynamicNotifierProvider


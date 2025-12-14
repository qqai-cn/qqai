import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_selector/file_selector.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/address_entity.dart';


part 'fabu_video_providers.freezed.dart';
part 'fabu_video_providers.g.dart';

// FabuVideoController 状态 - 使用 Freezed
@freezed
sealed class FabuVideoState with _$FabuVideoState {
  const factory FabuVideoState({
    required TextEditingController titleController,
    required TextEditingController contentController,
    @Default([]) List<XFile> files,
    @Default([]) List<XFile> videoFiles,
    @Default([]) List<AddressEntity> addressList,
    @Default([]) List<String> whoCanSee,
    AddressEntity? selAddressEntity,
    String? whoCanSeeSel,
    @Default({}) Map<int, String> huatiSel,
  }) = _FabuVideoState;
  
  // 工厂构造函数用于初始化
  factory FabuVideoState.initial() => FabuVideoState(
    titleController: TextEditingController(),
    contentController: TextEditingController(),
    whoCanSee: const ['公开', '私密', '仅好友可看'],
  );
}

// FabuVideoController Provider - 使用 Riverpod 3 代码生成（autoDispose）
@Riverpod(keepAlive: false)
class FabuVideoNotifier extends _$FabuVideoNotifier {
  @override
  FabuVideoState build() {
    final state = FabuVideoState.initial();
    ref.onDispose(() {
      state.titleController.dispose();
      state.contentController.dispose();
    });
    // 初始化后加载数据
    Future.microtask(() => loadAddressData());
    return state;
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
    if (state.files.length + value.length > 20) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        desc: '图片超出最大限制：20',
        btnOkOnPress: () {},
      )..show();
      return;
    }
    if (value.isNotEmpty) {
      final newFiles = List<XFile>.from(state.files)..addAll(value);
      state = state.copyWith(files: newFiles);
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

  void setWhoCanSee(String who) {
    state = state.copyWith(whoCanSeeSel: who);
  }

  void setHuati(Map<int, String> huati) {
    state = state.copyWith(huatiSel: huati);
  }

  void setAddress(AddressEntity addressEntity) {
    state = state.copyWith(selAddressEntity: addressEntity);
  }

  void addVideoFiles(List<XFile> videoFiles) {
    final newVideoFiles = List<XFile>.from(state.videoFiles)..addAll(videoFiles);
    state = state.copyWith(videoFiles: newVideoFiles);
  }

  // dispose 已通过 ref.onDispose 在 build 中设置
}

// Provider 已通过代码生成自动创建为 fabuVideoNotifierProvider


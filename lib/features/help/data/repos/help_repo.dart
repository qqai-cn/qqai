import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/constant/api_constant.dart';
import 'package:qqai/util/api_base_client.dart';

import '../models/help_model.dart';
import '../models/help_page_model.dart';

// Repo Provider（按 blog 的格式：Provider 放在 repo 文件里）
final helpRepoProvider = Provider<IHelpRepo>((ref) => HelpRepo());

abstract class IHelpRepo {
  Future<List<HelpModel>> getAllHelps();

  Future<HelpModel?> getHelpById(String id);

  Future<void> addHelp(HelpModel item);

  Future<void> updateHelp(HelpModel item);

  Future<void> deleteHelp(String id);

  Future<HelpPageModelData> getHelpPageModelData(String id);
}

class HelpRepo implements IHelpRepo {
  final List<HelpModel> _items = [];

  @override
  Future<List<HelpModel>> getAllHelps() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<HelpModel?> getHelpById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addHelp(HelpModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> updateHelp(HelpModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> deleteHelp(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<HelpPageModelData> getHelpPageModelData(String id) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_PAGE,
      RequestType.get,
    );
    return HelpPageModel.fromJson(response.data).data!;
  }
}

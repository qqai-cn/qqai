import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../models/share_model.dart';
import '../models/share_page_model.dart';

// Repo Provider（按 blog 的格式：Provider 放在 repo 文件里）
final shareRepoProvider = Provider<IShareRepo>((ref) => ShareRepo());

abstract class IShareRepo {
  Future<List<ShareModel>> getAllShares();

  Future<ShareModel?> getShareById(String id);

  Future<void> addShare(ShareModel item);

  Future<void> updateShare(ShareModel item);

  Future<void> deleteShare(String id);

  Future<SharePageModelData> getSharePageModel(String id);
}

class ShareRepo implements IShareRepo {
  final List<ShareModel> _items = [];

  @override
  Future<List<ShareModel>> getAllShares() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<ShareModel?> getShareById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addShare(ShareModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> updateShare(ShareModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> deleteShare(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<SharePageModelData> getSharePageModel(String id) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_PAGE,
      RequestType.get,
    );
    return SharePageModel.fromJson(response.data).data!;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../models/fabu_model.dart';
import '../models/topic_model.dart';
import '../models/qqai_weather_city_model.dart';

// Repo Provider（按 blog 的格式：Provider 放在 repo 文件里）
final fabuRepoProvider = Provider<IFabuRepo>(
  (ref) => FabuRepo(),
);

abstract class IFabuRepo {
  Future<List<FabuModel>> getAllFabus();
  Future<FabuModel?> getFabuById(String id);
  Future<void> addFabu(FabuModel item);
  Future<void> updateFabu(FabuModel item);
  Future<void> deleteFabu(String id);
  Future<List<SkuuTopicResVO>> getTopicList(int pageNo, int pageSize);
  Future<QqaiWeatherCityResVO?> getWeatherCityByGPS(String? lat, String? lon);
}

class FabuRepo implements IFabuRepo {
  final List<FabuModel> _items = [];

  @override
  Future<List<FabuModel>> getAllFabus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<FabuModel?> getFabuById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addFabu(FabuModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> updateFabu(FabuModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> deleteFabu(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<List<SkuuTopicResVO>> getTopicList(int pageNo, int pageSize) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.TOPIC_PAGE,
      RequestType.get,
      queryParameters: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    final result = TopicPageResponse.fromJson(response.data);
    return result.data?.list ?? [];
  }

  @override
  Future<QqaiWeatherCityResVO?> getWeatherCityByGPS(String? lat, String? lon) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.getByGPS,
      RequestType.get,
      queryParameters: {
        if (lat != null) 'lat': lat,
        if (lon != null) 'lon': lon,
      },
    );
    if (response.data['code'] == 0 && response.data['data'] != null) {
      return QqaiWeatherCityResVO.fromJson(response.data['data']);
    }
    return null;
  }
}

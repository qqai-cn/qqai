import 'package:dio/dio.dart';
import '../../data/models/city_model_entity.dart';
import '../../data/models/day_weather_entity.dart';
import '../../data/models/hour_weather_entity.dart';
import '../../data/models/indices_weather_entity.dart';
import '../../data/models/real_time_weather_entity.dart';
import '../../data/models/weather_city_entity.dart';
import 'package:qqai/constant/api_constant.dart';
import 'package:qqai/constant/api_constant2.dart';

class WeatherRepo {
  WeatherRepo({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: ApiConstant.BASE_URL,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  final Dio _dio;

  /// 获取城市列表
  Future<WeatherCityEntity> getCityList() async {
    try {
      final response = await _dio.get(ApiConstant.WEATHER_USER_CITY_LIST);
      return WeatherCityEntity.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get city list: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// 获取实时天气
  Future<RealTimeWeatherEntity> getRealTimeWeather(double lat, double lon) async {
    try {
      String latStr = lat.toStringAsFixed(2);
      String lonStr = lon.toStringAsFixed(2);
      String data = '?location=$lonStr,$latStr';
      String url = ApiConstant2.HE_FENG_BASE_API + ApiConstant2.REALTIME_WEATHER + data;
      
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'X-QW-Api-Key': ApiConstant2.API_KEY,
          },
        ),
      );
      return RealTimeWeatherEntity.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get real-time weather: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// 通过 GPS 获取城市
  Future<CityModelEntity> getCityByGPS(double lat, double lon) async {
    try {
      String data = '?lat=$lat&lon=$lon';
      String url = ApiConstant.getByGPS + data;
      
      final response = await _dio.get(url);
      return CityModelEntity.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get city by GPS: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// 获取小时天气
  Future<HourWeatherEntity> getHourWeather(String cityId) async {
    try {
      String url = ApiConstant2.HOUR_WEATHER + '?location=$cityId';
      
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'X-QW-Api-Key': ApiConstant2.API_KEY,
          },
        ),
      );
      return HourWeatherEntity.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get hour weather: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// 获取每日天气
  Future<DayWeatherEntity> getDayWeather(String cityId) async {
    try {
      String url = ApiConstant2.DAY_WEATHER + '?location=$cityId';
      
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'X-QW-Api-Key': ApiConstant2.API_KEY,
          },
        ),
      );
      return DayWeatherEntity.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get day weather: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// 获取天气指数
  Future<IndicesWeatherEntity> getDayIndices(String cityId) async {
    try {
      String url = ApiConstant2.DAY_INDICES + '?type=0&location=$cityId';
      
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'X-QW-Api-Key': ApiConstant2.API_KEY,
          },
        ),
      );
      return IndicesWeatherEntity.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get day indices: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}


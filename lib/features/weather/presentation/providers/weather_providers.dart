import 'dart:async';
import 'dart:convert';

import 'package:city_pickers/modal/result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/city_model_entity.dart';
import '../../../data/models/day_weather_entity.dart';
import '../../../data/models/hour_weather_entity.dart';
import '../../../data/models/indices_weather_entity.dart';
import '../../../data/models/real_time_weather_entity.dart';
import '../../../data/models/weather_city_entity.dart';
import '../../data/weather_repo.dart';
import '../../../../router/app_routes.dart';
import '../../../../util/api_call_status.dart';
import '../../../../constant/api_constant.dart';
import '../../../../constant/api_constant2.dart';

part 'weather_providers.freezed.dart';
part 'weather_providers.g.dart';

// WeatherRepo Provider - 使用 Riverpod 3 代码生成
@riverpod
WeatherRepo weatherRepo(Ref ref) {
  return WeatherRepo();
}

// WeatherController 状态 - 使用 Freezed
@freezed
sealed class WeatherState with _$WeatherState {
  const factory WeatherState({
    @Default(ApiCallStatus.holding) ApiCallStatus apiCallStatus,
    dynamic locationState,
    @Default(-1) int currentPage,
    Position? curPosition,
    CityModelEntity? curCity,
    RealTimeWeatherEntity? realTimeWeather,
    @Default([]) List<CityModelLocation> citys,
    @Default([]) List<RealTimeWeatherEntity> realTimeWeathers,
    @Default([]) List<Map> weatherMaps,
    @Default(false) bool ifOnHour,
    Result? selCity,
    required TextEditingController textEditingController,
    @Default([]) List<WeatherCityData> weatherCitys,
    @Default([]) List<RealTimeWeatherEntity> leftWeathers,
    @Default([]) List<DayWeatherDaily> leftTodayDaily,
    @Default([]) List<Map<String, String>> card1,
    @Default([]) List<HourWeatherHourly> hourly,
    @Default([]) List<DayWeatherDaily> daily,
    @Default({}) Map<int, String> minMaxTemp,
    @Default([]) List<IndicesWeatherDaily> indicesDaily,
    required ScrollController hourController,
    @Default(false) bool showToTopBtn,
  }) = _WeatherState;
  
  // 工厂构造函数用于初始化
  factory WeatherState.initial() => WeatherState(
    textEditingController: TextEditingController(),
    hourController: ScrollController(),
  );
}

// WeatherController Provider - 使用 Riverpod 3 代码生成
@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  WeatherState build() {
    final state = WeatherState.initial();
    ref.onDispose(() {
      _positionStreamSubscription?.cancel();
      state.textEditingController.dispose();
      state.hourController.dispose();
    });
    // 初始化后加载数据
    Future.microtask(() => _init());
    return state;
  }

  Future<void> _init() async {
    await initLeft();
  }

  Future<void> initLeft() async {
    await getCityList();
    await initLeftWeather();
    await changeIndexLeft(0);
  }

  Future<void> getCityList() async {
    try {
      state = state.copyWith(apiCallStatus: ApiCallStatus.loading);
      final repo = ref.read(weatherRepoProvider);
      final weatherCityEntity = await repo.getCityList();
      state = state.copyWith(
        weatherCitys: weatherCityEntity.data ?? [],
        apiCallStatus: ApiCallStatus.success,
      );
    } catch (e) {
      state = state.copyWith(apiCallStatus: ApiCallStatus.error);
    }
  }

  Future<void> initLeftWeather() async {
    final newLeftWeathers = <RealTimeWeatherEntity>[];
    final newLeftTodayDaily = <DayWeatherDaily>[];
    final newCard1 = <Map<String, String>>[];
    final newWeatherMaps = <Map>[];

    try {
      state = state.copyWith(apiCallStatus: ApiCallStatus.loading);
      final repo = ref.read(weatherRepoProvider);
      
      for (WeatherCityData value in state.weatherCitys) {
        try {
          final realTimeWeatherEntity = await repo.getRealTimeWeather(value.lat, value.lon);
          realTimeWeatherEntity.now.weatherType = transWeatherType(realTimeWeatherEntity);
          newLeftWeathers.add(realTimeWeatherEntity);
          final map = _setWeatherMap(realTimeWeatherEntity.now);
          newCard1.add(map);
          newWeatherMaps.add(map);

          try {
            final dayWeather = await repo.getDayWeather(value.id);
            newLeftTodayDaily.add(
              dayWeather.daily.isNotEmpty
                  ? dayWeather.daily.first
                  : DayWeatherDaily(),
            );
          } catch (_) {
            newLeftTodayDaily.add(DayWeatherDaily());
          }
        } catch (e) {
          // 单个城市失败不影响其他城市
          print('Failed to get weather for city ${value.city}: $e');
        }
      }
      
      // 更新所有数据
      state = state.copyWith(
        apiCallStatus: ApiCallStatus.success,
        leftWeathers: newLeftWeathers,
        leftTodayDaily: newLeftTodayDaily,
        card1: newCard1,
        weatherMaps: newWeatherMaps,
      );
    } catch (e) {
      state = state.copyWith(apiCallStatus: ApiCallStatus.error);
    }
  }

  WeatherCityData getCurWeatherCityData() {
    if (state.currentPage >= 0 && state.currentPage < state.weatherCitys.length) {
      return state.weatherCitys[state.currentPage];
    }
    return state.weatherCitys.isNotEmpty ? state.weatherCitys[0] : WeatherCityData();
  }

  Map<String, String> getCurCard1() {
    if (state.currentPage >= 0 && state.currentPage < state.card1.length) {
      return state.card1[state.currentPage];
    }
    return {};
  }

  RealTimeWeatherEntity getCurRealTimeWeather() {
    if (state.currentPage >= 0 && state.currentPage < state.leftWeathers.length) {
      return state.leftWeathers[state.currentPage];
    }
    return state.leftWeathers.isNotEmpty ? state.leftWeathers[0] : RealTimeWeatherEntity();
  }

  void updateSelCity(Result selCity) {
    state.textEditingController.text = selCity.provinceName! +
        '-' +
        selCity.cityName! +
        '-' +
        selCity.areaName!;
    state = state.copyWith(selCity: selCity);
  }

  void changeHour() {
    state = state.copyWith(ifOnHour: !state.ifOnHour);
  }

  void changeIndexRight(int n) {
    state = state.copyWith(currentPage: n);
  }

  String getWeatherKey(int index, int index1) {
    if (index >= 0 && index < state.weatherMaps.length) {
      return state.weatherMaps[index].keys.toList()[index1];
    }
    return '';
  }

  String getWeatherValue(int index, int index1) {
    String key = getWeatherKey(index, index1);
    if (index >= 0 && index < state.weatherMaps.length) {
      return state.weatherMaps[index][key] ?? '';
    }
    return '';
  }

  Future<void> changeIndexLeft1(int n) async {
    state = state.copyWith(currentPage: n);
    await getCard2(n);
    await getCard3(n);
    await getCard4(n);
  }

  Future<void> changeIndexLeft(int n) async {
    if (state.currentPage == n) {
      return;
    }
    state = state.copyWith(currentPage: n);
    await getCard2(n);
    await getCard3(n);
    await getCard4(n);
  }

  Future<void> loadAddressData() async {
    try {
      await rootBundle.loadString('mock/weather_city.json').then((value) {
        final Map<String, dynamic> jsonData = jsonDecode(value);
        final citys = CityModelEntity.fromJson(jsonData).data;
        state = state.copyWith(citys: citys);
      });
    } catch (e) {
      print('Error loading mock city data: $e');
    }
  }

  double getMaxTemp() {
    String? value = state.minMaxTemp[state.currentPage];
    if (value == null) return 0.0;
    List<String> vals = value.split(",");
    return double.parse(vals[1]);
  }

  double getMinTemp() {
    String? value = state.minMaxTemp[state.currentPage];
    if (value == null) return 0.0;
    List<String> vals = value.split(",");
    return double.parse(vals[0]);
  }

  void toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => _updatePositionList(position));
      _positionStreamSubscription?.pause();
    }

    if (_positionStreamSubscription == null) {
      return;
    }
    if (_positionStreamSubscription!.isPaused) {
      _positionStreamSubscription!.resume();
    } else {
      _positionStreamSubscription!.pause();
    }
  }

  void _updatePositionList(Position posi) {
    state = state.copyWith(curPosition: posi);
    print('Listening1 for position updates $posi');
  }

  Future<void> _updateRealTimeWeatherMock(double lat, double lon) async {
    await rootBundle.loadString('mock/realtime_weather.json').then((value) {
      final Map<String, dynamic> jsonData = jsonDecode(value);
      RealTimeWeatherEntity realTimeWeatherEntity =
          RealTimeWeatherEntity.fromJson(jsonData);
      realTimeWeatherEntity.now.weatherType =
          transWeatherType(realTimeWeatherEntity);
      final newRealTimeWeathers = List<RealTimeWeatherEntity>.from(state.realTimeWeathers);
      newRealTimeWeathers.add(realTimeWeatherEntity);
      final map = _setWeatherMap(realTimeWeatherEntity.now);
      final newWeatherMaps = List<Map>.from(state.weatherMaps);
      newWeatherMaps.add(map);
      state = state.copyWith(
        realTimeWeathers: newRealTimeWeathers,
        weatherMaps: newWeatherMaps,
      );
    });
  }

  Map<String, String> _setWeatherMap(RealTimeWeatherNow now) {
    var format2 = DateFormat('HH:mm:ss');
    DateTime dateTime = DateTime.parse(now.obsTime);
    Map<String, String> map = {};
    map["观察时间"] = format2.format(dateTime.toLocal());
    map[now.windDir] = now.windScale + "级";
    map["相对湿度"] = now.humidity + '%';
    map["能见度"] = now.vis + '公里';
    map["1小时降水量"] = now.precip + '毫米';
    map["大气压强"] = now.pressure + 'hPa';
    return map;
  }

  WeatherType transWeatherType(RealTimeWeatherEntity realTimeWeatherEntity) {
    String text = realTimeWeatherEntity.now.text;
    if (text.contains('云')) {
      return WeatherType.cloudy;
    } else if (text.contains('雨')) {
      return WeatherType.heavyRainy;
    } else if (text.contains('雪')) {
      return WeatherType.heavySnow;
    } else if (text.contains('雷')) {
      return WeatherType.thunder;
    } else if (text.contains('霾')) {
      return WeatherType.hazy;
    } else if (text.contains('雾')) {
      return WeatherType.foggy;
    } else {
      return WeatherType.sunny;
    }
  }

  Future<void> getCurCity(double lat, double lon) async {
    try {
      final repo = ref.read(weatherRepoProvider);
      final curCity = await repo.getCityByGPS(lat, lon);
      state = state.copyWith(curCity: curCity);
      print('Current city: ${curCity}');
    } catch (e) {
      print('Failed to get current city: $e');
    }
  }

  Future<void> getCard2(int n) async {
    if (n < 0 || n >= state.weatherCitys.length) return;
    
    try {
      final repo = ref.read(weatherRepoProvider);
      final hourWeatherEntity = await repo.getHourWeather(state.weatherCitys[n].id);
      final newHourly = List<HourWeatherHourly>.from(hourWeatherEntity.hourly);
      newHourly.forEach((a) {
        var format2 = DateFormat('HH');
        DateTime dateTime = DateTime.parse(a.fxTime);
        String time = format2.format(dateTime.toLocal());
        a.fxTime = time + '时';
      });
      state = state.copyWith(
        hourly: newHourly,
        apiCallStatus: ApiCallStatus.success,
      );
    } catch (e) {
      state = state.copyWith(apiCallStatus: ApiCallStatus.error);
    }
  }

  Future<void> getCard3(int n) async {
    if (n < 0 || n >= state.weatherCitys.length) return;
    
    try {
      final repo = ref.read(weatherRepoProvider);
      final dayWeatherEntity = await repo.getDayWeather(state.weatherCitys[n].id);
      final newDaily = List<DayWeatherDaily>.from(dayWeatherEntity.daily);
      double min = 100;
      double max = 0;
      newDaily.forEach((a) {
        const weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
        var format2 = DateFormat('yyyy-MM-dd');
        DateTime dateTime = DateTime.parse(a.fxDate);
        int weekIndex = dateTime.toLocal().weekday;
        a.fxDate = weekdays[weekIndex - 1];
        if (double.parse(a.tempMin) < min) {
          min = double.parse(a.tempMin);
        }
        if (double.parse(a.tempMax) > max) {
          max = double.parse(a.tempMax);
        }
      });
      final newMinMaxTemp = Map<int, String>.from(state.minMaxTemp);
      newMinMaxTemp[n] = '$min,$max';
      state = state.copyWith(
        daily: newDaily,
        minMaxTemp: newMinMaxTemp,
        apiCallStatus: ApiCallStatus.success,
      );
    } catch (e) {
      state = state.copyWith(apiCallStatus: ApiCallStatus.error);
    }
  }

  Future<void> getCard4(int n) async {
    if (n < 0 || n >= state.weatherCitys.length) return;
    
    try {
      final repo = ref.read(weatherRepoProvider);
      final indicesWeatherEntity = await repo.getDayIndices(state.weatherCitys[n].id);
      state = state.copyWith(
        indicesDaily: indicesWeatherEntity.daily,
        apiCallStatus: ApiCallStatus.success,
      );
    } catch (e) {
      state = state.copyWith(apiCallStatus: ApiCallStatus.error);
    }
  }

  Future<void> getRealTimeWeather() async {
    final bool hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }
    final Position position = await _geolocatorPlatform.getCurrentPosition();
    await getCurCity(position.latitude, position.longitude);
    
    for (CityModelLocation city in state.citys) {
      await _updateRealTimeWeatherMock(
          double.parse(city.lat), double.parse(city.lon));
    }

    print('realTimeWeathers,${state.realTimeWeathers}');
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // dispose 已通过 ref.onDispose 在 build 中设置
}

// Provider 已通过代码生成自动创建为 weatherNotifierProvider


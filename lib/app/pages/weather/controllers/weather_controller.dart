import 'dart:async';
import 'dart:convert';

import 'package:city_pickers/modal/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:geolocator_web/geolocator_web.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qqai/app/data/models/day_weather_entity.dart';
import 'package:qqai/app/data/models/weather_city_entity.dart';
import 'package:qqai/app/pages/weather/views/perday_weather_view.dart';
import 'package:qqai/app/services/base_client.dart';
import 'package:qqai/constant/api_constant2.dart';

import '../../../../constant/api_constant.dart';
import '../../../data/models/city_model_entity.dart';
import '../../../data/models/hour_weather_entity.dart';
import '../../../data/models/indices_weather_entity.dart';
import '../../../data/models/real_time_weather_entity.dart';
import '../../../services/api_call_status.dart';
import '../views/perhour_weather_view.dart';

class WeatherController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  var locationState;
  int currentPage = -1;

  static const String _locationServicesDisabledMessage =
      'data services are disabled.';
  static const String _permissionDeniedMessage = 'Permission denied.';
  static const String _permissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _permissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  late Position curPosition;
  late CityModelEntity curCity;

  StreamSubscription<Position>? _positionStreamSubscription;
  late RealTimeWeatherEntity realTimeWeather;
  var citys = <CityModelLocation>[];
  var realTimeWeathers = <RealTimeWeatherEntity>[];
  var weatherMaps = <Map>[];
  bool ifOnHour = false;
  late Result selCity;
  late TextEditingController textEditingController;

  late List<WeatherCityData> weatherCitys = [];
  late List<RealTimeWeatherEntity> leftWeathers = [];
  late List<Map<String, String>> card1 = [];
  late List<HourWeatherHourly> hourly = [];
  late List<DayWeatherDaily> daily = [];
  late Map<int, String> minMaxTemp = {};
  late List<IndicesWeatherDaily> indicesDaily = [];

  ScrollController hourController = ScrollController();
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  List<Widget> mainView = [
    PerDayWeatherView(),
    PerHourWeatherView(),
  ];

  @override
  void onInit() {
    textEditingController = TextEditingController();
    initLeft();
    super.onInit();
  }

  void initLeft() async {
    await getCityList();
    await initLeftWeather();
    await changeIndexLeft(0);
  }

  Future<void> getCityList() async {
    await ApiBaseClient.safeApiCall(
      ApiConstant.WEATHER_USER_CITY_LIST,
      RequestType.get,
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (res) {
        WeatherCityEntity weatherCityEntity =
            WeatherCityEntity.fromJson(res.data);
        weatherCitys = weatherCityEntity.data;
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        ApiBaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  Future<void> initLeftWeather() async {
    for (WeatherCityData value in weatherCitys) {
      double lat = value.lat;
      double lon = value.lon;
      String latStr = lat.toStringAsFixed(2);
      String lonStr = lon.toStringAsFixed(2);
      String data = '?data=$lonStr,$latStr';
      String url = ApiConstant2.HE_FENG_BASE_API +
          ApiConstant2.REALTIME_WEATHER +
          data;
      Map<String, dynamic> header = {};
      header.assign('X-QW-Api-Key', ApiConstant2.API_KEY);
      await ApiBaseClient.safeApiCall(url, RequestType.get, headers: header,
          onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      }, onSuccess: (res) {
        RealTimeWeatherEntity realTimeWeatherEntity =
            RealTimeWeatherEntity.fromJson(res.data);
        realTimeWeatherEntity.now.weatherType =
            transWeatherType(realTimeWeatherEntity);
        leftWeathers.add(realTimeWeatherEntity);
        setWeatherMap(realTimeWeatherEntity.now);
        apiCallStatus = ApiCallStatus.success;
        update();
      }, onError: (error) {
        ApiBaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      });
    }
  }

  WeatherCityData getCurWeatherCityData() {
    return weatherCitys[currentPage];
  }

  Map<String, String> getCurCard1() {
    return card1[currentPage];
  }

  RealTimeWeatherEntity getCurRealTimeWeather() {
    return leftWeathers[currentPage];
  }

  void updateSelCity(Result selCity) {
    this.selCity = selCity;
    textEditingController.text = selCity.provinceName! +
        '-' +
        selCity.cityName! +
        '-' +
        selCity.areaName!;
    update();
  }

  void changeHour() {
    ifOnHour = !ifOnHour;
    update();
  }

  void changeIndexRight(int n) {
    currentPage = n;
    update();
  }

  String getWeatherKey(int index, int index1) {
    return weatherMaps[index].keys.toList()[index1];
  }

  String getWeatherVlaue(int index, int index1) {
    String key = getWeatherKey(index, index1);
    return weatherMaps[index][key];
  }

  Future<void> changeIndexLeft1(int n) async {
    currentPage = n;
    await getCard2(n);
    await getCard3(n);
    await getCard4(n);
    update();
  }

  Future<void> changeIndexLeft(int n) async {
    if (currentPage == n) {
      return;
    }
    currentPage = n;
    await getCard2(n);
    await getCard3(n);
    await getCard4(n);
    update();
  }

  Future<void> loadAddressData() async {
    try {
      await rootBundle.loadString('mock/weather_city.json').then((value) {
        final Map<String, dynamic> jsonData = jsonDecode(value);
        citys = CityModelEntity.fromJson(jsonData).data;
      });
      update();
    } catch (e) {
      print('Error loading mock city data: $e');
    }
  }

  double getMaxTemp() {
    String? value = minMaxTemp[currentPage];
    List<String> vals = value!.split(",");
    return double.parse(vals[1]);
  }

  double getMinTemp() {
    String? value = minMaxTemp[currentPage];
    List<String> vals = value!.split(",");
    return double.parse(vals[0]);
  }

  void toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => _updatePositionList(
            position,
          ));
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
    update();
  }

  void _updatePositionList(Position posi) {
    curPosition = posi;
    print('Listening1 for position updates $posi');
  }


  Future<void> _updateRealTimeWeatherMock(double lat, double lon) async {
    await rootBundle.loadString('mock/realtime_weather.json').then((value) {
      final Map<String, dynamic> jsonData = jsonDecode(value);
      RealTimeWeatherEntity realTimeWeatherEntity =
          RealTimeWeatherEntity.fromJson(jsonData);
      realTimeWeatherEntity.now.weatherType =
          transWeatherType(realTimeWeatherEntity);
      realTimeWeathers.add(realTimeWeatherEntity);
      setWeatherMap(realTimeWeatherEntity.now);
    });
  }

  void setWeatherMap(RealTimeWeatherNow now) {
    var format2 = DateFormat('HH:mm:ss');
    DateTime dateTime = DateTime.parse(now.obsTime);
    Map<String, String> map = {};
    map["观察时间"] = format2.format(dateTime.toLocal());
    map[now.windDir] = now.windScale + "级";
    map["相对湿度"] = now.humidity + '%';
    map["能见度"] = now.vis + '公里';
    map["1小时降水量"] = now.precip + '毫米';
    map["大气压强"] = now.pressure + 'hPa';
    card1.add(map);
    update();
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
    String latStr = lat.toStringAsFixed(2);
    String lonStr = lon.toStringAsFixed(2);
    String data = '?lon=$lonStr&lat=$latStr';
    String url = ApiConstant.getByGPS + data;
    print('City URL: $url'); // Debug URL
    // Map<String, dynamic> header = {'X-QW-Api-Key': ApiConstant2.API_KEY};
    Map<String, dynamic> header = {};
    // header.assign('X-QW-Api-Key', ApiConstant2.API_KEY);

    await ApiBaseClient.safeApiCall(
      url, RequestType.get, headers: header,
      onSuccess: (res) {
        curCity = CityModelEntity.fromJson(res.data);
        print('Current city: ${curCity}');
      },
      // onError: (e) {
      //   print('City API error: $e');
      // },
    );
  }

  Future<void> getCard2(int n) async {
    String url = ApiConstant2.HOUR_WEATHER + '?data=${weatherCitys[n].id}';
    Map<String, dynamic> header = {};
    header.assign('X-QW-Api-Key', ApiConstant2.API_KEY);
    await ApiBaseClient.safeApiCall(url, RequestType.get, headers: header,
        onLoading: () {
      // apiCallStatus = ApiCallStatus.loading;
      update();
    }, onSuccess: (res) {
      HourWeatherEntity hourWeatherEntity =
          HourWeatherEntity.fromJson(res.data);
      hourly = hourWeatherEntity.hourly;
      hourly.forEach((a) {
        var format2 = DateFormat('HH');
        DateTime dateTime = DateTime.parse(a.fxTime);
        String time = format2.format(dateTime.toLocal());
        a.fxTime = time + '时';
      });
      apiCallStatus = ApiCallStatus.success;
      update();
    }, onError: (error) {
      ApiBaseClient.handleApiError(error);
      apiCallStatus = ApiCallStatus.error;
      update();
    });
  }

  Future<void> getCard3(int n) async {
    String url = ApiConstant2.DAY_WEATHER + '?data=${weatherCitys[n].id}';
    Map<String, dynamic> header = {};
    header.assign('X-QW-Api-Key', ApiConstant2.API_KEY);
    await ApiBaseClient.safeApiCall(url, RequestType.get, headers: header,
        onLoading: () {
      // apiCallStatus = ApiCallStatus.loading;
      // update();
    }, onSuccess: (res) {
      DayWeatherEntity dayWeatherEntity = DayWeatherEntity.fromJson(res.data);
      daily = dayWeatherEntity.daily;
      double min = 100;
      double max = 0;
      daily.forEach((a) {
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
      minMaxTemp.assign(n, '$min,$max');
      apiCallStatus = ApiCallStatus.success;
      update();
    }, onError: (error) {
      ApiBaseClient.handleApiError(error);
      apiCallStatus = ApiCallStatus.error;
      update();
    });
  }

  Future<void> getCard4(int n) async {
    String url =
        ApiConstant2.DAY_INDICES + '?type=0&data=${weatherCitys[n].id}';
    Map<String, dynamic> header = {};
    header.assign('X-QW-Api-Key', ApiConstant2.API_KEY);
    await ApiBaseClient.safeApiCall(url, RequestType.get, headers: header,
        onLoading: () {
      // apiCallStatus = ApiCallStatus.loading;
      // update();
    }, onSuccess: (res) {
      IndicesWeatherEntity indicesWeatherEntity =
          IndicesWeatherEntity.fromJson(res.data);
      indicesDaily = indicesWeatherEntity.daily;
      apiCallStatus = ApiCallStatus.success;
      update();
    }, onError: (error) {
      ApiBaseClient.handleApiError(error);
      apiCallStatus = ApiCallStatus.error;
      update();
    });
  }

  Future<void> getRealTimeWeather() async {
    final bool hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }
    final Position position = await _geolocatorPlatform.getCurrentPosition();
    await getCurCity(position.latitude, position.longitude);
    // CityModelLocation cityModelLocation = curCity.data.first;
    // citys.addAll(['当前：${cityModelLocation.name}', "朝阳", "海淀", "郓城"]);
    // await loadAddressData();
    // await _updateRealTimeWeather(position.latitude, position.longitude);
    for (CityModelLocation city in citys) {
      await _updateRealTimeWeatherMock(
          double.parse(city.lat), double.parse(city.lon));
    }

    print('realTimeWeathers,$realTimeWeathers');
    update();
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if data services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // data services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the data services.

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  @override
  void onClose() {
    // _positionStreamSubscription?.cancel();
    textEditingController.dispose();
    super.onClose();
  }
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}

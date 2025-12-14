import 'package:qqai/generated/json/base/json_convert_content.dart';
import '../../../features/data/models/real_time_weather_entity.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';


RealTimeWeatherEntity $RealTimeWeatherEntityFromJson(
    Map<String, dynamic> json) {
  final RealTimeWeatherEntity realTimeWeatherEntity = RealTimeWeatherEntity();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    realTimeWeatherEntity.code = code;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    realTimeWeatherEntity.updateTime = updateTime;
  }
  final String? fxLink = jsonConvert.convert<String>(json['fxLink']);
  if (fxLink != null) {
    realTimeWeatherEntity.fxLink = fxLink;
  }
  final RealTimeWeatherNow? now = jsonConvert.convert<RealTimeWeatherNow>(
      json['now']);
  if (now != null) {
    realTimeWeatherEntity.now = now;
  }
  final RealTimeWeatherRefer? refer = jsonConvert.convert<RealTimeWeatherRefer>(
      json['refer']);
  if (refer != null) {
    realTimeWeatherEntity.refer = refer;
  }
  return realTimeWeatherEntity;
}

Map<String, dynamic> $RealTimeWeatherEntityToJson(
    RealTimeWeatherEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['updateTime'] = entity.updateTime;
  data['fxLink'] = entity.fxLink;
  data['now'] = entity.now.toJson();
  data['refer'] = entity.refer.toJson();
  return data;
}

extension RealTimeWeatherEntityExtension on RealTimeWeatherEntity {
  RealTimeWeatherEntity copyWith({
    String? code,
    String? updateTime,
    String? fxLink,
    RealTimeWeatherNow? now,
    RealTimeWeatherRefer? refer,
  }) {
    return RealTimeWeatherEntity()
      ..code = code ?? this.code
      ..updateTime = updateTime ?? this.updateTime
      ..fxLink = fxLink ?? this.fxLink
      ..now = now ?? this.now
      ..refer = refer ?? this.refer;
  }
}

RealTimeWeatherNow $RealTimeWeatherNowFromJson(Map<String, dynamic> json) {
  final RealTimeWeatherNow realTimeWeatherNow = RealTimeWeatherNow();
  final String? obsTime = jsonConvert.convert<String>(json['obsTime']);
  if (obsTime != null) {
    realTimeWeatherNow.obsTime = obsTime;
  }
  final String? temp = jsonConvert.convert<String>(json['temp']);
  if (temp != null) {
    realTimeWeatherNow.temp = temp;
  }
  final String? feelsLike = jsonConvert.convert<String>(json['feelsLike']);
  if (feelsLike != null) {
    realTimeWeatherNow.feelsLike = feelsLike;
  }
  final String? icon = jsonConvert.convert<String>(json['icon']);
  if (icon != null) {
    realTimeWeatherNow.icon = icon;
  }
  final String? text = jsonConvert.convert<String>(json['text']);
  if (text != null) {
    realTimeWeatherNow.text = text;
  }
  final WeatherType? weatherType = jsonConvert.convert<WeatherType>(
      json['weatherType']);
  if (weatherType != null) {
    realTimeWeatherNow.weatherType = weatherType;
  }
  final String? wind360 = jsonConvert.convert<String>(json['wind360']);
  if (wind360 != null) {
    realTimeWeatherNow.wind360 = wind360;
  }
  final String? windDir = jsonConvert.convert<String>(json['windDir']);
  if (windDir != null) {
    realTimeWeatherNow.windDir = windDir;
  }
  final String? windScale = jsonConvert.convert<String>(json['windScale']);
  if (windScale != null) {
    realTimeWeatherNow.windScale = windScale;
  }
  final String? windSpeed = jsonConvert.convert<String>(json['windSpeed']);
  if (windSpeed != null) {
    realTimeWeatherNow.windSpeed = windSpeed;
  }
  final String? humidity = jsonConvert.convert<String>(json['humidity']);
  if (humidity != null) {
    realTimeWeatherNow.humidity = humidity;
  }
  final String? precip = jsonConvert.convert<String>(json['precip']);
  if (precip != null) {
    realTimeWeatherNow.precip = precip;
  }
  final String? pressure = jsonConvert.convert<String>(json['pressure']);
  if (pressure != null) {
    realTimeWeatherNow.pressure = pressure;
  }
  final String? vis = jsonConvert.convert<String>(json['vis']);
  if (vis != null) {
    realTimeWeatherNow.vis = vis;
  }
  final String? cloud = jsonConvert.convert<String>(json['cloud']);
  if (cloud != null) {
    realTimeWeatherNow.cloud = cloud;
  }
  final String? dew = jsonConvert.convert<String>(json['dew']);
  if (dew != null) {
    realTimeWeatherNow.dew = dew;
  }
  return realTimeWeatherNow;
}

Map<String, dynamic> $RealTimeWeatherNowToJson(RealTimeWeatherNow entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['obsTime'] = entity.obsTime;
  data['temp'] = entity.temp;
  data['feelsLike'] = entity.feelsLike;
  data['icon'] = entity.icon;
  data['text'] = entity.text;
  data['weatherType'] = entity.weatherType;
  data['wind360'] = entity.wind360;
  data['windDir'] = entity.windDir;
  data['windScale'] = entity.windScale;
  data['windSpeed'] = entity.windSpeed;
  data['humidity'] = entity.humidity;
  data['precip'] = entity.precip;
  data['pressure'] = entity.pressure;
  data['vis'] = entity.vis;
  data['cloud'] = entity.cloud;
  data['dew'] = entity.dew;
  return data;
}

extension RealTimeWeatherNowExtension on RealTimeWeatherNow {
  RealTimeWeatherNow copyWith({
    String? obsTime,
    String? temp,
    String? feelsLike,
    String? icon,
    String? text,
    WeatherType? weatherType,
    String? wind360,
    String? windDir,
    String? windScale,
    String? windSpeed,
    String? humidity,
    String? precip,
    String? pressure,
    String? vis,
    String? cloud,
    String? dew,
  }) {
    return RealTimeWeatherNow()
      ..obsTime = obsTime ?? this.obsTime
      ..temp = temp ?? this.temp
      ..feelsLike = feelsLike ?? this.feelsLike
      ..icon = icon ?? this.icon
      ..text = text ?? this.text
      ..weatherType = weatherType ?? this.weatherType
      ..wind360 = wind360 ?? this.wind360
      ..windDir = windDir ?? this.windDir
      ..windScale = windScale ?? this.windScale
      ..windSpeed = windSpeed ?? this.windSpeed
      ..humidity = humidity ?? this.humidity
      ..precip = precip ?? this.precip
      ..pressure = pressure ?? this.pressure
      ..vis = vis ?? this.vis
      ..cloud = cloud ?? this.cloud
      ..dew = dew ?? this.dew;
  }
}

RealTimeWeatherRefer $RealTimeWeatherReferFromJson(Map<String, dynamic> json) {
  final RealTimeWeatherRefer realTimeWeatherRefer = RealTimeWeatherRefer();
  final List<String>? sources = (json['sources'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (sources != null) {
    realTimeWeatherRefer.sources = sources;
  }
  final List<String>? license = (json['license'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (license != null) {
    realTimeWeatherRefer.license = license;
  }
  return realTimeWeatherRefer;
}

Map<String, dynamic> $RealTimeWeatherReferToJson(RealTimeWeatherRefer entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['sources'] = entity.sources;
  data['license'] = entity.license;
  return data;
}

extension RealTimeWeatherReferExtension on RealTimeWeatherRefer {
  RealTimeWeatherRefer copyWith({
    List<String>? sources,
    List<String>? license,
  }) {
    return RealTimeWeatherRefer()
      ..sources = sources ?? this.sources
      ..license = license ?? this.license;
  }
}
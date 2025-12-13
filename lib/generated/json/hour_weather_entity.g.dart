import 'package:qqai/generated/json/base/json_convert_content.dart';
import 'package:qqai/app/data/models/hour_weather_entity.dart';

HourWeatherEntity $HourWeatherEntityFromJson(Map<String, dynamic> json) {
  final HourWeatherEntity hourWeatherEntity = HourWeatherEntity();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    hourWeatherEntity.code = code;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    hourWeatherEntity.updateTime = updateTime;
  }
  final String? fxLink = jsonConvert.convert<String>(json['fxLink']);
  if (fxLink != null) {
    hourWeatherEntity.fxLink = fxLink;
  }
  final List<HourWeatherHourly>? hourly = (json['hourly'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<HourWeatherHourly>(e) as HourWeatherHourly)
      .toList();
  if (hourly != null) {
    hourWeatherEntity.hourly = hourly;
  }
  final HourWeatherRefer? refer = jsonConvert.convert<HourWeatherRefer>(
      json['refer']);
  if (refer != null) {
    hourWeatherEntity.refer = refer;
  }
  return hourWeatherEntity;
}

Map<String, dynamic> $HourWeatherEntityToJson(HourWeatherEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['updateTime'] = entity.updateTime;
  data['fxLink'] = entity.fxLink;
  data['hourly'] = entity.hourly.map((v) => v.toJson()).toList();
  data['refer'] = entity.refer.toJson();
  return data;
}

extension HourWeatherEntityExtension on HourWeatherEntity {
  HourWeatherEntity copyWith({
    String? code,
    String? updateTime,
    String? fxLink,
    List<HourWeatherHourly>? hourly,
    HourWeatherRefer? refer,
  }) {
    return HourWeatherEntity()
      ..code = code ?? this.code
      ..updateTime = updateTime ?? this.updateTime
      ..fxLink = fxLink ?? this.fxLink
      ..hourly = hourly ?? this.hourly
      ..refer = refer ?? this.refer;
  }
}

HourWeatherHourly $HourWeatherHourlyFromJson(Map<String, dynamic> json) {
  final HourWeatherHourly hourWeatherHourly = HourWeatherHourly();
  final String? fxTime = jsonConvert.convert<String>(json['fxTime']);
  if (fxTime != null) {
    hourWeatherHourly.fxTime = fxTime;
  }
  final String? temp = jsonConvert.convert<String>(json['temp']);
  if (temp != null) {
    hourWeatherHourly.temp = temp;
  }
  final String? icon = jsonConvert.convert<String>(json['icon']);
  if (icon != null) {
    hourWeatherHourly.icon = icon;
  }
  final String? text = jsonConvert.convert<String>(json['text']);
  if (text != null) {
    hourWeatherHourly.text = text;
  }
  final String? wind360 = jsonConvert.convert<String>(json['wind360']);
  if (wind360 != null) {
    hourWeatherHourly.wind360 = wind360;
  }
  final String? windDir = jsonConvert.convert<String>(json['windDir']);
  if (windDir != null) {
    hourWeatherHourly.windDir = windDir;
  }
  final String? windScale = jsonConvert.convert<String>(json['windScale']);
  if (windScale != null) {
    hourWeatherHourly.windScale = windScale;
  }
  final String? windSpeed = jsonConvert.convert<String>(json['windSpeed']);
  if (windSpeed != null) {
    hourWeatherHourly.windSpeed = windSpeed;
  }
  final String? humidity = jsonConvert.convert<String>(json['humidity']);
  if (humidity != null) {
    hourWeatherHourly.humidity = humidity;
  }
  final String? pop = jsonConvert.convert<String>(json['pop']);
  if (pop != null) {
    hourWeatherHourly.pop = pop;
  }
  final String? precip = jsonConvert.convert<String>(json['precip']);
  if (precip != null) {
    hourWeatherHourly.precip = precip;
  }
  final String? pressure = jsonConvert.convert<String>(json['pressure']);
  if (pressure != null) {
    hourWeatherHourly.pressure = pressure;
  }
  final String? cloud = jsonConvert.convert<String>(json['cloud']);
  if (cloud != null) {
    hourWeatherHourly.cloud = cloud;
  }
  final String? dew = jsonConvert.convert<String>(json['dew']);
  if (dew != null) {
    hourWeatherHourly.dew = dew;
  }
  return hourWeatherHourly;
}

Map<String, dynamic> $HourWeatherHourlyToJson(HourWeatherHourly entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['fxTime'] = entity.fxTime;
  data['temp'] = entity.temp;
  data['icon'] = entity.icon;
  data['text'] = entity.text;
  data['wind360'] = entity.wind360;
  data['windDir'] = entity.windDir;
  data['windScale'] = entity.windScale;
  data['windSpeed'] = entity.windSpeed;
  data['humidity'] = entity.humidity;
  data['pop'] = entity.pop;
  data['precip'] = entity.precip;
  data['pressure'] = entity.pressure;
  data['cloud'] = entity.cloud;
  data['dew'] = entity.dew;
  return data;
}

extension HourWeatherHourlyExtension on HourWeatherHourly {
  HourWeatherHourly copyWith({
    String? fxTime,
    String? temp,
    String? icon,
    String? text,
    String? wind360,
    String? windDir,
    String? windScale,
    String? windSpeed,
    String? humidity,
    String? pop,
    String? precip,
    String? pressure,
    String? cloud,
    String? dew,
  }) {
    return HourWeatherHourly()
      ..fxTime = fxTime ?? this.fxTime
      ..temp = temp ?? this.temp
      ..icon = icon ?? this.icon
      ..text = text ?? this.text
      ..wind360 = wind360 ?? this.wind360
      ..windDir = windDir ?? this.windDir
      ..windScale = windScale ?? this.windScale
      ..windSpeed = windSpeed ?? this.windSpeed
      ..humidity = humidity ?? this.humidity
      ..pop = pop ?? this.pop
      ..precip = precip ?? this.precip
      ..pressure = pressure ?? this.pressure
      ..cloud = cloud ?? this.cloud
      ..dew = dew ?? this.dew;
  }
}

HourWeatherRefer $HourWeatherReferFromJson(Map<String, dynamic> json) {
  final HourWeatherRefer hourWeatherRefer = HourWeatherRefer();
  final List<String>? sources = (json['sources'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (sources != null) {
    hourWeatherRefer.sources = sources;
  }
  final List<String>? license = (json['license'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (license != null) {
    hourWeatherRefer.license = license;
  }
  return hourWeatherRefer;
}

Map<String, dynamic> $HourWeatherReferToJson(HourWeatherRefer entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['sources'] = entity.sources;
  data['license'] = entity.license;
  return data;
}

extension HourWeatherReferExtension on HourWeatherRefer {
  HourWeatherRefer copyWith({
    List<String>? sources,
    List<String>? license,
  }) {
    return HourWeatherRefer()
      ..sources = sources ?? this.sources
      ..license = license ?? this.license;
  }
}
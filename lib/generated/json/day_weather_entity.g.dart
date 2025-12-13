import 'package:qqai/generated/json/base/json_convert_content.dart';
import 'package:qqai/app/data/models/day_weather_entity.dart';

DayWeatherEntity $DayWeatherEntityFromJson(Map<String, dynamic> json) {
  final DayWeatherEntity dayWeatherEntity = DayWeatherEntity();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    dayWeatherEntity.code = code;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    dayWeatherEntity.updateTime = updateTime;
  }
  final String? fxLink = jsonConvert.convert<String>(json['fxLink']);
  if (fxLink != null) {
    dayWeatherEntity.fxLink = fxLink;
  }
  final List<DayWeatherDaily>? daily = (json['daily'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<DayWeatherDaily>(e) as DayWeatherDaily)
      .toList();
  if (daily != null) {
    dayWeatherEntity.daily = daily;
  }
  final DayWeatherRefer? refer = jsonConvert.convert<DayWeatherRefer>(
      json['refer']);
  if (refer != null) {
    dayWeatherEntity.refer = refer;
  }
  return dayWeatherEntity;
}

Map<String, dynamic> $DayWeatherEntityToJson(DayWeatherEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['updateTime'] = entity.updateTime;
  data['fxLink'] = entity.fxLink;
  data['daily'] = entity.daily.map((v) => v.toJson()).toList();
  data['refer'] = entity.refer.toJson();
  return data;
}

extension DayWeatherEntityExtension on DayWeatherEntity {
  DayWeatherEntity copyWith({
    String? code,
    String? updateTime,
    String? fxLink,
    List<DayWeatherDaily>? daily,
    DayWeatherRefer? refer,
  }) {
    return DayWeatherEntity()
      ..code = code ?? this.code
      ..updateTime = updateTime ?? this.updateTime
      ..fxLink = fxLink ?? this.fxLink
      ..daily = daily ?? this.daily
      ..refer = refer ?? this.refer;
  }
}

DayWeatherDaily $DayWeatherDailyFromJson(Map<String, dynamic> json) {
  final DayWeatherDaily dayWeatherDaily = DayWeatherDaily();
  final String? fxDate = jsonConvert.convert<String>(json['fxDate']);
  if (fxDate != null) {
    dayWeatherDaily.fxDate = fxDate;
  }
  final String? sunrise = jsonConvert.convert<String>(json['sunrise']);
  if (sunrise != null) {
    dayWeatherDaily.sunrise = sunrise;
  }
  final String? sunset = jsonConvert.convert<String>(json['sunset']);
  if (sunset != null) {
    dayWeatherDaily.sunset = sunset;
  }
  final String? moonrise = jsonConvert.convert<String>(json['moonrise']);
  if (moonrise != null) {
    dayWeatherDaily.moonrise = moonrise;
  }
  final String? moonset = jsonConvert.convert<String>(json['moonset']);
  if (moonset != null) {
    dayWeatherDaily.moonset = moonset;
  }
  final String? moonPhase = jsonConvert.convert<String>(json['moonPhase']);
  if (moonPhase != null) {
    dayWeatherDaily.moonPhase = moonPhase;
  }
  final String? moonPhaseIcon = jsonConvert.convert<String>(
      json['moonPhaseIcon']);
  if (moonPhaseIcon != null) {
    dayWeatherDaily.moonPhaseIcon = moonPhaseIcon;
  }
  final String? tempMax = jsonConvert.convert<String>(json['tempMax']);
  if (tempMax != null) {
    dayWeatherDaily.tempMax = tempMax;
  }
  final String? tempMin = jsonConvert.convert<String>(json['tempMin']);
  if (tempMin != null) {
    dayWeatherDaily.tempMin = tempMin;
  }
  final String? iconDay = jsonConvert.convert<String>(json['iconDay']);
  if (iconDay != null) {
    dayWeatherDaily.iconDay = iconDay;
  }
  final String? textDay = jsonConvert.convert<String>(json['textDay']);
  if (textDay != null) {
    dayWeatherDaily.textDay = textDay;
  }
  final String? iconNight = jsonConvert.convert<String>(json['iconNight']);
  if (iconNight != null) {
    dayWeatherDaily.iconNight = iconNight;
  }
  final String? textNight = jsonConvert.convert<String>(json['textNight']);
  if (textNight != null) {
    dayWeatherDaily.textNight = textNight;
  }
  final String? wind360Day = jsonConvert.convert<String>(json['wind360Day']);
  if (wind360Day != null) {
    dayWeatherDaily.wind360Day = wind360Day;
  }
  final String? windDirDay = jsonConvert.convert<String>(json['windDirDay']);
  if (windDirDay != null) {
    dayWeatherDaily.windDirDay = windDirDay;
  }
  final String? windScaleDay = jsonConvert.convert<String>(
      json['windScaleDay']);
  if (windScaleDay != null) {
    dayWeatherDaily.windScaleDay = windScaleDay;
  }
  final String? windSpeedDay = jsonConvert.convert<String>(
      json['windSpeedDay']);
  if (windSpeedDay != null) {
    dayWeatherDaily.windSpeedDay = windSpeedDay;
  }
  final String? wind360Night = jsonConvert.convert<String>(
      json['wind360Night']);
  if (wind360Night != null) {
    dayWeatherDaily.wind360Night = wind360Night;
  }
  final String? windDirNight = jsonConvert.convert<String>(
      json['windDirNight']);
  if (windDirNight != null) {
    dayWeatherDaily.windDirNight = windDirNight;
  }
  final String? windScaleNight = jsonConvert.convert<String>(
      json['windScaleNight']);
  if (windScaleNight != null) {
    dayWeatherDaily.windScaleNight = windScaleNight;
  }
  final String? windSpeedNight = jsonConvert.convert<String>(
      json['windSpeedNight']);
  if (windSpeedNight != null) {
    dayWeatherDaily.windSpeedNight = windSpeedNight;
  }
  final String? humidity = jsonConvert.convert<String>(json['humidity']);
  if (humidity != null) {
    dayWeatherDaily.humidity = humidity;
  }
  final String? precip = jsonConvert.convert<String>(json['precip']);
  if (precip != null) {
    dayWeatherDaily.precip = precip;
  }
  final String? pressure = jsonConvert.convert<String>(json['pressure']);
  if (pressure != null) {
    dayWeatherDaily.pressure = pressure;
  }
  final String? vis = jsonConvert.convert<String>(json['vis']);
  if (vis != null) {
    dayWeatherDaily.vis = vis;
  }
  final String? cloud = jsonConvert.convert<String>(json['cloud']);
  if (cloud != null) {
    dayWeatherDaily.cloud = cloud;
  }
  final String? uvIndex = jsonConvert.convert<String>(json['uvIndex']);
  if (uvIndex != null) {
    dayWeatherDaily.uvIndex = uvIndex;
  }
  return dayWeatherDaily;
}

Map<String, dynamic> $DayWeatherDailyToJson(DayWeatherDaily entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['fxDate'] = entity.fxDate;
  data['sunrise'] = entity.sunrise;
  data['sunset'] = entity.sunset;
  data['moonrise'] = entity.moonrise;
  data['moonset'] = entity.moonset;
  data['moonPhase'] = entity.moonPhase;
  data['moonPhaseIcon'] = entity.moonPhaseIcon;
  data['tempMax'] = entity.tempMax;
  data['tempMin'] = entity.tempMin;
  data['iconDay'] = entity.iconDay;
  data['textDay'] = entity.textDay;
  data['iconNight'] = entity.iconNight;
  data['textNight'] = entity.textNight;
  data['wind360Day'] = entity.wind360Day;
  data['windDirDay'] = entity.windDirDay;
  data['windScaleDay'] = entity.windScaleDay;
  data['windSpeedDay'] = entity.windSpeedDay;
  data['wind360Night'] = entity.wind360Night;
  data['windDirNight'] = entity.windDirNight;
  data['windScaleNight'] = entity.windScaleNight;
  data['windSpeedNight'] = entity.windSpeedNight;
  data['humidity'] = entity.humidity;
  data['precip'] = entity.precip;
  data['pressure'] = entity.pressure;
  data['vis'] = entity.vis;
  data['cloud'] = entity.cloud;
  data['uvIndex'] = entity.uvIndex;
  return data;
}

extension DayWeatherDailyExtension on DayWeatherDaily {
  DayWeatherDaily copyWith({
    String? fxDate,
    String? sunrise,
    String? sunset,
    String? moonrise,
    String? moonset,
    String? moonPhase,
    String? moonPhaseIcon,
    String? tempMax,
    String? tempMin,
    String? iconDay,
    String? textDay,
    String? iconNight,
    String? textNight,
    String? wind360Day,
    String? windDirDay,
    String? windScaleDay,
    String? windSpeedDay,
    String? wind360Night,
    String? windDirNight,
    String? windScaleNight,
    String? windSpeedNight,
    String? humidity,
    String? precip,
    String? pressure,
    String? vis,
    String? cloud,
    String? uvIndex,
  }) {
    return DayWeatherDaily()
      ..fxDate = fxDate ?? this.fxDate
      ..sunrise = sunrise ?? this.sunrise
      ..sunset = sunset ?? this.sunset
      ..moonrise = moonrise ?? this.moonrise
      ..moonset = moonset ?? this.moonset
      ..moonPhase = moonPhase ?? this.moonPhase
      ..moonPhaseIcon = moonPhaseIcon ?? this.moonPhaseIcon
      ..tempMax = tempMax ?? this.tempMax
      ..tempMin = tempMin ?? this.tempMin
      ..iconDay = iconDay ?? this.iconDay
      ..textDay = textDay ?? this.textDay
      ..iconNight = iconNight ?? this.iconNight
      ..textNight = textNight ?? this.textNight
      ..wind360Day = wind360Day ?? this.wind360Day
      ..windDirDay = windDirDay ?? this.windDirDay
      ..windScaleDay = windScaleDay ?? this.windScaleDay
      ..windSpeedDay = windSpeedDay ?? this.windSpeedDay
      ..wind360Night = wind360Night ?? this.wind360Night
      ..windDirNight = windDirNight ?? this.windDirNight
      ..windScaleNight = windScaleNight ?? this.windScaleNight
      ..windSpeedNight = windSpeedNight ?? this.windSpeedNight
      ..humidity = humidity ?? this.humidity
      ..precip = precip ?? this.precip
      ..pressure = pressure ?? this.pressure
      ..vis = vis ?? this.vis
      ..cloud = cloud ?? this.cloud
      ..uvIndex = uvIndex ?? this.uvIndex;
  }
}

DayWeatherRefer $DayWeatherReferFromJson(Map<String, dynamic> json) {
  final DayWeatherRefer dayWeatherRefer = DayWeatherRefer();
  final List<String>? sources = (json['sources'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (sources != null) {
    dayWeatherRefer.sources = sources;
  }
  final List<String>? license = (json['license'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (license != null) {
    dayWeatherRefer.license = license;
  }
  return dayWeatherRefer;
}

Map<String, dynamic> $DayWeatherReferToJson(DayWeatherRefer entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['sources'] = entity.sources;
  data['license'] = entity.license;
  return data;
}

extension DayWeatherReferExtension on DayWeatherRefer {
  DayWeatherRefer copyWith({
    List<String>? sources,
    List<String>? license,
  }) {
    return DayWeatherRefer()
      ..sources = sources ?? this.sources
      ..license = license ?? this.license;
  }
}
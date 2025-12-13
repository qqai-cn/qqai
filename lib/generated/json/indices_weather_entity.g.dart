import 'package:qqai/generated/json/base/json_convert_content.dart';
import 'package:qqai/app/data/models/indices_weather_entity.dart';

IndicesWeatherEntity $IndicesWeatherEntityFromJson(Map<String, dynamic> json) {
  final IndicesWeatherEntity indicesWeatherEntity = IndicesWeatherEntity();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    indicesWeatherEntity.code = code;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    indicesWeatherEntity.updateTime = updateTime;
  }
  final String? fxLink = jsonConvert.convert<String>(json['fxLink']);
  if (fxLink != null) {
    indicesWeatherEntity.fxLink = fxLink;
  }
  final List<IndicesWeatherDaily>? daily = (json['daily'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<IndicesWeatherDaily>(e) as IndicesWeatherDaily)
      .toList();
  if (daily != null) {
    indicesWeatherEntity.daily = daily;
  }
  final IndicesWeatherRefer? refer = jsonConvert.convert<IndicesWeatherRefer>(
      json['refer']);
  if (refer != null) {
    indicesWeatherEntity.refer = refer;
  }
  return indicesWeatherEntity;
}

Map<String, dynamic> $IndicesWeatherEntityToJson(IndicesWeatherEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['updateTime'] = entity.updateTime;
  data['fxLink'] = entity.fxLink;
  data['daily'] = entity.daily.map((v) => v.toJson()).toList();
  data['refer'] = entity.refer.toJson();
  return data;
}

extension IndicesWeatherEntityExtension on IndicesWeatherEntity {
  IndicesWeatherEntity copyWith({
    String? code,
    String? updateTime,
    String? fxLink,
    List<IndicesWeatherDaily>? daily,
    IndicesWeatherRefer? refer,
  }) {
    return IndicesWeatherEntity()
      ..code = code ?? this.code
      ..updateTime = updateTime ?? this.updateTime
      ..fxLink = fxLink ?? this.fxLink
      ..daily = daily ?? this.daily
      ..refer = refer ?? this.refer;
  }
}

IndicesWeatherDaily $IndicesWeatherDailyFromJson(Map<String, dynamic> json) {
  final IndicesWeatherDaily indicesWeatherDaily = IndicesWeatherDaily();
  final String? date = jsonConvert.convert<String>(json['date']);
  if (date != null) {
    indicesWeatherDaily.date = date;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    indicesWeatherDaily.type = type;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    indicesWeatherDaily.name = name;
  }
  final String? level = jsonConvert.convert<String>(json['level']);
  if (level != null) {
    indicesWeatherDaily.level = level;
  }
  final String? category = jsonConvert.convert<String>(json['category']);
  if (category != null) {
    indicesWeatherDaily.category = category;
  }
  final String? text = jsonConvert.convert<String>(json['text']);
  if (text != null) {
    indicesWeatherDaily.text = text;
  }
  return indicesWeatherDaily;
}

Map<String, dynamic> $IndicesWeatherDailyToJson(IndicesWeatherDaily entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['date'] = entity.date;
  data['type'] = entity.type;
  data['name'] = entity.name;
  data['level'] = entity.level;
  data['category'] = entity.category;
  data['text'] = entity.text;
  return data;
}

extension IndicesWeatherDailyExtension on IndicesWeatherDaily {
  IndicesWeatherDaily copyWith({
    String? date,
    String? type,
    String? name,
    String? level,
    String? category,
    String? text,
  }) {
    return IndicesWeatherDaily()
      ..date = date ?? this.date
      ..type = type ?? this.type
      ..name = name ?? this.name
      ..level = level ?? this.level
      ..category = category ?? this.category
      ..text = text ?? this.text;
  }
}

IndicesWeatherRefer $IndicesWeatherReferFromJson(Map<String, dynamic> json) {
  final IndicesWeatherRefer indicesWeatherRefer = IndicesWeatherRefer();
  final List<String>? sources = (json['sources'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (sources != null) {
    indicesWeatherRefer.sources = sources;
  }
  final List<String>? license = (json['license'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (license != null) {
    indicesWeatherRefer.license = license;
  }
  return indicesWeatherRefer;
}

Map<String, dynamic> $IndicesWeatherReferToJson(IndicesWeatherRefer entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['sources'] = entity.sources;
  data['license'] = entity.license;
  return data;
}

extension IndicesWeatherReferExtension on IndicesWeatherRefer {
  IndicesWeatherRefer copyWith({
    List<String>? sources,
    List<String>? license,
  }) {
    return IndicesWeatherRefer()
      ..sources = sources ?? this.sources
      ..license = license ?? this.license;
  }
}